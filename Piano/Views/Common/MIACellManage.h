//
//  MIACellManage.h
//  Piano
//
//  Created by 刘维 on 16/5/9.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIABaseTableViewCell.h"
#import "MIAProfileLiveCell.h"
#import "MIAProfileAlbumCell.h"
#import "MIAProfileVideoCell.h"
#import "MIAProfileReplayCell.h"

typedef NS_ENUM(NSUInteger, MIACellType){

    MIACellTypeNormal,
    //主播的Profile
    MIACellTypeLive,
    MIACellTypeAlbum,
    MIACellTypeVideo,
    MIACellTypeReplay,
};

@interface MIACellManage : NSObject

+ (__kindof MIABaseTableViewCell *)getCellWithType:(MIACellType)type;

@end
