//
//  TeacherAnnouncementViewController.h
//  BetweenUs
//
//  Created by podar on 29/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
#import "MKNumberBadgeView.h"


@interface TeacherAnnouncementViewController : UIViewController<CCKFNavDrawerDelegate, UITabBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *device;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSString *clt_id,*usl_id,*check,*pmg_Id,*rol_id,*org_id,*Brd_Id,*sec_Id,*brd_name,*DeviceToken,*DeviceType,*AnnouncementStatus,*announcementReadStatus,*ReadStatus,*fulldate,*date,*announcementMsg,*formatedDate,*announcementUslId,*msg_id,*classTeacher;
    NSArray *teacherAnnoucementArray,*dateitems;
    __weak IBOutlet UIView *buttonView;

}
@property BOOL internetActive;
@property BOOL hostActive;
@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (weak, nonatomic) IBOutlet UITabBar *my_tabBar;
@property (retain) MKNumberBadgeView* badgeCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *announcementlabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthAnnouncement;
@property (weak, nonatomic) IBOutlet UIButton *attendanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *announcementBtn;
@property (weak, nonatomic) IBOutlet UIButton *behaviourbtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstarintAnnouncement;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintAnnouncement;
@property (weak, nonatomic) IBOutlet UITableView *announcementTableView;
@property (weak, nonatomic) IBOutlet UILabel *attendanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *behaviourLabel;

@property (weak, nonatomic) IBOutlet UITabBarItem *attendance_tab;
@property (weak, nonatomic) IBOutlet UITabBarItem *behaviour_tab;

- (IBAction)announcementBehavioutBtn:(id)sender;
- (IBAction)announcementAnnBtn:(id)sender;
- (IBAction)announcementAttendanceBtn:(id)sender;
- (IBAction)behaviourClick:(id)sender;
- (IBAction)attendanceClick:(id)sender;
- (IBAction)AnnouncementBtnClick:(id)sender;
- (IBAction)announcementButton:(id)sender;

@end
