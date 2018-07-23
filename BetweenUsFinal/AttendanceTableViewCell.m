//
//  AttendanceTableViewCell.m
//  TestAutoLayout
//
//  Created by podar on 05/07/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "AttendanceTableViewCell.h"

@implementation AttendanceTableViewCell

NSMutableArray *values;


static inline UIColor *GetRandomUIColor()
{
    CGFloat r = arc4random() % 255;
    CGFloat g = arc4random() % 255;
    CGFloat b = arc4random() % 255;
    UIColor * color = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1.0f];
    return color;
}

static const CGFloat dia = 250.0f;

static const CGRect kPieChartViewFrame = {{35.0f, 35.0f},{dia, dia}};
static const CGRect kHoleSliderFrame = {{35.0f, 300.0f},{dia, 20.0}};
static const CGRect kSlicesSliderFrame = {{35.0f, 330.0f},{dia, 20.0}};

static const CGRect kHoleLabelFrame = {{0.0f, 300.0f},{35.0, 20.0}};
static const CGRect kValueLabelFrame = {{0.0f, 330.0f},{35.0, 20.0}};

static const NSInteger tHoleLabelTag = 7;
static const NSInteger tValueLabelTag = 77;


-(void)loadView
{
    CGFloat h =  [UIApplication sharedApplication].statusBarHidden ? 0 :
    [UIApplication sharedApplication].statusBarFrame.size.height;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                            [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - h)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    pieChartView = [[PieChartView alloc] initWithFrame:kPieChartViewFrame];
    pieChartView.delegate = self;
    pieChartView.datasource = self;
    [view addSubview:pieChartView];
    holeLabel = [self labelWithFrame:kHoleLabelFrame];
    [view addSubview:holeLabel];
    
    valueLabel = [self labelWithFrame:kValueLabelFrame];
    [view addSubview:valueLabel];
    
    holeSlider = [[UISlider alloc] initWithFrame:kHoleSliderFrame];
    holeSlider.tag = tHoleLabelTag;
    holeSlider.maximumValue = 180/2 - 1;
    int max = holeSlider.maximumValue;
    holeSlider.value = arc4random() % max;
    [view addSubview:holeSlider];
    [holeSlider setHidden:YES];
    slicesSlider = [[UISlider alloc] initWithFrame:kSlicesSliderFrame];
    slicesSlider.tag = tValueLabelTag;
    [slicesSlider addTarget:self action:@selector(didChangeValueForSlider:)
           forControlEvents:UIControlEventValueChanged];
    slicesSlider.value = 3;
    [view addSubview:slicesSlider];
    [slicesSlider setHidden:YES];
    self.maskView = view;}

- (UILabel*)labelWithFrame:(CGRect)frame
{
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:frame];
    resultLabel.backgroundColor = [UIColor clearColor];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.textColor = [UIColor blackColor];
    resultLabel.font = [UIFont systemFontOfSize:15.0f];
    resultLabel.shadowOffset = (CGSize){2,1};
    resultLabel.shadowColor = [UIColor lightGrayColor];
    return resultLabel;
}



-(void)didChangeValueForSlider:(UISlider*)slider
{
    if (slider.tag == tValueLabelTag) valueLabel.text = [NSString stringWithFormat:@"%.0f",slider.value];
    if (slider.tag == tHoleLabelTag) holeLabel.text = [NSString stringWithFormat:@"%.0f",slider.value];
    [pieChartView reloadData];
}

#pragma mark -    PieChartViewDelegate
-(CGFloat)centerCircleRadius
{
    return 160/2 - 1;
}
#pragma mark - PieChartViewDataSource
-(int)numberOfSlicesInPieChartView:(PieChartView *)pieChartView
{
    return 3;
}
-(UIColor *)pieChartView:(PieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index
{
    return GetRandomUIColor();
}
-(double)pieChartView:(PieChartView *)pieChartView valueForSliceAtIndex:(NSUInteger)index
{
    values = [[NSMutableArray alloc] init];
    
    [values addObject:[NSNumber numberWithInt:10]];
    [values addObject:[NSNumber numberWithInt:20]];
    [values addObject:[NSNumber numberWithInt:30]];
    [values addObject:[NSNumber numberWithInt:40]];
    [values addObject:[NSNumber numberWithInt:50]];
    
    
    return [[values objectAtIndex:index] floatValue];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self loadView];
    [pieChartView reloadData];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)absentHistory:(id)sender {
    
   // NSLog(@"HistoryButton:%@",@"Button Clicked");
    
}
- (IBAction)dropDownBtn:(id)sender {
}
@end
