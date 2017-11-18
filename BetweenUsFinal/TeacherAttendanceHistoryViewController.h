//
//  TeacherAttendanceHistoryViewController.h
//  BetweenUs
//
//  Created by podar on 16/11/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TeacherAttendanceHistoryViewController : UIViewController
{
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSString *device,*clt_id,*brd_name,*usl_id,*Brd_Id,*AttendanceHistoryStatus,*month_id,*monthname,*DeviceType,*DeviceToken,*selectedMsdID,*absentReason,*absentDate,*date,*formatedDate,*atn_valid,*acy_id;
    NSArray *dateitems,*attendanceHistoryArray;
    
}

@property(nonatomic,strong) NSString *month;
@property BOOL internetActive;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UITableView *teacherAttendanceHistoryTableView;

@end
