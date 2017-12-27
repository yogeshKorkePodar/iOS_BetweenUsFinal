//
//  AdminProfileViewController.h
//  BetweenUs
//
//  Created by podar on 14/09/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "CCKFNavDrawer.h"
#import "MBProgressHUD.h"
#import "MKNumberBadgeView.h"
@interface AdminProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSString *clt_id;
    NSString *msd_id;
    NSString *rol_id;
    NSString *usl_id;
    NSString *school_name;
    NSString *brd_name;
    NSString *admin_name;
    NSString *org_id;
    NSString *Brd_Id;
    NSString *sec_Id;
    NSString *drawerstd;
    NSString *drawername;
    NSString *drawerRollNo;
    NSString *draweracademicYear;
    NSString *DeviceToken;
    NSString *DeviceType;
    NSString *teacherAnnouncementCount;
    NSDictionary *viewmessagedetails;
    NSArray *drawerlabelData;
    NSArray *ViewTableData;
    NSString *month;
    NSString *pageSize;
    NSString *pageNo;
    NSString *check;
    NSString *ViewMessageStatus;
    NSString *messageReadStatus;
    NSString *isStudentResourcePresent;
    NSString *LastViewMessageStatus;
    NSMutableArray *messageReadCount;
    NSMutableArray *messageReadCountWithNoInternet;
    NSString *announcementCount;
    NSString *behaviourCount;
    NSString *sch_id;
    NSString *cls_id;
    NSString *acy_yrID;
    NSString *stud_id,*device ;
    int badgeCountNo;
    Reachability* internetReachable;
    Reachability* hostReachable;
    MBProgressHUD *hud;

    
}
@property BOOL internetActive;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UIImageView *img_logo;
@property (weak, nonatomic) IBOutlet UILabel *label_school_name;

@property (weak, nonatomic) IBOutlet UILabel *label_admin_name;
@property (weak, nonatomic) IBOutlet UIButton *admin_message_click;
@property (weak, nonatomic) IBOutlet UILabel *label_message;
@property (weak, nonatomic) IBOutlet UIButton *admin_sms_click;
@property (weak, nonatomic) IBOutlet UILabel *label_sms;
@property (weak, nonatomic) IBOutlet UIButton *admin_announcement_click;
@property (weak, nonatomic) IBOutlet UILabel *label_announcement;
@property (retain) MKNumberBadgeView* badgeCount;


@property(nonatomic,strong) NSString *rol_id;
@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *school_name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstarintMessageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraintMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstarintSMSLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintSMS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstarintMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstarintAnnouncement;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstarintAnnouncementLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstarintAnnouncement;
@property(nonatomic,strong) NSString *brd_name;
@property(nonatomic,strong) NSString *org_id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *sec_Id;
@property(nonatomic,strong) NSString *Brd_Id;
@property(nonatomic,strong) NSString *drawerstd;
@property(nonatomic,strong) NSString *drawername;
@property(nonatomic,strong) NSString *drawerRollNo;
@property(nonatomic,strong) NSString *draweracademicYear;
@property(strong, nonatomic) NSString *teacherAnnouncementCount;
@end
