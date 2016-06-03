//
//  HXLiveCommentViewController.m
//  Piano
//
//  Created by miaios on 16/3/31.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXLiveCommentViewController.h"
#import "HXLiveCommentViewModel.h"

@interface HXLiveCommentViewController ()
@end

@implementation HXLiveCommentViewController {
    HXLiveCommentViewModel *_viewModel;
}

#pragma mark - Class Methods
+ (HXStoryBoardName)storyBoardName {
    return HXStoryBoardNameLive;
}

#pragma mark - View Controller Life Cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadConfigure];
    [self viewConfigure];
}

#pragma mark - Configure Methods
- (void)loadConfigure {
    _viewModel = [[HXLiveCommentViewModel alloc] initWithRoomID:_roomID];
    RAC(_viewModel, content) = _textField.rac_textSignal;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewConfigure {
    ;
}

#pragma mark - Event Response
- (IBAction)sendButtonPressed {
    [self showHUD];
    
    @weakify(self)
    RACSignal *sendSignal = [_viewModel.sendCommand execute:nil];
    [sendSignal subscribeNext:^(NSString *message) {
        @strongify(self)
        [self showBannerWithPrompt:message];
    } error:^(NSError *error) {
        @strongify(self)
        if (![error.domain isEqualToString:RACCommandErrorDomain]) {
            [self showBannerWithPrompt:error.domain];
        }
    } completed:^{
        @strongify(self)
        [self hiddenHUD];
        [self hiddenKeyboard];
    }];
}

- (void)tapGesture {
    [self hiddenKeyboard];
}

- (void)keyBoardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    //获取当前显示的键盘高度
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey ] CGRectValue].size;
    [self popKeyBoardAnimationWithHeight:keyboardSize.height];
}

- (void)keyBoardWillHidden:(NSNotification *)notification {
    [self hiddenKeyboard];
}

#pragma mark - Private Methods
- (void)popKeyBoardAnimationWithHeight:(CGFloat)height {
    _bottomConstraint.constant = height;
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_commentView layoutIfNeeded];
    } completion:nil];
}

- (void)hiddenKeyBoardAnimation {
    _bottomConstraint.constant = -50.0f;
    [UIView animateWithDuration:0.4f animations:^{
        [_commentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)hiddenKeyboard {
    [_textField resignFirstResponder];
    [self hiddenKeyBoardAnimation];
}

@end
