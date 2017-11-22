//
//  ChangePassswordViewController.h
//  BetweenUsFinal
//
//  Created by podar on 18/08/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"

@interface ChangePassswordViewController : UIViewController<CCKFNavDrawerDelegate>
{
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *school_name;
    NSString *brdName;
    NSString *oldPassword;
    NSString *classTeacher;
    NSString *newPassword;
    NSString *confirmPassword;
    NSString *LoginArrayCount;
    NSString *ChangePasswordStatus;
    NSString *ChangePasswordStatusMessage;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSString *DeviceToken;
    NSString *DeviceType;
    NSString *isStudentResourcePresent;
}
@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (weak, nonatomic) NSString *Status;
@property(nonatomic,strong) NSString *rol_id;
@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *school_name;
@property(nonatomic,strong) NSString *brd_Name;
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

@property BOOL internetActive;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UITextField *old_password_texfield;
@property (weak, nonatomic) IBOutlet UITextField *latestPassword;

@property (weak, nonatomic) IBOutlet UITextField *confirm_password_textfield;
- (IBAction)submit_Btn:(id)sender;

@end

