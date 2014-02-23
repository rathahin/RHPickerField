//
//  RHAnimator.m
//  RHPickerField
//
//  Created by Ratha Hin on 2/22/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "RHAnimator.h"

@implementation RHAnimator

+ (void)animateLayer:(CALayer *)layer
        toFloatValue:(CGFloat)toValue
          forKeyPath:(NSString *)keyPath
            duration:(NSTimeInterval)duration
        animationKey:(NSString *)animationKey {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
  [layer removeAllAnimations];
  animation.fromValue = [layer.presentationLayer valueForKey:keyPath];
  
  NSLog(@"Animation is %@", [layer.presentationLayer valueForKey:keyPath]);
  
  animation.toValue = [NSNumber numberWithFloat:toValue];
  animation.removedOnCompletion = NO;
  animation.duration = duration;
  animation.fillMode = kCAFillModeForwards;
  animation.additive = NO;
  [layer addAnimation:animation forKey:animationKey];
  
}

@end
