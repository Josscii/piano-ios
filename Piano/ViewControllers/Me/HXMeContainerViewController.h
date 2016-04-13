//
//  HXMeContainerViewController.h
//  Piano
//
//  Created by miaios on 16/3/28.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXMeViewModel.h"
#import "HXAttentionModel.h"


@class HXMeContainerViewController;


@protocol HXMeContainerViewControllerDelegate <NSObject>

@required
- (void)container:(HXMeContainerViewController *)container scrollOffset:(CGFloat)offset;
- (void)container:(HXMeContainerViewController *)container hanleAttentionAnchor:(HXAttentionModel *)model;

@end


@interface HXMeContainerViewController : UITableViewController

@property (weak, nonatomic) IBOutlet id  <HXMeContainerViewControllerDelegate>delegate;

@property (nonatomic, strong) HXMeViewModel *viewModel;

- (void)refresh;

@end
