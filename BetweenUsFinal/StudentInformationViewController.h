//
//  StudentInformationViewController.h
//  BetweenUsFinal
//
//  Created by podar on 18/08/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
@class Reachability;
@protocol StudentInformationViewControllerDelegate<NSObject>

@required
- (void)dataFromController:(NSString *)data;

@end

@interface StudentInformationViewController : UIViewController<CCKFNavDrawerDelegate, UITextFieldDelegate>

{
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *school_name;
    NSArray *stateTableData;
    NSArray *cityTableData;
    NSArray *countryTableData;
    NSDictionary* parentinfodetails;
    NSString *LoginArrayCount;
    NSString *isStudentResourcePresent;
    NSString *DeviceToken;
    NSString *DeviceType;
    Reachability* internetReachable;
    Reachability* hostReachable;

}

@property BOOL internetActive;
@property BOOL hostActive;

@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (weak, nonatomic) NSString *Status;
@property(nonatomic,strong) NSString *rol_id;
@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *school_name;
@property(nonatomic,strong) NSString *brdName;
@property(nonatomic,strong) NSString *org_id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *stdName;
@property(nonatomic,strong) NSString *sec_Id;
@property(nonatomic,strong) NSString *Brd_Id;
@property(nonatomic,strong) NSString *drawerstd;
@property(nonatomic,strong) NSString *drawername;
@property(nonatomic,strong) NSString *drawerRollNo;
@property(nonatomic,strong) NSString *draweracademicYear;
@property(strong, nonatomic) NSString *teacherAnnouncementCount;


@property(nonatomic,strong) NSString *Statename;
@property(nonatomic,strong) NSString *Cityname;
@property(nonatomic,strong) NSString *Countryname;
@property(nonatomic,strong) NSString *StateId;
@property(nonatomic,strong) NSString *CityId;
@property(nonatomic,strong) NSString *CountryId;
@property(nonatomic,strong) NSString *SelectedCountryId;
@property(nonatomic,strong) NSString *SelectedCityId;
@property(nonatomic,strong) NSString *SelectedStateId;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintSave;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintCancel;

@property (weak, nonatomic) IBOutlet UITextField *textfield_registeredEmailId;
@property (weak, nonatomic) IBOutlet UITextField *textfield_mobileNo;
@property (weak, nonatomic) IBOutlet UITextField *textfield_buildingAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonConstarint;
@property (weak, nonatomic) IBOutlet UITextField *textfield_streetName;
@property (weak, nonatomic) IBOutlet UITextField *textfield_locationArea;
@property (weak, nonatomic) IBOutlet UITextField *textfield_pinCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonConstraint;
@property (weak, nonatomic) IBOutlet UIButton *click_state;
@property (weak, nonatomic) IBOutlet UITableView *state_tableData;
@property (weak, nonatomic) IBOutlet UITableView *city_tableData;
@property (weak, nonatomic) IBOutlet UITableView *country_tableData;
- (IBAction)state_btn:(id)sender;
//- (IBAction)btn_state:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *click_city;
- (IBAction)btn_city:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *click_country;
- (IBAction)btn_country:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textfield_telephoneNo;
@property (weak, nonatomic) IBOutlet UIButton *click_edit;
- (IBAction)btn_edit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *click_save;
- (IBAction)btn_save:(id)sender;
- (IBAction)btn_cancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *click_cancel;
@property (nonatomic, weak) id<StudentInformationViewControllerDelegate> delegate;

@end

