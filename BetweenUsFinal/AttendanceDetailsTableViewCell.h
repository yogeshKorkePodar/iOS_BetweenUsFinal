//
//  AttendanceDetailsTableViewCell.h
//  BetweenUs
//
//  Created by podar on 02/11/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *absentBtnValue;
@property (weak, nonatomic) IBOutlet UILabel *rollNo_label;
- (IBAction)absentClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UILabel *attendance_countLabel;
@property (weak, nonatomic) IBOutlet UIView *rollNoView;
@property (weak, nonatomic) IBOutlet UIView *totalCountView;
@property (weak, nonatomic) IBOutlet UILabel *absent_attendanceLabel;
@property (weak, nonatomic) IBOutlet UIView *absentView;
@property (weak, nonatomic) IBOutlet UIButton *presentBtnValue;
- (IBAction)presentClick:(id)sender;

@end
