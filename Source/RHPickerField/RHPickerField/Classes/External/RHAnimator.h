//
//  RHAnimator.h
//  RHPickerField
//
//  Created by Ratha Hin on 2/22/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHAnimator : NSObject

+ (void)animateLayer:(CALayer *)layer
        toFloatValue:(CGFloat)toValue
          forKeyPath:(NSString *)keyPath
            duration:(NSTimeInterval)duration
        animationKey:(NSString *)animationKey;

@end
