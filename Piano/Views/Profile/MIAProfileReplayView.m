//
//  MIAProfileReplayView.m
//  Piano
//
//  Created by 刘维 on 16/5/6.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "MIAProfileReplayView.h"
#import "AppDelegate.h"
#import "MIAReplayModel.h"
#import "HXReplayLandscapeViewController.h"
#import "MusicMgr.h"
#import "MiaAPIHelper.h"
#import "WebSocketMgr.h"
#import "UserSetting.h"
#import "BlocksKit+UIKit.h"

CGFloat kProfileReplayImageToTitleSpaceDistance = 9. ;
CGFloat kProfileReplayTitleToTipSpaceDistance =  2.;

//直播回放的  宽/高  16:9

@interface MIAProfileReplayView()

@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *numberlabel;

@end

@implementation MIAProfileReplayView {
    MIAReplayModel *_replayModel;
}

- (void)addTapGesture{
    
    if (objc_getAssociatedObject(self, _cmd)) {
        //
    }else{
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
        objc_setAssociatedObject(self, _cmd, @"only", OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)updateViewLayout{
    
    [super updateViewLayout];
    
    [self addTapGesture];
    [self.showImageView setBackgroundColor:JORGBCreate(230., 230., 230., 1.)];
//    [[self.showImageView layer] setBorderWidth:0.5];
//    [[self.showImageView layer] setBorderColor:[UIColor grayColor].CGColor];
//    [[self.showImageView layer] setCornerRadius:3.];
    [self.showTitleLabel setJOFont:[MIAFontManage getFontWithType:MIAFontType_Profile_Replay_Name]];
    
    [self.showTipLabel setJOFont:[MIAFontManage getFontWithType:MIAFontType_Profile_Replay_Date]];
    
    
    [JOAutoLayout autoLayoutWithLeftSpaceDistance:0. selfView:self.showImageView superView:self];
    [JOAutoLayout autoLayoutWithRightSpaceDistance:0. selfView:self.showImageView superView:self];
    [JOAutoLayout autoLayoutWithTopSpaceDistance:0. selfView:self.showImageView superView:self];
//    [JOAutoLayout autoLayoutWithHeightWidthRatioValue:1. selfView:self.showImageView superView:self];
    [JOAutoLayout autoLayoutWithWidthHeightRatioValue:16./9. selfView:self.showImageView superView:self];
    
    [JOAutoLayout autoLayoutWithTopView:self.showImageView distance:kProfileReplayImageToTitleSpaceDistance selfView:self.showTitleLabel superView:self];
    [JOAutoLayout autoLayoutWithLeftXView:self.showImageView selfView:self.showTitleLabel superView:self];
    [JOAutoLayout autoLayoutWithRightXView:self.showImageView selfView:self.showTitleLabel superView:self];
    [JOAutoLayout autoLayoutWithHeight:[self.showTitleLabel sizeThatFits:JOMAXSize].height selfView:self.showTitleLabel superView:self];
    
    [JOAutoLayout autoLayoutWithTopView:self.showTitleLabel distance:kProfileReplayTitleToTipSpaceDistance selfView:self.showTipLabel superView:self];
    [JOAutoLayout autoLayoutWithLeftXView:self.showImageView selfView:self.showTipLabel superView:self];
    [JOAutoLayout autoLayoutWithRightXView:self.showImageView selfView:self.showTipLabel superView:self];
    [JOAutoLayout autoLayoutWithBottomSpaceDistance:0. selfView:self.showTipLabel superView:self];
    
    [JOAutoLayout autoLayoutWithRightSpaceDistance:0. selfView:_numberlabel superView:self];
    [JOAutoLayout autoLayoutWithTopSpaceDistance:7. selfView:_numberlabel superView:self];
    [JOAutoLayout autoLayoutWithHeight:[_numberlabel sizeThatFits:JOMAXSize].height+4. selfView:_numberlabel superView:self];
    [JOAutoLayout autoLayoutWithWidth:[_numberlabel sizeThatFits:JOMAXSize].width + 8. selfView:_numberlabel superView:self];
    
    UIImage *videoImage = [UIImage imageNamed:@"PR-Video"];
    
    [JOAutoLayout autoLayoutWithRightView:_numberlabel distance:-5. selfView:_videoImageView superView:self];
    [JOAutoLayout autoLayoutWithTopYView:_numberlabel selfView:_videoImageView superView:self];
    [JOAutoLayout autoLayoutWithBottomYView:_numberlabel selfView:_videoImageView superView:self];
    [JOAutoLayout autoLayoutWithWidth:videoImage.size.width selfView:_videoImageView superView:self];
    
}

- (void)createTipNumberView{
    
    if (!self.videoImageView) {
        
        self.videoImageView = [UIImageView newAutoLayoutView];
        [_videoImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_videoImageView setImage:[UIImage imageNamed:@"PR-Video"]];
        [self addSubview:_videoImageView];
        
        self.numberlabel = [JOUIManage createLabelWithJOFont:[MIAFontManage getFontWithType:MIAFontType_Profile_Replay_ViweCount]];
        [self addSubview:_numberlabel];
    }
}

- (void)setShowData:(id)data {
    
    if ([data isKindOfClass:[MIAReplayModel class]]) {
    
        [self createTipNumberView];
        
        _replayModel = data;
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:_replayModel.coverUrl] placeholderImage:nil];
        [self.showTitleLabel setText:_replayModel.title];
        [self.showTipLabel setText:[_replayModel.createTime JOConvertTimelineToDateStringWithFormatterType:JODateFormatterMonthDay]];
        [_numberlabel setText:_replayModel.replayCnt];
        
        [self updateViewLayout];
    }else{
    
        [JOFException exceptionWithName:@"MIAProfileReplayView exception" reason:@"data 不是MIAReplayModel类型"];
    }
}

