//
//  TeacherSMSViewController.h
//  BetweenUs
//
//  Created by podar on 29/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
#import "Reachability.h"

@interface TeacherSMSViewController : UIViewController<CCKFNavDrawerDelegate>{
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *teacherSmsdropdown,*teacherSectionListarray,*teacherDivisionListArray,*tecaherMonthListArray,*teacherShiftListArray,*teacherStandardListArray,*teacherAcademicYearArray,*class_id;
    NSString *clt_id,*usl_id,*cls_ID,*device,*DeviceToken,*DeviceType,*TeacherSMSDropdownStatus,*sectionName,*SfiName,*divName,*stdName,*teachershiftstdDiv,*classTeacher;
}

@property BOOL internetActive;
@property BOOL hostActive;
@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (weak, nonatomic) IBOutlet UITableView *teacherSMSdropdownTableView;


@end
