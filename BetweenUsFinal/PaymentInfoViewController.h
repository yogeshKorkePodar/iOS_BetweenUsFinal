//
//  PaymentInfoViewController.h
//  BetweenUsFinal
//
//  Created by podar on 18/08/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
@class Reachability;

@interface PaymentInfoViewController : UIViewController<CCKFNavDrawerDelegate, UITableViewDelegate,UITableViewDataSource>
{
    
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *description;
    NSString *paymentMode;
    NSString *ReceiprDate;
    NSString *amount;
    NSString *receiptNumebr;
    NSString *LoginArrayCount;
    NSArray* paymentDetails;
    NSString * student_std_div;
    NSString *DeviceToken;
    NSString *DeviceType;
    NSString *isStudentResourcePresent;
    NSDictionary* paymentinfodetails;
    NSArray *cellArray;
    NSMutableArray *myObject;
    // A dictionary object
    NSDictionary *dictionary;
    UILabel *lbl1;
    NSString *des;
    NSString * paymode;
    NSString *recdate;
    NSString *amt;
    NSString *recNo;
    NSString *formatedDate;
    NSString *sch_id;
    NSString *cls_id;
    NSString *acy_id;
    NSString *stud_id;
    NSString *brd_id;
    NSString *PayFessBtnStatus;
    NSString *username;
    NSString *password;
    
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
@property(nonatomic,strong) NSString *schoolName;
@property(nonatomic,strong) NSString *div;
@property(nonatomic,strong) NSString *std;
@property(nonatomic,strong) NSString *description;
@property(nonatomic,strong) NSString *paymentMode;
@property(nonatomic,strong) NSString *ReceiprDate;
@property(nonatomic,strong) NSString *amount;
@property(nonatomic,strong) NSString *receiptNumebr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_space;

@property (weak, nonatomic) IBOutlet UIView *payFessOnlineView;
@property (weak, nonatomic) IBOutlet UIImageView *payfessImg;
@property (weak, nonatomic) IBOutlet UIView *PaymentHistory;
@property (weak, nonatomic) IBOutlet UIButton *clickPayFees;

- (IBAction)payFeesOnlineBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *PaymentInfoTableData;


@end
