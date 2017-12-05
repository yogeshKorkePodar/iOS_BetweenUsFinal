//
//  AdminStudentSMSViewController.h
//  BetweenUs
//
//  Created by podar on 13/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AdminStudentSMSViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSArray *StudentListData,*AcademicYearTableData;
    NSString *clt_id,*usl_id,*studentlListStatus,*searchKey,*searchValue,*DeviceType,*device,*DeviceToken,*selectedAcademicYearId,*AcademiYearStatus,*currentacademicYear,*acy_year,*std_name,*div_name,*selectedAcademicYear,*cls_id,*selectedShiftname,*selected_sectionName,*selected_std,*selectAllClicked;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSDictionary *AdminStudentSMSDetails, *academicYearDetails;
    NSMutableArray *clsIDArraySMS;

}
@property (weak, nonatomic) IBOutlet UIButton *schoolSMSClick;
@property (weak, nonatomic) IBOutlet UIButton *studentSMSClick;
@property (weak, nonatomic) IBOutlet UIButton *teacherSMS;
@property (weak, nonatomic) IBOutlet UIButton *academicYearClick;
- (IBAction)AcademicYearBtn:(id)sender;
- (IBAction)searchByBtn:(id)sender;
- (IBAction)selectAllBtn:(id)sender;
- (IBAction)shiftBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shiftClick;
@property (weak, nonatomic) IBOutlet UIButton *sectionClick;
- (IBAction)sectionBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *stdClick;
- (IBAction)StdBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchKey;
- (IBAction)closeBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeClick;
- (IBAction)searchResult:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIImageView *dropdowImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintToAcademicYearView;
@property (weak, nonatomic) IBOutlet UITableView *StudentSMSList;
@property BOOL internetActive;
@property BOOL hostActive;
- (IBAction)schoolSMSBtn:(id)sender;
- (IBAction)teacherSMSBtn:(id)sender;


@end
