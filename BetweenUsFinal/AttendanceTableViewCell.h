//
//  AttendanceTableViewCell.h
//  TestAutoLayout
//
//  Created by podar on 05/07/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartView.h"

@interface AttendanceTableViewCell : UITableViewCell{
    PieChartView *pieChartView;
    UISlider *holeSlider;
    UISlider *slicesSlider;
    UILabel *holeLabel;
    UILabel *valueLabel;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *present_textfieldLeftConstraint;
- (IBAction)dropDownBtn:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraintHistoryButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstarintPresent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraintAbsent;
@property (weak, nonatomic) IBOutlet UIView *leftConstraintNotMarked;

@property (weak, nonatomic) IBOutlet UIButton *dropdownClick;

@property (weak, nonatomic) IBOutlet UILabel *absentlabel;
@property (weak, nonatomic) IBOutlet UILabel *notMarkedLabel;
@property (weak, nonatomic) IBOutlet UIButton *absentHistory;
@property (weak, nonatomic) IBOutlet UILabel *presentLabel;
@property (weak, nonatomic) IBOutlet UITextField *present_textfield;
@property (weak, nonatomic) IBOutlet UITextField *absent_textfield;
@property (weak, nonatomic) IBOutlet UITextField *notMarked_textfield;
@property (weak, nonatomic) IBOutlet UIButton *click_absentHistory;
@property (weak, nonatomic) IBOutlet UILabel *monthName;

@end
