//
//  HXAttentionModel.m
//  Piano
//
//  Created by miaios on 16/3/29.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXAttentionModel.h"


@implementation HXAttentionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uID": @"fuID",
        @"nickName": @"nick",
       @"avatarUrl": @"userpic"};
}

@end
