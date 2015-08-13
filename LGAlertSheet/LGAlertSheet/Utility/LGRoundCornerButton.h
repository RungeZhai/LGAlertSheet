//
//  LGRoundCornerButton.h
//  testUITextField
//
//  Created by Runge Zhai on 5/4/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "LGCommonButton.h"

#ifdef IB_DESIGNABLE
IB_DESIGNABLE
#endif

@interface LGRoundCornerButton : LGCommonButton


#ifdef IBInspectable
@property (nonatomic) IBInspectable CGFloat cornerRadius;
#else 
@property (nonatomic) CGFloat cornerRadius;
#endif

@end
