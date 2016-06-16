//
//  HXWatchLiveViewController.h
//  Piano
//
//  Created by miaios on 16/3/24.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "UIViewController+HXClass.h"
#import "HXWatchLiveViewModel.h"


@class HXLiveAnchorView;
@class HXLiveAlbumView;
@class HXStaticGiftView;
@class HXDynamicGiftView;
@protocol HXWatchLiveViewControllerDelegate;


@interface HXWatchLiveViewController : UIViewController

@property (weak, nonatomic) IBOutlet     id  <HXWatchLiveViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *liveView;

@property (weak, nonatomic) IBOutlet  HXLiveAnchorView *anchorView;
@property (weak, nonatomic) IBOutlet   HXLiveAlbumView *albumView;
@property (weak, nonatomic) IBOutlet  HXStaticGiftView *staticGiftView;
@property (weak, nonatomic) IBOutlet HXDynamicGiftView *dynamicGiftView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerLeftConstraint;

@property (nonatomic, strong) NSString *roomID;
@property (nonatomic, strong, readonly) HXWatchLiveViewModel *viewModel;

- (IBAction)reportButtonPressed;
- (IBAction)closeButtonPressed;

@end


@protocol HXWatchLiveViewControllerDelegate <NSObject>

@required
- (void)watchLiveViewControllerLiveEnded:(HXWatchLiveViewController *)viewController;

@end