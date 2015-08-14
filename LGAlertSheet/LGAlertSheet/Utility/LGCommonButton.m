//
//  LGCommonButton.m
//  LGAlertSheet
//
//  Created by Runge Zhai on 5/4/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//
//  Automatically calculate the highlighted color according to normal color
//  The highlighted color is the result of blending normalColor with a 0.2-alph-black color.
//  About alpha blending calculation:
//  http://stackoverflow.com/questions/746899/how-to-calculate-an-rgb-colour-by-specifying-an-alpha-blending-amount

#import "LGCommonButton.h"
#import "UIColor+Components.h"
#import "UIImage+Color.h"

@implementation LGCommonButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *normalColor = self.backgroundColor;
    
    UIColor *highlightedColor = [normalColor maskByColor:[UIColor colorWithWhite:0 alpha:.2f]];
    UIColor *disabledColor = [normalColor maskByColor:[UIColor colorWithWhite:1 alpha:.4f]];
    
    [self setBackgroundImage:[UIImage imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:disabledColor] forState:UIControlStateDisabled];
}

@end
