//
//  AdminWriteMessageViewController.h
//  BetweenUs
//
//  Created by podar on 22/09/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AdminWriteMessageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    NSString *clt_id,*usl_id,*check,*pageNo,*pageSize,*AcademiYearStatus,*StudentListStatus,*senderName,*date,*subject,*message,*filename,*filePath,*fulldate,*formatedDate,*device,*DeviceToken,*DeviceType,*toUslId,*pmuId,*pmg_id,*sentmessageClick,*attachementClick,*acy_year,*selectedAcademicYear,*selectedAcademicYearId,*searchKey,*searchValue,*std_name,*div_name,*currentacademicYear,*cls_id,*selectedShiftname,*selected_sectionName,*selected_std,*AdminWriteMessage,*clickedAll;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSMutableArray *clsIdArray;
    NSArray *AcademicYearTableData,*StudentTableData,*dateitems;
    NSDictionary *academicYearDetails,*studentDetails;
}

@property BOOL internetActiveViewMessage;
@property BOOL hostActiveViewMessage;
@property BOOL internetActive;
@property BOOL hostActive;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableToTeacherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewToTeacherSearchView; //
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromTeacherViewToStudentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewtolabelView; //

@property (weak, nonatomic) IBOutlet UIView *enteracademicYearView;
@property (weak, nonatomic) IBOutlet UIView *academicYearView;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIView *searchView; //
@property (strong, nonatomic) IBOutlet UIView *tableviewCpnstarintToLabelView;
@property (weak, nonatomic) IBOutlet UIView *teacherSearchView;//
@property (weak, nonatomic) IBOutlet UIView *teacherView; //
@property (weak, nonatomic) IBOutlet UIView *studentView; //
@property (weak, nonatomic) IBOutlet UIView *closeBtnView;//
@property (weak, nonatomic) IBOutlet UIView *teachernameView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintToButtonSFromLabelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewTopConstraintToLabelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableConstarintToLabelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintToAademicYearViewFromLableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherSearchViewContstraint;

- (IBAction)academicYear_btn:(id)sender;
- (IBAction)Student_btn:(id)sender;
- (IBAction)Teacher_btn:(id)sender;
- (IBAction)sentMessageTeacherBtn:(id)sender;
- (IBAction)searchTeacherBtn:(id)sender;
- (IBAction)All_btn:(id)sender;
- (IBAction)shiftBtn:(id)sender;
- (IBAction)searchButton:(id)sender;
- (IBAction)std_Btn:(id)sender;
- (IBAction)section_Btn:(id)sender;
- (IBAction)searchBtnAccordingToValue:(id)sender;
- (IBAction)closeBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *enterTeacherNameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *academic_year_textfield;
@property (weak, nonatomic) IBOutlet UITextField *enetrSearchKey_textfield;//

@property (weak, nonatomic) IBOutlet UIImageView *dropdown_img;

@property (weak, nonatomic) IBOutlet UITableView *studentTableView;

@property (weak, nonatomic) IBOutlet UIButton *viewMessage_click;
@property (weak, nonatomic) IBOutlet UIButton *academic_yearClick;
@property (weak, nonatomic) IBOutlet UIButton *sentMessage_click;
@property (weak, nonatomic) IBOutlet UIButton *studentClick;
@property (weak, nonatomic) IBOutlet UIButton *teacherClick;
@property (weak, nonatomic) IBOutlet UIButton *std_click;
@property (weak, nonatomic) IBOutlet UIButton *search_click;
@property (weak, nonatomic) IBOutlet UIButton *search_btn;
@property (weak, nonatomic) IBOutlet UIButton *all_click;
@property (weak, nonatomic) IBOutlet UIButton *shiftClick;
@property (weak, nonatomic) IBOutlet UIButton *sectionClick;
@property (weak, nonatomic) IBOutlet UIButton *closeClick;

@end
