//
//  AdminStudentListTableViewCell.h
//  BetweenUs
//
//  Created by podar on 24/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminStudentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rollNoLabel;
@property (weak, nonatomic) IBOutlet UIView *rollNoView;
@property (weak, nonatomic) IBOutlet UILabel *studentNamelabel;
@property (weak, nonatomic) IBOutlet UIButton *cellCheckBoxClick;
@property (weak, nonatomic) IBOutlet UIView *rolNoBgView;

@end
