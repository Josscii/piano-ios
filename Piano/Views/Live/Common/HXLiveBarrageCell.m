//
//  HXLiveBarrageCell.m
//  Piano
//
//  Created by miaios on 16/3/24.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXLiveBarrageCell.h"
#import "UIConstants.h"
#import "UIImageView+WebCache.h"


@implementation HXLiveBarrageCell

#pragma mark - Load Methods
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadConfigure];
    [self viewConfigure];
}

#pragma mark - Configure Methods
- (void)loadConfigure {
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTaped)]];
}

- (void)viewConfigure {
//    _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - ;
}

#pragma mark - Event Response
- (void)avatarTaped {
    if (_delegate && [_delegate respondsToSelector:@selector(commentCellShouldShowCommenter:)]) {
        [_delegate commentCellShouldShowCommenter:self];
    }
}

#pragma mark - Public Methods
- (void)updateWithBarrage:(HXBarrageModel *)barrage {
//    if ([model isKindOfClass:[HXWatcherModel class]]) {
//        HXWatcherModel *watcher = model;
//        
//        [_avatar sd_setImageWithURL:[NSURL URLWithString:watcher.avatarUrl]];
//        _contentLabel.text = [watcher.nickName stringByAppendingString:@"来了"];
//    } else if ([model isKindOfClass:[HXCommentModel class]]) {
//        HXCommentModel *comment = model;
//        
//        [_avatar sd_setImageWithURL:[NSURL URLWithString:comment.avatarUrl]];
//        NSString *nickName = [comment.nickName stringByAppendingString:@":"];
//        _contentLabel.text = [nickName stringByAppendingString:comment.content];
//        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithAttributedString:_contentLabel.attributedText];
//        [content addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[_contentLabel.text rangeOfString:nickName]];
//        _contentLabel.attributedText = content;
//    }
}

@end
