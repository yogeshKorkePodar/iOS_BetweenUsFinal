//
//  StudentDashboardWithoutSibling.h
//  BetweenUsFinal
//
//  Created by anand chawla on 01/08/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
#import "MKNumberBadgeView.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "stundentListDetails.h"
#import "ViewMessageResult.h"

@class Reachability;
@protocol StudentDashboardWithoutSibling<NSObject>

@required
- (void)dataFromController:(NSString *)data;

@end

@interface StudentDashboardWithoutSibling : UIViewController<UIGestureRecognizerDelegate,CCKFNavDrawerDelegate>{
    NSString *msd_id;
    NSString *rol_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *scool_name;
    NSString *brd_name;
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
    NSString *announcementCount,*device;
    NSString *behaviourCount;
    NSString *sch_id;
    NSString *cls_id;
    NSString *acy_yrID,*newVersion;
    NSString *stud_id;
    int badgeCountNo;
    Reachability* internetReachable;
    Reachability* hostReachable;
    MBProgressHUD *hud;
    BOOL studentInfo,paymentInfo,studentResource,message,attendane,firstTime,loginClick,firstWebcall;
    
}

@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property (retain) MKNumberBadgeView* badgeCount;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property(nonatomic,strong) NSString * std;
@property(nonatomic,strong) NSString * roll_no;
@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) stundentListDetails *stundentListDetails;
@property (nonatomic, strong) stundentListDetails *item;
@property (nonatomic, strong) ViewMessageResult *ViewMessageItems;
@property (nonatomic, strong) ViewMessageResult *ViewMessageDetails;
@property BOOL internetActive;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewForContent;

@property (weak, nonatomic) IBOutlet UIView *ViewAboveScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *school_icon;
@property (weak, nonatomic) IBOutlet UILabel *school_name_label;
@property (weak, nonatomic) IBOutlet UILabel *parent_label;
@property (weak, nonatomic) IBOutlet UILabel *std_label;
@property (weak, nonatomic) IBOutlet UILabel *roll_no_label;
@property (weak, nonatomic) IBOutlet UIButton *message_button;
@property (weak, nonatomic) IBOutlet UIButton *feesinfo_button;
@property (weak, nonatomic) IBOutlet UIButton *studentinfo_button;
@property (weak, nonatomic) IBOutlet UIButton *attendance_button;

@property (weak, nonatomic) IBOutlet UIButton *student_resources_button;
@property (weak, nonatomic) IBOutlet UILabel *student_resources_label;

@property (weak, nonatomic) IBOutlet UIButton *admissionKit_button;
@property (weak, nonatomic) IBOutlet UILabel *admissionKit_label;

@property (weak, nonatomic) NSString *Status;
@property(nonatomic,strong) NSString *rol_id;
@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *school_name;
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


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *message_btn_leading_constrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *message_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *message_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studinfo_btn_leading_constrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studinfo_btn_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studinfo_btn_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studRes_btn_leading_constrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studRes_btn_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studRes_btn_widht;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feesinfo_btn_trailing_constrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feesinfo_btn_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feesinfo_btn_width;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attendance_btn_trailing_constrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attendance_btn_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attendance_btn_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *admissionkit_btn_trailing_constrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *admissionkit_btn_widht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *admissionkit_btn_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *school_icon_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *school_icon_width;
@property (weak, nonatomic) IBOutlet UIImageView *watermark_background;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *watermark_background_height;


@end
