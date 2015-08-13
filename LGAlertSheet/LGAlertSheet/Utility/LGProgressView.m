//
//  LGProgressView.m
//  LGAlertSheet
//
//  Created by liuge on 8/12/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "LGProgressView.h"

static CGFloat kProgressLineWidth = 5.;

@interface LGProgressView ()

@property (nonatomic)       CGFloat       newToValue;
@property (nonatomic)       BOOL          isAnimationInProgress;
@property (weak, nonatomic) CAShapeLayer *progressCircleLayer;

@end

@implementation LGProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _progress = .0;
        _newToValue = .0;
        _isAnimationInProgress = NO;
        
        self.alpha = 0.95;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _progress = .0;
    _newToValue = .0;
    _isAnimationInProgress = NO;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = kProgressLineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = (self.bounds.size.width - kProgressLineWidth) / 2;
    CGFloat startAngle = 0;
    CGFloat endAngle = M_PI * 2;
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [[UIColor colorWithRed:239 / 255.f green:239 / 255.f blue:244 / 255.f alpha:1] setStroke];
    [processBackgroundPath stroke];
}

- (void)setAnimationDone {
    _isAnimationInProgress = NO;
    if (_newToValue > _progress)
        [self setProgress:_newToValue];
}

- (void)setProgress:(CGFloat)value {
    
    CGFloat toValue = value;
    
    if (toValue <= _progress)
        return;
    else if (toValue > 1.0)
        toValue = 1.0;
    
    // make this method non re-enterable but still can catch up if progress is 
    
    if (_isAnimationInProgress) {
        _newToValue = toValue;
        return;
    }
    
    _isAnimationInProgress = YES;
    
    CGFloat animation_time = (toValue - _progress) * 2;
    
    [self performSelector:@selector(setAnimationDone) withObject:Nil afterDelay:animation_time];
    
    float start_angle = -M_PI_2;
    float end_angle = 2 * M_PI * toValue - M_PI_2;
    
    CAShapeLayer *circle = _progressCircleLayer ?: ({[self.layer addSublayer:(_progressCircleLayer = [CAShapeLayer layer])]; _progressCircleLayer;});
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                                                        radius:(self.bounds.size.width - kProgressLineWidth) / 2
                                                    startAngle:start_angle
                                                      endAngle:end_angle
                                                     clockwise:YES];
    
    circle.path = path.CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor colorWithRed:52 / 255.f green:172 / 255.f blue:109 / 255.f alpha:1].CGColor;
    circle.lineWidth = kProgressLineWidth;
    circle.lineCap = kCALineCapRound;
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    drawAnimation.duration            = animation_time;
    drawAnimation.repeatCount         = 0.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:_progress / toValue];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    _progress = toValue;
}

@end
