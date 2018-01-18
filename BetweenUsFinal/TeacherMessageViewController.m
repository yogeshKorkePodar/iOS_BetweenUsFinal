//
//  TeacherMessageViewController.m
//  BetweenUs
//
//  Created by podar on 29/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherMessageViewController.h"
#import "AdminDetailMessageViewController.h"
#import "NavigationMenuButton.h"
#import "ViewMessageResult.h"
#import "MessageTableViewCell.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "URL_Constant.h"
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

@interface TeacherMessageViewController ()
{
    BOOL loginClick;
    NSDictionary *newDatasetinfoTeacherLogout,*newDatasetinfoTeacherViewMessages;
    NSString *classTeacher;
}

@property (nonatomic, strong) ViewMessageResult *ViewMessageItems;
@property (nonatomic, strong) ViewMessageResult *ViewMessageDetails;
@property(nonatomic,strong)   MessageTableViewCell *cell;
@end

@implementation TeacherMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    DeviceType= @"IOS";
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    
    classTeacher = [[NSUserDefaults standardUserDefaults]stringForKey:@"classTeacher"];
    pageNo = @"1";
    pageSize = @"500";
    month = @"0";
    check = @"0";
    _teacherViewMessageTableView.delegate = self;
    _teacherViewMessageTableView.dataSource = self;
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
        
        [self webserviceCall];
    }
    
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
-(void) webserviceCall{
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
        newDatasetinfoTeacherViewMessages = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",month,@"month",pageNo,@"PageNo",pageSize,@"PageSize",check,@"check",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherViewMessages options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    
}

-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    
    if(loginClick == YES){
        loginClick = NO;
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherViewMessages options:kNilOptions error:&err];
                
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
                if(!responseData == nil){
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                    
                    
                    ViewMessageStatus = [parsedJsonArray valueForKey:@"Status"];
                    ViewTableData = [receivedData objectForKey:@"ViewMessageResult"];
                    
                    [_teacherViewMessageTableView reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        
        return [ViewTableData count];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        // static NSString *simpleTableIdentifier = @"MessageTableViewCell";
        
        _cell = (MessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (_cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil];
            _cell = [nib objectAtIndex:0];
        }
        _cell.attachmentClick.tag = indexPath.row;
        [_cell.attachmentClick addTarget:self action:@selector(attachment:) forControlEvents:UIControlEventTouchUpInside];
        [_cell.attachmentClick setTag:indexPath.row];
        
        senderName = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"Fullname"];
        date = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_date"];
        subject = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_subject"];
        message = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_Message"];
        msgReadStatus = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmu_readunreadstatus"];
        filename = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_file_name"];
        filePath = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_file_path"];
        [[NSUserDefaults standardUserDefaults] setObject:filePath forKey:@"filePath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:filename forKey:@"filename"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
      
        
        _cell.label_senderName.text = senderName;
        _cell.label_date.text = date;
        _cell.label_message.text = message;
        _cell.label_subject.text = subject;
        
        if([filePath isEqualToString:@""] || [filePath isEqualToString:@"0"]){
            [_cell.attachmentClick setHidden:YES];
        }
        else if(![filePath isEqualToString:@"0"]){
            [_cell.attachmentClick setHidden:NO];
        }
        
        NSLog(@"Read Status: %@", msgReadStatus);
        NSLog(@"filepath: %@", filePath);
        
        if([msgReadStatus isEqualToString:@"1"]){
            if(_cell.attachmentClick.hidden ==NO){
                if([device isEqualToString:@"ipad"]){
                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(_cell.attachmentClick.frame.size.width-60, -25,44,40)];
                    
                    [_cell.attachmentClick addSubview:self.badgeCount];
                    self.badgeCount.value =  1;
                    
                }
                else if([device isEqualToString:@"iphone"]){
                    
                    
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        CGSize result = [[UIScreen mainScreen] bounds].size;
                        if(result.height == 568)
                        {
                            //  self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 160, -50,74,40)];
                            self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width+160, -25,44,40)];
                            [_cell.label_date addSubview:self.badgeCount];
                            self.badgeCount.value =  1;
                            
                            
                        }
                        if(result.height == 667){
                            self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width+210, -25,44,40)];
                            [_cell.label_date addSubview:self.badgeCount];
                            self.badgeCount.value =  1;
                            
                        }
                        if(result.height == 736){
                            self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width+230, -25,44,40)];
                            [_cell.label_date addSubview:self.badgeCount];
                            self.badgeCount.value =  1;
                            
                        }
                        
                        
                        
                    }
                    
                    
                    //
                    //                   self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(_cell.attachmentClick.frame.size.width-120, -25,44,40)];
                    //
                    //                    [_cell.attachmentClick addSubview:self.badgeCount];
                    //                    self.badgeCount.value =  1;
                    //
                    
                    
                    
                }
            }
            else if(_cell.attachmentClick.hidden == YES){
                if([device isEqualToString:@"ipad"]){
                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 610, -50,74,40)];
                    
                    [_cell.label_date addSubview:self.badgeCount];
                    self.badgeCount.value =  1;
                }
                else if([device isEqualToString:@"iphone"]){
                    //                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 250, -50,74,40)];
                    //
                    //                    [_cell.label_date addSubview:self.badgeCount];
                    //                    self.badgeCount.value =  1;
                    //
                    //
                    
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        CGSize result = [[UIScreen mainScreen] bounds].size;
                        if(result.height == 568)
                        {
                            //  self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 160, -50,74,40)];
                            self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width+160, -25,44,40)];
                            [_cell.label_date addSubview:self.badgeCount];
                            self.badgeCount.value =  1;
                            
                        
                        }
                        if(result.height == 667){
                            self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 230, -50,74,40)];
                            [_cell.label_date addSubview:self.badgeCount];
                            self.badgeCount.value =  1;
                            
                        }
                        if(result.height == 736){
                            self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width+230, -25,44,40)];
                            [_cell.label_date addSubview:self.badgeCount];
                            self.badgeCount.value =  1;
                            
                        }
                        
                    }
                    
                }
            }
            
            [_cell.label_message setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
        }
        else if([msgReadStatus isEqualToString:@"0"]){
            [_cell.label_message setFont:[UIFont fontWithName:@"Arial" size:13]];
            //    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(_cell.label_date.frame.size.width - 28, -20,44,40)];
            //   [_cell.label_date addSubview:self.badgeCount];
            [_cell.label_date willRemoveSubview:self.badgeCount];
            //  self.badgeCount.value =  0;
        }
        return _cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}
