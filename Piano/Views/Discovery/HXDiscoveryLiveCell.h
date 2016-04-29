//
//  HXDiscoveryLiveCell.h
//  Piano
//
//  Created by miaios on 16/3/16.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXDiscoveryCell.h"
#import "HXDiscoveryModel.h"


@class HXDiscoveryLiveCell;


@protocol HXDiscoveryLiveCellDelegate <NSObject>

@required
- (void)liveCellStartLive:(HXDiscoveryLiveCell *)cell;

@end


@interface HXDiscoveryLiveCell : HXDiscoveryCell

@property (weak, nonatomic) IBOutlet          id  <HXDiscoveryLiveCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *cover;

- (IBAction)startLiveButtonPressed;

@end
