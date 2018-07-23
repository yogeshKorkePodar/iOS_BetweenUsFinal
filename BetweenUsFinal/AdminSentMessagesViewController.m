//
//  AdminSentMessagesViewController.m
//  BetweenUs
//
//  Created by podar on 23/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "URL_Constant.h"
#import "AdminSentMessagesViewController.h"
#import "MBProgressHUD.h"
#import "AdminMessageTableViewCell.h"
#import "ViewMessageResult.h"
#import "NavigationMenuButton.h"
#import "RestAPI.h"
#import "AdminReceiverListViewController.h"
#import "AdminDetailMessageViewController.h"
#import "AdminMessageTableViewCell.h"

#import "TeacherBehaviourViewController.h"
#import "TeacherMessageViewController.h"
#import "LoginViewController.h"
#import "TeacherProfileViewController.h"
#import "TeacherAttendanceViewController.h"
#import "TeacherSubjectListViewController.h"
#import "TeacherAnnouncementViewController.h"
#import "AboutUsViewController.h"
#import "ChangePassswordViewController.h"
#import "DetailMessageViewController.h"
#import "TeacherSentMessageViewController.h"
#import "TeacherWriteMessageViewController.h"
#import "TeacherSMSViewController.h"
#import "TeacherProfileNoClassTeacherViewController.h"

//// admin imports starts here

#import "AdminProfileViewController.h"
#import "AdminViewMessageViewController.h"
#import "AdminAnnouncementViewController.h"
#import "AboutUsViewController.h"
#import "AdminWriteMessageViewController.h"
#import "AdminSchoolSMSViewController.h"

@interface AdminSentMessagesViewController ()
{
    MBProgressHUD *hud;
    UITapGestureRecognizer *tapGestRecog ;
    NSDictionary *newDatasetinfoAdminViewMessages,*newDatasetinfoAdminLogout;
    AdminMessageTableViewCell *cell;
    BOOL loginClick;

}

@property (nonatomic, strong) ViewMessageResult *SentMessageItems;
@property (nonatomic, strong) ViewMessageResult *ViewMessageDetails;
@end

@implementation AdminSentMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];
    
    
    check = @"1";
    pageSize = @"500";
    pageNo=@"1";
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    AdminsentmessageClick = [[NSUserDefaults standardUserDefaults]stringForKey:@"AdminmessageClick"];
    attachementClick = [[NSUserDefaults standardUserDefaults]stringForKey:@"AttachmentClick"];
    classTeacher = [[NSUserDefaults standardUserDefaults]stringForKey:@"classTeacher"];
    _adminLoggedIn =  [[NSUserDefaults standardUserDefaults]stringForKey:@"adminLoggedIn"];

    DeviceType= @"IOS";
    
    self.adminSentMessageTableView.delegate = self;
    self.adminSentMessageTableView.dataSource = self;
    
    [self checkInternetConnectivity];

}

-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
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
            self.internetActiveViewMessage = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActiveViewMessage = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActiveViewMessage = YES;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActiveViewMessage = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActiveViewMessage = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActiveViewMessage = YES;
            
            break;
        }
    }
    if(self.internetActiveViewMessage == YES){
        
        [self webserviceCall];
    }
    
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

