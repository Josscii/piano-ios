//
//  HXLiveGiftContainerViewController.m
//  Piano
//
//  Created by miaios on 16/5/23.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXLiveGiftContainerViewController.h"
#import "HXLiveGiftItemCell.h"
#import "UIConstants.h"
#import "HXRewardGiftListLayout.h"


@implementation HXLiveGiftContainerViewController

#pragma mark - Property
- (void)setGifts:(NSArray *)gifts {
    _gifts = gifts;
    
    _selectedIndex = 0;
    [self.collectionView reloadData];
}

- (CGFloat)contianerHeight {
    return ((HXRewardGiftListLayout *)self.collectionView.collectionViewLayout).controlHeight;
}

#pragma mark - UICollectionView Data Source Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _gifts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXLiveGiftItemCell class]) forIndexPath:indexPath];
}

#pragma mark - UICollectionView Delegate Methods
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    HXLiveGiftItemCell *itemCell = (HXLiveGiftItemCell *)cell;
    [itemCell updateWithGift:_gifts[indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HXGiftModel *selectedGift = _gifts[_selectedIndex];
    selectedGift.selected = NO;
    
    HXGiftModel *selectGift = _gifts[indexPath.row];
    selectGift.selected = YES;
    
    _selectedIndex = indexPath.row;
    [collectionView reloadData];
}

@end
