//
//  MIAAlbumRewardView.m
//  Piano
//
//  Created by 刘维 on 16/5/10.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "MIAAlbumRewardView.h"
#import "UIImageView+WebCache.h"
#import "MIAAlbumModel.h"
#import "MIAFontManage.h"
#import "JOBaseSDK.h"

static CGFloat const kTipLabelToUserItemSpaceDistance = 5.;
static CGFloat const kScrollViewToBottomSpaceDistance = 5.;
static CGFloat const kAlbumUserItemSpaceDistance = 6.;//每个元素之间的间距

@interface MIAAlbumRewardView(){

    CGFloat rewardViewHeight;
    CGFloat rewardSrcollHeight;
    CGFloat rewardContentWidth;
}

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIScrollView *rewardScrollView;
@property (nonatomic, strong) UIView *rewardContentView;

@end

@implementation MIAAlbumRewardView

- (instancetype)init{

    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self createRewardView];
    }
    return self;
}

- (void)setRewardViewHeight:(CGFloat)height{

    rewardViewHeight = height;
    rewardSrcollHeight = rewardViewHeight - [_tipLabel sizeThatFits:JOMAXSize].height - kTipLabelToUserItemSpaceDistance - kScrollViewToBottomSpaceDistance;
}

- (void)createRewardView{

    self.tipLabel = [JOUIManage createLabelWithJOFont:[MIAFontManage getFontWithType:MIAFontType_Album_Reward_Tip]];
    [_tipLabel setText:@" "];
    [self addSubview:_tipLabel];
    
//    [JOAutoLayout autoLayoutWithLeftSpaceDistance:0. selfView:_tipLabel superView:self];
//    [JOAutoLayout autoLayoutWithRightSpaceDistance:0. selfView:_tipLabel superView:self];
//    [JOAutoLayout autoLayoutWithTopSpaceDistance:0. selfView:_tipLabel superView:self];
//    [JOAutoLayout autoLayoutWithHeight:[_tipLabel sizeThatFits:JOMAXSize].height selfView:_tipLabel superView:self];
    
    [_tipLabel layoutLeft:0. layoutItemHandler:nil];
    [_tipLabel layoutRight:0. layoutItemHandler:nil];
    [_tipLabel layoutTop:0. layoutItemHandler:nil];
    [_tipLabel layoutHeight:[_tipLabel sizeThatFits:JOMAXSize].height layoutItemHandler:nil];
    
    self.rewardScrollView = [UIScrollView newAutoLayoutView];
    [_rewardScrollView setBackgroundColor:[UIColor whiteColor]];
    [_rewardScrollView setShowsHorizontalScrollIndicator:NO];
    [_rewardScrollView setShowsVerticalScrollIndicator:NO];
    [self addSubview:_rewardScrollView];
    
//    [JOAutoLayout autoLayoutWithTopView:_tipLabel distance:kTipLabelToUserItemSpaceDistance selfView:_rewardScrollView superView:self];
//    [JOAutoLayout autoLayoutWithLeftSpaceDistance:0. selfView:_rewardScrollView superView:self];
//    [JOAutoLayout autoLayoutWithRightSpaceDistance:0. selfView:_rewardScrollView superView:self];
//    [JOAutoLayout autoLayoutWithBottomSpaceDistance:-kScrollViewToBottomSpaceDistance selfView:_rewardScrollView superView:self];
    
    [_rewardScrollView layoutTopView:_tipLabel distance:kTipLabelToUserItemSpaceDistance layoutItemHandler:nil];
    [_rewardScrollView layoutLeft:0. layoutItemHandler:nil];
    [_rewardScrollView layoutRight:0. layoutItemHandler:nil];
    [_rewardScrollView layoutBottom:-kScrollViewToBottomSpaceDistance layoutItemHandler:nil];
    
    self.rewardContentView = [UIView newAutoLayoutView];
    [_rewardScrollView addSubview:_rewardContentView];
    
//    [JOAutoLayout autoLayoutWithEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 0.) selfView:_rewardContentView superView:_rewardScrollView];
    
    [_rewardContentView layoutEdge:UIEdgeInsetsMake(0., 0., 0., 0.) layoutItemHandler:nil];
   
}