-(void)webserviceCall{
    if(loginClick==YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *urlString = app_url @"LogOut";
        //    newDatasetinfoAdminLogout = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        //Pass The String to server
        newDatasetinfoAdminLogout= [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminLogout options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else{
        NSString *urlString = app_url @"ViewAdminMessageDetails";
        
        //Pass The String to server
        newDatasetinfoAdminViewMessages = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",pageNo,@"PageNo",pageSize,@"PageSize",check,@"check",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminViewMessages options:NSJSONWritingPrettyPrinted error:&error];
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
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminViewMessages options:kNilOptions error:&err];
                
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
                    
                    SentMessageStatus = [parsedJsonArray valueForKey:@"Status"];
                    SentTableData = [receivedData objectForKey:@"ViewMessageResult"];
                    if([SentMessageStatus isEqualToString:@"1"]){
                        for(int n = 0; n < [SentTableData count]; n++)
                        {
                            _SentMessageItems = [[ViewMessageResult alloc]init];
                            sentmessagedetails = [SentTableData objectAtIndex:n];
                            _SentMessageItems.Fullname = [sentmessagedetails objectForKey:@"Fullname"];
                            _SentMessageItems.pmg_subject =[sentmessagedetails objectForKey:@"pmg_subject"];
                            _SentMessageItems.pmg_date =[sentmessagedetails objectForKey:@"pmg_date"];
                            _SentMessageItems.pmg_Message =[sentmessagedetails objectForKey:@"pmg_Message"];
                            _SentMessageItems.pmg_file_name =[sentmessagedetails objectForKey:@"pmg_file_name"];
                            _SentMessageItems.pmg_file_path =[sentmessagedetails objectForKey:@"pmg_file_path"];
                            _SentMessageItems.pmu_readunredStatus = [sentmessagedetails objectForKey:@"pmu_readunreadstatus"];
                            msgReadStatus = _SentMessageItems.pmu_readunredStatus;
                            NSLog(@"Message:%@", _SentMessageItems.pmg_Message);
                            // [_label_NoRecords setHidden:YES];
                            
                        }
                    }
                    [_adminSentMessageTableView reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        return [SentTableData count];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        // static NSString *simpleTableIdentifier = @"MessageTableViewCell";
        
        cell = (AdminMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminMessageTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.attachment_click.tag = indexPath.row;
        cell.reciverList_view.tag = indexPath.row;
        [cell.attachment_click addTarget:self action:@selector(attachment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.receiver_click addTarget:self action:@selector(receiverList:) forControlEvents:UIControlEventTouchUpInside];
        [cell.attachment_click setTag:indexPath.row];
        [cell.receiver_click setTag:indexPath.row];
        
        senderName = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"Fullname"];
        date = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_date"];
        subject = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_subject"];
        message = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_Message"];
        msgReadStatus = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmu_readunreadstatus"];
        filename = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_file_name"];
        filePath = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_file_path"];
        [[NSUserDefaults standardUserDefaults] setObject:filePath forKey:@"filePath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:filename forKey:@"filename"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //        dateitems = [date componentsSeparatedByString:@" "];
        //        fulldate = dateitems[0];
        //
        //
        //        NSLog(@"firstdate==%@", fulldate);
        //        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //        dateFormat.dateFormat = @"dd/MM/yyyy";
        //
        //        NSDate *yourDate = [dateFormat dateFromString:fulldate];
        //
        //        NSLog(@"your date%@",yourDate);
        //        dateFormat.dateFormat = @"dd-MMM-yyyy";
        //        NSLog(@"formated date%@",[dateFormat stringFromDate:yourDate]);
        //        formatedDate = [dateFormat stringFromDate:yourDate];
        //
        cell.label_name.text = senderName;
        cell.label_date.text = date;
        cell.message_label.text = message;
        cell.label_subj.text = subject;
        
        if([filePath isEqualToString:@""] || [filePath isEqualToString:@"0"]){
            [cell.attachment_click setHidden:YES];
        }
        else if(![filePath isEqualToString:@"0"]){
            [cell.attachment_click setHidden:NO];
        }
        
        
        NSLog(@"Read Status: %@", msgReadStatus);
        NSLog(@"filepath: %@", filePath);
        if([msgReadStatus isEqualToString:@"1"]){
            if(cell.attachment_click.hidden ==NO){
                self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(cell.attachment_click.frame.size.width-60, -25,44,40)];
                
                [cell.attachment_click addSubview:self.badgeCount];
                self.badgeCount.value =  1;
            }
            else if(cell.attachment_click.hidden == YES){
                if([device isEqualToString:@"ipad"]){
                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 580, -50,74,40)];
                    
                    [cell.label_date addSubview:self.badgeCount];
                    self.badgeCount.value =  1;
                }
                else if([device isEqualToString:@"iphone"]){
                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 180, -50,74,40)];
                    
                    [cell.label_date addSubview:self.badgeCount];
                    self.badgeCount.value =  1;
                }
            }
            
            [cell.message_label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
        }
        else if([msgReadStatus isEqualToString:@"0"]){
            [cell.message_label setFont:[UIFont fontWithName:@"Arial" size:13]];
            //    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(_cell.label_date.frame.size.width - 28, -20,44,40)];
            //   [_cell.label_date addSubview:self.badgeCount];
            [cell.label_date willRemoveSubview:self.badgeCount];
            //  self.badgeCount.value =  0;
            
            
            
            
        }
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

-(void)receiverList:(id)sender{
    //Unable to access sender.tag property }
    UIButton *btn = (UIButton*)sender;
    int row = btn.tag;
    pmg_id = [[SentTableData objectAtIndex:row] objectForKey:@"pmg_ID"];
    [[NSUserDefaults standardUserDefaults] setObject:pmg_id forKey:@"pmg_Id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"PmgID: %@", pmg_id);
    
    AdminReceiverListViewController *adminReceiverListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Receiver"];
    [self.navigationController pushViewController:adminReceiverListViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
}

-(void)attachment:(id)sender{
    //Unable to access sender.tag property }
    UIButton *btn = (UIButton*)sender;
    int row = btn.tag;
    attachementClick = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:attachementClick forKey:@"AttachmentClick"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    filePath = [[SentTableData objectAtIndex:row] objectForKey:@"pmg_file_path"];
    NSLog(@"Cell button clicked filepath: %@", filePath);
    filePath = [filePath stringByReplacingOccurrencesOfString:@"C:/inetpub/"
                                                   withString:@""];
    
    NSArray* foo = [filePath componentsSeparatedByString: @"Messages/"];
    NSString* firstBit = [foo objectAtIndex: 1];
    
    NSLog(@"first bit%@",firstBit);
    NSLog(@"File Path:%@",filePath);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"??Downloading Started");
        // NSString     *urlToDownload  = [@"https://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        NSString     *urlToDownload = [@"http://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        
        //urlToDownload = [urlToDownload stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"??UrlTodownload:%@",urlToDownload);
        
        NSURL *url = [NSURL URLWithString:urlToDownload];
        
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        
        NSLog(@"Url:%@",url);
        [[UIApplication sharedApplication] openURL:url];
        //saving is done on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            NSLog(@"File Saved !");
        });
        
        //  [hud hideAnimated:YES];
        if ( urlData )
        {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePathnew = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.png"];
            NSLog(@"filepathnew %@",filePathnew);
            
            
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePathnew atomically:YES];
                [hud hideAnimated:YES];
                NSLog(@"File Saved !");
            });
        }
        
    });
    
    //   [hud hideAnimated:YES];
    
}

