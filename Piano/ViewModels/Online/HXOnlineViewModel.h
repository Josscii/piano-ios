//
//  HXOnlineViewModel.h
//  Piano
//
//  Created by miaios on 16/3/23.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "ReactiveCocoa.h"
#import "HXOnlineModel.h"


@interface HXOnlineViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *fetchCommand;

@property (nonatomic, assign, readonly)    CGFloat  cellHeight;

@property (nonatomic, strong, readonly) NSArray<HXOnlineModel *> *onlineList;

@end
