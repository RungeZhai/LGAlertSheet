//
//  ViewController.m
//  LGAlertSheet
//
//  Created by Runge Zhai on 8/11/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "ViewController.h"
#import "LGAlertView.h"
#import "LGActionSheet.h"
#import "LGProgressView.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)didClickNormalAlert:(id)sender {
    LGAlertView *alert =
    [LGAlertView alertWithTitle:@"This is title"
                            message:@"This is message"
                  cancelButtonTitle:@"Cancel"
                   otherButtonTitle:@"OK"
                  cancelButtonBlock:nil
                   otherButtonBlock:^(LGAlertView *alertView) {
                       [alertView dismiss];
                   }];
    alert.dismissOnTappingBackground = YES;
    [alert show];
}

- (IBAction)didClickAlertWithTopImage:(id)sender {
    [LGAlertView showAlertWithTitleImage:[UIImage imageNamed:@"import_done"]
                                   title:@"This is title"
                                 message:@"This is message"
                       cancelButtonTitle:@"Cancel"
                        otherButtonTitle:@"OK"
                       cancelButtonBlock:nil
                        otherButtonBlock:nil];
}

- (IBAction)didClickAlertWithTextField:(id)sender {
    LGAlertView *alert =
    [LGAlertView alertWithTitle:@"This is Title"
                            message:@"This is message"
                  cancelButtonTitle:@"Cancel"
                   otherButtonTitle:@"OK"
                  cancelButtonBlock:nil
                     textFieldBlock:^(LGAlertView *alertView) {
                         [alertView showErrorMessage:@"Wrong Password" animated:YES];
                     }];
    
    alert.dismissOnTappingBackground = YES;
    [alert show];
}

- (IBAction)didClickAlertWithProgress:(id)sender {
    LGAlertView *alertView = [LGAlertView alertWithInProgressImage:[UIImage imageNamed:@"import_in_progress"]
                                                   completionImage:[UIImage imageNamed:@"import_done"]
                                                           message:@"This is a long long long long long long message"
                                                 cancelButtonTitle:@"OK, I know"
                                                  otherButtonTitle:@"Please don't"
                                                 cancelButtonBlock:nil
                                                  otherButtonBlock:nil];
    
    [alertView show];
    [self simulateProgressOfAlertView:alertView];
}

- (IBAction)didClickActionSheetWith1Option:(id)sender {
    [LGActionSheet showActionSheetWithCancelButtonTitle:@"Cancel"
                                       otherButtonTitle:@"OK"
                                      cancelButtonBlock:nil
                                       otherButtonBlock:nil
                                               fromView:nil];
}

- (IBAction)didClickActionSheetWith2Options:(id)sender {
    [LGActionSheet showActionSheetWithCancelButtonTitle:@"Cancel"
                                      otherButtonTitle0:@"Option 1"
                                      otherButtonTitle1:@"Option 2"
                                      cancelButtonBlock:nil
                                      otherButtonBlock0:nil
                                      otherButtonBlock1:nil
                                               fromView:nil];
}

- (void)simulateProgressOfAlertView:(LGAlertView *)alertView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (alertView.progressView.currentProgress >= 1) {
            [alertView animateToCompletionState];
        } else {
            [alertView.progressView setProgress:alertView.progressView.currentProgress + .1];
            alertView.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", alertView.progressView.currentProgress * 100];
            [self simulateProgressOfAlertView:alertView];
        }
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
