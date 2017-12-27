//
//  AdminStudentListViewController.h
//  BetweenUs
//
//  Created by podar on 23/09/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AdminStudentListViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString *clt_id,*usl_id,*cls_ID,*check,*pageSize,*AdminStudentListStatus,*senderName,*date,*subject,*message,*filename,*filePath,*fulldate,*formatedDate,*device,*DeviceToken,*DeviceType,*toUslId,*pmuId,*pmg_id,*sentmessageClick,*attachementClick,*acy_year,*selectedAcademicYear,*selectedAcademicYearId,*searchKey,*searchValue,*std_name,*div_name,*currentacademicYear,*cls_id,*student_name,*pageIndex,*stu_id,*btntapp,*section,*std,*shift,*AdminWriteMessage,*clickedAll,*checkAll;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSMutableArray *clsIdArray,*stuIdArray,*pathArray,*mystringArray,*buttonTagsTapped,*newMyStringArray,*arrayForTag;
    NSArray *AdminStudentListData,*StudentTableData,*dateitems;
    NSDictionary *academicYearDetails,*studentDetails;
    

}
-(void)checkButtonPressed:(id)sender;
-(void)addSelectedCheckBoxTag:(int)value;
-(void)deleteSelectedCheckBoxTag:(int)value;
-(BOOL)isSelectedCheckBox:(int)value;
@property (weak, nonatomic) IBOutlet UITextField *studentNameTextfield;
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtnClick;
@property (weak, nonatomic) IBOutlet UIView *dropDownView;
- (IBAction)searchStudentBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchStudentClick;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageClick;
- (IBAction)sendMessageBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkAllClick;
- (IBAction)checkAllBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *studentListTableView;
@property BOOL internetActive;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UIButton *closebuttonClick;
@property (weak, nonatomic) IBOutlet UIView *closeView;


@end
