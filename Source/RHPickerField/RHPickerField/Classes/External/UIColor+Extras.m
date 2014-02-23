//
//  UIColor+Hex.m
//  Tesco
//
//  Created by Ratha Hin on 7/18/13.
//  Copyright (c) 2013 Golden Gekko. All rights reserved.
//

#import "UIColor+Extras.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
  
  if (hexString == nil) {
    return [UIColor blackColor];
  }
  
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0 green:((rgbValue & 0xFF00) >> 8) / 255.0 blue:(rgbValue & 0xFF) / 255.0 alpha:1.0];
}

@end

@implementation UIColor (Brightness)

- (UIColor *)lighterColor {
  CGFloat h, s, b, a;
  
  if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
    
    return [UIColor colorWithHue:h
                      saturation:s
                      brightness:MIN(b * 1.3, 1.0)
                           alpha:a];
  
  return nil;
}

- (UIColor *)darkerColor {
  CGFloat h, s, b, a;
  
  if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
    
    return [UIColor colorWithHue:h
                      saturation:s
                      brightness:b * 0.75
                           alpha:a];
  
  return nil;
}

@end