//
//  LGActionSheet.h
//  LGAlertSheet
//
//  Created by Runge Zhai on 7/16/15.
//  Copyright (c) 2015 ZIXUWUYOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGActionSheet;

typedef void (^LGActionSheetCancelBlock)(LGActionSheet *alertView);
typedef void (^LGActionSheetOtherBlock)(LGActionSheet *alertView);

@interface LGActionSheet : UIView

@property (weak, nonatomic) UIView *superView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton0;
@property (weak, nonatomic) IBOutlet UIButton *otherButton1;

@property (copy, nonatomic) LGActionSheetCancelBlock cancelButtonBlock;
@property (copy, nonatomic) LGActionSheetOtherBlock otherButtonBlock0;
@property (copy, nonatomic) LGActionSheetOtherBlock otherButtonBlock1;

- (void)dismiss;

+ (void)showActionSheetWithCancelButtonTitle:(NSString *)cancelButtonTitle
                            otherButtonTitle:(NSString *)otherButtonTitle
                           cancelButtonBlock:(LGActionSheetCancelBlock)cancelButtonBlock
                            otherButtonBlock:(LGActionSheetOtherBlock)otherButtonBlock
                                    fromView:(UIView *)superView;

+ (void)showActionSheetWithCancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitle0:(NSString *)otherButtonTitle0
                           otherButtonTitle1:(NSString *)otherButtonTitle1
                           cancelButtonBlock:(LGActionSheetCancelBlock)cancelButtonBlock
                           otherButtonBlock0:(LGActionSheetOtherBlock)otherButtonBlock
                           otherButtonBlock1:(LGActionSheetOtherBlock)otherButtonBlock1
                                    fromView:(UIView *)superView;

@end
