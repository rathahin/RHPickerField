//
//  SampleViewController.m
//  RHPickerField
//
//  Created by Ratha Hin on 2/21/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "SampleViewController.h"
#import "RHPickerField.h"

@interface SampleViewController () <RHPickerFieldDataSource, RHPickerFieldDelegate>

@property (strong, nonatomic) RHPickerField *datePickerField;

@end

@implementation SampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self configureView];
}

- (void)configureView {
  self.view.backgroundColor = [UIColor whiteColor];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 320, 30)];
  [label setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
  label.text = @"Date of birth";
  [self.view addSubview:label];
  [self.view addSubview:self.datePickerField];
  
  

}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (RHPickerField *)datePickerField {
  if (!_datePickerField) {
    _datePickerField = [[RHPickerField alloc] initWithFrame:CGRectMake(0, 200, 320, 60)];
    
    /// setup
    _datePickerField.highlightedBackgroundColor = [UIColor colorWithHexString:@"#eaa659"];
    _datePickerField.backgroundColor = [UIColor colorWithHexString:@"#e5e5dc"];
    _datePickerField.userInteractionEnabled = YES;
    _datePickerField.delegate = self;
    _datePickerField.dataSource = self;
    
    /// end setup
  }
  
  return _datePickerField;
}

- (NSArray *)day {
  NSMutableArray *days = [[NSMutableArray alloc] init];
  
  for (int i= 0; i < 30 ; i++) {
    [days addObject:[NSString stringWithFormat:@"%0.2d", i]];
  }
  
  return [days copy];
}

- (NSArray *)month {
  NSMutableArray *days = [[NSMutableArray alloc] init];
  
  for (int i= 1; i <= 12 ; i++) {
    [days addObject:[NSString stringWithFormat:@"%0.2d", i]];
  }
  
  return [days copy];
}

- (NSArray *)year {
  NSMutableArray *days = [[NSMutableArray alloc] init];
  
  for (int i= 0; i < 30 ; i++) {
    [days addObject:[NSString stringWithFormat:@"%0.2d", i + 1980]];
  }
  
  return [days copy];
}

#pragma mark - PickerFieldDelegate

- (NSUInteger)rhPickerFieldNumberOfColumn:(RHPickerField *)pickerField {
  if (pickerField ==  self.datePickerField) {
    return 3;
  }
  
  return 0;
}

- (NSUInteger)rhPickerField:(RHPickerField *)pickerField
        numberOfRowInColumn:(NSUInteger)columnNumber {
  switch (columnNumber) {
    case 0:
      return [[self month] count];
      break;
      
    case 1:
      return [[self day] count];
      break;
      
    case 2:
      return [[self year] count];
      break;
      
    default:
      break;
  }
  
  return 0;
}

- (NSString *)rhPickerField:(RHPickerField *)pickerField
              textForColumn:(NSUInteger)columnNumber
                   rowIndex:(NSUInteger)rowIndex {
  switch (columnNumber) {
    case 0:
      return [[self month] objectAtIndex:rowIndex];
      break;
      
    case 1:
      return [[self day] objectAtIndex:rowIndex];
      break;
      
    case 2:
      return [[self year] objectAtIndex:rowIndex];
      break;
      
    default:
      break;
  }
  
  return @"";
}

@end
