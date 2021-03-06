//
//  HXAlbumsCommentViewModel.h
//  Piano
//
//  Created by miaios on 16/3/31.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "ReactiveCocoa.h"


@interface HXAlbumsCommentViewModel : NSObject

@property (nonatomic, strong, readonly)   NSString *albumID;
@property (nonatomic, strong, readonly)   NSString *content;

@property (nonatomic, strong, readonly) RACCommand *sendCommand;

- (instancetype)initWithAlbumID:(NSString *)albumID;

@end