-(void)attachment:(id)sender{
    //Unable to access sender.tag property }
    UIButton *btn = (UIButton*)sender;
    int row = btn.tag;
    filePath = [[ViewTableData objectAtIndex:row] objectForKey:@"pmg_file_path"];
    NSLog(@"Cell button clicked filepath: %@", filePath);
    filePath = [filePath stringByReplacingOccurrencesOfString:@"C:/inetpub/"
                                                   withString:@""];
    
    NSArray* foo = [filePath componentsSeparatedByString: @"Messages/"];
    NSString* firstBit = [foo objectAtIndex: 1];
    
    NSLog(@"first bit%@",firstBit);
    NSLog(@"File Path:%@",filePath);
    // hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        // NSString     *urlToDownload  = [@"https://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        NSString     *urlToDownload = [@"http://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        
        urlToDownload = [urlToDownload stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //  NSString *decodeString = [NSString alloc]initWithCString:ch encoding:NSUTF8StringEncoding];
        
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
    
    //   [hud hideAnimated:YES];
    
}

-(void)attachmentButtonClick{
    
    int row = _cell.attachmentClick.tag;
    NSString *strValue = [@(row) stringValue];
    NSLog(@"Cell row %@", strValue);
    
    NSLog(@"Cell button clicked: %@", @"Cell button clicked");
    filePath = [[ViewTableData objectAtIndex:_cell.attachmentClick.tag] objectForKey:@"pmg_file_path"];
    
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
        NSString     *urlToDownload = [@"http://www.betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        
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
        
        if ( urlData )
        {
            NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
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
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

-(void)viewWillAppear:(BOOL)animated{
    if([messageClick isEqualToString:@"1"]){
        [self webserviceCall];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    senderName = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"Fullname"];
    date = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_date"];
    subject = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_subject"];
    message = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_Message"];
    toUslId = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"usl_ID"];
    pmuId = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmu_ID"];
    filename = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_file_name"];
    filePath = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_file_path"];
    dateitems = [date componentsSeparatedByString:@" "];
    stud_id = [[ViewTableData objectAtIndex:indexPath.row]objectForKey:@"stu_id"];
    
    fulldate = dateitems[0];
    
    messageClick = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:messageClick forKey:@"AdminMessageClick"];
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
    
    //yo comment
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
    
    //yo comment
    
    //
    //            DetailMessageViewController *DetailMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail Message"];
    //
    //            DetailMessageViewController.usl_id = usl_id;
    //            DetailMessageViewController.clt_id = clt_id;
    //            DetailMessageViewController.message = message;
    //            DetailMessageViewController.sender_name  = senderName;
    //            DetailMessageViewController.subject = subject;
    //            DetailMessageViewController.date =  formatedDate;
    //            DetailMessageViewController.toUslId = toUslId;
    //            DetailMessageViewController.pmuId  = pmuId;
    //            DetailMessageViewController.filename = filename;
    //            DetailMessageViewController.filePath = filePath;
    //    
    //    
    //            [self.navigationController pushViewController:DetailMessageViewController animated:YES];
    //            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    if([classTeacher isEqualToString:@"1"]){
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
