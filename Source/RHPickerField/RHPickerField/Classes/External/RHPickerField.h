//
//  RHPickerField.h
//  RHPickerField
//
//  Created by Ratha Hin on 2/21/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extras.h"

@protocol RHPickerFieldDelegate;
@protocol RHPickerFieldDataSource;

@interface RHPickerField : UIControl

@property (weak, nonatomic) id<RHPickerFieldDelegate> delegate;
@property (weak, nonatomic) id<RHPickerFieldDataSource> dataSource;
@property (strong, nonatomic) UIColor *highlightedBackgroundColor;

@end

@protocol RHPickerFieldDelegate <NSObject>

@end

@protocol RHPickerFieldDataSource <NSObject>

- (NSUInteger)rhPickerFieldNumberOfColumn:(RHPickerField *)pickerField;

- (NSUInteger)rhPickerField:(RHPickerField *)pickerField
        numberOfRowInColumn:(NSUInteger)columnNumber;

- (NSString *)rhPickerField:(RHPickerField *)pickerField
                     textForColumn:(NSUInteger)columnNumber
                          rowIndex:(NSUInteger)rowIndex;



@end
