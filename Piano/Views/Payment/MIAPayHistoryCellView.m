//
//  MIAPayHistoryView.m
//  Piano
//
//  Created by 刘维 on 16/5/16.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "MIAPayHistoryCellView.h"
#import "UIImageView+WebCache.h"
#import "JOBaseSDK.h"
#import "MIAFontManage.h"

static CGFloat const kGiftImageViewWidth = 50.;//礼物图片的宽度
static CGFloat const kPayHistoryImageToLabelSpaceDistance = 15.;//礼物与名字的间距大小

@interface MIAPayHistoryCellView()

@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *mCountLabel;

@end

@implementation MIAPayHistoryCellView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self createPayHistoryView];
    }
    return self;
}

- (void)createPayHistoryView{

    self.giftImageView = [UIImageView newAutoLayoutView];
    [_giftImageView setBackgroundColor:[UIColor grayColor]];
    [[_giftImageView layer] setCornerRadius:kGiftImageViewWidth/2.];
    [[_giftImageView layer] setMasksToBounds:YES];
    [self addSubview:_giftImageView];
    
    [JOAutoLayout autoLayoutWithLeftSpaceDistance:0. selfView:_giftImageView superView:self];
    [JOAutoLayout autoLayoutWithTopSpaceDistance:0. selfView:_giftImageView superView:self];
    [JOAutoLayout autoLayoutWithSize:JOSize(kGiftImageViewWidth, kGiftImageViewWidth) selfView:_giftImageView superView:self];
    
    self.mCountLabel = [JOUIManage createLabelWithJOFont:[MIAFontManage getFontWithType:MIAFontType_PayHistory_Amount]];
    [self addSubview:_mCountLabel];
    
    [JOAutoLayout autoLayoutWithRightSpaceDistance:0. selfView:_mCountLabel superView:self];
    [JOAutoLayout autoLayoutWithTopYView:_giftImageView selfView:_mCountLabel superView:self];
    [JOAutoLayout autoLayoutWithBottomYView:_giftImageView selfView:_mCountLabel superView:self];
    [JOAutoLayout autoLayoutWithWidth:30. selfView:_mCountLabel superView:self];
    
    self.nameLabel = [JOUIManage createLabelWithJOFont:[MIAFontManage getFontWithType:MIAFontType_PayHistory_Title]];
    [self addSubview:_nameLabel];
    
    [JOAutoLayout autoLayoutWithLeftView:_giftImageView distance:kPayHistoryImageToLabelSpaceDistance selfView:_nameLabel superView:self];
    [JOAutoLayout autoLayoutWithTopYView:_giftImageView selfView:_nameLabel superView:self];
    [JOAutoLayout autoLayoutWithRightView:_mCountLabel distance:0. selfView:_nameLabel superView:self];
    [JOAutoLayout autoLayoutWithHeightWithView:_giftImageView ratioValue:1./2. selfView:_nameLabel superView:self];
    
    self.dateLabel = [JOUIManage createLabelWithJOFont:[MIAFontManage getFontWithType:MIAFontType_PayHistory_Time]];
    [self addSubview:_dateLabel];
    
    [JOAutoLayout autoLayoutWithLeftXView:_nameLabel selfView:_dateLabel superView:self];
    [JOAutoLayout autoLayoutWithTopView:_nameLabel distance:0. selfView:_dateLabel superView:self];
    [JOAutoLayout autoLayoutWithBottomYView:_giftImageView selfView:_dateLabel superView:self];
    [JOAutoLayout autoLayoutWithRightXView:_nameLabel selfView:_dateLabel superView:self];
    
}

- (void)setPayHistoryFlag:(NSInteger)flag{


    if (flag == 0) {
        //礼物
        [_nameLabel setText:@"礼物A x 3"];
        [_mCountLabel setText:@"-100M"];
        [_dateLabel setText:@"3月23日"];
        
        [JOAutoLayout removeAutoLayoutWithSizeSelfView:_mCountLabel superView:self];
        [JOAutoLayout autoLayoutWithWidth:[_mCountLabel sizeThatFits:JOMAXSize].width+1 selfView:_mCountLabel superView:self];
        
    }else {
        //充值记录
        [_nameLabel setText:@"充值 100元"];
        [_mCountLabel setText:@"+100M"];
        [_dateLabel setText:@"3月23日"];
        
        [JOAutoLayout removeAutoLayoutWithWidthSelfView:_giftImageView superView:self];
        [JOAutoLayout autoLayoutWithWidth:CGFLOAT_MIN selfView:_giftImageView superView:self];
        
        [JOAutoLayout removeAutoLayoutWithWidthSelfView:_mCountLabel superView:self];
        [JOAutoLayout autoLayoutWithWidth:[_mCountLabel sizeThatFits:JOMAXSize].width+1 selfView:_mCountLabel superView:self];
    }
}

@end