-(void)attachmentButtonClick{
    
    int row = cell.attachment_click.tag;
    NSString *strValue = [@(row) stringValue];
    NSLog(@"<<Cell row %@", strValue);
    
    NSLog(@"<<Cell button clicked: %@", @"Cell button clicked");
    filePath = [[SentTableData objectAtIndex:cell.attachment_click.tag] objectForKey:@"pmg_file_path"];
    
    NSLog(@"Cell button clicked filepath: %@", filePath);
    
    
    filePath = [filePath stringByReplacingOccurrencesOfString:@"C:/inetpub/"
                                                   withString:@""];
    
    NSArray* foo = [filePath componentsSeparatedByString: @"Messages/"];
    NSString* firstBit = [foo objectAtIndex: 1];
    
    NSLog(@"first bit%@",firstBit);
    NSLog(@"File Path:%@",filePath);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        
        // NSString     *urlToDownload  = [@"https://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        NSString     *urlToDownload = [@"http://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        
        //    urlToDownload = [urlToDownload stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //  NSURL *url = [[NSURL alloc] initWithString:[urlToDownload stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        NSLog(@"<<UrlTodownload:%@",urlToDownload);
        
        NSURL *url = [NSURL URLWithString:urlToDownload];
        
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        
        NSLog(@"<<Url:%@",url);
        [[UIApplication sharedApplication] openURL:url];
        
        if ( urlData )
        {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePathnew = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.png"];
            NSLog(@"filepathnew %@",filePathnew);
            
            
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePathnew atomically:YES];
                [hud hideAnimated:YES];
                NSLog(@"File Saved !");
                [hud hideAnimated:YES];
            });
        }
        
    });
    //  [hud hideAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self webserviceCall];
    //    if([sentmessageClick isEqualToString:@"1"]){
    //    [self webserviceCall];
    //        sentmessageClick = @"0";
    //        [[NSUserDefaults standardUserDefaults] setObject:sentmessageClick forKey:@"SentMessageClick"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //    }
    //    else if([attachementClick isEqualToString:@"1"]){
    //        [self webserviceCall];
    //        attachementClick = @"0";
    //        [[NSUserDefaults standardUserDefaults] setObject:attachementClick forKey:@"AttachmentClick"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    senderName = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"Fullname"];
    date = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_date"];
    subject = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_subject"];
    message = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_Message"];
    toUslId = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"usl_ID"];
    pmuId = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmu_ID"];
    pmg_id = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_ID"];
    filename = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_file_name"];
    filePath = [[SentTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_file_path"];
    dateitems = [date componentsSeparatedByString:@" "];
    stud_id = [[SentTableData objectAtIndex:indexPath.row]objectForKey:@"stu_id"];
    
    fulldate = dateitems[0];
    AdminsentmessageClick =@"0";
    [[NSUserDefaults standardUserDefaults] setObject:AdminsentmessageClick forKey:@"AdminMessageClick"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    NSLog(@"firstdate==%@", fulldate);
    //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //    dateFormat.dateFormat = @"dd/MM/yyyy";
    //
    //    NSDate *yourDate = [dateFormat dateFromString:fulldate];
    //
    //    NSLog(@"your date%@",yourDate);
    //    dateFormat.dateFormat = @"dd-MMM-yyyy";
    //    NSLog(@"formated date%@",[dateFormat stringFromDate:yourDate]);
    //    formatedDate = [dateFormat stringFromDate:yourDate];
    //
    //    DetailMessageViewController *DetailMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail Message"];
    //
    //    DetailMessageViewController.usl_id = usl_id;
    //    DetailMessageViewController.clt_id = clt_id;
    //    DetailMessageViewController.message = message;
    //    DetailMessageViewController.sender_name  = senderName;
    //    DetailMessageViewController.subject = subject;
    //    DetailMessageViewController.date =  formatedDate;
    //    DetailMessageViewController.toUslId = toUslId;
    //    DetailMessageViewController.pmuId  = pmuId;
    //    DetailMessageViewController.filename = filename;
    //    DetailMessageViewController.filePath = filePath;
    //
    //
    //    [self.navigationController pushViewController:DetailMessageViewController animated:YES];
    //    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    AdminDetailMessageViewController  *AdminDetailMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminDetail Message"];
    AdminDetailMessageViewController.usl_id = usl_id;
    AdminDetailMessageViewController.clt_id = clt_id;
    AdminDetailMessageViewController.message = message;
    AdminDetailMessageViewController.sender_name  = senderName;
    AdminDetailMessageViewController.subject = subject;
    AdminDetailMessageViewController.date =  date;
    AdminDetailMessageViewController.toUslId = toUslId;
    AdminDetailMessageViewController.pmuId  = pmuId;
    AdminDetailMessageViewController.filename = filename;
    AdminDetailMessageViewController.filePath = filePath;
    AdminDetailMessageViewController.stud_id = stud_id;
    
    [self.navigationController pushViewController:AdminDetailMessageViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    
}



-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    
    if([_adminLoggedIn isEqualToString:@"true"]){
        
        
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
            NSLog(@"<<<<< About Us clicked >>>>>>>>");
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                
                AboutUsViewController *aboutus = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs1"];
                UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:aboutus];/*Here dateVC is controller you want to show in popover*/
                aboutus.preferredContentSize = CGSizeMake(320,300);
                destNav.modalPresentationStyle = UIModalPresentationPopover;
                _aboutUsPopOver = destNav.popoverPresentationController;
                _aboutUsPopOver.delegate = self;
                _aboutUsPopOver.sourceView = self.view;
                _aboutUsPopOver.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0);
                destNav.navigationBarHidden = YES;
                _aboutUsPopOver.permittedArrowDirections = 0;
                [self presentViewController:destNav animated:YES completion:nil];
            }
            else{
                
                AboutUsViewController *aboutus = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs2"];
                [self.navigationController pushViewController:aboutus animated:YES];
                
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
        }
        
    }
    
    else if([classTeacher isEqualToString:@"1"]){
        if(selectionIndex == 0){
            
            TeacherProfileViewController *teacherProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherProfile"];
            [self.navigationController pushViewController:teacherProfileViewController animated:YES];
        }
        else if(selectionIndex == 1){
            // Messsage
            TeacherMessageViewController *teacherMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherViewMessage"];
            
            [self.navigationController pushViewController:teacherMessageViewController animated:YES];
        }
        else if(selectionIndex == 2){
            //sms
            TeacherSMSViewController *teacherSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherSMS"];
            [self.navigationController pushViewController:teacherSMSViewController animated:YES];
        }
        else if(selectionIndex == 3){
            TeacherAnnouncementViewController *teacherAnnouncementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAnnouncement"];
            
            [self.navigationController pushViewController:teacherAnnouncementViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        
        else if(selectionIndex == 4){
            TeacherAttendanceViewController *teacherAttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAttendance"];
            [self.navigationController pushViewController:teacherAttendanceViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 5){
            //Behaviour
            TeacherBehaviourViewController *teacherBehaviourViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherBehaviour"];
            [self.navigationController pushViewController:teacherBehaviourViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 6){
            //SubjectList
            TeacherSubjectListViewController *teacherSubjectListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherSubjectList"];
            [self.navigationController pushViewController:teacherSubjectListViewController animated:YES];
            
        }
        else if(selectionIndex == 7){
            //Setting
            ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
            [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 8){
            loginClick = YES;
            [self webserviceCall];
            LoginViewController *LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [self.navigationController pushViewController:LoginViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 9){
            NSLog(@"<<<<< About Us clicked >>>>>>>>");
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                AboutUsViewController *aboutus = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs1"];
                UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:aboutus];/*Here dateVC is controller you want to show in popover*/
                aboutus.preferredContentSize = CGSizeMake(320,300);
                destNav.modalPresentationStyle = UIModalPresentationPopover;
                _aboutUsPopOver = destNav.popoverPresentationController;
                _aboutUsPopOver.delegate = self;
                _aboutUsPopOver.sourceView = self.view;
                _aboutUsPopOver.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0);
                destNav.navigationBarHidden = YES;
                _aboutUsPopOver.permittedArrowDirections = 0;
                [self presentViewController:destNav animated:YES completion:nil];
            }
            else{
                
                AboutUsViewController *aboutus = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs2"];
                [self.navigationController pushViewController:aboutus animated:YES];
                
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
        }
    }
    else if ([classTeacher isEqualToString:@"0"])
    {
        if(selectionIndex == 0){
            
            TeacherProfileNoClassTeacherViewController *teacherProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherNoClassProfile"];
            [self.navigationController pushViewController:teacherProfileViewController animated:YES];
        }
        else if(selectionIndex == 1){
            // Messsage
            
            TeacherMessageViewController *teacherMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherViewMessage"];
            
            [self.navigationController pushViewController:teacherMessageViewController animated:YES];
        }
        else if(selectionIndex == 2){
            //sms
            TeacherSMSViewController *teacherSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherSMS"];
            [self.navigationController pushViewController:teacherSMSViewController animated:YES];
        }
        else if(selectionIndex == 3){
            TeacherAnnouncementViewController *teacherAnnouncementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAnnouncement"];
            
            [self.navigationController pushViewController:teacherAnnouncementViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        
        else if(selectionIndex == 4){
            //SubjectList
            TeacherSubjectListViewController *teacherSubjectListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherSubjectList"];
            [self.navigationController pushViewController:teacherSubjectListViewController animated:YES];
        }
        else if(selectionIndex == 5){
            //Setting
            ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
            [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 6){
            loginClick = YES;
            [self webserviceCall];
            LoginViewController *LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [self.navigationController pushViewController:LoginViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 7){
            NSLog(@"<<<<< About Us clicked >>>>>>>>");
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                
                AboutUsViewController *aboutus = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs1"];
                UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:aboutus];/*Here dateVC is controller you want to show in popover*/
                aboutus.preferredContentSize = CGSizeMake(320,300);
                destNav.modalPresentationStyle = UIModalPresentationPopover;
                _aboutUsPopOver = destNav.popoverPresentationController;
                _aboutUsPopOver.delegate = self;
                _aboutUsPopOver.sourceView = self.view;
                _aboutUsPopOver.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0);
                destNav.navigationBarHidden = YES;
                _aboutUsPopOver.permittedArrowDirections = 0;
                [self presentViewController:destNav animated:YES completion:nil];
            }
            else{
                
                AboutUsViewController *aboutus = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs2"];
                [self.navigationController pushViewController:aboutus animated:YES];
                
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
        }
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
