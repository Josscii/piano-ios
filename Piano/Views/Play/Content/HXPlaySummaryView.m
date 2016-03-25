//
//  HXPlaySummaryView.m
//  mia
//
//  Created by miaios on 16/2/25.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXPlaySummaryView.h"
#import "HXXib.h"
//#import "MusicItem.h"
#import "UIImageView+WebCache.h"

@implementation HXPlaySummaryView {
    NSDictionary *_lyricsAttributes;
}

HXXibImplementation

#pragma mark - Load Methods
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self loadConfigure];
    [self viewConfigure];
}

#pragma mark - Configure Methods
- (void)loadConfigure {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 15.0f;
    _lyricsAttributes = @{NSParagraphStyleAttributeName: paragraphStyle};
}

- (void)viewConfigure {
    _containerView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Public Methods
- (void)displayWithMusic:(MusicItem *)music {
//    [_cover sd_setImageWithURL:[NSURL URLWithString:music.purl] placeholderImage:nil];
//    _songNameLabel.text = music.name;
//    _singerNameLabel.text = music.singerName;
    [self handleLyrics:nil];
}

#pragma mark - Private Methods
- (void)handleLyrics:(NSString *)lyrics {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:_lyricsView.attributedText];
    [attributedString addAttributes:_lyricsAttributes range:[lyrics rangeOfString:lyrics]];
    _lyricsView.attributedText = attributedString.copy;
    _lyricsView.textAlignment = NSTextAlignmentCenter;
}

@end
