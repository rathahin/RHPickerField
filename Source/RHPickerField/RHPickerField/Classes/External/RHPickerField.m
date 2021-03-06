//
//  RHPickerField.m
//  RHPickerField
//
//  Created by Ratha Hin on 2/21/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "RHPickerField.h"
#import "RHAnimator.h"
#import "PickerCell.h"
#import "RHHighlightView.h"

NSString *const nibCell = @"PickerCellID";

@interface RHPickerField () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *tableViewCollection;
@property (strong, nonatomic) NSMutableArray *highlightViewCollection;
@property (strong, nonatomic) UIWindow *overlayWindow;
@property (strong, nonatomic) UIView *pickerView;
@property (strong, nonatomic) CAShapeLayer *backgroundLayer;
@property (strong, nonatomic) UILongPressGestureRecognizer *longGesture;
@property (strong, nonatomic) UIButton *yesButton;
@property (strong, nonatomic) UIButton *noButton;

@end

@implementation RHPickerField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
      [self createControlUI];
    }
    return self;
}

- (void)createControlUI {
  [self.layer insertSublayer:self.backgroundLayer atIndex:0];
  self.backgroundLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  [self addGestureRecognizer:self.longGesture];
}

#pragma mark - expose function

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [super setBackgroundColor:backgroundColor];
  self.backgroundLayer.backgroundColor = self.backgroundColor.CGColor;
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
  _highlightedBackgroundColor = highlightedBackgroundColor;
  
  self.backgroundLayer.fillColor = [_highlightedBackgroundColor CGColor];
}

#pragma mark - view

- (CAShapeLayer *)backgroundLayer {
  if (!_backgroundLayer) {
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.frame = self.bounds;
    _backgroundLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    _backgroundLayer.fillColor = [UIColor redColor].CGColor;
    _backgroundLayer.opacity = 0.0;
  }
  
  return _backgroundLayer;
}

- (UILongPressGestureRecognizer *)longGesture {
  if (!_longGesture) {
    _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureHandle:)];
    _longGesture.minimumPressDuration = 0.3;
  }
  
  return _longGesture;
}

- (UIWindow *)overlayWindow {
  if(!_overlayWindow) {
    _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _overlayWindow.backgroundColor = [UIColor clearColor];
    _overlayWindow.userInteractionEnabled = YES;
    _overlayWindow.windowLevel = UIWindowLevelNormal;
  }
  return _overlayWindow;
}

-(UIView *)pickerView {
  if (!_pickerView) {
    _pickerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _pickerView.backgroundColor = [UIColor colorWithHexString:@"#121d2b"];
    
    [_pickerView addSubview:self.noButton];
    [_pickerView addSubview:self.yesButton];
    
    self.noButton.center = CGPointMake(40, CGRectGetMaxY(_pickerView.bounds) - 20);
    self.yesButton.center = CGPointMake(CGRectGetMaxX(_pickerView.bounds) - 40, CGRectGetMaxY(_pickerView.bounds) - 20);
  }
  
  return _pickerView;
}

#pragma mark - get datasource

- (void)setDataSource:(id<RHPickerFieldDataSource>)dataSource {
  _dataSource = dataSource;
  
  [self setupColumn];
}

- (NSUInteger)numberOfColumn {
  return [self.dataSource rhPickerFieldNumberOfColumn:self];
}

#pragma mark - picker view

- (void)showPickerView {
  [self.overlayWindow addSubview:self.pickerView];
  [self.overlayWindow setHidden:NO];
}

