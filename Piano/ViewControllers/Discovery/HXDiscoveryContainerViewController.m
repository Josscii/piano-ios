//
//  HXDiscoveryContainerViewController.m
//  Piano
//
//  Created by miaios on 16/3/16.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXDiscoveryContainerViewController.h"
#import "MJRefresh.h"
#import "HXDiscoveryViewModel.h"
#import "HXDiscoveryCell.h"
#import "HXDiscoveryReplayCell.h"
#import "HXDiscoveryNewEntryCell.h"
#import "HXDiscoveryVideoCell.h"
#import "HXAlertBanner.h"


@interface HXDiscoveryContainerViewController () <
HXDiscoveryCellDelegate
>
@end


@implementation HXDiscoveryContainerViewController {
    HXDiscoveryViewModel *_viewModel;
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadConfigure];
    [self viewConfigure];
}

#pragma mark - Configure Methods
- (void)loadConfigure {
    _viewModel = [[HXDiscoveryViewModel alloc] init];
}

- (void)viewConfigure {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchDiscoveryList)];
}

#pragma mark - Public Methods
- (void)startFetchDiscoveryList {
    [self.tableView.mj_header beginRefreshing];
}

- (void)fetchDiscoveryList {
    @weakify(self)
    RACSignal *requestSiganl = [_viewModel.fetchCommand execute:nil];
    [requestSiganl subscribeError:^(NSError *error) {
        @strongify(self)
        [self showBannerWithPrompt:error.domain];
        [self endLoad];
    } completed:^{
        @strongify(self)
        [self endLoad];
    }];
}

#pragma mark - Private Methods
- (void)endLoad {
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.discoveryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (_viewModel.discoveryList[indexPath.row].type) {
        case HXDiscoveryTypeLive: {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXDiscoveryCell class]) forIndexPath:indexPath];
            break;
        }
        case HXDiscoveryTypeReplay: {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXDiscoveryReplayCell class]) forIndexPath:indexPath];
            break;
        }
        case HXDiscoveryTypeNewEntry: {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXDiscoveryNewEntryCell class]) forIndexPath:indexPath];
            break;
        }
        case HXDiscoveryTypeVideo: {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXDiscoveryVideoCell class]) forIndexPath:indexPath];
            break;
        }
    }
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _viewModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    HXDiscoveryModel *model = _viewModel.discoveryList[indexPath.row];
    switch (model.type) {
        case HXDiscoveryTypeLive: {
            [(HXDiscoveryCell *)cell updateCellWithModel:model];
            break;
        }
        case HXDiscoveryTypeReplay: {
            break;
        }
        case HXDiscoveryTypeNewEntry: {
            break;
        }
        case HXDiscoveryTypeVideo: {
            break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(container:showLiveByModel:)]) {
        [_delegate container:self showLiveByModel:_viewModel.discoveryList[indexPath.row]];
    }
}

#pragma mark - HXDiscoveryCellDelegate Methods
- (void)discoveryCellAnchorContainerTaped:(HXDiscoveryCell *)cell {
    NSInteger row = [self.tableView indexPathForCell:cell].row;
    if (_delegate && [_delegate respondsToSelector:@selector(container:showAnchorByModel:)]) {
        [_delegate container:self showAnchorByModel:_viewModel.discoveryList[row]];
    }
}

@end
