//
//  HXReplayViewModel.h
//  Piano
//
//  Created by miaios on 16/4/12.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "ReactiveCocoa.h"
#import "HXDiscoveryModel.h"
#import "HXCommentModel.h"


@interface HXReplayViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *fetchCommentCommand;
@property (nonatomic, strong, readonly)  RACSignal *reloadCommentSignal;

@property (nonatomic, strong, readonly) HXDiscoveryModel *model;

@property (nonatomic, strong) NSArray<HXCommentModel *> *comments;

- (instancetype)initWithDiscoveryModel:(HXDiscoveryModel *)model;

@end
