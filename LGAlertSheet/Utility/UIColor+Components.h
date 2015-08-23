//
//  UIColor+Components.h
//  ZiXuWuYou
//
//  Created by Runge Zhai on 5/4/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Components)

- (void)retrieveRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha;

- (UIColor *)maskByColor:(UIColor *)maskColor;

- (BOOL)isEqualToColor:(UIColor *)color;

@end
