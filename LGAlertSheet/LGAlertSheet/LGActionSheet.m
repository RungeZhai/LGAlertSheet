//
//  LGActionSheet.m
//  ZIXUWUYOU
//
//  Created by Runge Zhai on 7/16/15.
//  Copyright (c) 2015 ZIXUWUYOU. All rights reserved.
//

#import "LGActionSheet.h"

@interface LGActionSheet ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomSpace;

@property (strong, nonatomic) UIColor *maskBackgroundColor;

@end

@implementation LGActionSheet

+ (void)showActionSheetWithCancelButtonTitle:(NSString *)cancelButtonTitle
                            otherButtonTitle:(NSString *)otherButtonTitle
                           cancelButtonBlock:(LGActionSheetCancelBlock)cancelButtonBlock
                            otherButtonBlock:(LGActionSheetOtherBlock)otherButtonBlock
                                    fromView:(UIView *)superView {
    
    LGActionSheet *alert = [[[NSBundle mainBundle] loadNibNamed:@"LGActionSheet" owner:nil options:nil] firstObject];
    
    if (alert) {
        if (!cancelButtonTitle) {
            cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
        }
        [alert.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [alert.otherButton0 setTitle:otherButtonTitle forState:UIControlStateNormal];
        alert.cancelButtonBlock = cancelButtonBlock;
        alert.otherButtonBlock0 = otherButtonBlock;
        
        alert.superView = superView;
        
        [alert configCommonProperties];
        
        [alert show];
    }
}

+ (void)showActionSheetWithCancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitle0:(NSString *)otherButtonTitle0
                           otherButtonTitle1:(NSString *)otherButtonTitle1
                           cancelButtonBlock:(LGActionSheetCancelBlock)cancelButtonBlock
                           otherButtonBlock0:(LGActionSheetOtherBlock)otherButtonBlock0
                           otherButtonBlock1:(LGActionSheetOtherBlock)otherButtonBlock1
                                    fromView:(UIView *)superView {
    LGActionSheet *alert = [[[NSBundle mainBundle] loadNibNamed:@"LGActionSheet_2Opt" owner:nil options:nil] firstObject];
    
    if (alert) {
        if (!cancelButtonTitle) {
            cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
        }

        [alert.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [alert.otherButton0 setTitle:otherButtonTitle0 forState:UIControlStateNormal];
        [alert.otherButton1 setTitle:otherButtonTitle1 forState:UIControlStateNormal];
        alert.cancelButtonBlock = cancelButtonBlock;
        alert.otherButtonBlock0 = otherButtonBlock0;
        alert.otherButtonBlock1 = otherButtonBlock1;
        
        alert.superView = superView;
        
        [alert configCommonProperties];
        
        [alert show];
    }
}

- (void)show {
    self.frame = (CGRect){.origin = CGPointZero, .size = [self superView].frame.size};
    [[self superView] addSubview:self];
    
    UIColor *backgroundColor = self.backgroundColor;
    self.backgroundColor = [UIColor clearColor];
    
    _containerViewBottomSpace.constant = -_containerView.frame.size.height;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = backgroundColor;
        
        _containerViewBottomSpace.constant = 0;
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    self.cancelButtonBlock = self.otherButtonBlock0 = self.otherButtonBlock1 = NULL;
    
    [UIView animateWithDuration:.25f animations:^{
        self.backgroundColor = [UIColor clearColor];
        
        _containerViewBottomSpace.constant = -_containerView.frame.size.height;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// Caution: with a upper case "V", superview is a system built-in property.
- (UIView *)superView {
    return _superView ?: (_superView = [[UIApplication sharedApplication] keyWindow]);
}

- (void)configCommonProperties {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    _maskBackgroundColor = self.backgroundColor;
}


#pragma mark - Button action

// There are 2 triggers of dismissing alertView
// 1. user click & 2. application enter background
- (IBAction)didClickCancel:(id)sender {
    __weak typeof(self) weakSelf = self;
    if (_cancelButtonBlock) _cancelButtonBlock(weakSelf);
    [self dismiss];
}

- (IBAction)didClickOther0:(id)sender {
    __weak typeof(self) weakSelf = self;
    if (_otherButtonBlock0) _otherButtonBlock0(weakSelf);
}


- (IBAction)didClickOther1:(id)sender {
    __weak typeof(self) weakSelf = self;
    if (_otherButtonBlock1) _otherButtonBlock1(weakSelf);
}

#pragma mark - UIApplicationDidEnterBackground

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self dismiss];// everyone will be dismissed, so no need to concern siblings
}


#pragma mark - Touches Began

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

@end
