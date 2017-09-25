//
//  WriteMessageViewController.h
//  BetweenUsFinal
//
//  Created by podar on 22/08/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"

@interface WriteMessageViewController : UIViewController <CCKFNavDrawerDelegate,UITabBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UITextViewDelegate> {
NSString *isStudentResourcePresent;
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *brd_Name;
    NSArray *recipientdetails;
    NSDictionary *recipientdetailsdictionry;
    NSString *recipientStatus;
    NSString *messageSentStatus;
    NSString *toUslId;
    NSString *recipientName;
    NSString *subject;
    NSString *LoginArrayCount;
    NSString *Message;
    NSString *statusMessage;
    NSString *schoolName;
    NSString *DeviceToken;
    NSString *DeviceType;
    Reachability* internetReachable;
    Reachability* hostReachable;
}

@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property BOOL internetActive,hostActive;
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
@property(nonatomic,strong) NSString *brd_Name;
@property(nonatomic,strong) NSString *drawerstd;
@property(nonatomic,strong) NSString *drawername;
@property(nonatomic,strong) NSString *drawerRollNo;
@property(nonatomic,strong) NSString *draweracademicYear;
@property(strong, nonatomic) NSString *teacherAnnouncementCount;
@property (weak, nonatomic) IBOutlet UITabBar *my_tabBar;

@property (weak, nonatomic) IBOutlet UITextView *enterMsg;
@property (weak, nonatomic) IBOutlet UIButton *click_recipient;

- (IBAction)btn_recipient:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *messageSubject;

- (IBAction)btn_PostIt:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *recipientTableData;

@end
