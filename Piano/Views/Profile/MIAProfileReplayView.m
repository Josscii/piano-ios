//
//  MIAProfileReplayView.m
//  Piano
//
//  Created by 刘维 on 16/5/6.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "MIAProfileReplayView.h"
#import "MIAReplayModel.h"

@interface MIAProfileReplayView()

@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *numberlabel;

@end

@implementation MIAProfileReplayView

- (void)updateViewLayout{
    
    [super updateViewLayout];
    
//    [self.showImageView setBackgroundColor:[UIColor purpleColor]];
    [[self.showImageView layer] setCornerRadius:3.];
    [self.showTitleLabel setFont:[UIFont systemFontOfSize:15.]];
    [self.showTitleLabel setTextColor:[UIColor blackColor]];
    
    [self.showTipLabel setTextColor:[UIColor grayColor]];
    [self.showTipLabel setFont:[UIFont systemFontOfSize:10.]];
    
    
    [JOAutoLayout autoLayoutWithLeftSpaceDistance:0. selfView:self.showImageView superView:self];
    [JOAutoLayout autoLayoutWithRightSpaceDistance:0. selfView:self.showImageView superView:self];
    [JOAutoLayout autoLayoutWithTopSpaceDistance:0. selfView:self.showImageView superView:self];
    [JOAutoLayout autoLayoutWithHeightWidthRatioValue:1. selfView:self.showImageView superView:self];
    
    [JOAutoLayout autoLayoutWithTopView:self.showImageView distance:0. selfView:self.showTitleLabel superView:self];
    [JOAutoLayout autoLayoutWithLeftXView:self.showImageView selfView:self.showTitleLabel superView:self];
    [JOAutoLayout autoLayoutWithRightXView:self.showImageView selfView:self.showTitleLabel superView:self];
    [JOAutoLayout autoLayoutWithHeight:[self.showTitleLabel sizeThatFits:JOMAXSize].height + 6 selfView:self.showTitleLabel superView:self];
    
    [JOAutoLayout autoLayoutWithTopView:self.showTitleLabel distance:0 selfView:self.showTipLabel superView:self];
    [JOAutoLayout autoLayoutWithLeftXView:self.showImageView selfView:self.showTipLabel superView:self];
    [JOAutoLayout autoLayoutWithRightXView:self.showImageView selfView:self.showTipLabel superView:self];
    [JOAutoLayout autoLayoutWithBottomSpaceDistance:0. selfView:self.showTipLabel superView:self];
    
    [JOAutoLayout autoLayoutWithRightSpaceDistance:0. selfView:_numberlabel superView:self];
    [JOAutoLayout autoLayoutWithTopSpaceDistance:5. selfView:_numberlabel superView:self];
    [JOAutoLayout autoLayoutWithHeight:[_numberlabel sizeThatFits:JOMAXSize].height selfView:_numberlabel superView:self];
    [JOAutoLayout autoLayoutWithWidth:[_numberlabel sizeThatFits:JOMAXSize].width + 8. selfView:_numberlabel superView:self];
    
    [JOAutoLayout autoLayoutWithRightView:_numberlabel distance:0. selfView:_videoImageView superView:self];
    [JOAutoLayout autoLayoutWithTopYView:_numberlabel selfView:_videoImageView superView:self];
    [JOAutoLayout autoLayoutWithBottomYView:_numberlabel selfView:_videoImageView superView:self];
    [JOAutoLayout autoLayoutWithWidthEqualHeightWithselfView:_videoImageView superView:self];
    
}

- (void)createTipNumberView{
    
    if (!self.videoImageView) {
        
        self.videoImageView = [UIImageView newAutoLayoutView];
        [_videoImageView setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:_videoImageView];
        
        self.numberlabel = [JOUIManage createLabelWithTextColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:12.]];
        [self addSubview:_numberlabel];
    }
    
    
    
}

- (void)setShowData:(id)data{
    
    if ([data isKindOfClass:[MIAReplayModel class]]) {
    
        [self createTipNumberView];
        
        MIAReplayModel *replayModel = data;
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:replayModel.coverUrl] placeholderImage:nil];
        [self.showTitleLabel setText:replayModel.title];
        [self.showTipLabel setText:replayModel.createTime];
        [_numberlabel setText:replayModel.viewCnt];
        
        [self updateViewLayout];
        
    }else{
    
        [JOFException exceptionWithName:@"MIAProfileReplayView exception" reason:@"data 不是MIAReplayModel类型"];
    }
}

@end
