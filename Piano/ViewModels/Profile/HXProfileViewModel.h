//
//  HXProfileViewModel.h
//  Piano
//
//  Created by miaios on 16/3/30.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "ReactiveCocoa.h"
#import "HXProfileModel.h"


typedef NS_ENUM(NSUInteger, HXProfileRowType) {
    HXProfileRowTypeHeader,
    HXProfileRowTypeLiving,
    HXProfileRowTypeAlbumContainer,
    HXProfileRowTypeVideoContainer,
    HXProfileRowTypeReplayContainer,
};


@interface HXProfileViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *fetchCommand;

@property (nonatomic, assign, readonly)   CGFloat  headerHeight;
@property (nonatomic, assign, readonly)   CGFloat  livingHeight;
@property (nonatomic, assign, readonly)   CGFloat  albumHeight;
@property (nonatomic, assign, readonly)   CGFloat  videoHeight;
@property (nonatomic, assign, readonly)   CGFloat  replayHeight;

@property (nonatomic, assign, readonly)   CGFloat  albumItemSpace;
@property (nonatomic, assign, readonly)   CGFloat  videoItemSpcae;
@property (nonatomic, assign, readonly)   CGFloat  replayItemSpace;

@property (nonatomic, assign, readonly)   CGFloat  albumItemWidth;
@property (nonatomic, assign, readonly)   CGFloat  videoItemWidth;
@property (nonatomic, assign, readonly)   CGFloat  replayItemWidth;
@property (nonatomic, assign, readonly)   CGFloat  albumItemHeight;
@property (nonatomic, assign, readonly)   CGFloat  videoItemHeight;
@property (nonatomic, assign, readonly)   CGFloat  replayItemHeight;

@property (nonatomic, assign, readonly) NSInteger  rows;
@property (nonatomic, strong, readonly)   NSArray *rowTypes;

@property (nonatomic, strong, readonly) NSString *uid;

@property (nonatomic, strong, readonly) HXProfileModel *model;

- (instancetype)initWithUID:(NSString *)UID;

@end
