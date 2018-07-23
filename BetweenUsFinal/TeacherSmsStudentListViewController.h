//
//  TeacherSmsStudentListViewController.h
//  BetweenUs
//
//  Created by podar on 15/11/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TeacherSmsStudentListViewController : UIViewController{
    NSString *clt_id,*usl_id,*cls_ID,*check,*pageSize,*TeacherStudentListStatus,*senderName,*date,*subject,*message,*filename,*filePath,*fulldate,*formatedDate,*device,*DeviceToken,*DeviceType,*toUslId,*pmuId,*pmg_id,*sentmessageClick,*attachementClick,*acy_year,*selectedAcademicYear,*selectedAcademicYearId,*searchKey,*searchValue,*std_name,*div_name,*currentacademicYear,*cls_id,*student_name,*pageIndex,*stu_id,*btntapp,*section,*std,*shift,*AdminWriteMessage;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *teacherStudentArray;
    NSMutableArray *clsIdArray,*stuIdArray,*pathArray,*mystringArray,*buttonTagsTapped,*newMyStringArray,*arrayForTag;
}

@property BOOL internetActive;
@property BOOL hostActive;

@property (weak, nonatomic) IBOutlet UIImageView *closeClick;
@property (weak, nonatomic) IBOutlet UIView *closeView;
@property (weak, nonatomic) IBOutlet UITableView *studentListTableView;
@property (weak, nonatomic) IBOutlet UIButton *checkAllClick;
@property (weak, nonatomic) IBOutlet UITextField *studentNameTextfield;

- (IBAction)searchStudent:(id)sender;
- (IBAction)sentSMSToselectedStudent:(id)sender;
- (IBAction)checkAll:(id)sender;

@end
