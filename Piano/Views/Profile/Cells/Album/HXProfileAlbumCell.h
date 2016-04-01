//
//  HXProfileAlbumCell.h
//  Piano
//
//  Created by miaios on 16/4/1.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXAlbumModel.h"


@interface HXProfileAlbumCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet     UILabel *titleLabel;

- (void)updateCellWithAlbum:(HXAlbumModel *)album;

@end
