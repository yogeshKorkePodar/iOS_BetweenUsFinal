//
//  ForgotPasswordViewController.h
//  BetweenUsFinal
//
//  Created by anand chawla on 26/07/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reachability;

@protocol ForgotPasswordViewControllerDelegate<NSObject,UITextFieldDelegate>

@required
- (void)dataFromController:(NSString *)data;
@end

@interface ForgotPasswordViewController : UIViewController{
    
    Reachability* internetReachable;
    Reachability* hostReachable;
}
- (IBAction)btn_submit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *click_submit;
@property (weak, nonatomic) IBOutlet UITextField *textfield_mobileno;
@property (weak, nonatomic) IBOutlet UITextField *textfiled_emailId;
@property (strong,nonatomic) NSString *forgotPassword_status;
@property (strong,nonatomic) NSString *forgotPassword_status_msg;
@property BOOL internetActive;
@property BOOL hostActive;


@property (nonatomic, weak) id<ForgotPasswordViewControllerDelegate> delegate;
@end
