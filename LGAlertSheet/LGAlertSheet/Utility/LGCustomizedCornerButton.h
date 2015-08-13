//
//  LGCustomizedCornerButton.h
//  ILSPrivatePhoto
//
//  Created by Runge Zhai on 7/17/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "LGCommonButton.h"

#ifdef  IB_DESIGNABLE
IB_DESIGNABLE
#endif

#ifndef IBInspectable
#define IBInspectable
#endif

@interface LGCustomizedCornerButton : LGCommonButton

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (strong, nonatomic) IBInspectable UIColor *borderColor;

@property (nonatomic) IBInspectable BOOL topLeft;
@property (nonatomic) IBInspectable BOOL bottomLeft;
@property (nonatomic) IBInspectable BOOL bottomRight;
@property (nonatomic) IBInspectable BOOL topRight;

@end
