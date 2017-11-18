//
//  TeacherAttendanceDetailsViewController.h
//  BetweenUs
//
//  Created by podar on 16/11/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TeacherAttendanceDetailsViewController : UIViewController
{
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSString *device,*clt_id,*brd_name,*usl_id,*Brd_Id,*AttendanceStatus,*month_id,*monthname,*DeviceType,*DeviceToken,*pageNo,*pageSize,*class_id,*AttendanceStatusDeatils,*rollNo,*Name,*Total,*selectedMsdID,*acy_id,*totalP,*atnValid;
    NSArray *teacherAttendanceDropdownArray,*teacherSectionListarray,*teacherDivisionListArray,*tecaherMonthListArray,*teacherShiftListArray,*teacherStandardListArray,*teacherAcademicYearArray,*teacherAttendanceDetailsArray;
}
@property BOOL internetActive;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UIView *attendanceView;
@property (weak, nonatomic) IBOutlet UIView *rollNoView;
@property (weak, nonatomic) IBOutlet UITableView *attendaneDetailsTableView;
@property (weak, nonatomic) IBOutlet UIButton *academicYearClick;
- (IBAction)academicYearBtn:(id)sender;

@end
