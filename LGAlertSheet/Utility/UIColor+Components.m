//
//  UIColor+Components.m
//  ZiXuWuYou
//
//  Created by Runge Zhai on 5/4/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//
//  http://stackoverflow.com/questions/816828/extracting-rgb-from-uicolor?lq=1

#import "UIColor+Components.h"

@implementation UIColor (Components)

- (void)retrieveRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
    
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    NSInteger numberOfComponents = CGColorGetNumberOfComponents(self.CGColor) ;
    if (numberOfComponents == 2) {  // grayscale(created with colorWithWhite:alpha:)
        *red = *green = *blue = components[0];
        *alpha = components[1];
    } else if (numberOfComponents == 4) {
        *red = components[0];
        *green = components[1];
        *blue = components[2];
        *alpha = components[3];
    }
}

- (UIColor *)maskByColor:(UIColor *)maskColor {
    CGFloat selfRed, selfGreen, selfBlue, selfAlpha;
    CGFloat maskRed, maskGreen, maskBlue, maskAlpha;
    
    [self retrieveRed:&selfRed green:&selfGreen blue:&selfBlue alpha:&selfAlpha];
    [maskColor retrieveRed:&maskRed green:&maskGreen blue:&maskBlue alpha:&maskAlpha];
    
    CGFloat red, green, blue, alpha;
    red = (selfRed * (1 - maskAlpha) + maskRed * maskAlpha) / selfAlpha;
    green = (selfGreen * (1 - maskAlpha) + maskGreen * maskAlpha) / selfAlpha;
    blue = (selfBlue * (1 - maskAlpha) + maskBlue * maskAlpha) / selfAlpha;
    alpha = selfAlpha;
    
    if (red == green && red == blue) {
        return [UIColor colorWithWhite:red alpha:alpha];
    } else {
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
}

- (BOOL)isEqualToColor:(UIColor *)color {
    CGFloat selfRed, selfGreen, selfBlue, selfAlpha;
    CGFloat red, green, blue, alpha;
    
    [self retrieveRed:&selfRed green:&selfGreen blue:&selfBlue alpha:&selfAlpha];
    [color retrieveRed:&red green:&green blue:&blue alpha:&alpha];
    
    return ((selfRed == red) && (selfGreen == green) && (selfBlue == blue) && (selfAlpha == alpha));
}

@end
