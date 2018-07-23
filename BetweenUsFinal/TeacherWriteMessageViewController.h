//
//  TeacherWriteMessageViewController.h
//  BetweenUs
//
//  Created by podar on 24/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "CCKFNavDrawer.h"

@interface TeacherWriteMessageViewController : UIViewController <CCKFNavDrawerDelegate> {
    NSString *device,*clt_id,*usl_id,*check,*pmg_Id,*rol_id,*org_id,*Brd_Id,*sec_Id,*DeviceToken,*DeviceType,*school_name,*brd_name,*BehaviourStatus,*sectionName,*SfiName,*divName,*stdName,*teachershiftstdDiv,* class_id,*classTeacher;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *teacherWriteMessageDropdownArray,*teacherSectionListarray,*teacherDivisionListArray,*tecaherMonthListArray,*teacherShiftListArray,*teacherStandardListArray,*teacherAcademicYearArray;
}

@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property BOOL internetActive;
@property BOOL hostActive;

@property (weak, nonatomic) IBOutlet UITableView *TeacherWriteMEssageDropDown;

@end
