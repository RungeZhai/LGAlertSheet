# LGAlertSheet
A customized AlertView and ActionSheet

## Demo
<img src="https://cloud.githubusercontent.com/assets/3366713/9427558/ccb5e920-49b6-11e5-90c8-4d5cd2cb5974.gif" width=320 />

## Overview
LGAlertSheet includes customized AlertView and ActionSheet.

Four kinds of AlertViews are implemented:

1. Normal AlertView with title, message and button(s);

2. AlertView with an image on the top;

3. AlertView with a TextField in it;

4. AlertView showing a progress view and optionally transitioning to completion state.

Two kinds of ActionSheet are implemented: ActionSheet with 1 option and with 2 options.

LGAlertSheet pretty much covers most of the usage scenarios and, moreover:

1. Easy to customize UI as it is implemented using xib and Autolayout.

2. Fully optimized for device rotation and keyboard.

3. Support extensions.

4. Support multiple instances of AlertView/ActionSheet showing one above another.

Requires iOS**7** or later. The popping up animation is a spring animation and it's only available on iOS7 and later.

## Usage

1. Showing a plain alert view:

  ```objective-c
  [LGAlertView showAlertWithTitle:@"This is title"
                          message:@"This is message"
                cancelButtonTitle:@"Cancel"
                 otherButtonTitle:@"OK"
                cancelButtonBlock:nil
                 otherButtonBlock:^(LGAlertView *alertView) {
                     [alertView dismiss];
                 }];
  ```
  Note that to dismiss the AlertView when the "OK" button is clicked, you have to manually call `dismiss`. The advantage of this is that you can do something else to the alert like showing wrong message or popping up another AlertView.
  
2. Showing an AlertView with an image on the top:
  
  ```objective-c
  [LGAlertView showAlertWithTitleImage:[UIImage imageNamed:@"import_done"]
                                 title:@"This is title"
                               message:@"This is message"
                     cancelButtonTitle:@"Cancel"
                      otherButtonTitle:@"OK"
                     cancelButtonBlock:nil
                      otherButtonBlock:nil];
  ```
3. Showing AlertView with a TextField:
  
  ```objective-c
  [LGAlertView showAlertWithTitle:@"This is Title"
                          message:@"This is message"
                cancelButtonTitle:@"Cancel"
                 otherButtonTitle:@"OK"
                cancelButtonBlock:nil
                   textFieldBlock:^(LGAlertView *alertView) {
                       [alertView showErrorMessage:@"Wrong Password" animated:YES];
                   }];
  }
  ```
  Here you can show some error message if user's input is not valid with optionally a spring animation.
  
4. Showing AlertView with a progress view:
  
  ```objective-c
  LGAlertView *alertView = [LGAlertView alertWithInProgressImage:[UIImage imageNamed:@"import_in_progress"]
                                                 completionImage:[UIImage imageNamed:@"import_done"]
                                                         message:@"This is a long long long long long long message"
                                               cancelButtonTitle:@"OK, I know"
                                                otherButtonTitle:@"Please don't"
                                               cancelButtonBlock:nil
                                                otherButtonBlock:nil];
      
  [alertView show];
  ```
  You can call `[alertView animateToCompletionState];` after the progress is completed to transite to completion state, or set `alertView.progressView`'s `animationCompletionCallBack` and in that block call `[alertView animateToCompletionState];` so that it will animate to completion state once the progress is completed.
  
5. Showing ActionSheet with 1 options:
  
  ```objective-c
  [LGActionSheet showActionSheetWithCancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"
                                    cancelButtonBlock:nil
                                     otherButtonBlock:nil
                                             fromView:nil];
  ```
  If you pass nil to `fromView`, the super view of ActionSheet is the topmost window. But CAUTION: This parameter MUST NOT be nil in extensions as we cannot use UIWindow in extensions.
  
6. Showing ActionSheet with 2 options:
  
  ```objective-c
  [LGActionSheet showActionSheetWithCancelButtonTitle:@"Cancel"
                                    otherButtonTitle0:@"Option 1"
                                    otherButtonTitle1:@"Option 2"
                                    cancelButtonBlock:nil
                                    otherButtonBlock0:nil
                                    otherButtonBlock1:nil
                                             fromView:nil];
  ```
  
### Extensions
To use LGAlertSheet in extensions, you have to: 

1. Define Macro LGAS_APP_EXTENSIONS

2. Either passing a non-nullable superView parameter to init... method (LGActionSheet) or setting superView before showing the AlertView/ActionSheet.
