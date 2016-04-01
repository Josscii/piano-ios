//
//  HXMeViewModel.m
//  Piano
//
//  Created by miaios on 16/3/28.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXMeViewModel.h"
#import "MiaAPIHelper.h"
#import "HXUserSession.h"


@implementation HXMeViewModel

#pragma mark - Initialize Methods
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initConfigure];
    }
    return self;
}

#pragma mark - Configure Methods
- (void)initConfigure {
    [self setupRowTypes];
    
    [self fetchDataCommandConfigure];
}

- (void)setupRowTypes {
    _rowTypes = @[@(HXMeRowTypeHeader),
                  @(HXMeRowTypeRecharge),
                  @(HXMeRowTypePurchaseHistory)];
}

- (void)fetchDataCommandConfigure {
    @weakify(self)
    _fetchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [self fetchProfileRequestWithSubscriber:subscriber];
            return nil;
        }];
    }];
}

#pragma mark - Property
- (CGFloat)headerHeight {
    return 176.0f;
}

- (CGFloat)normalHeight {
    return 56.0f;
}

- (CGFloat)attentionHeight {
    return 115.0f;
}

- (NSInteger)rows {
    return _rowTypes.count;
}

#pragma mark - Private Methods
- (void)fetchProfileRequestWithSubscriber:(id<RACSubscriber>)subscriber {
    [MiaAPIHelper getUserProfileWithUID:[HXUserSession session].uid completeBlock:^(MiaRequestItem *requestItem, BOOL success, NSDictionary *userInfo) {
        if (success) {
            [self parseAttentionData:userInfo[MiaAPIKey_Values][MiaAPIKey_Data]];
            [subscriber sendCompleted];
        } else {
            [subscriber sendError:[NSError errorWithDomain:userInfo[MiaAPIKey_Values][MiaAPIKey_Error] code:-1 userInfo:nil]];
        }
    } timeoutBlock:^(MiaRequestItem *requestItem) {
        [subscriber sendError:[NSError errorWithDomain:TimtOutPrompt code:-1 userInfo:nil]];
    }];
}

- (void)parseAttentionData:(NSDictionary *)data {
    HXProfileModel *model = [HXProfileModel mj_objectWithKeyValues:data];
    ;
}

@end
