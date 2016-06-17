//
//  HXDiscoveryContainerViewController.h
//  Piano
//
//  Created by miaios on 16/3/16.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "UIViewController+HXClass.h"
#import "HXDiscoveryViewModel.h"


typedef NS_ENUM(NSUInteger, HXDiscoveryContainerAction) {
    HXDiscoveryContainerActionRefresh,
    HXDiscoveryContainerActionScrolled,
    HXDiscoveryContainerActionStartLive,
    HXDiscoveryContainerActionChangeCover,
    HXDiscoveryContainerActionShowLive,
    HXDiscoveryContainerActionShowStation,
};


@protocol HXDiscoveryContainerDelegate;


@interface HXDiscoveryContainerViewController : UICollectionViewController

@property (weak, nonatomic) IBOutlet id  <HXDiscoveryContainerDelegate>delegate;
@property (weak, nonatomic) HXDiscoveryViewModel *viewModel;

- (void)displayDiscoveryList;
- (void)stopPreviewVideo;
- (void)reload;

@end


@protocol HXDiscoveryContainerDelegate <NSObject>

@required
- (void)container:(HXDiscoveryContainerViewController *)container takeAction:(HXDiscoveryContainerAction)action model:(HXDiscoveryModel *)model;

@end
