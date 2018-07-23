//
//  AdminTeacherSMSViewController.h
//  BetweenUs
//
//  Created by podar on 19/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AdminTeacherSMSViewController2 : UIViewController<UITextFieldDelegate>{
    NSString *clt_id,*usl_id,*DeviceToken,*device,*TeacherSMSStatus,*cls_ID,*enteredSms,*mode,*stu_ID,*PageNo,*PageSize,*Searchname,*brd_name,*checkAll,*contactNo;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSMutableArray *contactNoArray,*pathArray,*arrayForTag;
    NSArray *AdminTeacherSMSArray;
    
}

@property BOOL internetActive;
@property BOOL hostActive;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;

@property (weak, nonatomic) IBOutlet UITableView *teacherSMSList;
@property (weak, nonatomic) IBOutlet UITableView *teacherSMSListData;

@property (weak, nonatomic) IBOutlet UITextField *enterTeacherName;
@property (weak, nonatomic) IBOutlet UITextField *enterTeacher;

@property (weak, nonatomic) IBOutlet UIView *closeView;
@property (weak, nonatomic) IBOutlet UIImageView *closeViewImg;

@property (weak, nonatomic) IBOutlet UIButton *checkAllClick;
@property (weak, nonatomic) IBOutlet UIButton *checkAll;

-(void)checkButtonPressed:(id)sender;
- (IBAction)searchBtn:(id)sender;
- (IBAction)sendSMSBtn:(id)sender;
- (IBAction)checkAllBtn:(id)sender;
- (IBAction)schoolSMSBtn:(id)sender;
- (IBAction)teacherSMSBtn:(id)sender;
- (IBAction)studentSMSBtn:(id)sender;

@end
