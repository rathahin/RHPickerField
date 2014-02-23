//
//  UIColor+Hex.h
//  Tesco
//
//  Created by Ratha Hin on 7/18/13.
//  Copyright (c) 2013 Golden Gekko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

@interface UIColor (Brightness)

- (UIColor *)lighterColor;
- (UIColor *)darkerColor;

@end
