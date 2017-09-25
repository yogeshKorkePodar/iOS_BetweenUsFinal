//
//  StudentProfileWithSiblingViewController.h
//  TestAutoLayout
//
//  Created by podar on 15/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNumberBadgeView.h"
@class Reachability;
@protocol  StudentProfileWithSiblingViewControllerDelegate<NSObject>

@required
- (void)dataFromController:(NSString *)data;

@end

@interface StudentProfileWithSiblingViewController : UIViewController{
    
    NSString *msd_id;
    NSString *rol_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *scool_name;
    NSString *brd_name;
    NSString *org_id;
    NSString *Brd_Id;
    NSString *sec_Id;
    NSString *teacherAnnouncementCount;
    NSString *drawerstd;
    NSString *drawername;
    NSString *drawerRollNo;
    NSString *draweracademicYear;
    NSString *LoginArrayCount;
    NSArray *ViewTableData;
    NSString *month;
    NSString *pageSize;
    NSString *pageNo;
    NSString *check;
    NSString *ViewMessageStatus;
    NSString *messageReadStatus;
    NSString *LastViewMessageStatus;
    NSMutableArray *messageReadCount;
    NSDictionary *viewmessagedetails;
    NSString *isStudentResourcePresent;
    NSInteger day;
    NSString *DeviceToken;
    NSString *DeviceType;
    NSString *announcementCount;
    NSString *behaviourCount;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSString *sch_id;
    NSString *cls_id;
    NSString *acy_yrID;
    NSString *stud_id;
    NSString *newVersion;



}
@property BOOL internetActive;
@property BOOL hostActive;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (weak, nonatomic) IBOutlet UILabel *studentresource_label;
@property (weak, nonatomic) NSString *Status;
@property(nonatomic,strong) NSString *rol_id;
@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *schoolName;
@property(nonatomic,strong) NSString *school_name;
@property(nonatomic,strong) NSString *brd_name;
@property(nonatomic,strong) NSString *brdName;
@property(nonatomic,strong) NSString *org_id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *sec_Id;
@property(nonatomic,strong) NSString *Brd_Id;
@property(strong, nonatomic) NSString *teacherAnnouncementCount;

@property (weak, nonatomic) IBOutlet UIButton *btn_studentInformation;
- (IBAction)studentInformation_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_sibling;
- (IBAction)sibling_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_paymentInfo;
@property (weak, nonatomic) IBOutlet UIButton *btn_studentResource;
- (IBAction)studentResource:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_message;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
- (IBAction)Message:(id)sender;
- (IBAction)Attendance:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *schoolLogo;
@property (weak, nonatomic) IBOutlet UILabel *label_schoolName;
@property (weak, nonatomic) IBOutlet UIButton *attendance_btn;
- (IBAction)paymentInfo_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label_studentName;
@property (weak, nonatomic) IBOutlet UILabel *label_std;
@property (weak, nonatomic) IBOutlet UILabel *label_div;
@property (weak, nonatomic) IBOutlet UIButton *admissionKit_button;
@property (weak, nonatomic) IBOutlet UILabel *admissionKit_label;

@property (nonatomic, weak) id<StudentProfileWithSiblingViewControllerDelegate> delegate;
@property (retain) MKNumberBadgeView* badgeCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *watermark_background_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *message_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stud_info_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stud_res_leading_constrain;

@property (weak, nonatomic) IBOutlet UIImageView *stud_resources_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sibling_trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attendance_trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fees_info_trailing;



@end
