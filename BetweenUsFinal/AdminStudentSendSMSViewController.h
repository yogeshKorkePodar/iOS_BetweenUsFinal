//
//  AdminStudentSendSMSViewController.h
//  BetweenUs
//
//  Created by podar on 19/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AdminStudentSendSMSViewController : UIViewController<UITextViewDelegate>{
    NSString *clt_id,*usl_id,*DeviceToken,*device,*SendSMSStatus,*cls_ID,*enteredSms,*mode,*stu_ID;
    Reachability* internetReachable;
    Reachability* hostReachable;
}
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UITextView *entermsg;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSClick;
- (IBAction)sendSMS:(id)sender;
@property BOOL internetActive;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UILabel *characterLimitLabel;


@end