- (void)setupColumn {
  
  if (!self.tableViewCollection) {
    self.tableViewCollection = [[NSMutableArray alloc] initWithCapacity:[self numberOfColumn]];
  } else {
    [self.tableViewCollection removeAllObjects];
  }
  
  if (!self.highlightViewCollection) {
    self.highlightViewCollection = [[NSMutableArray alloc] initWithCapacity:[self numberOfColumn]];
  } else {
    [self.highlightViewCollection removeAllObjects];
  }
  
  CGRect columnFrame = CGRectMake(0, 44, CGRectGetWidth(self.pickerView.bounds) / [self numberOfColumn], CGRectGetHeight(self.pickerView.bounds) - 88);
  CGFloat cx = 0;
  for (NSInteger i = 0; i < [self numberOfColumn]; i++) {
    columnFrame.origin = CGPointMake(cx, 44);
    UITableView *column = [[UITableView alloc] initWithFrame:columnFrame];
    column.backgroundColor = [UIColor clearColor];
    column.scrollEnabled = NO;
    column.delegate = self;
    column.dataSource = self;
    column.separatorStyle = UITableViewCellSeparatorStyleNone;
    [column registerClass:[PickerCell class] forCellReuseIdentifier:nibCell];
    [self.pickerView addSubview:column];
    [self.tableViewCollection addObject:column];
    
    // pangesture
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    panGesture.delegate = self;
    [column addGestureRecognizer:panGesture];
    
    // highlight
    RHHighlightView *highlightView = [[RHHighlightView alloc] initWithFrame:CGRectMake(cx, 0, CGRectGetWidth(columnFrame), CGRectGetHeight(self.bounds))];
    highlightView.backgroundColor = self.highlightedBackgroundColor;
    [self.pickerView addSubview:highlightView];
    [self.highlightViewCollection addObject:highlightView];
    cx += CGRectGetWidth(columnFrame);
  }
  
}

- (void)closePickerView {
  [self.pickerView removeFromSuperview];
  self.overlayWindow = nil;
  
  [RHAnimator animateLayer:self.backgroundLayer
              toFloatValue:0.0
                forKeyPath:@"opacity"
                  duration:0.3
              animationKey:@"opacityOut"];
}

