//
//  AnnouncementViewController.h
//  BetweenUsFinal
//
//  Created by podar on 22/08/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNumberBadgeView.h"
#import "CCKFNavDrawer.h"
@class Reachability;

@interface AnnouncementViewController : UIViewController<CCKFNavDrawerDelegate,UITabBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    NSString *isStudentResourcePresent;
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSArray *announcementdetails;
    NSDictionary *announcemntdetailsdictionry;
    NSString *announcementStatus;
    NSString *device;
    NSString *fulldate;
    NSString *date;
    NSArray *dateitems;
    NSString *msg_id;
    NSString *LoginArrayCount;
    NSString *formatedDate,*announcementMsg;
    NSString *announcementReadStatus;
    NSString *ReadStatus;
    NSString *DeviceType;
    NSString *DeviceToken;
    NSString *announcementCount;
    NSString *behaviourCount;
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

@property BOOL internetActive;
@property BOOL hostActive;

@property (weak, nonatomic) IBOutlet UITableView *announcemntTableView;
@property (retain) MKNumberBadgeView* badgeCount;

@property(nonatomic,strong) NSString *brd_name;
@property(nonatomic,strong) NSString *announcementUslId;

@end
