//
//  AdminViewMessageViewController.m
//  BetweenUs
//
//  Created by podar on 19/09/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "AdminViewMessageViewController.h"
#import "CCKFNavDrawer.h"
#import "NavigationMenuButton.h"
#import "MBProgressHUD.h"
#import "WYPopoverController.h"
#import "RestAPI.h"
#import "ViewMessageResult.h"
#import "AdminMessageTableViewCell.h"
#import "MessageTableViewCell.h"
#import "DetailMessageViewController.h"
#import "ChangePassswordViewController.h"
#import "AdminProfileViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "AdminAnnouncementViewController.h"
#import "AdminSentMessagesViewController.h"
#import "AdminWriteMessageViewController.h"
#import "AdminSchoolSMSViewController.h"
#import "AdminDetailMessageViewController.h"

@interface AdminViewMessageViewController (){
    MBProgressHUD *hud;
    WYPopoverController *settingsPopoverController;
    UITapGestureRecognizer *tapGestRecog;
    NSDictionary *newDatasetinfoAdminViewMessages,*newDatasetinfoAdminLogout;
    BOOL loginClick;
   // AdminMessageTableViewCell *cell;
}
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (nonatomic, strong) ViewMessageResult *ViewMessageItems;
@property (nonatomic, strong) ViewMessageResult *ViewMessageDetails;
@property(nonatomic,strong)   MessageTableViewCell *cell;

@end

@implementation AdminViewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Hide back button
    [self checkInternetConnectivityViewMessage];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.title = @"Messages";
    
           self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];

    check = @"0";
    pageSize = @"500";
    pageNo=@"1";
    clt_id = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    AdminmessageClick = [[NSUserDefaults standardUserDefaults]stringForKey:@"AdminmessageClick"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];

    DeviceType= @"IOS";

    self.viewMessageTableView.delegate = self;
    self.viewMessageTableView.dataSource = self;
    
    //Click Event
    //SentMessages
    UITapGestureRecognizer *tapGestAdminSentMessages =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceASentMessages)];
    [tapGestAdminSentMessages setNumberOfTapsRequired:1];
    [_sentMessageClick addGestureRecognizer:tapGestAdminSentMessages];
    tapGestAdminSentMessages.delegate = self;
    
    //Write Message
    UITapGestureRecognizer *tapGestAdminWriteMessages =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOncewriteMessages)];
    [tapGestAdminWriteMessages setNumberOfTapsRequired:1];
    [_writeMessageClick addGestureRecognizer:tapGestAdminWriteMessages];
    tapGestAdminWriteMessages.delegate = self;
    
    [self webserviceCall];
  
}

-(void)handleDrawer{
    [self.rootNav drawerToggle];
    
}


-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
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

-(void)checkInternetConnectivityViewMessage{
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatusViewMessage:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
  
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
      
          //  [self webserviceCall];
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
    //    newDatasetinfoAdminLogout = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        //Pass The String to server
        newDatasetinfoAdminLogout= [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminLogout options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else{
    NSString *urlString = app_url @"PodarApp.svc/ViewAdminMessageDetails";
    
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
     MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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
            
            
            ViewMessageStatus = [parsedJsonArray valueForKey:@"Status"];
            ViewTableData = [receivedData objectForKey:@"ViewMessageResult"];
    
            [_viewMessageTableView reloadData];
             [hud hideAnimated:YES];
//            //saving is done on main thread
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES];
//            });
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
            
//            dateitems = [date componentsSeparatedByString:@" "];
//            fulldate = dateitems[0];
//            
//            
//            NSLog(@"firstdate==%@", fulldate);
//            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//            dateFormat.dateFormat = @"dd/MM/yyyy";
//            
//            NSDate *yourDate = [dateFormat dateFromString:fulldate];
//            
//            NSLog(@"your date%@",yourDate);
//            dateFormat.dateFormat = @"dd-MMM-yyyy";
//            NSLog(@"formated date%@",[dateFormat stringFromDate:yourDate]);
//            formatedDate = [dateFormat stringFromDate:yourDate];
        
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
                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(_cell.attachmentClick.frame.size.width-60, -25,44,40)];
                    
                    [_cell.attachmentClick addSubview:self.badgeCount];
                    self.badgeCount.value =  1;
                }
                else if(_cell.attachmentClick.hidden == YES){
                    if([device isEqualToString:@"ipad"]){
                        self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 610, -50,74,40)];
                        
                        [_cell.label_date addSubview:self.badgeCount];
                        self.badgeCount.value =  1;
                    }
                    else if([device isEqualToString:@"iphone"]){
//                        self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 180, -50,74,40)];
//                        
//                        [_cell.label_date addSubview:self.badgeCount];
//                        self.badgeCount.value =  1;
                        
                        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                        {
                            CGSize result = [[UIScreen mainScreen] bounds].size;
                            if(result.height == 568)
                            {
                                if(_cell.attachmentClick.hidden == YES){
                                    //self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 230, -25,44,40)];_cell.attachmentClick.frame.size.width-10
                                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width+140, -25,44,40)];
                                    [_cell.label_date addSubview:self.badgeCount];
                                    self.badgeCount.value =  1;
                                }
                                else if(_cell.attachmentClick.hidden == NO){
                                    //  self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 160, -50,74,40)];
                                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width-10, -25,44,40)];
                                    [_cell.label_date addSubview:self.badgeCount];
                                    self.badgeCount.value =  1;
                                    
                                }
                            }
                            if(result.height == 667){
                                if(_cell.attachmentClick.hidden == YES){
                                    //self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 230, -25,44,40)];_cell.attachmentClick.frame.size.width-10
                                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width+190, -25,44,40)];
                                    [_cell.label_date addSubview:self.badgeCount];
                                    self.badgeCount.value =  1;
                                }
                                else if(_cell.attachmentClick.hidden == NO){
                                    //  self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 160, -50,74,40)];
                                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width-10, -25,44,40)];
                                    [_cell.label_date addSubview:self.badgeCount];
                                    self.badgeCount.value =  1;
                                    
                                }
                            }
                            if(result.height == 736)
                            {
                                if(_cell.attachmentClick.hidden == YES){
                                    //self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 230, -25,44,40)];_cell.attachmentClick.frame.size.width-10
                                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width+230, -25,44,40)];
                                    [_cell.label_date addSubview:self.badgeCount];
                                    self.badgeCount.value =  1;
                                }
                                else if(_cell.attachmentClick.hidden == NO){
                                    //  self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 160, -50,74,40)];
                                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width-10, -25,44,40)];
                                    [_cell.label_date addSubview:self.badgeCount];
                                    self.badgeCount.value =  1;
                                    
                                }
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
        
        //   NSString *decodeString = [NSString alloc]initWithCString:ch encoding:NSUTF8StringEncoding];
        
        
        
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
        NSString     *urlToDownload = [@"http://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
    
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
-(void)viewWillAppear:(BOOL)animated{
    if([AdminmessageClick isEqualToString:@"1"]){
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
        stud_id = [[ViewTableData objectAtIndex:indexPath.row]objectForKey:@"stu_id"];
        dateitems = [date componentsSeparatedByString:@" "];
        fulldate = dateitems[0];
    
    AdminmessageClick = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:AdminmessageClick forKey:@"AdminMessageClick"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
        NSLog(@"firstdate==%@", fulldate);
    NSLog(@"sender==%@", senderName);
    
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





@end
