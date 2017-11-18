//
//  TeacherBehaviourStudentListViewController.h
//  BetweenUs
//
//  Created by podar on 18/11/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TeacherBehaviourStudentListViewController : UIViewController
{
    NSString *device,*clt_id,*usl_id,*check,*pmg_Id,*rol_id,*org_id,*Brd_Id,*sec_Id,*DeviceToken,*DeviceType,*school_name,*brd_name,*BehaviourStatus,*studentName,*teachershiftstdDiv,* class_id,*rollNo,*pageSize,*pageNo,*selectedMsd_ID;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *teacherBehaviourStudentListArray,*teacherSectionListarray,*teacherDivisionListArray,*tecaherMonthListArray,*teacherShiftListArray,*teacherStandardListArray,*teacherAcademicYearArray;
}

@property BOOL internetActive;
@property BOOL hostActive;

- (IBAction)viewBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *rollNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewClick;
@property (weak, nonatomic) IBOutlet UIView *rollNoView;
@property (weak, nonatomic) IBOutlet UITableView *teacherBehaviourStudentTableView;

@end
