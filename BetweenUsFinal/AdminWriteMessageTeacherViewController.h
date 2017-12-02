//
//  AdminWriteMessageTeacherViewController.h
//  BetweenUs
//
//  Created by podar on 29/09/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AdminWriteMessageTeacherViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>{
    NSString *clt_id,*usl_id,*check,*pageNo,*pageSize,*TeacherListStatus,*senderName,*date,*subject,*message,*filename,*filePath,*fulldate,*formatedDate,*device,*DeviceToken,*DeviceType,*toUslId,*pmuId,*pmg_id,*sentmessageClick,*attachementClick,*acy_year,*selectedAcademicYear,*selectedAcademicYearId,*searchKey,*searchValue,*std_name,*div_name,*currentacademicYear,*cls_id,*studentName,*AdminWriteMessage;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSMutableArray *uslIdArray,*arrayForTag,*pathArray;
    NSArray *TeacherTableData,*dateitems;
    NSDictionary *TeacherDetails;
}

- (IBAction)closeBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *closeBtnView;

- (IBAction)TeacherBtn:(id)sender;
- (IBAction)StudentBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *teacherNameTextfiled;
- (IBAction)searchTeacherBtn:(id)sender;
- (IBAction)sendMessageTeacher:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *viewMessageClick;
@property (weak, nonatomic) IBOutlet UIButton *writeMessageClick;
@property (weak, nonatomic) IBOutlet UIButton *sentMessageClick;
@property (weak, nonatomic) IBOutlet UIButton *closeBtnClick;
@property (weak, nonatomic) IBOutlet UITableView *adminTeacherTableView;
@property BOOL internetActive;
@property BOOL hostActive;
- (IBAction)checkAllBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkAllClick;

@end
