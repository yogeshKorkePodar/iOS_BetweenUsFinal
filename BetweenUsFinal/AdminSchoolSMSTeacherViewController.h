//
//  AdminSchoolSMSTeacherViewController.h
//  BetweenUs
//
//  Created by podar on 07/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AdminSchoolSMSTeacherViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSString *clt_id,*usl_id,*DeviceToken,*device,*std_name,*div_name,*studIDSMS,*clsIDSMS,*category,*sender_usl_id,*filePath,*AdminWriteMessage,*attachedfilename,*usl_IdMessage,*cls_id,*stu_id,*board_name,*mode,*enteredSms,*SendSMSTeaherStatus,*DeviceType;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *CategoryTableData;
}
- (IBAction)sendSMSBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *CategoryClick;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSClick;
@property (weak, nonatomic) IBOutlet UIButton *studentSMSClick;
@property (weak, nonatomic) IBOutlet UITextView *enterMessage;
@property (weak, nonatomic) IBOutlet UIButton *teacherSMSClick;
@property (weak, nonatomic) IBOutlet UILabel *condition_label;
@property (weak, nonatomic) IBOutlet UIButton *schoolSMSClick;
@property (weak, nonatomic) IBOutlet UIImageView *dropdownClick;
- (IBAction)category_btn:(id)sender;
@property BOOL internetActive;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UILabel *charachterLengthLimit_label;

@end
