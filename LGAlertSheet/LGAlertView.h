//
//  LGAlertView.h
//  LGAlertSheet
//
//  Created by Runge Zhai on 5/15/15.
//  Copyright (c) 2015 ZIXUWUYOU. All rights reserved.
//


#import <UIKit/UIKit.h>

@class LGAlertView;
@class LGProgressView;

typedef void (^LGAlertViewCancelBlock)(LGAlertView *alertView);
typedef void (^LGAlertViewOtherBlock)(LGAlertView *alertView);
typedef void (^LGAlertViewTextFieldBlock)(LGAlertView *alertView);

@interface LGAlertView : UIView

/**
 *  If you don't set superView, the superView by default is:
 *  1. keyboard window, if the topmost window is keyboard;
 *  2. keyWindow, if the topmost window is not keyboard.
 *  Otherwise, you MUST set it BEFORE alertView has shown.
 *
 *  For extensions, you HAVE TO:
 *  1. define MACRO: LGAS_APP_EXTENSIONS
 *  2. manually set the superView before calling show.
 */
@property (weak, nonatomic)          UIView           *superView;

/**
 *  For Basic AlertView
 */
@property (weak, nonatomic) IBOutlet UIView           *containerView;
@property (weak, nonatomic) IBOutlet UITextField      *textField;
@property (weak, nonatomic) IBOutlet UILabel          *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel          *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton         *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton         *otherButton;
@property (weak, nonatomic) IBOutlet UIButton         *okButton;

/**
 *  You can set button action callback block any time before user click the button
 */
@property (copy, nonatomic) LGAlertViewCancelBlock    cancelButtonBlock;
@property (copy, nonatomic) LGAlertViewOtherBlock     otherButtonBlock;
@property (copy, nonatomic) LGAlertViewTextFieldBlock textFieldBlock;

/**
 *  For Title Image AlertView
 */
@property (weak, nonatomic) IBOutlet UIImageView      *titleImageView;

/**
 *  For Progress AlertView with a completion transition
 */
@property (weak, nonatomic) IBOutlet UILabel          *progressLabel;
@property (weak, nonatomic) IBOutlet LGProgressView   *progressView;
@property (weak, nonatomic) IBOutlet UIImageView      *circularProgressBGImageView;
@property (strong, nonatomic)        UIImage          *completionImage;


/**
 *  General Show/Hide method
 */
- (void)show;
- (void)dismiss;

/**
 *  Default behaviour of showing/changing title/message/errorMessage
 *  You can directly use titleLable/messageLabel to customize you own way
 */
- (void)setTitle:(NSString *)title animated:(BOOL)animated;
- (void)setMessage:(NSString *)message animated:(BOOL)animated;
- (void)showErrorMessage:(NSString *)errorMessage animated:(BOOL)animated;


/**
 *  Progress Alert View
 */
- (void)animateToCompletionState;


/**
 *  Use this method if you want to initialize a basic alert view without a textField
 *  and customize it your own way before shown
 */
+ (LGAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitle:(NSString *)otherButtonTitle
              cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
               otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock;

/**
 *  Initialize an alert view without a textField and show
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitle:(NSString *)otherButtonTitle
         cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
          otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock;

/**
 *  Use this method if you want to initialize a basic alert view with a textField
 *  and customize it your own way before shown
 */
+ (LGAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitle:(NSString *)otherButtonTitle
              cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
                 textFieldBlock:(LGAlertViewTextFieldBlock)textFieldBlock;

/**
 *  Initialize an alert view with a textField and show
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitle:(NSString *)otherButtonTitle
         cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
            textFieldBlock:(LGAlertViewTextFieldBlock)textFieldBlock;

/**
 *  Use this method if you want to initialize an alert view 
 *  with an image on the top without a textField
 *  and customize it your own way before shown
 *  Caution: Use Basic Alert View if you don't want an image on the top
 */
+ (LGAlertView *)alertWithTitleImage:(UIImage *)titleImage
                               title:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                    otherButtonTitle:(NSString *)otherButtonTitle
                   cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
                    otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock;

/**
 *  Initialize an alert view with an image on the top without a textField and show
 *  Caution: Use Basic Alert View if you don't want an image on the top
 */
+ (void)showAlertWithTitleImage:(UIImage *)titleImage
                          title:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitle:(NSString *)otherButtonTitle
              cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
               otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock;

/**
 *  Use this method if you want to initialize a progress alert view
 *  and customize it your own way before shown
 */
+ (LGAlertView *)alertWithInProgressImage:(UIImage *)inProgressImage
                          completionImage:(UIImage *)completionImage
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                         otherButtonTitle:(NSString *)otherButtonTitle
                        cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
                         otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock;

/**
 *  Initialize a progress alert view and show
 */
+ (void)showAlertWithInProgressImage:(UIImage *)inProgressImage
                     completionImage:(UIImage *)completionImage
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                    otherButtonTitle:(NSString *)otherButtonTitle
                   cancelButtonBlock:(LGAlertViewCancelBlock)cancelButtonBlock
                    otherButtonBlock:(LGAlertViewOtherBlock)otherButtonBlock;

@end
