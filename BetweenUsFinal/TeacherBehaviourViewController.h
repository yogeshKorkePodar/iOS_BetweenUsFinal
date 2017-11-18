//
//  TeacherBehaviourViewController.h
//  BetweenUs
//
//  Created by podar on 29/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
@interface TeacherBehaviourViewController : UIViewController<CCKFNavDrawerDelegate, UITabBarDelegate>{
    NSString *device,*clt_id,*usl_id,*check,*pmg_Id,*rol_id,*org_id,*Brd_Id,*sec_Id,*DeviceToken,*DeviceType,*school_name,*brd_name,*BehaviourStatus,*sectionName,*SfiName,*divName,*stdName,*teachershiftstdDiv,* class_id;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *teacherBehaviourDropdownArray,*teacherSectionListarray,*teacherDivisionListArray,*tecaherMonthListArray,*teacherShiftListArray,*teacherStandardListArray,*teacherAcademicYearArray;
}
@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (weak, nonatomic) IBOutlet UITabBar *my_tabBar;

@property BOOL internetActive;
@property BOOL hostActive;

- (IBAction)attendanceBtn:(id)sender;
- (IBAction)announcemntBtn:(id)sender;
- (IBAction)behaviourBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *teacherBehaviourTableView;

@end
