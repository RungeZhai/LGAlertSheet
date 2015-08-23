//
//  LGRoundCornerView.m
//  LGAlertSheet
//
//  Created by liuge on 5/5/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "LGRoundCornerView.h"

@implementation LGRoundCornerView

- (void)awakeFromNib
{
    [self setupBorder];
}

- (void)setupBorder
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.borderColor  = _borderColor.CGColor;
    self.layer.borderWidth  = _borderWidth;
}

#ifdef IB_DESIGNABLE
- (void)prepareForInterfaceBuilder
{
    [self setupBorder];
}
#endif

@end
