//
//  TeacherSendSMSViewController.h
//  BetweenUs
//
//  Created by podar on 15/11/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TeacherSendSMSViewController : UIViewController{
    NSString *TemplateStatus,*enteredSms,*clt_id,*usl_id,*cls_ID,*device,*DeviceToken,*DeviceType,*stu_id,*cls_id,*sendSMSStatus,*selectedModule;
    NSArray *SMSTemplateArray;
    Reachability* internetReachable;
    Reachability* hostReachable;
    
}
@property BOOL internetActive;
@property BOOL hostActive;
@property(nonatomic,strong) NSString *stu_id;

@property (weak, nonatomic) IBOutlet UILabel *characterLimit_label;
@property (weak, nonatomic) IBOutlet UIButton *selectModuleClick;
@property (weak, nonatomic) IBOutlet UITextView *enterSmsTextview;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSClick;

- (IBAction)selectModule:(id)sender;
- (IBAction)sendSMS:(id)sender;

@end
