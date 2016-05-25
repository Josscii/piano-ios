//
//  HXProfileContainerViewController.h
//  Piano
//
//  Created by miaios on 16/3/30.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXProfileViewModel.h"


@class HXProfileContainerViewController;


@protocol HXProfileContainerViewControllerDelegate <NSObject>

@required
- (void)container:(HXProfileContainerViewController *)container scrollOffset:(CGFloat)offset;
- (void)container:(HXProfileContainerViewController *)container selectedAlbum:(HXAlbumModel *)album;
- (void)container:(HXProfileContainerViewController *)container selectedVideo:(HXVideoModel *)video;
- (void)container:(HXProfileContainerViewController *)container selectedReplay:(HXReplayModel *)replay;

@end

@interface HXProfileContainerViewController : UITableViewController

@property (weak, nonatomic) IBOutlet id  <HXProfileContainerViewControllerDelegate>delegate;

@property (nonatomic, strong) HXProfileViewModel *viewModel;

- (void)refresh;

@end
