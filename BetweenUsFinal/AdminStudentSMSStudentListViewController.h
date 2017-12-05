//
//  AdminStudentSMSStudentListViewController.h
//  BetweenUs
//
//  Created by podar on 13/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface AdminStudentSMSStudentListViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *AdminStudentSMSListData,*StudentSMSTableData,*dateitems;
    NSDictionary *academicYearDetails,*studentDetails;
    NSMutableArray *clsIdArray,*stuIdArray,*pathArray,*mystringArray,*buttonTagsTapped,*newMyStringArray,*arrayForTag;
    NSString *clt_id,*usl_id,*cls_ID,*check,*pageSize,*AdminStudentSMSListStatus,*senderName,*date,*subject,*message,*filename,*filePath,*fulldate,*formatedDate,*device,*DeviceToken,*DeviceType,*toUslId,*pmuId,*pmg_id,*sentmessageClick,*attachementClick,*acy_year,*selectedAcademicYear,*selectedAcademicYearId,*searchKey,*searchValue,*std_name,*div_name,*currentacademicYear,*cls_id,*student_name,*pageIndex,*stu_id,*btntapp,*section,*std,*shift,*classID,*selectAllClicked;
}
@property (weak, nonatomic) IBOutlet UITextField *enterStudentName;
- (IBAction)searchStudentBtn:(id)sender;
- (IBAction)sendMessageBtn:(id)sender;
- (IBAction)checkAllBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkAllClick;
@property (weak, nonatomic) IBOutlet UITableView *StudentSMSStudentList;
@property BOOL internetActive;
@property (weak, nonatomic) IBOutlet UIImageView *closeImage;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UIView *closeView;

@end
