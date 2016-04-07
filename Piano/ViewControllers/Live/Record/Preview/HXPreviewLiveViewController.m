//
//  HXPreviewLiveViewController.m
//  Piano
//
//  Created by miaios on 16/4/7.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXPreviewLiveViewController.h"
#import "HXCountDownViewController.h"
#import "HXZegoAVKitManager.h"
#import "HXSettingSession.h"
#import "HXPreviewLiveTopBar.h"
#import "HXPreviewLiveEidtView.h"
#import "HXPreviewLiveControlView.h"
#import "MiaAPIHelper.h"


@interface HXPreviewLiveViewController () <
HXCountDownViewControllerDelegate,
HXPreviewLiveTopBarDelegate,
HXPreviewLiveEidtViewDelegate,
HXPreviewLiveControlViewDelegate
>
@end


@implementation HXPreviewLiveViewController {
    HXCountDownViewController *_countDownViewController;
    
    NSString *_roomID;
    NSString *_roomTitle;
    NSString *_shareUrl;
    BOOL _frontCamera;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    _countDownViewController = segue.destinationViewController;
    _countDownViewController.delegate = self;
}

#pragma mark - Status Bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadConfigure];
    [self viewConfigure];
}

#pragma mark - Configure Methods
- (void)loadConfigure {
    _frontCamera = YES;
    
    [MiaAPIHelper createRoomWithCompleteBlock:^(MiaRequestItem *requestItem, BOOL success, NSDictionary *userInfo) {
        [self hiddenHUD];
        
        if (success) {
            NSDictionary *data = userInfo[MiaAPIKey_Values][MiaAPIKey_Data];
            self->_roomID = data[@"roomID"];
            self->_shareUrl = data[@"shareUrl"];
        }
    } timeoutBlock:^(MiaRequestItem *requestItem) {
        [self hiddenHUD];
        [self showBannerWithPrompt:TimtOutPrompt];
    }];
}

- (void)viewConfigure {
    [self showHUD];
    
    [self startPreview];
}

#pragma mark - Private Methods
- (void)startPreview {
    [[HXZegoAVKitManager manager].zegoAVApi setFrontCam:_frontCamera];
    
    ZegoAVApi *zegoAVApi = [HXZegoAVKitManager manager].zegoAVApi;
    [zegoAVApi setAVConfig:[HXSettingSession session].configure];
    [zegoAVApi setLocalView:_preview];
    [zegoAVApi setLocalViewMode:ZegoVideoViewModeScaleAspectFill];
    [zegoAVApi startPreview];
}

- (void)stopPreview {
    ZegoAVApi *zegoAVApi = [HXZegoAVKitManager manager].zegoAVApi;
    [zegoAVApi setLocalView:nil];
    [zegoAVApi stopPreview];
}

- (void)startCountDown {
    _countDownContainerView.hidden = NO;
    [_countDownViewController startCountDown];
}

- (void)setRoomTitle {
    [self showHUD];
    
    _roomTitle = _editView.textField.text;
    
    if (_roomTitle.length) {
        [MiaAPIHelper setRoomTitle:_roomTitle
                            roomID:_roomID
                     completeBlock:
         ^(MiaRequestItem *requestItem, BOOL success, NSDictionary *userInfo) {
             if (success) {
                 self.controlContainerView.hidden = YES;
                 [self startCountDown];
             }
             [self hiddenHUD];
         } timeoutBlock:^(MiaRequestItem *requestItem) {
             [self hiddenHUD];
             [self showBannerWithPrompt:TimtOutPrompt];
         }];
    } else {
        [self hiddenHUD];
        [self showBannerWithPrompt:@"请先填写直播标题！"];
    }
}

#pragma mark - HXCountDownViewControllerDelegate Methods
- (void)countDownFinished {
    _countDownContainerView.hidden = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(previewControllerHandleFinishedShouldStartLive:roomID:roomTitle:shareUrl:)]) {
        [_delegate previewControllerHandleFinishedShouldStartLive:self roomID:_roomID roomTitle:_roomTitle shareUrl:_shareUrl];
    }
}

#pragma mark - HXPreviewLiveTopBarDelegate Methods
- (void)topBar:(HXPreviewLiveTopBar *)bar takeAction:(HXPreviewLiveTopBarAction)action {
    switch (action) {
        case HXPreviewLiveTopBarActionBeauty: {
            ;
            break;
        }
        case HXPreviewLiveTopBarActionChange: {
            _frontCamera = !_frontCamera;
            [[HXZegoAVKitManager manager].zegoAVApi setFrontCam:_frontCamera];
            break;
        }
        case HXPreviewLiveTopBarActionColse: {
            [self stopPreview];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
    }
}

#pragma marrk - HXPreviewLiveEidtViewDelegate Methods
- (void)editView:(HXPreviewLiveEidtView *)editView takeAction:(HXPreviewLiveEidtViewAction)action {
    switch (action) {
        case HXPreviewLiveEidtViewActionEdit: {
            ;
            break;
        }
        case HXPreviewLiveEidtViewActionCamera: {
            ;
            break;
        }
        case HXPreviewLiveEidtViewActionLocation: {
            ;
            break;
        }
    }
}

#pragma mark - HXPreviewLiveControlViewDelegate Methods
- (void)controlView:(HXPreviewLiveControlView *)controlView takeAction:(HXPreviewLiveControlViewAction)action {
    switch (action) {
        case HXPreviewLiveControlViewActionFriendsCycle: {
            ;
            break;
        }
        case HXPreviewLiveControlViewActionWeChat: {
            ;
            break;
        }
        case HXPreviewLiveControlViewActionWeiBo: {
            ;
            break;
        }
        case HXPreviewLiveControlViewActionStartLive: {
            [self setRoomTitle];
            break;
        }
    }
}

@end
