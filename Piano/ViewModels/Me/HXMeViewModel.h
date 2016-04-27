//
//  HXMeViewModel.h
//  Piano
//
//  Created by miaios on 16/3/28.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "ReactiveCocoa.h"
#import "HXProfileModel.h"


typedef NS_ENUM(NSUInteger, HXMeRowType) {
    HXMeRowTypeRecharge,
    HXMeRowTypePurchaseHistory,
    HXMeRowTypeMyStation,
    HXMeRowTypeAttentionPrompt,
    HXMeRowTypeAttentions,
};


@interface HXMeViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *fetchCommand;

@property (nonatomic, assign, readonly)   CGFloat  normalHeight;
@property (nonatomic, assign, readonly)   CGFloat  attentionHeight;

@property (nonatomic, assign, readonly) NSInteger  rows;
@property (nonatomic, strong, readonly)   NSArray *rowTypes;

@property (nonatomic, strong, readonly) HXProfileModel *model;

@end
