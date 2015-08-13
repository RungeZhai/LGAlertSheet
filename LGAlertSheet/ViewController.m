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

@interface ViewController ()

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
    [self showAlertView];
}

- (void)showAlertView {
    
    LGAlertView *alertView = [LGAlertView alertWithInProgressImage:[UIImage imageNamed:@"import_in_progress"]
                                                   completionImage:[UIImage imageNamed:@"import_done"]
                                                           message:@"This is a long long long long long long message"
                                                 cancelButtonTitle:@"OK, I know"
                                                  otherButtonTitle:@"Please don't"
                                                 cancelButtonBlock:nil
                                                  otherButtonBlock:nil];
    
    [alertView show];
    [self simulateProgressOfAlertVie:alertView];
    
    

    
//    [LGAlertView showAlertWithTitleImage:[UIImage imageNamed:@"import_done"]
//                                   title:@"This is Title"
//                                 message:@"This is message"
//                       cancelButtonTitle:@"OK, I know"
//                        otherButtonTitle:nil
//                       cancelButtonBlock:nil
//                        otherButtonBlock:nil];
}

- (void)simulateProgressOfAlertVie:(LGAlertView *)alertView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (alertView.progressView.currentProgress >= 1) {
            [alertView animateToCompletionState];
        } else {
            [alertView.progressView setProgress:alertView.progressView.currentProgress + .05];
            alertView.progressLabel.text = [NSString stringWithFormat:@"%f%%", alertView.progressView.currentProgress];
            [self simulateProgressOfAlertVie:alertView];
        }
    });
}


@end
