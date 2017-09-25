//
//  SentMessagesViewController.h
//  BetweenUsFinal
//
//  Created by podar on 22/08/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
@class Reachability;
@interface SentMessagesViewController : UIViewController<CCKFNavDrawerDelegate,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *brd_Name;
    NSString *monthId;
    NSString *monthYear;
    NSString *pageNo;
    NSString *pageSize;
    NSString *check;
    NSString *senderName;
    NSString *subject;
    NSString *SentMessageStatus;
    NSString *message;
    NSString *date;
    NSString *pmuId;
    NSString *toUslId;
    NSString *formatedDate;
    NSString *fulldate;
    NSString *DropDownStatus;
    NSString *LastSentMessageStatus;
    NSString *LoginArrayCount;
    NSArray *sentMessagedetails;
    NSArray *monthdetails;
    NSArray *dateitems;
    NSDictionary *sentMessagedetailsdictionry;
    NSDictionary *monthdictionary;
    NSString *day;
    NSString *schoolName;
    NSString *isStudentResourcePresent;
    NSString *DeviceType;
    NSString *DeviceToken;
    NSString *filePath;
    Reachability* internetReachable;
    Reachability* hostReachable;
}
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
@property(nonatomic,strong) NSString *brd_Name;
@property(nonatomic,strong) NSString *drawerstd;
@property(nonatomic,strong) NSString *drawername;
@property(nonatomic,strong) NSString *drawerRollNo;
@property(nonatomic,strong) NSString *draweracademicYear;
@property(strong, nonatomic) NSString *teacherAnnouncementCount;
@property (weak, nonatomic) IBOutlet UITabBar *my_tabBar;

@property (weak, nonatomic) IBOutlet UIView *behaviourView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIView *attendanceView;
@property (weak, nonatomic) IBOutlet UIView *announcementView;
@property BOOL internetActive;
@property (weak, nonatomic) IBOutlet UIView *dropdownClick;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UITableView *sentMessageData;
@property (weak, nonatomic) IBOutlet UIButton *sentClickWrite_Message;
- (IBAction)sentBtn_WriteMessage:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sentMessageTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIButton *sentCliclView_Message;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
- (IBAction)sentBtn_ViewMessage:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceConstaint;
@property (weak, nonatomic) IBOutlet UITableView *monthTableData;

- (IBAction)selectMonthBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *selectMonthView;
@property (weak, nonatomic) IBOutlet UIView *messagesView;
- (IBAction)sentBtn_Announcement:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sentClick_Attendance;
- (IBAction)sentBtn_attendance:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sentClick_Behaviour;
- (IBAction)sentBtn_Behaviour:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *noRecords_Label;
@property (weak, nonatomic) IBOutlet UIButton *clickMonth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sentTopConstraint;

- (IBAction)sentBtn_Message:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sentClickMessage;
@property (weak, nonatomic) IBOutlet UIButton *sentClick_Announcement;
@property (weak, nonatomic) IBOutlet UIButton *sentClick_selectMonth;

@end

