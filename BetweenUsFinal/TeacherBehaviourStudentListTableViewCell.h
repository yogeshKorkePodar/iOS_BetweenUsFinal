//
//  TeacherBehaviourStudentListTableViewCell.h
//  BetweenUs
//
//  Created by podar on 07/11/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherBehaviourStudentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rollNo;
@property (weak, nonatomic) IBOutlet UILabel *studentname;
@property (weak, nonatomic) IBOutlet UIButton *viewClick;
@property (weak, nonatomic) IBOutlet UIView *rollNoView;

@end
