//
//  HXDiscoveryModel.m
//  Piano
//
//  Created by miaios on 16/3/18.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXDiscoveryModel.h"
#import "HXReplayModel.h"


@implementation HXDiscoveryModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"nickName": @"nick",
            @"avatarUrl": @"userpic",
          @"onlineCount": @"onlineCnt",
            @"viewCount": @"viewCnt",
               @"prompt": @"liveDate"};
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    if (_live) {
        _ID = _roomID;
        _type = HXDiscoveryTypeLive;
        return;
    }
    
    _ID = @(_itemID).stringValue;
    switch (_itemType) {
        case 1: {
            _type = HXDiscoveryTypeNewAlbum;
            break;
        }
        case 2: {
            _type = HXDiscoveryTypeVideo;
            break;
        }
        case 3: {
            _type = HXDiscoveryTypeReplay;
            break;
        }
    }
}

#pragma mark - Init Methods
+ (instancetype)createWithReplayModel:(HXReplayModel *)replayModel {
    NSDictionary *keyValues = [replayModel mj_keyValues];
    HXDiscoveryModel *model = [HXDiscoveryModel mj_objectWithKeyValues:keyValues];
    model.avatarUrl = replayModel.avatarUrl;
    model.videoUrl = replayModel.replayUrl;
    return model;
}

@end
