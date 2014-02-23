//
//  PickerCell.m
//  RHPickerField
//
//  Created by Ratha Hin on 2/23/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "PickerCell.h"
#import "UIColor+Extras.h"

@implementation PickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
      [self commonSetupOnInit];
      
    }
    return self;
}

- (void)commonSetupOnInit {
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  [self.textLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:15.0]];
  [self.textLabel setTextColor:[UIColor colorWithHexString:@"#4d5259"]];
  self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reusableIdentifier {
  return @"PickerCellID";
}

+ (CGFloat)cellHeight {
  return 40;
}

@end
