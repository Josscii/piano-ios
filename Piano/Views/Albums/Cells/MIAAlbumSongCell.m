//
//  MIAAlbumSongCell.m
//  Piano
//
//  Created by 刘维 on 16/5/10.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "MIAAlbumSongCell.h"
#import "MIAAlbumSongView.h"

@interface MIAAlbumSongCell()

@property (nonatomic, strong) MIAAlbumSongView *albumSongView;

@end

@implementation MIAAlbumSongCell

- (void)setCellWidth:(CGFloat)width{
    
}

- (void)createAlbumDetailView{
    
    if (!self.albumSongView) {
        self.albumSongView = [MIAAlbumSongView newAutoLayoutView];
        [self.cellContentView addSubview:_albumSongView];
        
        [JOAutoLayout autoLayoutWithEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 0.) selfView:_albumSongView superView:self.cellContentView];
    }
}

- (void)setCellData:(id)data{
    
    [self createAlbumDetailView];
    [_albumSongView setSongData:data];
}

- (void)setSongPlayState:(BOOL)state{

    [_albumSongView changeSongPlayState:state];
}

- (void)setSongCellIndex:(NSInteger)cellIndex{

    [_albumSongView setSongIndex:cellIndex];
}

@end
