//
//  MIAHostAttentionView.m
//  Piano
//
//  Created by 刘维 on 16/6/12.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "MIAHostAttentionView.h"
#import "MIAHostProfileModel.h"
#import "MIAFontManage.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MIAProfileViewController.h"

static CGFloat const kLiveTipLableHeight = 18.; //直播状态提示label的高度
static CGFloat const kLiveImageHeight = 8.;//直播的image的高度
CGFloat const kAttentionImageToTitleSpaceDistance = 10.;//图片与标题的间距大小.

@interface MIAHostAttentionView()

@property (nonatomic, strong) UIView *liveView;
@property (nonatomic, strong) UILabel *liveTipLabel;

@property (nonatomic, strong) HostProfileFollowModel *profileFollowModel;

@end

@implementation MIAHostAttentionView

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
    
    [self.showTipLabel setHidden:YES];
    [self.showTitleLabel setFont:[MIAFontManage getFontWithType:MIAFontType_Host_Attention_Title]->font];
    [self.showTitleLabel setTextColor:[MIAFontManage getFontWithType:MIAFontType_Host_Attention_Title]->color];
    [self.showTitleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [JOAutoLayout autoLayoutWithTopSpaceDistance:0. selfView:self.showImageView superView:self];
    [JOAutoLayout autoLayoutWithLeftSpaceDistance:0. selfView:self.showImageView superView:self];
    [JOAutoLayout autoLayoutWithRightSpaceDistance:0. selfView:self.showImageView superView:self];
    [JOAutoLayout autoLayoutWithHeightWidthRatioValue:1. selfView:self.showImageView superView:self];
    
    [JOAutoLayout autoLayoutWithTopView:self.showImageView distance:kAttentionImageToTitleSpaceDistance selfView:self.showTitleLabel superView:self];
    [JOAutoLayout autoLayoutWithLeftXView:self.showImageView selfView:self.showTitleLabel superView:self];
    [JOAutoLayout autoLayoutWithRightXView:self.showImageView selfView:self.showTitleLabel superView:self];
    [JOAutoLayout autoLayoutWithHeight:[self.showTitleLabel sizeThatFits:JOMAXSize].height selfView:self.showTitleLabel superView:self];
}

- (void)setLiveShowState:(BOOL)state{
    
    if (!self.liveView) {
        
        self.liveView = [UIView newAutoLayoutView];
        [_liveView setBackgroundColor:[UIColor whiteColor]];
        [[_liveView layer] setCornerRadius:kLiveTipLableHeight/2.];
        [[_liveView layer] setMasksToBounds:YES];
        [self addSubview:_liveView];
        
        UIImage *liveImage = [UIImage imageNamed:@"PR-Live"];
        UIImageView *liveImageView = [UIImageView newAutoLayoutView];
        [liveImageView setImage:liveImage];
        [_liveView addSubview:liveImageView];
        
        CGFloat leftSpace = (kLiveTipLableHeight - kLiveImageHeight)/2.;
        
        [JOAutoLayout autoLayoutWithLeftSpaceDistance:leftSpace selfView:liveImageView superView:_liveView];
        [JOAutoLayout autoLayoutWithTopSpaceDistance:leftSpace selfView:liveImageView superView:_liveView];
        [JOAutoLayout autoLayoutWithSize:JOSize(kLiveImageHeight, kLiveImageHeight) selfView:liveImageView superView:_liveView];
        
        self.liveTipLabel = [JOUIManage createLabelWithJOFont:[MIAFontManage getFontWithType:MIAFontType_Host_Attention_Live]];
        [_liveTipLabel setBackgroundColor:[UIColor whiteColor]];
        [_liveTipLabel setTextAlignment:NSTextAlignmentCenter];
        [[_liveTipLabel layer] setCornerRadius:kLiveTipLableHeight/2.];
        [[_liveTipLabel layer] setMasksToBounds:YES];
        [_liveTipLabel setText:@"Live"];
        [_liveView addSubview:_liveTipLabel];
        
        [JOAutoLayout autoLayoutWithLeftView:liveImageView distance:leftSpace selfView:_liveTipLabel superView:_liveView];
        [JOAutoLayout autoLayoutWithTopSpaceDistance:0. selfView:_liveTipLabel superView:_liveView];
        [JOAutoLayout autoLayoutWithBottomSpaceDistance:0. selfView:_liveTipLabel superView:_liveView];
        [JOAutoLayout autoLayoutWithRightSpaceDistance:-leftSpace selfView:_liveTipLabel superView:_liveView];
    }
    
    [JOAutoLayout removeAllAutoLayoutWithSelfView:_liveTipLabel superView:self];
    
    if (state) {
        [_liveView setHidden:NO];
        
        CGFloat leftSpace = (kLiveTipLableHeight - kLiveImageHeight)/2.;
        
        CGFloat liveViewWidth = leftSpace + kLiveImageHeight + leftSpace + [_liveTipLabel sizeThatFits:JOMAXSize].width + leftSpace;
        
        [JOAutoLayout autoLayoutWithBottomYView:self.showImageView distance:2. selfView:_liveView superView:self];
        [JOAutoLayout autoLayoutWithHeight:kLiveTipLableHeight selfView:_liveView superView:self];
        [JOAutoLayout autoLayoutWithCenterXWithView:self.showImageView selfView:_liveView superView:self];
//        [JOAutoLayout autoLayoutWithWidthWithView:self.showImageView ratioValue:3./4. selfView:_liveView superView:self];
        [JOAutoLayout autoLayoutWithWidth:liveViewWidth selfView:_liveView superView:self];
        
    }else{
        
        [_liveView setHidden:YES];
    }
}

- (void)setAttentionViewWidth:(CGFloat )width{
    
    [[self.showImageView layer] setCornerRadius:width/2.];
}

- (void)setShowData:(id)data{
    
    if ([data isKindOfClass:[HostProfileFollowModel class]]) {
        
        self.profileFollowModel = nil;
        self.profileFollowModel = data;
        
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:_profileFollowModel.userpic] placeholderImage:[UIImage imageNamed:@"C-AvatarDefaultIcon"]];
        [self.showTitleLabel setText:_profileFollowModel.nick];
        [self setLiveShowState:[_profileFollowModel.live boolValue]];

        [self updateViewLayout];
    }else{
    
        [JOFException exceptionWithName:@"MIAHostAttentionView exception!" reason:@"data 必须是HostProfileFollowModel类型"];
    }
}

#pragma mark - tap gesture

- (void)tapAction:(UIGestureRecognizer *)gesture{
    
    MIAProfileViewController *profileViewController = [MIAProfileViewController new];
    [profileViewController setUid:_profileFollowModel.fuID];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [(UINavigationController *)[[delegate window] rootViewController] pushViewController:profileViewController animated:YES];
}

@end
