//
//  MIACellManage.m
//  Piano
//
//  Created by 刘维 on 16/5/9.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "MIACellManage.h"

@implementation MIACellManage

+ (MIABaseTableViewCell *)getCellWithType:(MIACellType)type{

    MIABaseTableViewCell *cell = nil;
    
    if (type == MIACellTypeHostAttention) {
        return [MIACellManage createCellWithClass:[MIAHostAttentionCell class]];
    }else if (type == MIACellTypeHostRewardAlbum){
        return [MIACellManage createCellWithClass:[MIAHostRewardAlbumCell class]];
    }else if (type == MIACellTypeHostNormal){
        return [MIACellManage createCellWithClass:[MIASettingCell class]];
    }
    
    if (type == MIACellTypeLive) {
        return [MIACellManage createCellWithClass:[MIAProfileLiveCell class]];
    }else if(type == MIACellTypeAlbum){
       return [MIACellManage createCellWithClass:[MIAProfileAlbumCell class]];
    }else if (type == MIACellTypeVideo){
        return [MIACellManage createCellWithClass:[MIAProfileVideoCell class]];
    }else if (type == MIACellTypeReplay){
        return [MIACellManage createCellWithClass:[MIAProfileReplayCell class]];
    }
    
    if (type == MIACellTypeAlbumSong) {
        return [MIACellManage createCellWithClass:[MIAAlbumSongCell class]];
    }else if (type == MIACellTypeAlbumComment){
        return [MIACellManage createCellWithClass:[MIAAlbumCommentCell class]];
    }
    
    if (type == MIACellTypePayment) {
        return [MIACellManage createCellWithClass:[MIAPaymentCell class]];
    }else if (type == MIACellTypePayHistory){
        return [MIACellManage createCellWithClass:[MIAPayHistoryCell class]];
    }
    
    if (type == MIACellTypeSetting) {
        return [MIACellManage createCellWithClass:[MIASettingCell class]];
    }
    
    if (type == MIACellTypeNormal) {
        return [MIACellManage createCellWithClass:[MIABaseTableViewCell class]];
    }
    
    return cell;
}

+ (MIABaseTableViewCell *)createCellWithClass:(Class)class{

    return [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(class)];
}

@end
