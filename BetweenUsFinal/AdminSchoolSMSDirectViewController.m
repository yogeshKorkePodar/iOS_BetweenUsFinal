//
//  AdminSchoolSMSDirectViewController.m
//  BetweenUs
//
//  Created by podar on 12/10/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "AdminSchoolSMSDirectViewController.h"
#import "WYPopoverController.h"
#import "AdminTeacherSMSViewController.h"
#import "TeacherSMSViewController.h"
#import "AdminSchoolSMSTeacherViewController.h"
#import "AdminSendSMSViewController.h"
#import "AdminSendMessageViewController.h"
#import "WriteMessageStudentTableViewCell.h"
#import "WYPopoverController.h"
#import "MBProgressHUD.h"
#import "AdminSentMessagesViewController.h"
#import "CCKFNavDrawer.h"
#import "ViewMessageResult.h"
#import "WYPopoverController.h"
#import "MBProgressHUD.h"
#import "AdminViewMessageViewController.h"
#import "RestAPI.h"
#import "DetailMessageViewController.h"
#import "ChangePassswordViewController.h"
#import "AdminProfileViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "AdminMessageTableViewCell.h"
#import "AdminAnnouncementViewController.h"
#import "AcedmicYearResult.h"
#import "AdminDropResult.h"
#import "AdminStudentListViewController.h"
#import "AdminWriteMessageTeacherViewController.h"
#import "MsgTeacherResult.h"
#import "AdminTeacherTableViewCell.h"
#import "AdminSendMessageViewController.h"
#import "AdminSchoolSMSViewController.h"
#import "AdminStudentSMSViewController.h"

@interface AdminSchoolSMSDirectViewController (){
    WYPopoverController *settingsPopoverController;
    BOOL loginClick,moduleClick;
    UIAlertView *alertCategory;
    UITableView *categoryTableView;
    NSData *itemData;
    NSOutputStream *outputStream;
    NSMutableArray *byteArray;
    UIAlertView *alertmodule;
    UITableView *moduleTable;
    NSString *selectedModule,*TemplateStatus;
    
    NSArray *SMSTemplateArray;

    NSDictionary *newDatasetinfoAdminLogout,*newDatasetinfoAdminSchoolSendSMSDirect,*newDatasetinfoTeacherUploadFile,*dic;
}

@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation AdminSchoolSMSDirectViewController
    


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"SMS";
    //Add drawer image button
    UIImage *faceImage = [UIImage imageNamed:@"drawer_icon.png"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake( 10, 0, 15, 15 );
    self.selectModuleClick.layer.borderWidth = 1.0f;
    self.selectModuleClick.layer.borderColor = [[UIColor grayColor] CGColor];
    
    UITapGestureRecognizer *tapdrawer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrawer)];
    [tapdrawer setNumberOfTapsRequired:1];
    [face addGestureRecognizer:tapdrawer];
    tapdrawer.delegate = self;
    [face addTarget:self action:@selector(handleDrawer) forControlEvents:UIControlEventTouchUpInside];
    [face setImage:faceImage forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:face];
    self.navigationItem.leftBarButtonItem = backButton;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setBackBarButtonItem:nil];
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];


    self.enterMessage.layer.borderWidth = 1.0f;
    self.enterMessage.layer.borderColor = [[UIColor grayColor] CGColor];
    _sendSMSClick.layer.cornerRadius = 5;
    _sendSMSClick.layer.masksToBounds = YES;
    _conditionLabel.layer.masksToBounds = YES;
    _conditionLabel.layer.cornerRadius = 5;
    _attachement.layer.cornerRadius = 5;
    _attachement.layer.masksToBounds = YES;
    
    _enterMessage.text = @"Type your message here";
    _enterMessage.textColor = [UIColor lightGrayColor];
    [_enterMessage setDelegate:self];
    [_charachterLimit_label setHidden:YES];
   [self checkInternetConnectivity];
    NSURL *myURL = [NSURL URLWithString:app_url @"PodarApp.svc/GetAdminSMSTemplate"];
    
    
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:myRequest delegate:self];
     CategoryTableData = [NSArray arrayWithObjects:@"Student", @"Teacher", @"Direct", nil];
   

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

