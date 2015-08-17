//
//  ViewController.m
//  LGAlertSheet
//
//  Created by Runge Zhai on 8/11/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "ViewController.h"
#import "LGAlertView.h"
#import "LGProgressView.h"

@interface ViewController ()<UIActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showAlertView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)showAlertView {
    
    
//    LGAlertView *alertView = [LGAlertView alertWithInProgressImage:[UIImage imageNamed:@"import_in_progress"]
//                                                   completionImage:[UIImage imageNamed:@"import_done"]
//                                                           message:@"This is a long long long long long long message"
//                                                 cancelButtonTitle:@"OK, I know"
//                                                  otherButtonTitle:@"Please don't"
//                                                 cancelButtonBlock:nil
//                                                  otherButtonBlock:nil];
//    
//    [alertView show];
//    [self simulateProgressOfAlertView:alertView];
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Title" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
//    [actionSheet showInView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK1", @"OK1", nil];
    
    [alert show];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [LGAlertView showAlertWithTitleImage:nil
                                       title:@"This is Title"
                                     message:@"This is message"
                           cancelButtonTitle:@"OK, I know"
                            otherButtonTitle:@"Please don't"
                           cancelButtonBlock:nil
                            otherButtonBlock:^(LGAlertView *alertView) {
                                [alertView showErrorMessage:@"Wrong\nWrong\nWrong Password" animated:YES];
                            }];
    });
    
}

- (void)simulateProgressOfAlertView:(LGAlertView *)alertView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (alertView.progressView.currentProgress >= 1) {
            [alertView animateToCompletionState];
        } else {
            [alertView.progressView setProgress:alertView.progressView.currentProgress + .1];
            alertView.progressLabel.text = [NSString stringWithFormat:@"%f%%", alertView.progressView.currentProgress];
            [self simulateProgressOfAlertView:alertView];
        }
    });
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    [LGAlertView showAlertWithTitleImage:nil
//                                   title:@"This is Title"
//                                 message:@"This is message"
//                       cancelButtonTitle:@"OK, I know"
//                        otherButtonTitle:@"Please don't"
//                       cancelButtonBlock:nil
//                        otherButtonBlock:^(LGAlertView *alertView) {
//                            [alertView showErrorMessage:@"Wrong\nWrong\nWrong Password" animated:YES];
//                        }];

}

- (IBAction)didClickShowProgressHUD:(id)sender {
//    [SVProgressHUD show];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK1", @"OK1", nil];
//    
//    [alert show];
    
//    [self showAlertView];
    
    
//    [LGAlertView showAlertWithTitleImage:nil
//                                   title:@"This is Title"
//                                 message:@"This is message"
//                       cancelButtonTitle:@"OK, I know"
//                        otherButtonTitle:@"Please don't"
//                       cancelButtonBlock:nil
//                        otherButtonBlock:^(LGAlertView *alertView) {
//                            [alertView showErrorMessage:@"Wrong\nWrong\nWrong Password" animated:YES];
//                        }];
    
    [LGAlertView showAlertWithTitle:@"Title" message:@"Message" cancelButtonTitle:@"Cancel" otherButtonTitle:@"OK" cancelButtonBlock:nil textFieldBlock:nil];

}
- (IBAction)didClickNormalAlert:(id)sender {
    
    [LGAlertView showAlertWithTitleImage:nil
                                   title:@"This is Title"
                                 message:@"This is message"
                       cancelButtonTitle:@"OK, I know"
                        otherButtonTitle:@"Please don't"
                       cancelButtonBlock:nil
                        otherButtonBlock:^(LGAlertView *alertView) {
                            [alertView showErrorMessage:@"Wrong\nWrong\nWrong Password" animated:YES];
                        }];

}

@end
