//
//  LGAlertView.m
//  LGAlertSheet
//
//  Created by Runge Zhai on 5/15/15.
//  Copyright (c) 2015 ZIXUWUYOU. All rights reserved.
//

#import "LGAlertView.h"
#import "UIView+Shake.h"
#import "LGProgressView.h"
#import "NSPointerArray+AbstractionHelpers.h"


static NSMutableDictionary *stacks;
static dispatch_semaphore_t show_animation_semaphore;


@interface LGAlertView ()

/**
 *  0 by default, for going up/down when keyboard shows/hides
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewCenterYOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewCenterXOffset;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopSpace;

@property (copy, nonatomic) LGAlertViewCancelBlock      cancelButtonBlock;
@property (copy, nonatomic) LGAlertViewOtherBlock       otherButtonBlock;
@property (copy, nonatomic) LGAlertViewTextFieldBlock   textFieldBlock;

/**
 *  For Progress Alert View completion transition
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressContainerViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressContainerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressContainerViewCenterY;
@property (weak, nonatomic) IBOutlet UIView             *completionContainerView;

@end


@implementation LGAlertView

#pragma mark - Initialization & LifeCycle

+ (void)initialize {
    
    stacks = [NSMutableDictionary new];
    show_animation_semaphore = dispatch_semaphore_create(1);
}

+ (LGAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitle:(NSString *)otherButtonTitle
              cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
               otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock {
    
    return [LGAlertView alertWithTitleImage:nil
                                      title:title
                                    message:message
                          cancelButtonTitle:cancelButtonTitle
                           otherButtonTitle:otherButtonTitle
                          cancelButtonBlock:cancelButtonBlock
                           otherButtonBlock:otherButtonBlock];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitle:(NSString *)otherButtonTitle
         cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
          otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock {
    LGAlertView *alert = [LGAlertView alertWithTitle:title
                                             message:message
                                   cancelButtonTitle:cancelButtonTitle
                                    otherButtonTitle:otherButtonTitle
                                   cancelButtonBlock:cancelButtonBlock
                                    otherButtonBlock:otherButtonBlock];
    [alert show];
}

+ (LGAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitle:(NSString *)otherButtonTitle
              cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
                 textFieldBlock:(LGAlertViewTextFieldBlock)textFieldBlock {
    LGAlertView *alert = [[[NSBundle mainBundle] loadNibNamed:@"LGTextFieldAlertView" owner:nil options:nil] firstObject];
    
    if (alert) {
        alert.titleLabel.text = title;
        alert.messageLabel.text = message;
        if (!cancelButtonTitle) {
            cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
        }
        [alert.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [alert.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
        alert.cancelButtonBlock = cancelButtonBlock;
        alert.textFieldBlock = textFieldBlock;
        
        [[NSNotificationCenter defaultCenter] addObserver:alert selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [alert configCommonProperties];
    }
    
    return alert;
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitle:(NSString *)otherButtonTitle
         cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
            textFieldBlock:(LGAlertViewTextFieldBlock)textFieldBlock {
    LGAlertView *alert = [LGAlertView alertWithTitle:title
                                             message:message
                                   cancelButtonTitle:cancelButtonTitle
                                    otherButtonTitle:otherButtonTitle
                                   cancelButtonBlock:cancelButtonBlock
                                      textFieldBlock:textFieldBlock];
    [alert show];
}

+ (LGAlertView *)alertWithTitleImage:(UIImage *)titleImage
                               title:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                    otherButtonTitle:(NSString *)otherButtonTitle
                   cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
                    otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock {
    LGAlertView *alert = [[[NSBundle mainBundle] loadNibNamed:@"LGAlertView" owner:nil options:nil] firstObject];
    
    if (alert) {
        
        if (!titleImage) {
            alert.titleLabelTopSpace.priority = UILayoutPriorityDefaultHigh + 1;
            [alert.titleImageView removeFromSuperview];
        } else {
            alert.containerView.clipsToBounds = NO;
            alert.titleImageView.image = titleImage;
        }
        alert.titleLabel.text = title;
        alert.messageLabel.text = title ? message : [message stringByAppendingString:@"\n"];// just for good-looking when there is no title
        if (!cancelButtonTitle) {
            if (otherButtonTitle) {
                cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
            } else {
                cancelButtonTitle = NSLocalizedString(@"OK", nil);
            }
        }
        if (otherButtonTitle) {
            [alert.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [alert.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
        } else {
            [alert.okButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            alert.okButton.hidden = NO;
        }
        alert.cancelButtonBlock = cancelButtonBlock;
        alert.otherButtonBlock = otherButtonBlock;
        
        [alert configCommonProperties];
    }
    
    return alert;
}

+ (void)showAlertWithTitleImage:(UIImage *)titleImage
                          title:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitle:(NSString *)otherButtonTitle
              cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
               otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock {
    
    LGAlertView *alert = [LGAlertView alertWithTitleImage:titleImage
                                                    title:title
                                                  message:message
                                        cancelButtonTitle:cancelButtonTitle
                                         otherButtonTitle:otherButtonTitle
                                        cancelButtonBlock:cancelButtonBlock
                                         otherButtonBlock:otherButtonBlock];
    [alert show];
}

+ (LGAlertView *)alertWithInProgressImage:(UIImage *)inProgressImage
                          completionImage:(UIImage *)completionImage
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                         otherButtonTitle:(NSString *)otherButtonTitle
                        cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
                         otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock {
    LGAlertView *alert = [[[NSBundle mainBundle] loadNibNamed:@"LGProgressAlertView" owner:nil options:nil] firstObject];
    
    if (alert) {
        alert.containerView.clipsToBounds = NO;
        alert.circularProgressBGImageView.image = inProgressImage;
        alert.completionImage = completionImage;
        alert.messageLabel.text = message;
        if (!cancelButtonTitle) {
            if (otherButtonTitle) {
                cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
            } else {
                cancelButtonTitle = NSLocalizedString(@"OK", nil);
            }
        }
        if (otherButtonTitle) {
            [alert.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [alert.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
        } else {
            [alert.okButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
            alert.okButton.hidden = NO;
        }
        alert.cancelButtonBlock = cancelButtonBlock;
        alert.otherButtonBlock = otherButtonBlock;
        
        [alert configCommonProperties];
    }
    
    return alert;
}

+ (void)showAlertWithInProgressImage:(UIImage *)inProgressImage
                     completionImage:(UIImage *)completionImage
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                    otherButtonTitle:(NSString *)otherButtonTitle
                   cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
                    otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock {
    LGAlertView *alert = [LGAlertView alertWithInProgressImage:inProgressImage
                                               completionImage:completionImage
                                                       message:message
                                             cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitle:otherButtonTitle
                                             cancelButtonBlock:cancelButtonBlock
                                              otherButtonBlock:otherButtonBlock];
    [alert show];
}

- (void)configCommonProperties {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc {
    // Caution: Donnot use properties or instance variable in dealloc with ARC
    // Because they might have been dealloced first and set to nil
    
    for (id key in stacks.allKeys) {
        NSPointerArray *stack = stacks[key];
        [stack removeAllNulls];
        if (stack.count == 0 || (stack.count == 1 && [stack containsObject:self])) {
            [stacks removeObjectForKey:key];
        }
    }
}


#pragma mark - getter

// Caution: with a upper case "V", superview is a system built-in property.
- (UIView *)superView {
    return _superView ?: (_superView = [[UIApplication sharedApplication] keyWindow]);
}

- (NSPointerArray *)stack {
    NSValue *key = [NSValue valueWithNonretainedObject:self.superView];
    NSPointerArray *stack = stacks[key];
    
    if (!stack) {
        stack = [NSPointerArray weakObjectsPointerArray];
        stacks[key] = stack;
    }
    
    return stack;
}


#pragma mark - show & animation

- (void)show {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(show_animation_semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![self.stack containsObject:self]) {
                typeof(self) currentTopMostAlert = [self.stack lastNonNullableObject];
                currentTopMostAlert.hidden = YES;
                
                [self addToSuperView];
                [self performShowAnimation:^() {
                    [self.stack addObject:self];
                    dispatch_semaphore_signal(show_animation_semaphore);
                }];
            } else {
                [self performShowAnimation:^{
                    dispatch_semaphore_signal(show_animation_semaphore);
                }];
            }
        });
    });
}

- (void)addToSuperView {
    if ([self.superView isKindOfClass:[UIWindow class]] &&
        [[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        [self statusBarOrientationChange:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    
    self.frame = (CGRect){.origin = CGPointZero, .size = self.superView.frame.size};
    [self.superView addSubview:self];
}

- (void)performShowAnimation:(void (^)())completion {
    self.hidden = NO;
    self.alpha = .0f;
    CGAffineTransform originalTransform = self.containerView.transform;
    
    self.containerView.transform = CGAffineTransformScale(originalTransform, .1f, .1f);
    
    [UIView animateWithDuration:.35f delay:0 usingSpringWithDamping:.8f initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 1;
        self.containerView.transform = originalTransform;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)animateToCompletionState {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(show_animation_semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat transitionDuration1 = .5;
            CGFloat transitionDuration2 = .25;
            CGFloat transitionDelay2 = .3;
            
            // 1. Expand progress view, hide progress related views
            [UIView animateWithDuration:transitionDuration1
                             animations:^{
                                 _progressContainerViewHeight.priority = UILayoutPriorityDefaultHigh + 1;
                                 _progressContainerViewHeight.constant = _containerView.frame.size.height;
                                 _progressContainerViewWidth.constant = _containerView.frame.size.width;
                                 _progressContainerViewCenterY.priority = UILayoutPriorityDefaultLow - 1;
                                 
                                 _progressView.alpha = _progressLabel.alpha = 0;
                                 
                                 [self layoutIfNeeded];
                             } completion:^(BOOL finished) {
                                 [_progressView removeFromSuperview];
                                 [_progressLabel removeFromSuperview];
                             }];
            
            // 2. Show completion view
            [UIView animateKeyframesWithDuration:transitionDuration2
                                           delay:transitionDelay2
                                         options:0
                                      animations:^{
                                          _completionContainerView.alpha = 1;
                                      } completion:nil];
            
            // 3. Transition to completion image
            [UIView transitionWithView:_circularProgressBGImageView
                              duration:transitionDuration2 + transitionDelay2
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                _circularProgressBGImageView.image = _completionImage;
                            }
                            completion:^(BOOL finished) {
                                dispatch_semaphore_signal(show_animation_semaphore);
                            }];
        });
    });
}

- (void)showErrorMessage:(NSString *)errorMessage {
    [self showErrorMessage:errorMessage animated:NO];
}

- (void)showErrorMessage:(NSString *)errorMessage animated:(BOOL)animated {
    
    if (animated) {
        [UIView transitionWithView:_messageLabel duration:.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _messageLabel.textColor = [UIColor colorWithRed:249 / 255.f green:0 blue:14 / 255.f alpha:1.f];
            _messageLabel.text = errorMessage;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_messageLabel shake:8 withDelta:_messageLabel.bounds.size.width / 10 speed:.05f];
        }];
    } else {
        _messageLabel.textColor = [UIColor colorWithRed:249 / 255.f green:0 blue:14 / 255.f alpha:1.f];
        _messageLabel.text = errorMessage;
    }
}

- (void)showMessage:(NSString *)message {
    _messageLabel.textColor = [UIColor colorWithWhite:0x65 / 255.f alpha:1.f];
    _messageLabel.text = message;
}


#pragma mark - dismiss

- (void)dismissSelf {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    self.cancelButtonBlock = self.otherButtonBlock = self.textFieldBlock = NULL;
    [self removeFromSuperview];
    [self.stack removeObject:self];
}

- (void)dismiss {
    // 1. dismiss self
    [self dismissSelf];
    
    // 2. show the youngest sibling older than self
    typeof(self) nextTopMostAlert = [self.stack lastNonNullableObject];
    [nextTopMostAlert show];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self didClickOther:nil];
    
    return YES;
}


#pragma mark - UIKeyboardWillChangeFrameNotification

- (void)keyboardWillChange:(NSNotification *)notification {
    
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardHeight = self.frame.size.height -  keyboardRect.origin.y;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    [UIView beginAnimations:@"cn.LGAlertView.keyboardframechange" context:NULL];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    
    if ([self.superView isKindOfClass:[UIWindow class]] && [[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait) {
            _containerViewCenterYOffset.constant = keyboardHeight / 2;
            _containerViewCenterXOffset.constant = 0;
        } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
            keyboardHeight = self.frame.size.width - keyboardRect.origin.x;
            _containerViewCenterXOffset.constant = keyboardHeight / 2;
            _containerViewCenterYOffset.constant = 0;
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            keyboardHeight = CGRectGetMaxX(keyboardRect);
            _containerViewCenterXOffset.constant = -keyboardHeight / 2;
            _containerViewCenterYOffset.constant = 0;
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            keyboardHeight = CGRectGetMaxY(keyboardRect);
            _containerViewCenterYOffset.constant = -keyboardHeight / 2;
            _containerViewCenterXOffset.constant = 0;
        }
    } else {
        _containerViewCenterYOffset.constant = keyboardHeight / 2;
    }
    [self layoutIfNeeded];
    
    [UIView commitAnimations];
}


#pragma mark - UIApplicationDidEnterBackground

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self dismissSelf];// everyone will be dismissed, so no need to concern siblings
}


#pragma mark - Orientation & Rotation

- (void)statusBarOrientationChange:(NSNotification *)notification {
    self.containerView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, [[self class] rotationAngle]);
}

+ (CGFloat)rotationAngle {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat radian = 0;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        radian = -M_PI / 2.f;
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        radian = M_PI / 2.f;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        radian = -M_PI;
    }
    
    return radian;
}


#pragma mark - Button action

/**
 *  There are 2 triggers of dismissing alertView
 *  1. user click the buttons & 2. application enter background
 */
- (IBAction)didClickCancel:(id)sender {
    __weak typeof(self) weakSelf = self;
    if (_cancelButtonBlock) _cancelButtonBlock(weakSelf);
    [self dismiss];
}

- (IBAction)didClickOther:(id)sender {
    __weak typeof(self) weakSelf = self;
    if (!_textField) {
        if (_otherButtonBlock) _otherButtonBlock(weakSelf);
    } else if (_textFieldBlock) {
        _textFieldBlock(weakSelf);
    }
    // Caution: alert view will not dismiss by default
    // To dismiss it, you have to call [alert dismiss]; manually
}


#pragma mark - Touch To Hide Keyboard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}


@end
