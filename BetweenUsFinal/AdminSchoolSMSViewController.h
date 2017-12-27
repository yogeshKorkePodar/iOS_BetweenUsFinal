//
//  AdminSchoolSMSViewController.h
//  BetweenUs
//
//  Created by podar on 05/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AdminSchoolSMSViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSMutableArray *uslIdArray,*arrayForTag,*pathArray,*studIDArraySMS,*clsIDArraySMS;
    NSArray *AdminSchoolSMSData,*AcademicYearTableData,*CategoryTableData;
    NSDictionary *AdminSchoolSMSDetails, *academicYearDetails;
    NSString *clt_id,*usl_id,*DeviceToken,*device,*searchValue,*selectedAcademicYearId,*searchKey,*AcademiYearStatus,*currentacademicYear,*ListStatus,*acy_year,*std_name,*div_name,*selectedAcademicYear,*studIDSMS,*clsIDSMS,*category,*DeviceType;
}
-(void)checkButtonPressed:(id)sender;
-(void)addSelectedCheckBoxTag:(int)value;
-(void)deleteSelectedCheckBoxTag:(int)value;
-(BOOL)isSelectedCheckBox:(int)value;

@property (weak, nonatomic) IBOutlet UIView *SearchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintToAcademicYearFromLabel;
- (IBAction)closeBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SchoolSMS_click;

@property (weak, nonatomic) IBOutlet UIButton *StudentSMS_click;
- (IBAction)SearchValueBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *TeacherSMS_click;
@property (weak, nonatomic) IBOutlet UIButton *selectCategory_Click;

- (IBAction)SelectCategory_Btn:(id)sender;
- (IBAction)SearchKeyBtn:(id)sender;
- (IBAction)SendSMSBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *close_click;
- (IBAction)AcademicYearBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *AcademicYear_Click;
@property (weak, nonatomic) IBOutlet UITextField *enterSearchValueTextfield;
@property (weak, nonatomic) IBOutlet UITableView *AdminSchoolSMSTableView;
@property BOOL internetActive;
@property BOOL hostActive;
- (IBAction)stdBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *section_Click;
- (IBAction)sectionBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shift_click;
- (IBAction)shiftBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *Academicdropdown;
@property (weak, nonatomic) IBOutlet UIView *academicDropDownView;
@property (weak, nonatomic) IBOutlet UIButton *checkAllClick;

- (IBAction)CheckAllBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *std_click;
- (IBAction)showSearchViewBtn:(id)sender;

@end