- (void)setRewardData:(id)rewardData{

    if ([rewardData isKindOfClass:[NSArray class]]) {
        
        rewardContentWidth = 0.;
        [self removeAllRewardScrollSubViews];
        [_tipLabel setText:[NSString stringWithFormat:@"已打赏:%lu人",(unsigned long)[rewardData count]]];
        
        if([rewardData count] == 0){
        
//            [JOAutoLayout removeAutoLayoutWithBottomSelfView:_rewardScrollView superView:self];
//            [JOAutoLayout autoLayoutWithBottomSpaceDistance:0. selfView:_rewardScrollView superView:self];
            
            [_rewardScrollView layoutBottom:0. layoutItemHandler:nil];
        }
        
        for (int i = 0; i < [rewardData count]; i++) {
            if ([[rewardData objectAtIndex:i] isKindOfClass:[MIARewardAlbumModel class]]) {
                
                MIARewardAlbumModel *rewardAlbumModel = [rewardData objectAtIndex:i];
                
                UIImageView *userImageView = [UIImageView newAutoLayoutView];
                [userImageView setBackgroundColor:[UIColor grayColor]];
                [[userImageView layer] setCornerRadius:rewardSrcollHeight/2.];
                [[userImageView layer] setMasksToBounds:YES];
                [[userImageView layer] setBorderWidth:1.];
                [[userImageView layer] setBorderColor:JORGBSameCreate(220.).CGColor];
                [userImageView setTag:i+1];
                [userImageView sd_setImageWithURL:[NSURL URLWithString:rewardAlbumModel.userpic] placeholderImage:[UIImage imageNamed:@"C-DefaultAvatar"]];
                [_rewardContentView addSubview:userImageView];
                
//                [JOAutoLayout autoLayoutWithTopSpaceDistance:0. selfView:userImageView superView:_rewardContentView];
//                [JOAutoLayout autoLayoutWithBottomSpaceDistance:0. selfView:userImageView superView:_rewardContentView];
//                [JOAutoLayout autoLayoutWithWidthEqualHeightWithselfView:userImageView superView:_rewardContentView];
                
                [userImageView layoutTop:0. layoutItemHandler:nil];
                [userImageView layoutBottom:0. layoutItemHandler:nil];
                [userImageView layoutWidthHeightRatio:1. layoutItemHandler:nil];
                
                if (i == 0) {
//                    [JOAutoLayout autoLayoutWithLeftSpaceDistance:0. selfView:userImageView superView:_rewardContentView];
                    [userImageView layoutLeft:0. layoutItemHandler:nil];
                }else{
                    UIView *lastView = [_rewardContentView viewWithTag:i];
//                    [JOAutoLayout autoLayoutWithLeftView:lastView distance:kAlbumUserItemSpaceDistance selfView:userImageView superView:_rewardContentView];
                    [userImageView layoutLeftView:lastView distance:kAlbumUserItemSpaceDistance layoutItemHandler:nil];
                }
                
                rewardContentWidth += rewardSrcollHeight;
                rewardContentWidth += kAlbumUserItemSpaceDistance;
                [_rewardScrollView setContentSize:JOSize(rewardContentWidth, rewardSrcollHeight)];
                
                
//                [JOAutoLayout removeAutoLayoutWithSizeSelfView:_rewardContentView superView:_rewardScrollView];
//                [JOAutoLayout autoLayoutWithSize:JOSize(rewardContentWidth, rewardSrcollHeight) selfView:_rewardContentView superView:_rewardScrollView];
                
                [_rewardContentView layoutSize:JOSize(rewardContentWidth, rewardSrcollHeight) layoutItemHandler:nil];
                
            }
        }
    }else{
    
        [JOFException exceptionWithName:@"MIAAlbumRewardView exception!" reason:@"rewardData需要为一个数组类型"];
    }
}

- (void)removeAllRewardScrollSubViews{

    for (UIView *view in _rewardContentView.subviews) {
        [view setHidden:YES];
        [view removeFromSuperview];
    }
}

- (void)removeRewardViewLayout{

    [JOAutoLayout removeAllAutoLayoutWithSelfView:_tipLabel superView:self];
}

@end
