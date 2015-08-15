//
//  LGProgressView.h
//  LGAlertSheet
//
//  Created by liuge on 8/12/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class LGProgressView;

typedef void(^LGPVAnimationCompletionCallBack)(LGProgressView *);



@interface LGProgressView : UIView

@property (nonatomic, getter = currentProgress) CGFloat progress;

@property (nonatomic, assign)                   BOOL    animationHasCompleted;

@property (nonatomic, copy) LGPVAnimationCompletionCallBack animationCompletionCallBack;

@end
