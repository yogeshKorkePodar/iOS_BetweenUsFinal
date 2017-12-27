//
//  AdminSendSMSToTeacherSMSViewController.h
//  BetweenUs
//
//  Created by podar on 20/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AdminSendSMSToTeacherSMSViewController : UIViewController<UITextViewDelegate>
{
    NSString *checkall,*usl_id,*clt_id,*messageContent,*contactNo,*brd_name,*DeviceToken,*device,*SendSMSStatus;
    Reachability* internetReachable;
    Reachability* hostReachable;
}
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSClick;
- (IBAction)SendSMSBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *characterLength;
@property (weak, nonatomic) IBOutlet UITextView *enterMsg;
@property BOOL internetActive;
@property BOOL hostActive;

@end
