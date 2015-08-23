//
//  LGCustomizedCornerButton.m
//  LGAlertSheet
//
//  Created by Runge Zhai on 7/17/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "LGCustomizedCornerButton.h"

@implementation LGCustomizedCornerButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    
    self.clipsToBounds = YES;
    
    // corner
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:((_topLeft ? UIRectCornerTopLeft : 0) |
                                                                      (_bottomLeft ? UIRectCornerBottomLeft : 0) |
                                                                      (_bottomRight ? UIRectCornerBottomRight : 0) |
                                                                      (_topRight ? UIRectCornerTopRight : 0))
                                                         cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    // border
    CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
    borderLayer.frame = self.bounds;
    borderLayer.path  = maskPath.CGPath;
    borderLayer.lineWidth   = _borderWidth;
    borderLayer.strokeColor = _borderColor.CGColor;
    borderLayer.fillColor   = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:borderLayer];
}

#ifdef IB_DESIGNABLE
- (void)prepareForInterfaceBuilder {
    [self setupUI];
}
#endif

@end
