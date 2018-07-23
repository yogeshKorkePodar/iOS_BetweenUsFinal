//
//  ViewMessageViewController.h
//  BetweenUsFinal
//
//  Created by podar on 18/08/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
#import "MKNumberBadgeView.h"
@class Reachability;

@interface ViewMessageViewController : UIViewController <CCKFNavDrawerDelegate,UITabBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *school_name;
    NSString *brdName;
    NSString *stdName;
    NSString *DropdownStatus;
    NSString *ViewMessageStatus;
    NSString *LastViewMessageStatus;
    NSArray *MonthTableData;
    NSArray *ViewTableData;
    NSString *monthanme;
    NSString *monthid;
    NSString *pageSize;
    NSString *pageNo;
    NSString *check;
    NSString *senderName;
    NSString *date;
    NSString *message;
    NSString *subject;
    NSDictionary *dropdowndetails;
    NSDictionary *viewmessagedetails;
    NSString *LoginArrayCount;
    NSString *toUslId;
    NSString *pmuId;
    NSString *msgReadStatus;
    NSString *filename;
    NSString *filePath;
    NSString *day;
    NSString *fulldate;
    NSArray *dateitems;
    NSString *formatedDate;
    NSString *DeviceType;
    NSString *DeviceToken;
    NSString *behaviourCount;
    NSString *announcementCount;
    NSString *isStudentResourcePresent;
    NSString *device;
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
@property(nonatomic,strong) NSString *Brd_Id;
@property(nonatomic,strong) NSString *drawerstd;
@property(nonatomic,strong) NSString *drawername;
@property(nonatomic,strong) NSString *drawerRollNo;
@property(nonatomic,strong) NSString *draweracademicYear;
@property(strong, nonatomic) NSString *teacherAnnouncementCount;
@property (weak, nonatomic) IBOutlet UITabBar *my_tabBar;

@property BOOL internetActiveViewMessage;
@property BOOL hostActiveViewMessage;

@property (retain) MKNumberBadgeView* badgeCount;
- (IBAction)viewMessageBtn_Action:(id)sender;
// strategy: when view message opened initially hide selectMonthTable and set viewMessageConstraint = 8 then load the messages for current month
//when user select month unhide selectMonthTable inside it show table items and set viewMessageConstraint = 99,  and after month selection show messages in the viewMessageTable
- (IBAction)selectMonthBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *SelectMonth;
@property (weak, nonatomic) IBOutlet UITableView *selectMonthTableData;
@property (weak, nonatomic) IBOutlet UITableView *viewMessageTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewMessageConstraint;


@end
