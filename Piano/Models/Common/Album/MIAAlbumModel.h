//
//  MIAAlbumModel.h
//  Piano
//
//  Created by 刘维 on 16/5/9.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "MJExtension.h"

@interface MIARewardAlbumModel : NSObject

@property (nonatomic, copy) NSString *addtime; //添加的时间
@property (nonatomic, copy) NSString *albumID; //专辑的id
@property (nonatomic, copy) NSString *id; //id
@property (nonatomic, copy) NSString *mcoin; //打赏的M币
@property (nonatomic, copy) NSString *musicianID; //
@property (nonatomic, copy) NSString *nick; //打赏人的昵称
@property (nonatomic, copy) NSString *roomID; //房间的id
@property (nonatomic, copy) NSString *status; //status
@property (nonatomic, copy) NSString *uID; //uid
@property (nonatomic, copy) NSString *userpic; //打赏人的头像的URL

@end

@interface MIAAlbumModel : NSObject

@property (nonatomic, copy) NSString *status; // ???(暂时没用到)
@property (nonatomic, copy) NSString *addtime; //添加的时间
@property (nonatomic, copy) NSString *summary; //专辑的简介
@property (nonatomic, copy) NSString *coverID; //封面的id
@property (nonatomic, copy) NSString *id;  //专辑的id
@property (nonatomic, copy) NSString *title; //专辑的标题
@property (nonatomic, copy) NSString *backTotal;//打赏的人数
@property (nonatomic, copy) NSString *uID; //用户的id
@property (nonatomic, copy) NSString *coverUrl; //专辑图片的地址
@property (nonatomic, copy) NSString *nick;//昵称
@property (nonatomic, copy) NSArray  <MIARewardAlbumModel *>*backList;//打赏的列表

@end
