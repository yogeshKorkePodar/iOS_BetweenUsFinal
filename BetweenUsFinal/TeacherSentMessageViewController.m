//
//  TeacherSentMessageViewController.m
//  BetweenUs
//
//  Created by podar on 17/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherSentMessageViewController.h"
#import "NavigationMenuButton.h"
#import "ViewMessageResult.h"
#import "AdminMessageTableViewCell.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "AdminReceiverListViewController.h"
#import "URL_Constant.h"

@interface TeacherSentMessageViewController ()
{
    BOOL loginClick;
    NSDictionary *newDatasetinfoTeacherLogout,*newDatasetinfoTeacherSentMessages;
    AdminMessageTableViewCell *cell;

}
@property (nonatomic, strong) ViewMessageResult *SentMessageItems;
@property (nonatomic, strong) ViewMessageResult *ViewMessageDetails;

@end

@implementation TeacherSentMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];
    
    
    check = @"1";
    pageSize = @"500";
    pageNo=@"1";
    month = @"0";
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    sentmessageClick = [[NSUserDefaults standardUserDefaults]stringForKey:@"SentMessageClick"];
    attachementClick = [[NSUserDefaults standardUserDefaults]stringForKey:@"AttachmentClick"];
    
    classTeacher = [[NSUserDefaults standardUserDefaults]stringForKey:@"classTeacher"];
    DeviceType= @"IOS";
    
    self.teacherSentMessageTableView.delegate = self;
    self.teacherSentMessageTableView.dataSource = self;
    
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
            self.internetActive= YES;
            
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
            self.hostActive= YES;
            
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
        NSString *urlString = app_url @"PodarApp.svc/LogOut";
        
        //Pass The String to server
        newDatasetinfoTeacherLogout= [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherLogout options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else{
        NSString *urlString = app_url @"PodarApp.svc/GetSentMessageDataTeacher";
        
        //Pass The String to server
        newDatasetinfoTeacherSentMessages = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",month,@"month",pageNo,@"PageNo",pageSize,@"PageSize",check,@"check",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherSentMessages options:NSJSONWritingPrettyPrinted error:&error];
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
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherLogout options:kNilOptions error:&err];
                
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
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherSentMessages options:kNilOptions error:&err];
                
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
                    else if([SentMessageStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    }
                    [_teacherSentMessageTableView reloadData];
                    
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
        NSLog(@"Downloading Started");
        // NSString     *urlToDownload  = [@"https://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        NSString     *urlToDownload = [@"http://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        
        urlToDownload = [urlToDownload stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"UrlTodownload:%@",urlToDownload);
        
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
    NSLog(@"Cell row %@", strValue);
    
    NSLog(@"Cell button clicked: %@", @"Cell button clicked");
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
        NSLog(@"UrlTodownload:%@",urlToDownload);
        
        NSURL *url = [NSURL URLWithString:urlToDownload];
        
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        
        NSLog(@"Url:%@",url);
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
    sentmessageClick =@"0";
    [[NSUserDefaults standardUserDefaults] setObject:sentmessageClick forKey:@"AdminMessageClick"];
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
    
    //yo comment
//    AdminDetailMessageViewController  *AdminDetailMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminDetail Message"];
//    AdminDetailMessageViewController.usl_id = usl_id;
//    AdminDetailMessageViewController.clt_id = clt_id;
//    AdminDetailMessageViewController.message = message;
//    AdminDetailMessageViewController.sender_name  = senderName;
//    AdminDetailMessageViewController.subject = subject;
//    AdminDetailMessageViewController.date =  date;
//    AdminDetailMessageViewController.toUslId = toUslId;
//    AdminDetailMessageViewController.pmuId  = pmuId;
//    AdminDetailMessageViewController.filename = filename;
//    AdminDetailMessageViewController.filePath = filePath;
//    AdminDetailMessageViewController.stud_id = stud_id;
//    
//    [self.navigationController pushViewController:AdminDetailMessageViewController animated:YES];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    //yo comment
    
    
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
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
