//
//  TeacherWriteMessageStudentListViewController.h
//  BetweenUs
//
//  Created by podar on 24/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface TeacherWriteMessageStudentListViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSString *clt_id,*usl_id,*cls_ID,*check,*pageSize,*TeacherStudentListStatus,*senderName,*date,*subject,*message,*filename,*filePath,*fulldate,*formatedDate,*device,*DeviceToken,*DeviceType,*toUslId,*pmuId,*pmg_id,*sentmessageClick,*attachementClick,*acy_year,*selectedAcademicYear,*selectedAcademicYearId,*searchKey,*searchValue,*std_name,*div_name,*currentacademicYear,*cls_id,*student_name,*pageIndex,*stu_id,*btntapp,*section,*std,*shift,*AdminWriteMessage;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *teacherStudentArray;
    NSMutableArray *clsIdArray,*stuIdArray,*pathArray,*mystringArray,*buttonTagsTapped,*newMyStringArray,*arrayForTag;
}

@property BOOL internetActive;
@property BOOL hostActive;

- (IBAction)searchStudent:(id)sender;
- (IBAction)sentMessageToStudent:(id)sender;
- (IBAction)checkAll:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *studentNameTextfield;
@property (weak, nonatomic) IBOutlet UITableView *TeacherwriteMessageStudentTableView;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxAllClick;
@property (weak, nonatomic) IBOutlet UIView *closeView;
@property (weak, nonatomic) IBOutlet UIImageView *close_click;

@end
