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

#ifndef LGAS_SYSTEM_VERSION_LESS_THAN
#define LGAS_SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#endif


static NSMutableDictionary *stacks;
static dispatch_semaphore_t show_animation_semaphore;


@interface LGAlertView ()

/**
 *  0 by default, for going up/down when keyboard shows/hides
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewCenterYOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewCenterXOffset;

/** 
 *  For Basic AlertView
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelTopSpaceToTitleLabel;

/**
 *  For Progress Alert View completion transition
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressContainerViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressContainerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressContainerViewCenterY;
@property (weak, nonatomic) IBOutlet UIView             *completionContainerView;

@end


@implementation LGAlertView

/**
 *  If getter and setter method are both implemented explicitly,
 *  the complier will not automatically create corresponding instance variable any more
 */
@synthesize superView = _superView;


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
        if (!title) {
            alert.messageLabelTopSpaceToTitleLabel.constant = 0;
        }
        alert.messageLabel.text = message;
        if (!cancelButtonTitle) {
            cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
        }
        [alert.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [alert.otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
        alert.cancelButtonBlock = cancelButtonBlock;
        alert.textFieldBlock = textFieldBlock;
        
#ifndef LGAS_APP_EXTENSIONS
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
#endif
        
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
        if (!title) {
            alert.messageLabelTopSpaceToTitleLabel.constant = 0;
        }
        alert.messageLabel.text = message;
        
        [alert configCancelButtonTitle:cancelButtonTitle
                      otherButtonTitle:otherButtonTitle
                     cancelButtonBlock:cancelButtonBlock
                      otherButtonBlock:otherButtonBlock];
        
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
        
        [alert configCancelButtonTitle:cancelButtonTitle
                      otherButtonTitle:otherButtonTitle
                     cancelButtonBlock:cancelButtonBlock
                      otherButtonBlock:otherButtonBlock];
        
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)configCancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitle:(NSString *)otherButtonTitle
              cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
               otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock {
    if (!cancelButtonTitle && !otherButtonTitle) {
        [_okButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
        _cancelButtonBlock = cancelButtonBlock;
        _okButton.hidden = NO;
    } else if (!cancelButtonTitle && otherButtonTitle) {
        [_okButton setTitle:otherButtonTitle forState:UIControlStateNormal];
        _otherButtonBlock = otherButtonBlock;
        [_okButton removeTarget:self action:@selector(didClickCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_okButton addTarget:self action:@selector(didClickOther:) forControlEvents:UIControlEventTouchUpInside];
        _okButton.hidden = NO;
    } else if (cancelButtonTitle && !otherButtonTitle) {
        [_okButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        _okButton.backgroundColor = _cancelButton.backgroundColor;
        _cancelButtonBlock = cancelButtonBlock;
        _okButton.hidden = NO;
    } else {
        [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [_otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
        _cancelButtonBlock = cancelButtonBlock;
        _otherButtonBlock = otherButtonBlock;
        [_okButton removeFromSuperview];
    }
}

- (void)dealloc {
    // Caution: Donnot use properties or instance variable in dealloc with ARC
    // Because they might have been dealloced first and set to nil
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidChangeStatusBarOrientationNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    for (id key in stacks.allKeys) {
        NSPointerArray *stack = stacks[key];
        [stack removeAllNulls];
        if (stack.count == 0 || (stack.count == 1 && [stack containsObject:self])) {
            [stacks removeObjectForKey:key];
        }
    }
}


#pragma mark - getter & setter

// Caution: with a upper case "V", superview is a system built-in property.
- (UIView *)superView {
#ifdef LGAS_APP_EXTENSIONS
    if (!_superView) {
        [NSException raise:@"LGAlertView: Superview must be set mannually in extensions"
                    format:@"To use LGAlertView in extensions, you have to: \n\
         1. Define Macro LGAS_APP_EXTENSIONS \n\
         2. Init an alertView, set its superView and call show"];
    }
    return _superView;
#else
    return _superView ?: (_superView = [self suitableWindowToShowAlertView]);
#endif
}

#ifndef LGAS_APP_EXTENSIONS
- (UIWindow *)suitableWindowToShowAlertView {
    /**
     *  We want the alert view to be exclusively on top. So keyboard window is considered.
     *  Meanwhile, UIAlertView and UIAcionSheet's windows are not in the
     *  UIApplication.sharedApplication.windows array, but they are set as keyWindow.
     *  So we cannot always use topmost window as default superview.
     *  Showing alert view with a textField when the keyboard is already in signt is weird.
     *  So we dismiss the keyboard before alert view is shown.
     */
    if (!_textField) {
        UIWindow *topMostWindow = UIApplication.sharedApplication.windows.lastObject;
        BOOL windowOnMainScreen = topMostWindow.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !topMostWindow.hidden && topMostWindow.alpha > 0;
        
        if (windowOnMainScreen
            && windowIsVisible
            && [self windowIsKeyboard:topMostWindow]) {
            return topMostWindow;
        }
    }
    
    return [[UIApplication sharedApplication] keyWindow];
}
#endif

- (BOOL)windowIsKeyboard:(UIView *)window {
    return [window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")];
}

- (void)setSuperView:(UIView *)superView {
    if (self.superview) {
        [NSException raise:NSObjectInaccessibleException
                    format:@"LGAlertView: You cannot change alertview's superView once it has shown"];
    } else {
        _superView = superView;
    }
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
    
    CGRect rect = (CGRect){.origin = CGPointZero, .size = self.superView.frame.size};
    
#ifndef LGAS_APP_EXTENSIONS
    if ([self.superView isKindOfClass:[UIWindow class]]
        && ![self windowIsKeyboard:self.superView]
        && LGAS_SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        [self statusBarOrientationChange:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    } else if ([self windowIsKeyboard:self.superView]) {
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            rect.size = self.superView.bounds.size;
        }
    }
#endif
    
    self.frame = rect;
    [self.superView addSubview:self];
}

- (void)performShowAnimation:(void (^)())completion {
    self.hidden = NO;
    self.alpha = .0f;
    CGAffineTransform originalTransform = self.containerView.transform;
    
    self.containerView.transform = CGAffineTransformScale(originalTransform, .1f, .1f);
    
    [UIView animateWithDuration:.35f
                          delay:0
         usingSpringWithDamping:.8f
          initialSpringVelocity:20
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
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
            CGFloat transitionDuration2 = .275;
            CGFloat transitionDelay2 = .275;
            
            // 1. Expand progress view, hide progress related views
            [UIView animateWithDuration:transitionDuration1
                             animations:^{
                                 _progressContainerViewHeight.priority = UILayoutPriorityDefaultHigh + 1;
                                 _progressContainerViewHeight.constant = _containerView.bounds.size.height;
                                 _progressContainerViewWidth.constant = _containerView.bounds.size.width;
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

- (void)setTitle:(NSString *)title animated:(BOOL)animated {
    [self setLabel:_titleLabel
       withMessage:title
         textColor:nil
           isError:NO
          animated:animated];
}

- (void)setMessage:(NSString *)message animated:(BOOL)animated {
    [self setLabel:_messageLabel
       withMessage:message
         textColor:[UIColor colorWithWhite:0x65 / 255.f alpha:1.f]
           isError:NO
          animated:animated];
}

- (void)showErrorMessage:(NSString *)errorMessage animated:(BOOL)animated {
    [self setLabel:_messageLabel
       withMessage:errorMessage
         textColor:[UIColor colorWithRed:249 / 255.f green:0 blue:14 / 255.f alpha:1.f]
           isError:YES
          animated:animated];
}

- (void)setLabel:(UILabel *)label
     withMessage:(NSString *)message
       textColor:(UIColor *)textColor
         isError:(BOOL)isError
        animated:(BOOL)animated {
    
    void (^block)() = ^(){
        if (textColor) {
            label.textColor = textColor;
        }
        label.text = message;
    };
    
    if (animated) {
        [UIView transitionWithView:label
                          duration:.15
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            block();
                            [self layoutIfNeeded];
                        }
                        completion:^(BOOL finished) {
                            if (isError) {
                                [label shake:8 withDelta:label.bounds.size.width / 10 speed:.05f];
                            }
                        }];
    } else {
        block();
    }
}


#pragma mark - dismiss

- (void)dismissSelf {
    [self removeFromSuperview];
    self.cancelButtonBlock = self.otherButtonBlock = self.textFieldBlock = NULL;
    [self.stack removeObject:self];
}

- (void)dismiss {
    // Make this un-re-enterable for each alert
    if (self.superview) {
        // 1. dismiss self
        [self dismissSelf];
        
        // 2. show the youngest sibling older than self
        typeof(self) nextTopMostAlert = [self.stack lastNonNullableObject];
        [nextTopMostAlert show];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_textField == textField) {
        [self didClickOther:nil];
    }
    
    return YES;
}


#pragma mark - UIKeyboardWillChangeFrameNotification

- (void)keyboardWillChange:(NSNotification *)notification {
    
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    [UIView beginAnimations:@"cn.LGAlertView.keyboardframechange" context:NULL];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    
    [self adjustSubviewsWhenKeyboardFrameChanged:keyboardRect];
    
    [self layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)adjustSubviewsWhenKeyboardFrameChanged:(CGRect)keyboardRect {
    
    keyboardRect = [self convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardHeight = self.frame.size.height -  keyboardRect.origin.y;
    
#ifdef LGAS_APP_EXTENSIONS
    _containerViewCenterYOffset.constant = keyboardHeight / 2;
#else
    if ([self.superView isKindOfClass:[UIWindow class]] && LGAS_SYSTEM_VERSION_LESS_THAN(@"8.0")) {
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
#endif
}


#pragma mark - UIApplicationDidEnterBackground

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self dismissSelf];// everyone will be dismissed, so no need to concern siblings
}


#pragma mark - Orientation & Rotation

#ifndef LGAS_APP_EXTENSIONS
- (void)statusBarOrientationChange:(NSNotification *)notification {
    self.containerView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, [self rotationAngle]);
}

- (CGFloat)rotationAngle {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat radian = 0;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        radian = -M_PI / 2.;
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        radian = M_PI / 2.;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        radian = -M_PI;
    }
    
    return radian;
}
#endif


#pragma mark - Button action

/**
 *  There are 2 triggers of dismissing alertView
 *  1. user click the buttons 
 *  2. application enter background
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
    if (_textField.isFirstResponder) {
        [_textField resignFirstResponder];
    } else if (_dismissOnTappingBackground) {
        UITouch *touch = [touches anyObject];
        if ([touch view] == self) {
            [self didClickCancel:nil];
        }
    }
}


@end