#pragma mark - tag action

- (void)enterReplayViewController{

    //视频统计.
    [MiaAPIHelper videoCountWithID:_replayModel.roomID
                     completeBlock:^(MiaRequestItem *requestItem, BOOL success, NSDictionary *userInfo) {
                         
                         if (success) {
                             //            JOLog(@"视频统计成功");
                             NSString *viewCount = [NSString stringWithFormat:@"%ld",(long)[JOConvertStringToNormalString(_replayModel.replayCnt) integerValue] +1];
                             _replayModel.replayCnt = viewCount;
                             [_numberlabel setText:viewCount];
                         }else{
                             //            JOLog(@"error:%@",userInfo[MiaAPIKey_Values][MiaAPIKey_Error]);
                         }
                     } timeoutBlock:^(MiaRequestItem *requestItem) {
                         
                     }];
    
    HXReplayViewController *replayViewController = nil;
    if (_replayModel.horizontal) {
        replayViewController = [HXReplayLandscapeViewController instance];
    } else {
        replayViewController = [HXReplayViewController instance];
    }
    replayViewController.model = [HXDiscoveryModel createWithReplayModel:_replayModel];
    replayViewController.model.uID = _uid;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:replayViewController animated:YES completion:^{
        if ([[MusicMgr standard] isPlaying]) {
            [[MusicMgr standard] pause];
        }
    }];
}

- (void)tapAction:(UIGestureRecognizer *)gesture {

	if ([[WebSocketMgr standard] isWifiNetwork] || [UserSetting playWith3G]) {
		[self enterReplayViewController];
	} else {
		[UIAlertView bk_showAlertViewWithTitle:k3GPlayTitle message:k3GPlayMessage cancelButtonTitle:k3GPlayCancel otherButtonTitles:@[k3GPlayAllow] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
			if (buttonIndex != alertView.cancelButtonIndex) {
				[self enterReplayViewController];
			}
		}];
	}
}

@end
