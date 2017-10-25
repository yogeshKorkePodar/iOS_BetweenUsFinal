//
//  TeacherAttendanceTableViewCell.h
//  BetweenUs
//
//  Created by podar on 24/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherAttendanceTableViewCell : UITableViewCell
- (IBAction)nextButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *std_div_label;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *shiftlabel;
@property (weak, nonatomic) IBOutlet UIButton *teacherbtnBg;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtnBg;
@property (weak, nonatomic) IBOutlet UIView *wholeview;

@end
