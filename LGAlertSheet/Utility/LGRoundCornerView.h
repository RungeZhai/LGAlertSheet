//
//  LGRoundCornerView.h
//  LGAlertSheet
//
//  Created by liuge on 5/5/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import <UIKit/UIKit.h>


#ifdef  IB_DESIGNABLE
IB_DESIGNABLE
#endif


@interface LGRoundCornerView : UIView

#ifdef IBInspectable
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
#else
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) UIColor *borderColor;

#endif

@end
