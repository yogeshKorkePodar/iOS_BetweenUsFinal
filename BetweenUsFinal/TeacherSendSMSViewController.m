//
//  TeacherSendSMSViewController.m
//  BetweenUs
//
//  Created by podar on 15/11/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherSendSMSViewController.h"
#import "MBProgressHUD.h"
#import "TeacherSMSViewController.h"
#import "RestAPI.h"
#import "URL_Constant.h"

@interface TeacherSendSMSViewController (){
    NSDictionary *newDatasetinfoTeacherSendSMSStudent;
    UIAlertView *alertmodule;
    UITableView *moduleTable;
    BOOL moduleClick;
}

@end

@implementation TeacherSendSMSViewController
@synthesize stu_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.enterSmsTextview.layer.borderWidth = 1.0f;
    self.enterSmsTextview.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.selectModuleClick.layer.borderWidth = 1.0f;
    self.selectModuleClick.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _conditionLabel.layer.cornerRadius = 5;
    _conditionLabel.layer.masksToBounds = YES;
    
    _sendSMSClick.layer.cornerRadius = 5;
    _sendSMSClick.layer.masksToBounds = YES;
    
    _enterSmsTextview.text = @"Type your message here";
    _enterSmsTextview.textColor = [UIColor lightGrayColor];
    
    [_selectModuleClick setTitle:@"Dear Parent, Kindly Note" forState:UIControlStateNormal];
    [_selectModuleClick setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_enterSmsTextview setDelegate:self];
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    cls_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"cls_ID"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    cls_ID = [[NSUserDefaults standardUserDefaults]stringForKey:@"class_Id_TeacherSMS"];
    DeviceType= @"IOS";
    self.navigationItem.title = @"Send SMS";
    [_characterLimit_label setHidden:YES];
    
    [self checkInternetConnectivity];
    NSURL *myURL = [NSURL URLWithString:app_url @"GetSMSTemplate"];
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:myRequest delegate:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//-(void)webserviceCall{
//    //Pass The String to server
//   NSString *urlString = @"http://  //  newDatasetinfoTeacherSendMessageStudent = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",subject,@"pmg_subject",message,@"msg_message",sender_usl_id,@"sender_uslId",cls_ID,@"cls_id",filePath,@"filepath",attachedfilename,@"filename",stu_id,@"stud_id",nil];
//    NSLog(@"the data Details is =%@", newDatasetinfoTeacherSendMessageStudent);
//    NSError *error = nil;
 //    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
//    [self checkWithServer:urlString jsonString:jsonInputString];
//}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
    
    int errorCode = httpResponse.statusCode;
    
    NSString *fileMIMEType = [[httpResponse MIMEType] lowercaseString];
    
    NSLog(@"response is %d, %@", errorCode, fileMIMEType);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSLog(@"data is %@", data);
    NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"string is %@", myString);
    NSError *error = nil;
    
    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
    TemplateStatus = [parsedJsonArray valueForKey:@"Status"];
    
    NSLog(@"Status is %@", TemplateStatus);
    SMSTemplateArray = [receivedData objectForKey:@"SMSTemplateResult"];
    selectedModule = [[SMSTemplateArray objectAtIndex:0]objectForKey:@"Stm_template_name"];
    [_selectModuleClick setTitle:selectedModule forState:UIControlStateNormal];
    [_selectModuleClick setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //  SMSTemplateArray = [data objectForKey:@"SMSTemplateResult"];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // inform the user
    
    NSLog(@"Connection failed! Error - %@ %@",
          
          [error localizedDescription],
          
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // do something with the data
    
    // receivedData is declared as a method instance elsewhere
    
    NSLog(@"Succeeded!");
    
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    // return YES;
    else{
        [_characterLimit_label setHidden:NO];
        NSString *length  =[NSString stringWithFormat:@"%d",textView.text.length + (text.length - range.length) ];
        
        length=   [NSString stringWithFormat:@"%@/%@",length,@"132"];
        _characterLimit_label.text = length;
        return textView.text.length + (text.length - range.length) < 132;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

-(void)webserviceCall{
    //Pass The String to server
    NSString *urlString = app_url @"StudentSMS";
    
    newDatasetinfoTeacherSendSMSStudent = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",enteredSms,@"msg_message",cls_ID,@"cls_id",stu_id,@"stud_id",nil];
    NSLog(@"the data Details is =%@", newDatasetinfoTeacherSendSMSStudent);
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherSendSMSStudent options:NSJSONWritingPrettyPrinted error:&error];
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
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherSendSMSStudent options:kNilOptions error:&err];
            
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
                
                sendSMSStatus = [parsedJsonArray valueForKey:@"Status"];
                if([sendSMSStatus isEqualToString:@"1"]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Message Sent Successfully" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                        TeacherSMSViewController *teacherSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherSMS"];
                        [self.navigationController pushViewController:teacherSMSViewController animated:NO];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                        
                    }];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else if([sendSMSStatus isEqualToString:@"0"]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Message Not Sent" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                [hud hideAnimated:YES];
            }
        });
    });
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedModule = @"";
    [alertmodule dismissWithClickedButtonIndex:0 animated:YES];
    selectedModule = [[SMSTemplateArray objectAtIndex:indexPath.row] objectForKey:@"Stm_template_name"];
    [_selectModuleClick setTitle:selectedModule forState:UIControlStateNormal];
    [_selectModuleClick setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
}


- (IBAction)selectModule:(id)sender {
    alertmodule= [[UIAlertView alloc] initWithTitle:@"Select Module"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:(NSString *)nil];
    if(self.internetActive == YES){
        
        moduleClick = YES;
        // [self webserviceCall];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    moduleTable = [[UITableView alloc] init];
    moduleTable.delegate = self;
    moduleTable.dataSource = self;
    [alertmodule setValue:moduleTable forKey:@"accessoryView"];
    [alertmodule show];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        return 45;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try {
        return [SMSTemplateArray count];
    }  @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    cell.textLabel.text = [[SMSTemplateArray objectAtIndex:indexPath.row]objectForKey:@"Stm_template_name"];
    return cell;
}

- (IBAction)sendSMS:(id)sender {
    enteredSms = _enterSmsTextview.text;
    enteredSms =[NSString stringWithFormat: @"%@ ,%@ ",selectedModule,enteredSms];
    NSLog(@"TExt%@",enteredSms);
    if([enteredSms isEqualToString:@"Dear Parent, Kindly Note ,Type your message here "]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"SMS can not be Blank" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"&+%=#'"];
        NSRange range = [enteredSms rangeOfCharacterFromSet:cset];
        if (range.location == NSNotFound) {
            // no ( or ) in the string
            
            //  enteredSms= [NSString stringWithFormat:@"%@ %@",selectedModule,enteredSms];
            NSLog(@"NO%@",@"NO");
            NSLog(@"After text%@",enteredSms);
            
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
