//
//  AdminSendSMSToTeacherSMSViewController.m
//  BetweenUs
//
//  Created by podar on 20/10/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "AdminSendSMSToTeacherSMSViewController.h"
#import "WYPopoverController.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "AdminTeacherSMSViewController.h"

@interface AdminSendSMSToTeacherSMSViewController ()
{
    WYPopoverController *settingsPopoverController;
    NSDictionary *newDatasetinfoAdminSMSToTeacherSMS;
}
@end

@implementation AdminSendSMSToTeacherSMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Send SMS";
    self.enterMsg.layer.borderWidth = 1.0f;
    self.enterMsg.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _enterMsg.text = @"Type your message here";
    _enterMsg.textColor = [UIColor lightGrayColor];
    [_enterMsg setDelegate:self];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    
    contactNo = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedContactNo"];
    checkall = [[NSUserDefaults standardUserDefaults]stringForKey:@"CheckAll"];
    _conditionLabel.layer.cornerRadius = 5;
    _conditionLabel.layer.masksToBounds = YES;
    
    _sendSMSClick.layer.cornerRadius = 5;
    _sendSMSClick.layer.masksToBounds = YES;
    _enterMsg.delegate = self;
   
    [_characterLength setHidden:YES];
    [self checkInternetConnectivity];

}

-(void)checkInternetConnectivity{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatusViewMessage:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    [hud hideAnimated:YES];
}
-(void) checkNetworkStatusViewMessage:(NSNotification *)notice
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
    if(self.internetActive == YES){
        
        //   [self webserviceCall];
    }
    
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

-(void)webserviceCall{
    
    NSString *urlString = app_url @"PodarApp.svc/SendSmsAdminToTeacher";
    
    //Pass The String to server
    newDatasetinfoAdminSMSToTeacherSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",messageContent,@"smsString",contactNo,@"mobilenumber",usl_id,@"usl_id",brd_name,@"brd_name",checkall,@"ChkAll",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSMSToTeacherSMS options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServer:urlString jsonString:jsonInputString];
    
}
-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    
    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err;
            NSData* responseData = nil;
            NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            responseData = [NSMutableData data] ;
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSMSToTeacherSMS options:kNilOptions error:&err];
            
            [request setHTTPMethod:POST];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            //Apply the data to the body
            [request setHTTPBody:jsonData];
            NSURLResponse *response;
            
            responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
            
            //This is for Response
            NSLog(@"got response==%@", resSrt);
            
            NSError *error = nil;
            if(!responseData==nil){
                NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                
                SendSMSStatus = [parsedJsonArray valueForKey:@"Status"];
                
                if([SendSMSStatus isEqualToString:@"1"]){
                    
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"SMS Sent Successfully" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                        AdminTeacherSMSViewController *adminTeacherSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminTeacherSMS"];
                        [self.navigationController pushViewController:adminTeacherSMSViewController animated:NO];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                        
                    }];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else if([SendSMSStatus isEqualToString:@"0"]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"SMS Not Sent" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                [hud hideAnimated:YES];
            }
        });
    });
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Type your message here"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Type your message here";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    // return YES;
    else{
        [_characterLength setHidden:NO];
        NSString *length  =[NSString stringWithFormat:@"%d",textView.text.length + (text.length - range.length) ];
        
        length=   [NSString stringWithFormat:@"%@/%@",length,@"132"];
        _characterLength.text = length;
        return textView.text.length + (text.length - range.length) < 132;
    }
    
}

- (IBAction)SendSMSBtn:(id)sender {
    messageContent = _enterMsg.text;
    NSLog(@"TExt%@",messageContent);
    if([messageContent isEqualToString:@"Type your message here"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"SMS can not be Blank" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"&+%=#'"];
        NSRange range = [messageContent rangeOfCharacterFromSet:cset];
        if (range.location == NSNotFound) {
            // no ( or ) in the string
            
            messageContent= [NSString stringWithFormat:@"%@ %@",@"Dear Teacher,Kindly Note",messageContent];
            NSLog(@"NO%@",@"NO");
            NSLog(@"Afer text%@",messageContent);
            
            [self webserviceCall];
            
        } else {
            // ( or ) are present
            NSLog(@"YES%@",@"Yes");
            NSString *message = @"There is special character in SMS";
            UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
            [toast show];
            int duration = 1; // in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [toast dismissWithClickedButtonIndex:0 animated:YES];
            });
        }
        
    }

}
@end