//
//  LoginViewController.h
//  BetweenUsFinal
//
//  Created by podar on 25/07/17.
//  Copyright © 2017 podar. All rights reserved.

#import <UIKit/UIKit.h>
#import "ForgotPasswordViewController.h"
#import "RestAPI.h"

@interface LoginViewController : UIViewController <RestAPIDelegate,  UIGestureRecognizerDelegate, UITextFieldDelegate> {
    ForgotPasswordViewController *forgotPasswordViewController;
    
    bool checked;
    bool sibling;
    NSString *DeviceType;
    NSString *DeviceToken;
    NSString *username;
    NSString *password;
    NSString *teacherClassStdDiv;
}

@property (weak, nonatomic) IBOutlet UITextField *textfield_username;
@property (weak, nonatomic) IBOutlet UITextField *textfield_password;
@property (weak, nonatomic) IBOutlet UIButton *outlet_showPassword;

- (IBAction)btn_login:(UIButton *)sender;

- (IBAction)btn_forgotPassword:(UIButton *)sender;

- (IBAction)btn_showPassword:(UIButton *)sender;

@property(strong,nonatomic) NSString *msd_id;
@property(strong,nonatomic) NSString *DeviceType;
@property(strong,nonatomic) NSString *DeviceToken;
@property(strong,nonatomic) NSString *roll_id;
@property(strong,nonatomic) NSString *brd_name;
@property(strong,nonatomic) NSString *usl_id;
@property(strong,nonatomic) NSString *org_id;
@property(strong,nonatomic) NSString *school_name;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *teacher_announcementCount;
@property(strong,nonatomic) NSString *clt_id;
@property(strong,nonatomic) NSString *LoginUserCount;
@property(strong,nonatomic) NSString *adminLoggedIn;



@end
