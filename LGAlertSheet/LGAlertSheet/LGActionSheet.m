//
//  LGActionSheet.m
//  LGAlertSheet
//
//  Created by Runge Zhai on 7/16/15.
//  Copyright (c) 2015 ZIXUWUYOU. All rights reserved.
//

#import "LGActionSheet.h"
#import "NSPointerArray+AbstractionHelpers.h"

#ifndef LGAS_SYSTEM_VERSION_LESS_THAN
#define LGAS_SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#endif

static NSMutableDictionary *stacks;
static dispatch_semaphore_t show_animation_semaphore;

@interface LGActionSheet ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomSpace;

@end

@implementation LGActionSheet

@synthesize superView = _superView;

#pragma mark - Initialization & LifeCycle

+ (void)initialize {
    stacks = [NSMutableDictionary new];
    show_animation_semaphore = dispatch_semaphore_create(1);
}

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

- (void)configCommonProperties {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
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
     */
    UIWindow *topMostWindow = UIApplication.sharedApplication.windows.lastObject;
    BOOL windowOnMainScreen = topMostWindow.screen == UIScreen.mainScreen;
    BOOL windowIsVisible = !topMostWindow.hidden && topMostWindow.alpha > 0;
    
    if (windowOnMainScreen
        && windowIsVisible
        && [self windowIsKeyboard:topMostWindow]) {
        return topMostWindow;
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
                typeof(self) currentTopMostActionSheet = [self.stack lastNonNullableObject];
                currentTopMostActionSheet.hidden = YES;
                
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
    
    UIColor *backgroundColor = self.backgroundColor;
    self.backgroundColor = [UIColor clearColor];
    
    _containerViewBottomSpace.constant = -_containerView.frame.size.height;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = backgroundColor;
        
        _containerViewBottomSpace.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}


#pragma mark - dismiss

- (void)dismissSelf:(void(^)())completion {
    self.cancelButtonBlock = self.otherButtonBlock0 = self.otherButtonBlock1 = NULL;
    
    [UIView animateWithDuration:.25f animations:^{
        self.backgroundColor = [UIColor clearColor];
        _containerViewBottomSpace.constant = -_containerView.frame.size.height;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.stack removeObject:self];
        if (completion) completion();
    }];
}

- (void)dismiss {
    if (self.superview) {
        [self dismissSelf:^{
            typeof(self) nextTopMostActionSheet = [self.stack lastNonNullableObject];
            [nextTopMostActionSheet show];
        }];
    }
}

#pragma mark - UIApplicationDidEnterBackground

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self dismissSelf:nil];// everyone will be dismissed, so no need to concern siblings
}


#pragma mark - Orientation & Rotation

#ifndef LGAS_APP_EXTENSIONS
- (void)statusBarOrientationChange:(NSNotification *)notification {
    
    self.transform = CGAffineTransformIdentity;
    
    CGRect rect = self.frame;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat radian = 0;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        radian = -M_PI / 2.;
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        radian = M_PI / 2.;
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        radian = -M_PI;
    }
    
    CGFloat minValue = MIN(rect.size.height, rect.size.width);
    CGFloat maxValue = MAX(rect.size.height, rect.size.width);
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        rect.size = (CGSize){maxValue, minValue};
    } else {
        rect.size = (CGSize){minValue, maxValue};
    }
    
    self.frame = rect;
    self.center = self.superView.center;
    
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, radian);
}
#endif


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


#pragma mark - Touches Began

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

@end
