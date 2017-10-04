//
//  TeacherProfileViewController.h
//  BetweenUs
//
//  Created by podar on 28/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
#import "Reachability.h"
#import "MKNumberBadgeView.h"

@interface TeacherProfileViewController : UIViewController <CCKFNavDrawerDelegate>{

NSString *device;
Reachability* internetReachable;
Reachability* hostReachable;
int badgeCountNo;
NSInteger day;
NSString *clt_id,*usl_id,*check,*pmg_Id,*rol_id,*org_id,*Brd_Id,*sec_Id,*DeviceToken,*DeviceType,*MessageStatus,*AnnouncementStatus,*messageReadStatus,*announcementReadStatus,*pageNo,*pageSize,*brd_name,*name,*school_name,*month,*drawerstd,*classTeacher;
NSArray *TeacherViewMessageTableData,*teacherAnnoucementArray;
NSMutableArray *unreadMessage,*unreadAnnouncement,*announcementReadCount,*messageReadCount,*messageReadCountWithNoInternet,*announcementReadCountWithNoInternet;

}

@property BOOL internetActive;
@property BOOL hostActive;
@property (retain) MKNumberBadgeView* badgeCount;
@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;

@property (weak, nonatomic) IBOutlet UIImageView *image_logo;
@property (weak, nonatomic) IBOutlet UIButton *MessageClick;
@property (weak, nonatomic) IBOutlet UIButton *smsClick;
@property (weak, nonatomic) IBOutlet UIButton *announcementClick;
@property (weak, nonatomic) IBOutlet UIButton *behaviourClick;
@property (weak, nonatomic) IBOutlet UIButton *subjectListClick;
@property (weak, nonatomic) IBOutlet UIButton *attendanceClick;

@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;

@end