-(void)handleDrawer{
    [self.rootNav drawerToggle];
}
-(void)screenTappedOnceStudentSMS{
    AdminStudentSMSViewController *adminStudentSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminStudentSMS"];
    [self.navigationController pushViewController:adminStudentSMSViewController animated:YES];
}
-(void)screenTappedOnceSchoolSMS{
    //sms
    AdminSchoolSMSViewController *adminSchoolSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMS"];
    
    [self.navigationController pushViewController:adminSchoolSMSViewController animated:YES];
}
-(void)screenTappedOneTeacherSMS{
    AdminTeacherSMSViewController *adminTeacherSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminTeacherSMS"];
    
    [self.navigationController pushViewController:adminTeacherSMSViewController animated:YES];
}


-(void)screenTappedOnceTeacherSMS_template{
    [alertmodule setFrame:CGRectMake(40, 150, 2500, 500)];
    alertmodule= [[UIAlertView alloc] initWithTitle:@"Select Module"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:(NSString *)nil];
    if(self.internetActive == YES){
        
        moduleClick = YES;
      //   [self webserviceCall];
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
 //   _template_textfield.text = selectedModule;
   //_template_textfield.textColor = [UIColor blackColor];
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
-(void)webserviceCall{
    if(loginClick==YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *urlString = app_url @"PodarApp.svc/LogOut";
        //    newDatasetinfoAdminLogout = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        //Pass The String to server
        newDatasetinfoAdminLogout= [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminLogout options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    
    else{
        
        NSString *urlString = app_url @"PodarApp.svc/AdminSendDirectSMS";
        
        //Pass The String to server
        newDatasetinfoAdminSchoolSendSMSDirect= [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",enteredSms,@"message",contactList,@"contactList",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSendSMSDirect options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    
}
-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    if(loginClick == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminLogout options:kNilOptions error:&err];
                
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
                [hud hideAnimated:YES];
            });
        });
    }
    else{
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSendSMSDirect options:kNilOptions error:&err];
                
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
                    
                    SendSMSDirectStatus = [parsedJsonArray valueForKey:@"Status"];
                    
                    if([SendSMSDirectStatus isEqualToString:@"1"]){
                        
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Message Sent Successfully" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                            AdminSchoolSMSViewController *adminSchoolSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMS"];
                            [self.navigationController pushViewController:adminSchoolSMSViewController animated:NO];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                            
                        }];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    else if([SendSMSDirectStatus isEqualToString:@"0"]){
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
    
}

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    
    if(selectionIndex == 0){
        
        AdminProfileViewController *adminProfileController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminProfile"];
        [self.navigationController pushViewController:adminProfileController animated:YES];
    }
    else if(selectionIndex == 1){
        //Messsage
        AdminViewMessageViewController *adminViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewMessage"];
        
        [self.navigationController pushViewController:adminViewMessageViewController animated:YES];
    }
    else if(selectionIndex == 2){
        //sms
        AdminSchoolSMSViewController *adminSchoolSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMS"];
        
        [self.navigationController pushViewController:adminSchoolSMSViewController animated:YES];
        
        
    }
    else if(selectionIndex == 3){
        AdminAnnouncementViewController *adminAnnouncementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminAnnouncement"];
        
        [self.navigationController pushViewController:adminAnnouncementViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    
    else if(selectionIndex == 4){
        ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
        [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    else if(selectionIndex == 5){
        loginClick = YES;
        [self webserviceCall];
        LoginViewController *LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self.navigationController pushViewController:LoginViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    else if(selectionIndex == 6){
        if (settingsPopoverController == nil)
        {
            AboutUsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
            settingsViewController.preferredContentSize = CGSizeMake(320, 300);
            
            settingsViewController.title = @"AboutUs";
            settingsViewController.modalInPopover = NO;
            
            UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            
            settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            settingsPopoverController.delegate = self;
            settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            settingsPopoverController.wantsDefaultContentAppearance = NO;
            [settingsPopoverController presentPopoverAsDialogAnimated:YES
                                                              options:WYPopoverAnimationOptionFadeWithScale];
        }
    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    selectedModule = @"";
//    [alertmodule dismissWithClickedButtonIndex:0 animated:YES];
//    selectedModule = [[SMSTemplateArray objectAtIndex:indexPath.row] objectForKey:@"Stm_template_name"];
//    _template_textfield.text = selectedModule;
//   // [_template_textfield setTitle:selectedModule forState:UIControlStateNormal];
//    //[_selectModuleClick setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _template_textfield.textColor = [UIColor blackColor];
//}

- (IBAction)categoryBtn:(id)sender {
    [alertCategory setFrame:CGRectMake(40, 150, 2500, 500)];
    alertCategory = [[UIAlertView alloc] initWithTitle:@"Category"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"Close"
                                     otherButtonTitles:(NSString *)nil];
    
    categoryTableView = [[UITableView alloc] init];
    categoryTableView.delegate = self;
    categoryTableView.dataSource = self;
    [alertCategory setValue:categoryTableView forKey:@"accessoryView"];
    [alertCategory show];

}

- (IBAction)studentSMSBtn:(id)sender {
    [self screenTappedOnceStudentSMS];
}

- (IBAction)sendSMSBtn:(id)sender {
    enteredSms = _enterMessage.text;
    NSLog(@"TExt%@",enteredSms);
    if([enteredSms isEqualToString:@"Type your message here"]){
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
            
            enteredSms= [NSString stringWithFormat:@"%@ %@",_selectModuleClick.titleLabel.text,enteredSms];
            NSLog(@"NO%@",@"NO");
            NSLog(@"Afer text%@",enteredSms);
            
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
- (IBAction)teacherSMSBtn:(id)sender {
    [self screenTappedOneTeacherSMS];
}

- (IBAction)schoolSMSBtn:(id)sender {
    [self screenTappedOnceSchoolSMS];
}

- (IBAction)downLloadSampleCSV:(id)sender {
//    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *filePath = [documentDir stringByAppendingPathComponent:@""];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://betweenus.in/Administrator/Files/sms_sample.csv"]];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if (error) {
//            NSLog(@"Download Error:%@",error.description);
//        }
//        if (data) {
//            [data writeToFile:filePath atomically:YES];
//            NSLog(@"File is saved to %@",filePath);
//        }
//    }];
    
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"/File"];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSURL *url = [NSURL URLWithString:@"http://betweenus.in/Administrator/Files/sms_sample.csv"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data)
    {
        stringPath = [stringPath stringByAppendingPathComponent:[url lastPathComponent]];
        [data writeToFile:stringPath atomically:YES];
        NSLog(@"File is saved to %@",stringPath);

    }
    
    NSString *destPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"/Dest"];
    error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:destPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:destPath withIntermediateDirectories:NO attributes:nil error:&error];
    destPath = [destPath stringByAppendingPathComponent:[stringPath lastPathComponent]];
    
    [[NSFileManager defaultManager] copyItemAtPath:stringPath toPath:destPath error:&error];
    NSLog(@"Desti Path %@",destPath);
    
    
    //NSString *file = [[NSString alloc] initWithContentsOfFile:yourCSVHere];
    
  //  NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
//    
//    NSData *dataPdf = [NSData dataWithContentsOfURL:@"http://betweenus.in/Administrator/Files/sms_sample.csv"];
//    
//    //Get path directory
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    //Create PDF_Documents directory
//    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"PDF_Documents"];
//    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
//    
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"sms_sample.csv"];
//    
//    NSLog(@" Path %@",filePath);
//    [dataPdf writeToFile:filePath atomically:YES];
    
    
    
}
- (IBAction)attachementBtn:(id)sender {
    
    
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
    

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        if(tableView == moduleTable){
             return 35;
        }
        else if(tableView == categoryTableView){
            return 30;
        }
       
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
        
    }
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    @try {
//        return [SMSTemplateArray count];
//    }  @catch (NSException *exception) {
//        NSLog(@"Exception: %@", exception);
//    }
//    
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    // Set up the cell...
//    cell.textLabel.text = [[SMSTemplateArray objectAtIndex:indexPath.row]objectForKey:@"Stm_template_name"];
//    return cell;
//}

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
  //  [controller.presentingViewController dismissViewControllerAnimated:YES completion:^{
        // [self didPickLocalURL:url];
        NSLog(@"URL  :  %@",url);
        uploadFilePath = url.absoluteString;
        
        NSLog(@"Path  :  %@",uploadFilePath);
        
        extension= [url pathExtension];
        extension = [NSString stringWithFormat: @"%@%@", @".", extension];
        
        filename =[[url lastPathComponent] stringByDeletingPathExtension];
        NSLog(@"Extension  :  %@",extension);
        NSLog(@"Filename  :  %@",filename);
        
        
        NSError *attributesError;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[url path] error:&attributesError];
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        fileSize = [NSByteCountFormatter stringFromByteCount:[fileAttributes fileSize] countStyle:NSByteCountFormatterCountStyleFile];
        NSLog(@"size   %@", fileSize);
        
        int fileSizeInt = [fileSize intValue];
        
        
        NSString *file = [[NSString alloc] initWithContentsOfFile:url];
        
       //  NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSArray *fields = [file componentsSeparatedByString:@","];
        for (id tempObject in fields) {
            NSLog(@"Single element: %@", tempObject);
        }
        for(int i =0;i<=fields.count;i++){
            contactList = [fields componentsJoinedByString:@","];
        }
         NSLog(@"Count   %@", contactList);
        
    
        itemData = [NSData dataWithContentsOfFile:url];
        
        
        NSUInteger len = [itemData length];
        Byte *bytedata = (Byte*)malloc(len);
        memcpy(bytedata,[itemData bytes], len);
        
        
        const unsigned char *bytes = [itemData bytes];
        // no need to copy the data
        NSUInteger length = [itemData length];
        byteArray = [NSMutableArray array];
        for (NSUInteger i = 0; i < length; i++) {
            [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
        }
        
        dic = [byteArray mutableCopy];
        
        base64String = [itemData base64EncodedStringWithOptions:0];
        
        base64String = [base64String stringByReplacingOccurrencesOfString:@"/"
                                                               withString:@"_"];
        
        base64String = [base64String stringByReplacingOccurrencesOfString:@"+"
                                                               withString:@"-"];
        
        NSLog(@"Base 64 :--   =%@", base64String);
        
        
        
        NSString *filesContent = [[NSString alloc] initWithContentsOfFile:url];
        // myMediaFile is a path to my file eg. .../Documents/myvideo.mp4/
        outputStream = [[NSOutputStream alloc] initToMemory];
        [outputStream setDelegate:self];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
        [outputStream open];
        NSData *data = [ filesContent dataUsingEncoding:NSASCIIStringEncoding        allowLossyConversion:YES];
        
        const uint8_t *buf = [data bytes];
        
        NSUInteger length1 = [data length];
        NSLog(@"datalen = %d",length1);
        NSInteger nwritten = [outputStream write:buf maxLength:length];
        
        if (-1 == nwritten) {
            NSLog(@"Error writing to stream %@: %@", outputStream, [outputStream streamError]);
        }else{
            NSLog(@"Wrote %ld bytes to stream %@.", outputStream);
        }
        
        
        if(fileSizeInt>500){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"File size is greater than 500KB" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if(!([extension isEqualToString:@".csv"])){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Upload only CSV Document" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            [self uploadFilewithData:byteArray];
        }
   // }];
    
}
-(void) uploadFilewithData:(NSMutableArray *)fileByteArray{
    //Pass The String to server
    NSString *urlString = app_url @"PodarApp.svc/UploadSmsCsvFile";
    
    newDatasetinfoTeacherUploadFile= [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",filename,@"Filename",extension,@"extension",nil];
    
    NSLog(@"the data Details is =%@", newDatasetinfoTeacherUploadFile);
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherUploadFile options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    
    [self checkWithServerUploadFile:urlString jsonString:jsonInputString fileData:fileByteArray];
    
}
-(void)checkWithServerUploadFile:(NSString *)urlname jsonString:(NSString *)jsonString fileData:(NSMutableArray *)fileByteArray{
    
    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err;
            NSData* responseData = nil;
            NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            responseData = [NSMutableData data] ;
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            
            
            [request setHTTPMethod:POST];
            
            
            NSString *boundary = @"---BOUNDARY";
            
            NSString *contentType = [NSString stringWithFormat:@"application/octet-stream; boundary=%@",boundary];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            [request addValue:clt_id forHTTPHeaderField:@"clt_id"];
            [request addValue:usl_id forHTTPHeaderField:@"usl_id"];
            [request setHTTPBody:itemData];
            
            
            NSURLResponse *response;
            
            responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
            
            //This is for Response
            NSLog(@"got response==%@", resSrt);
            
            NSError *error = nil;
            if(!responseData==nil){
                NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                
                uploadFileStatus = [parsedJsonArray valueForKey:@"Status"];
                uploadStatusMsg = [parsedJsonArray valueForKey:@"StatusMsg"];
                if([uploadFileStatus isEqualToString:@"1"]){
                    
                    NSLog(@"Status==%@", uploadFileStatus);
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:uploadStatusMsg preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
                else if([uploadFileStatus isEqualToString:@"0"]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:uploadStatusMsg preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                [hud hideAnimated:YES];
            }
        });
    });
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        if(tableView == categoryTableView){
            return [CategoryTableData count];
        }
        else if(tableView == moduleTable){
             return [SMSTemplateArray count];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if(tableView == categoryTableView){
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SiblingTableViewCell" owner:self options:nil];
                // cell = [nib objectAtIndex:0];
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
                
                
                [cell.textLabel setFont: [cell.textLabel.font fontWithSize: 14]];
                cell.textLabel.text =  [CategoryTableData objectAtIndex:indexPath.row];
                //[_selectCategory_Click setTitle:currentacademicYear forState:UIControlStateNormal];
            }
            return cell;
            
        }
        else if (tableView == moduleTable){
            static NSString *CellIdentifier = @"Cell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            // Set up the cell...
            cell.textLabel.text = [[SMSTemplateArray objectAtIndex:indexPath.row]objectForKey:@"Stm_template_name"];
            return cell;

        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 30;
//}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
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
        [_charachterLimit_label setHidden:NO];
        NSString *length  =[NSString stringWithFormat:@"%d",textView.text.length + (text.length - range.length) ];
        
        length=   [NSString stringWithFormat:@"%@/%@",length,@"132"];
        _charachterLimit_label.text = length;
        return textView.text.length + (text.length - range.length) < 132;
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == categoryTableView){
        category = [CategoryTableData objectAtIndex:indexPath.row];
        if([category isEqualToString:@"Student"]){
            NSLog(@"SelectedcycleCateg:%@",category);
            [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
            [_Categoryclick setTitle:category forState:UIControlStateNormal];
            
            AdminSchoolSMSViewController *adminSchoolSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMS"];
            
            [self.navigationController pushViewController:adminSchoolSMSViewController animated:NO];
            [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
        }
        else if([category isEqualToString:@"Teacher"]){
            NSLog(@"SelectedcycleCateg:%@",category);
            [_Categoryclick setTitle:category forState:UIControlStateNormal];
            
            AdminSchoolSMSTeacherViewController *adminSchoolSMSTeacherViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMSTeacher"];
            
            [self.navigationController pushViewController:adminSchoolSMSTeacherViewController animated:NO];
            [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
        }
        else if([category isEqualToString:@"Direct"]){
            NSLog(@"SelectedcycleCateg:%@",category);
            [_Categoryclick setTitle:category forState:UIControlStateNormal];
            
            AdminSchoolSMSDirectViewController *adminSchoolSMSDirectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMSDirect"];
            
            [self.navigationController pushViewController:adminSchoolSMSDirectViewController animated:NO];
            [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
    else if(tableView == moduleTable){
        selectedModule = @"";
        [alertmodule dismissWithClickedButtonIndex:0 animated:YES];
        selectedModule = [[SMSTemplateArray objectAtIndex:indexPath.row] objectForKey:@"Stm_template_name"];
        //_template_textfield.text = selectedModule;
         [_selectModuleClick setTitle:selectedModule forState:UIControlStateNormal];
        [_selectModuleClick setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       // _template_textfield.textColor = [UIColor blackColor];
    }
   
    
}

- (IBAction)selectModule:(id)sender {
    [self screenTappedOnceTeacherSMS_template];
}
@end
