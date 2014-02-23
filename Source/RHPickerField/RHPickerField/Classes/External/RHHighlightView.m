//
//  RHHighlightView.m
//  RHPickerField
//
//  Created by Ratha Hin on 2/23/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "RHHighlightView.h"
#import "UIColor+Extras.h"

const CGFloat padding = 10;

@interface RHHighlightView ()

@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation RHHighlightView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.userInteractionEnabled = NO;
      [self addSubview:self.textLabel];
    }
    return self;
}

- (void)updateLabelWithText:(NSString *)text {
  self.textLabel.text = text;
  self.textLabel.textColor = [UIColor colorWithHexString:@"#121d2b"];
}

- (void)endUpdate {
  self.textLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
}

- (UILabel *)textLabel {
  if (!_textLabel) {
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, CGRectGetWidth(self.bounds) - padding, CGRectGetHeight(self.bounds))];
    _textLabel.backgroundColor = [UIColor clearColor];
    [_textLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:25.0]];
  }
  
  return _textLabel;
}

@end
