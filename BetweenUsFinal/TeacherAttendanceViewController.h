//
//  TeacherAttendanceViewController.h
//  BetweenUs
//
//  Created by podar on 29/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
#import "Reachability.h"

@interface TeacherAttendanceViewController : UIViewController<CCKFNavDrawerDelegate, UITabBarDelegate>{
    NSString *device,*clt_id,*usl_id,*check,*pmg_Id,*rol_id,*org_id,*Brd_Id,*sec_Id,*DeviceToken,*DeviceType,*MessageStatus,*school_name,*brd_name,*AttendanceStatus,*sectionName,*SfiName,*divName,*stdName,*teachershiftstdDiv,* class_id;
    NSArray *teacherAttendanceDropdownArray,*teacherSectionListarray,*teacherDivisionListArray,*tecaherMonthListArray,*teacherShiftListArray,*teacherStandardListArray,*teacherAcademicYearArray;
    Reachability* internetReachable;
    Reachability* hostReachable;
}
@property BOOL internetActive;
@property BOOL hostActive;

@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (weak, nonatomic) IBOutlet UITabBar *my_tabBar;

@property (weak, nonatomic) IBOutlet UIView *attendanceView;
@property (weak, nonatomic) IBOutlet UILabel *stdLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionlabel;
@property (weak, nonatomic) IBOutlet UILabel *shiftLabel;
@property (weak, nonatomic) IBOutlet UITableView *teacherAttendanceDropDownTableView;

@end
