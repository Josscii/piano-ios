//
//  HXDiscoveryNormalCell.h
//  Piano
//
//  Created by miaios on 16/3/23.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXDiscoveryCell.h"
#import "HXDiscoveryModel.h"


@interface HXDiscoveryNormalCell : HXDiscoveryCell

@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet     UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *musicIcon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoIconWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *musicIconLeftConstraint;

- (void)updateCellWithModel:(HXDiscoveryModel *)model;

@end
