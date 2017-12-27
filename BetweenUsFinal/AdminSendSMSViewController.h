//
//  AdminSendSMSViewController.h
//  BetweenUs
//
//  Created by podar on 07/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AdminSendSMSViewController : UIViewController<UITextViewDelegate>{
    NSString *clt_id,*usl_id,*DeviceToken,*device,*SendSMSStatus,*cls_ID,*enteredSms,*mode;
    Reachability* internetReachable;
    Reachability* hostReachable;
}
@property (weak, nonatomic) IBOutlet UILabel *characterLimitLabel;
@property (weak, nonatomic) IBOutlet UIButton *SchoolSenfSMS_click;
@property (weak, nonatomic) IBOutlet UITextView *enterMessageTextview;
@property (weak, nonatomic) IBOutlet UITextField *dearParent_textfield;
- (IBAction)selectModule:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectModuleClick;

@property (weak, nonatomic) IBOutlet UILabel *condition_label;
- (IBAction)SchoolSendSMS:(id)sender;
@property BOOL internetActive;
@property BOOL hostActive;

@end
