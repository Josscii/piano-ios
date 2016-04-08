//
//  HXDiscoveryNormalCell.h
//  Piano
//
//  Created by miaios on 16/3/23.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXDiscoveryModel.h"


@interface HXDiscoveryNormalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet     UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet     UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet     UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet     UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet     UILabel *watchCountLabel;

- (void)updateCellWithModel:(HXDiscoveryModel *)model;

@end
