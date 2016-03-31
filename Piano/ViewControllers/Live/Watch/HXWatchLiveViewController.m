//
//  HXWatchLiveViewController.m
//  Piano
//
//  Created by miaios on 16/3/24.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXWatchLiveViewController.h"
#import "HXZegoAVKitManager.h"
#import <ZegoAVKit/ZegoMoviePlayer.h>
#import "HXCommentContainerViewController.h"
#import "HXLiveAnchorView.h"
#import "HXWatchLiveBottomBar.h"
#import "HXWatcherBoard.h"
#import "HXWatchLiveViewModel.h"
#import "HXSettingSession.h"
#import "UIButton+WebCache.h"
#import "HXUserSession.h"


@interface HXWatchLiveViewController () <
ZegoChatDelegate,
ZegoVideoDelegate,
HXCommentContainerViewControllerDelegate,
HXLiveAnchorViewDelegate,
HXWatchLiveBottomBarDelegate
>
@end


@implementation HXWatchLiveViewController {
    HXCommentContainerViewController *_containerViewController;
    HXWatchLiveViewModel *_viewModel;
}

#pragma mark - Class Methods
+ (HXStoryBoardName)storyBoardName {
    return HXStoryBoardNameLive;
}

+ (NSString *)navigationControllerIdentifier {
    return @"HXWatchLiveNavigationController";
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    _containerViewController = segue.destinationViewController;
    _containerViewController.delegate = self;
}

#pragma mark - Status Bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    
    [self loadConfigure];
    [self viewConfigure];
}

#pragma mark - Configure Methods
- (void)loadConfigure {
    _viewModel = [[HXWatchLiveViewModel alloc] initWithRoomID:_roomID];
    [self signalLink];
}

- (void)viewConfigure {
    ZegoAVApi *zegoAVApi = [HXZegoAVKitManager manager].zegoAVApi;
    
    [zegoAVApi setRemoteView:RemoteViewIndex_First view:_liveView];
    [zegoAVApi setRemoteViewMode:RemoteViewIndex_First mode:ZegoVideoViewModeScaleToFill];
    
    //设置回调代理
    [zegoAVApi setChatDelegate:self callbackQueue:dispatch_get_main_queue()];
    [zegoAVApi setVideoDelegate:self callbackQueue:dispatch_get_main_queue()];
}

- (void)signalLink {
    @weakify(self)
    [_viewModel.enterSignal subscribeNext:^(id x) {
        @strongify(self)
    }];
    [_viewModel.exitSignal subscribeNext:^(id x) {
        @strongify(self)
    }];
    [_viewModel.commentSignal subscribeNext:^(id x) {
        @strongify(self)
    }];
    
    RACSignal *enterRoomSiganl = [_viewModel.enterRoomCommand execute:nil];
    [enterRoomSiganl subscribeError:^(NSError *error) {
        @strongify(self)
        [self showBannerWithPrompt:error.domain];
    } completed:^{
        @strongify(self)
        [self fetchDataFinfished];
    }];
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
    [_viewModel.enterRoomCommand execute:nil];
    [[HXZegoAVKitManager manager].zegoAVApi leaveChatRoom];
}

- (void)fetchDataFinfished {
    [self roomConfigure];
    [self updateAnchorView];
}

- (void)roomConfigure {
    ZegoAVApi *zegoAVApi = [HXZegoAVKitManager manager].zegoAVApi;
    
    HXLiveModel *model = _viewModel.model;
    //进入聊天室
    ZegoUser *user = [ZegoUser new];
    user.userID = [HXUserSession session].uid;
    user.userName = [HXUserSession session].nickName;
    
    UInt32 roomToken = (UInt32)model.zegoToken;
    UInt32 roomNum = (UInt32)model.zegoID;
    [zegoAVApi getInChatRoom:user zegoToken:roomToken zegoId:roomNum];
    [zegoAVApi setAVConfig:[HXSettingSession session].configure];
}

- (void)updateAnchorView {
    [_anchorView.avatar sd_setImageWithURL:[NSURL URLWithString:_viewModel.anchorAvatar] forState:UIControlStateNormal];
    _anchorView.nickNameLabel.text = _viewModel.anchorNickName;
    _anchorView.countLabel.text = _viewModel.viewCount;
}

#pragma mark - ZegoChatDelegate
- (void)onGetInChatRoomResult:(uint32)result zegoToken:(uint32)zegoToken zegoId:(uint32)zegoId {
    if (result == 0) {
        NSLog(@"进入聊天室成功，开始启动直播...");
    } else {
        NSLog(@"进入聊天室失败!");
        return;
    }
    NSLog(@"直播中!");
}

- (void)onChatRoomDisconnected:(uint32)err {
    NSLog(@"已经从聊天室断开了:%u", err);
    NSLog(@"直播终止");
}

- (void)onKickOut:(uint32)reason msg:(NSString*)msg {
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

- (void)onVideoSizeChanged:(long long)streamID width:(uint32)width height:(uint32)height {
    NSLog(@"%@ onVideoSizeChanged width: %u height:%u", self, width, height);
}

- (void)onPlayerCountUpdate:(uint32)userCount {
    NSLog(@"观看直播的人数:%@", @(userCount));
}

- (void)onSetPublishExtraDataResult:(uint32)errCode zegoToken:(uint32)zegoToken zegoId:(uint32)zegoId dataKey:(NSString*)strDataKey {}

- (void)onTakeRemoteViewSnapshot:(CGImageRef)img {}

- (void)onTakeLocalViewSnapshot:(CGImageRef)img {}

#pragma mark - HXCommentContainerViewControllerDelegate Methods
- (void)container:(HXCommentContainerViewController *)container shouldShowWatcher:(id)watcher {
    [HXWatcherBoard showWithWatcher:watcher closed:^{
        ;
    }];
}

#pragma mark - HXLiveAnchorViewDelegate Methods
- (void)anchorView:(HXLiveAnchorView *)anchorView takeAction:(HXLiveAnchorViewAction)action {
    ;
}

#pragma mark - HXWatchLiveBottomBarDelegate Methods
- (void)bottomBar:(HXWatchLiveBottomBar *)bar takeAction:(HXWatchLiveBottomBarAction)action {
    ;
}

@end
