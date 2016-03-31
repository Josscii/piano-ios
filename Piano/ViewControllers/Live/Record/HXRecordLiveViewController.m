//
//  HXRecordLiveViewController.m
//  Piano
//
//  Created by miaios on 16/3/18.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXRecordLiveViewController.h"
#import "HXZegoAVKitManager.h"
#import <ZegoAVKit/ZegoMoviePlayer.h>
#import "HXSettingSession.h"
#import "HXLiveModel.h"
#import "HXUserSession.h"


@interface HXRecordLiveViewController () <
ZegoChatDelegate,
ZegoVideoDelegate
>
@end


@implementation HXRecordLiveViewController

#pragma mark - Class Methods
+ (HXStoryBoardName)storyBoardName {
    return HXStoryBoardNameLive;
}

+ (NSString *)navigationControllerIdentifier {
    return @"HXRecordLiveNavigationController";
}

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self shouldSteady:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self shouldSteady:NO];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self loadConfigure];
//    [self viewConfigure];
}

#pragma mark - Configure Methods
- (void)loadConfigure {
    ZegoAVApi *zegoAVApi = [HXZegoAVKitManager manager].zegoAVApi;
    
    [zegoAVApi setRemoteView:RemoteViewIndex_First view:_liveView];
//    [zegoAVApi setRemoteView:RemoteViewIndex_Second view:secondRemoteView];
    
//    [zegoAVApi setLocalViewMode:ZegoVideoViewModeScaleAspectFit];
    [zegoAVApi setRemoteViewMode:RemoteViewIndex_First mode:ZegoVideoViewModeScaleAspectFit];
//    [zegoAVApi setRemoteViewMode:RemoteViewIndex_Second mode:ZegoVideoViewModeScaleAspectFit];
    
    //设置回调代理
    [zegoAVApi setChatDelegate:self callbackQueue:dispatch_get_main_queue()];
    [zegoAVApi setVideoDelegate:self callbackQueue:dispatch_get_main_queue()];
    
    //进入聊天室
    ZegoUser * user = [ZegoUser new];
    user.userID = [HXUserSession session].uid;
    user.userName = [HXUserSession session].nickName;
    
    UInt32 roomToken = (UInt32)_model.zegoToken;
    UInt32 roomNum = (UInt32)_model.zegoID;
    
    [zegoAVApi getInChatRoom:user zegoToken:roomToken zegoId:roomNum];
    [zegoAVApi setAVConfig:[HXSettingSession session].configure];
}

- (void)viewConfigure {
    ;
}

#pragma mark - Event Response
- (IBAction)closeButtonPressed {
    [self dismiss];
}

#pragma mark - Private Methods
- (void)shouldSteady:(BOOL)steady {
    [[UIApplication sharedApplication] setIdleTimerDisabled:steady];
}

- (void)dismiss {
    [self leaveRoom];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leaveRoom {
    [[HXZegoAVKitManager manager].zegoAVApi leaveChatRoom];
}

#pragma mark - ZegoChatDelegate
- (void)onGetInChatRoomResult:(uint32)result zegoToken:(uint32)zegoToken zegoId:(uint32)zegoId {
    if (result == 0) {
        NSLog(@"进入聊天室成功，开始启动直播...");
    } else {
        NSLog(@"进入聊天室失败!");
        return;
    }
    
//    if (_type == HXLiveTypePublish) {
//        ZegoAVApi *zegoApi = [HXZegoAVKitManager manager].zegoAVApi;
//        [zegoApi setLocalView:_liveView];
//        [zegoApi startPreview];
//        [zegoApi startPublishInChatRoom:_model.userName];
//    }
    NSLog(@"直播中!");
}

- (void)onChatRoomDisconnected:(uint32)err {
    NSLog(@"已经从聊天室断开了:%u", err);
    NSLog(@"直播终止");
}

- (void)onKickOut:(uint32) reason msg:(NSString*)msg{
    NSLog(@"\n已经被踢出聊天室 （%d:%@）", reason, msg);
}

- (void)onPlayListUpdate:(PlayListUpdateFlag)flag playList:(NSArray*)list {
    ZegoAVApi *zegoAVApi = [HXZegoAVKitManager manager].zegoAVApi;
    
    if (flag == PlayListUpdateFlag_Error || list.count <= 0) {
        NSLog(@"直播出错");
        NSLog(@"无法拉取到直播信息！请退出重进！");
        return;
    }
    
    if (flag == PlayListUpdateFlag_Remove) {
        NSDictionary * dictStream = list[0];
        if ([[dictStream objectForKey:PUBLISHER_ID] isEqualToString:[HXUserSession session].uid]) {
            return;     //是自己停止直播的消息，应该在停止时处理过相关逻辑，这里不再处理
        }
    } else {
        if (flag == PlayListUpdateFlag_UpdateAll) {
//            [[HXZegoAVKitManager manager].zegoAVApi stopPlayInChatRoom:streamID];
        }
        
        for (NSUInteger i = 0; i < list.count; i++) {
            NSDictionary *dictStream = list[i];
            if ([[dictStream objectForKey:PUBLISHER_ID] isEqualToString:[HXUserSession session].uid]) {
                continue;     //是自己发布直播的消息，应该在发布时处理过相关逻辑，这里不再处理
            }
            
            //有新流加入，找到一个空闲的view来播放，如果已经有两路播放，则停止比较老的流，播放新流
            NSInteger newStreamID = [[dictStream objectForKey:STREAM_ID] longLongValue];
            [zegoAVApi startPlayInChatRoom:RemoteViewIndex_First streamID:newStreamID];
        }
    }
}

#pragma mark - ZegoVideoDelegate
- (void)onPublishSucc:(uint32)zegoToken zegoId:(uint32)zegoId title:(NSString *)title {
    NSLog(@"启动直播成功，直播进行中...");
}

- (void)onPublishStop:(ShowErrCode)err zegoToken:(uint32)zegoToken zegoId:(uint32)zegoId title:(NSString *)title {
    if (err == ShowErrCode_Temp_Broken) {
        NSLog(@"网络优化中...");
        NSLog(@"直播已经被停止！");
        
        //临时中断，尝试重新启动发布直播
        ZegoAVApi *zegoAVApi = [HXZegoAVKitManager manager].zegoAVApi;
        [zegoAVApi startPreview];
    } else if (err == ShowErrCode_End) {
        //发布流正常结束
    }
}

- (void)onPlaySucc:(long long)streamID zegoToken:(uint32)zegoToken zegoId:(uint32)zegoId title:(NSString *)title {
    NSLog(@"直播中...");
}

- (void)onPlayStop:(uint32)err streamID:(long long)streamID zegoToken:(uint32)zegoToken zegoId:(uint32)zegoId title:(NSString *)title {
    if (err == ShowErrCode_Temp_Broken) {
        NSLog(@"网络优化中...");
    } else if (err == ShowErrCode_End) {
        NSLog(@"直播结束");
    }
}

- (void)onVideoSizeChanged:(long long)streamID width:(uint32)width height:(uint32)height{
    NSLog(@"%@ onVideoSizeChanged width: %u height:%u", self, width, height);
}

- (void)onPlayerCountUpdate:(uint32)userCount {
    NSLog(@"观看直播的人数:%@", @(userCount));
}

- (void)onSetPublishExtraDataResult:(uint32)errCode zegoToken:(uint32)zegoToken zegoId:(uint32)zegoId dataKey:(NSString*)strDataKey {
    ;
}

- (void)onTakeRemoteViewSnapshot:(CGImageRef)img {
    ;
}

- (void)onTakeLocalViewSnapshot:(CGImageRef)img {
    ;
}

@end
