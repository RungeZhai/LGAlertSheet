//
//  LGRoundCornerButton.m
//  LGAlertSheet
//
//  Created by Runge Zhai on 5/4/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "LGRoundCornerButton.h"

@implementation LGRoundCornerButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.clipsToBounds = TRUE;
    self.layer.cornerRadius = _cornerRadius > 0 ? _cornerRadius : 0;
}

#ifdef IB_DESIGNABLE
- (void)prepareForInterfaceBuilder
{
    self.clipsToBounds = TRUE;
    self.layer.cornerRadius = _cornerRadius;
}
#endif

@end
