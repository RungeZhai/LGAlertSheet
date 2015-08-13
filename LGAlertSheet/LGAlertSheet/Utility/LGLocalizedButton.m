//
//  HPLocalizedButton.m
//  ILSPrivatePhoto
//
//  Created by Runge Zhai on 15/4/14.
//  Copyright (c) 2015年 ZiXuWuYou. All rights reserved.
//

#import "LGLocalizedButton.h"

@implementation LGLocalizedButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTitle:NSLocalizedString(self.titleLabel.text, nil) forState:UIControlStateNormal];
}
@end