- (UIButton *)yesButton {
  
  if (!_yesButton) {
    _yesButton = [[UIButton alloc] initWithFrame:self.buttonFrame];
    [_yesButton setTitle:@"YES" forState:UIControlStateNormal];
    [_yesButton addTarget:self action:@selector(yesAction) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return _yesButton;
  
}

- (UIButton *)noButton {
  
  if (!_noButton) {
    _noButton = [[UIButton alloc] initWithFrame:self.buttonFrame];
    [_noButton setTitle:@"NO" forState:UIControlStateNormal];
    [_noButton addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return _noButton;
  
}

- (CGRect)buttonFrame {
  return CGRectMake(0, 0, 60, 44);
}

#pragma mark - column && tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSUInteger columnNumber = [self.tableViewCollection indexOfObject:tableView];
  
  return [self.dataSource rhPickerField:self numberOfRowInColumn:columnNumber];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [PickerCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger columnNumber = [self.tableViewCollection indexOfObject:tableView];
  
  PickerCell *cell = [tableView dequeueReusableCellWithIdentifier:nibCell];
  cell.textLabel.text = [self.dataSource rhPickerField:self
                                         textForColumn:columnNumber
                                              rowIndex:[indexPath row]];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger columnNumber = [self.tableViewCollection indexOfObject:tableView];
  CGPoint cellPoint = [tableView cellForRowAtIndexPath:indexPath].center;
  CGPoint targetPoint = [tableView convertPoint:cellPoint toView:self.pickerView];
  RHHighlightView *highlightView = (RHHighlightView *)self.highlightViewCollection[columnNumber];
  highlightView.center = targetPoint;
  [highlightView updateLabelWithText:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
  [highlightView endUpdate];
}

#pragma mark - action

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
  
  NSLog(@"state => %d", gesture.state);
  
  if (gesture.state == UIGestureRecognizerStateBegan ||
      gesture.state == UIGestureRecognizerStateChanged) {
    [self moveHighlightWithPoint:[gesture locationInView:self.pickerView] restrictedInView:gesture.view];
  } else if (gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateCancelled) {
    [self endMoveHighlightWithPoint:[gesture locationInView:self.pickerView] inView:gesture.view];
  }
}

- (void)noAction {
  [self closePickerView];
}

- (void)yesAction {
  
}

- (void)longGestureHandle:(UILongPressGestureRecognizer *)gesture {
  if (gesture.state == UIGestureRecognizerStateBegan) {
    [self showPickerView];
    
    CGPoint location = [gesture locationInView:self.pickerView];
    [self moveHighlightWithPoint:location restrictedInView:nil];
    
  } else if (gesture.state == UIGestureRecognizerStateChanged) {
    
    CGPoint location = [gesture locationInView:self.pickerView];
    [self moveHighlightWithPoint:location restrictedInView:nil];
    
  } else if (gesture.state == UIGestureRecognizerStateCancelled ||
           gesture.state == UIGestureRecognizerStateFailed ||
           gesture.state == UIGestureRecognizerStateEnded) {
    [self endMoveHighlightWithPoint:[gesture locationInView:self.pickerView] inView:nil];
  }
}

- (void)moveHighlightWithPoint:(CGPoint)location restrictedInView:(UIView *)view{
  UITableView *tableView = nil;
  
  for (UITableView *eachTableView in self.tableViewCollection) {
    
    if (CGRectContainsPoint(eachTableView.frame, location)) {
      tableView = eachTableView;
      
      BOOL shouldMoveHighlight = NO;
      
      if (!view || view == tableView) {
        shouldMoveHighlight = YES;
      }
      
      if (shouldMoveHighlight) {
        NSUInteger columnNumber = [self.tableViewCollection indexOfObject:tableView];
        CGPoint moveTo = CGPointMake(CGRectGetMidX(tableView.frame), location.y);
        RHHighlightView *highlightView = (RHHighlightView *)self.highlightViewCollection[columnNumber];
        highlightView.center = moveTo;
        
        UITableViewCell *hitCell = [tableView cellForRowAtIndexPath:[tableView indexPathForRowAtPoint:[self.pickerView convertPoint:location toView:tableView]]];
        
        [highlightView updateLabelWithText:hitCell.textLabel.text];
        [self scrollTableViewIfNeededWithCell:hitCell tableView:tableView];
      }
      
      break;
    }
    
  }
}

- (void)scrollTableViewIfNeededWithCell:(UITableViewCell *)cell tableView:(UITableView *)tableView {
  
  NSArray *visibleCell = tableView.visibleCells;
  NSIndexPath *cellIndexPath = [tableView indexPathForCell:cell];
  NSIndexPath *indexPath;
  UITableViewScrollPosition scrollPosition = UITableViewScrollPositionBottom;
  
  if (cell == [visibleCell firstObject] && [cellIndexPath row] > 0) {
    indexPath = [NSIndexPath indexPathForRow:[cellIndexPath row] - 1
                                                inSection:[cellIndexPath section]];
    scrollPosition = UITableViewScrollPositionTop;
  } else if (cell == [visibleCell lastObject] && [cellIndexPath row] < [tableView numberOfRowsInSection:[cellIndexPath section]] - 1) {
    indexPath = [NSIndexPath indexPathForRow:[cellIndexPath row] + 1
                                   inSection:[cellIndexPath section]];
    scrollPosition = UITableViewScrollPositionBottom;
  }
  
  if (indexPath) {
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];
  }
}

- (void)endMoveHighlightWithPoint:(CGPoint)location inView:(UIView *)view{
  UITableView *tableView = (UITableView *)view;
  
  if (!tableView) {
    for (UITableView *eachTableView in self.tableViewCollection) {
      
      if (CGRectContainsPoint(eachTableView.frame, location)) {
        tableView = eachTableView;
        break;
      }
    }
  }
  
  NSUInteger columnNumber = [self.tableViewCollection indexOfObject:tableView];
  RHHighlightView *highlightView = (RHHighlightView *)self.highlightViewCollection[columnNumber];
  [highlightView endUpdate];
  
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  [RHAnimator animateLayer:self.backgroundLayer
              toFloatValue:1.0
                forKeyPath:@"opacity"
                  duration:0.25
              animationKey:@"opacityIn"];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [RHAnimator animateLayer:self.backgroundLayer
              toFloatValue:0.0
                forKeyPath:@"opacity"
                  duration:0.3
              animationKey:@"opacityOut"];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return NO;
}

@end
