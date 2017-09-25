//
//  ForgotPasswordViewController.m
//  BetweenUsFinal
//
//  Created by anand chawla on 26/07/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "URL_Constant.h"
#import "ForgotPasswordViewController.h"
#import "RestAPI.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface ForgotPasswordViewController (){
    NSString *mobileno;
    NSString *emailid;
    NSString *type;
}

@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic,strong) NSString *forgotPasssword_status;
@property (nonatomic,strong) NSString *forgotPasssword_statusmsg;
@end

@implementation ForgotPasswordViewController
@synthesize click_submit;

-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // self.navigationItem.title = [NSTextAlignmentCenter];
    self.navigationItem.title = @"Forgot Password";
    
    _textfield_mobileno.leftViewMode = UITextFieldViewModeAlways;
    _textfield_mobileno.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mobile_icon_25px.png"]];
    
    _textfiled_emailId.leftViewMode = UITextFieldViewModeAlways;
    _textfiled_emailId.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email_icon_25px2.png"]];
    
    [_textfiled_emailId setDelegate:self];
    [_textfield_mobileno setDelegate:self];
    
    [self checkInternetConnectivity];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)checkInternetConnectivity{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    
}
-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
        }
    }
    
}

- (void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender
{
    NSError *error = nil;
    
    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
    _forgotPasssword_status = [parsedJsonArray valueForKey:@"Status"];
    _forgotPasssword_statusmsg = [parsedJsonArray valueForKey:@"StatusMsg"];
    NSLog(@"Status:%@",_forgotPasssword_status);
    NSLog(@"StatusMsg:%@",_forgotPasssword_statusmsg);
    
    if([_forgotPasssword_status isEqualToString:@"1"]){
        
        UIAlertController *alertController_forgotpassword = [UIAlertController alertControllerWithTitle:@"Info" message:_forgotPasssword_statusmsg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController_forgotpassword addAction:ok];
        [self presentViewController:alertController_forgotpassword animated:YES completion:nil];
    }
    else if([_forgotPasssword_status isEqualToString:@"0"]){
        UIAlertController *alertController_forgotpassword = [UIAlertController alertControllerWithTitle:@"Error" message:_forgotPasssword_statusmsg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController_forgotpassword addAction:ok];
        [self presentViewController:alertController_forgotpassword animated:YES completion:nil];
        
    }
}


- (void)passDataBack
{
    if ([_delegate respondsToSelector:@selector(dataFromController:)])
    {
        [_delegate dataFromController:@"This data is from the second view controller."];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btn_submit:(id)sender {
    
    mobileno = _textfield_mobileno.text;
    emailid = _textfiled_emailId.text;
    
    NSLog(@"MobileNo: %@", mobileno);
    NSLog(@"EmailID: %@", emailid);
    if(self.internetActive == YES){
        
        if([mobileno isEqualToString:@""] && [emailid isEqualToString:@""]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please Enter Either Mobile No or Email ID" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if(![mobileno isEqualToString:@""]){
            type = @"M";
            //Create the response and Error
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            NSError *err;
            NSString *str = app_url @"PodarApp.svc/ForgotPassword";
            str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:str];
            
            //Pass The String to server
            NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:mobileno,@"SendTo",type,@"type", nil];
            NSLog(@"the data Details is =%@", newDatasetInfo);
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&err];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:POST];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            //Apply the data to the body
            [request setHTTPBody:jsonData];
            
            self.restApi.delegate = self;
            [self.restApi httpRequest:request];
            NSURLResponse *response;
            
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
            
            //This is for Response
            NSLog(@"got response==%@", resSrt);
            [hud hideAnimated:YES];
        }
        else if(![emailid isEqualToString:@""]){
            type = @"E";
            //Create the response and Error
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            NSError *err;
            NSString *str = app_url @"PodarApp.svc/ForgotPassword";
            str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:str];
            
            //Pass The String to server
            NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:emailid,@"SendTo",type,@"type", nil];
            NSLog(@"the data Details is =%@", newDatasetInfo);
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&err];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:POST];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            //Apply the data to the body
            [request setHTTPBody:jsonData];
            
            self.restApi.delegate = self;
            [self.restApi httpRequest:request];
            NSURLResponse *response;
            
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
            
            //This is for Response
            NSLog(@"got response==%@", resSrt);
            [hud hideAnimated:YES];
        }
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
}
@end
