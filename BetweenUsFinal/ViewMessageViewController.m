//
//  ViewMessageViewController.m
//  BetweenUsFinal
//
//  Created by podar on 18/08/17.
//  Copyright © 2017 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "ViewMessageViewController.h"
#import "LoginViewController.h"
#import "StudentDashboardWithoutSibling.h"
#import "ViewMessageViewController.h"
#import "PaymentInfoViewController.h"
#import "ViewAttendanceViewController.h"
#import "StudentInformationViewController.h"
#import "ChangePassswordViewController.h"
#import "RestAPI.h"
#import "stundentListDetails.h"
#import "CCKFNavDrawer.h"
#import "DrawerView.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AnnouncementViewController.h"
#import "BehaviourViewController.h"
#import "RestAPI.h"
#import "MessageTableViewCell.h"
#import "MonthTableViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "DateDropdownValueDetails.h"
#import "DetailMessageViewController.h"
#import "AboutUsViewController.h"
#import "StudentProfileWithSiblingViewController.h"
#import "SiblingStudentViewController.h"
#import "StudentResourcesViewController.h"


@interface ViewMessageViewController ()

@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) DateDropdownValueDetails *DateDropdownValueDetails;
@property (nonatomic, strong) DateDropdownValueDetails *DateDropdownItems;
@property (nonatomic, strong) ViewMessageResult *ViewMessageItems;
@property (nonatomic, strong) ViewMessageResult *ViewMessageDetails;
@property(nonatomic,strong)   MessageTableViewCell *cell;

@end

@implementation ViewMessageViewController{

   BOOL monthselecteed,firstTime,isMonthSelected,loginClick,firstWebcall;
   BOOL behaviour,attendace,announcement,messageBool,viewMessage,writeMessage,sentMessage;
   MBProgressHUD *hud;
}

@synthesize clt_id, msd_id, usl_id, brdName;

-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

    if(item.tag==1)
    {
        NSLog(@"First tab selected");
        ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
//        ViewMessageViewController.msd_id = msd_id;
//        ViewMessageViewController.usl_id = usl_id;
//        ViewMessageViewController.clt_id = clt_id;
//        ViewMessageViewController.brdName = brd_Name;
        [self.navigationController pushViewController:ViewMessageViewController animated:NO];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
//

    }
    else if(item.tag==2)

    {
        NSLog(@"Second tab selected");
        
        AnnouncementViewController *AnnouncementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Announcement"];
//        AnnouncementViewController.msd_id = msd_id;
//        AnnouncementViewController.usl_id = usl_id;
//        AnnouncementViewController.clt_id = clt_id;
//        AnnouncementViewController.brd_name = brd_Name;
        [self.navigationController pushViewController:AnnouncementViewController animated:NO];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];


    }
    else if(item.tag==3)
        
    {
        NSLog(@"Third tab selected");
        ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
//        AttendanceViewController.msd_id = msd_id;
//        AttendanceViewController.usl_id = usl_id;
//        AttendanceViewController.clt_id = clt_id;
//        AttendanceViewController.brd_Name = brd_Name;
        [self.navigationController pushViewController:AttendanceViewController animated:NO];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

        
    }
    else if(item.tag==4)
        
    {
        NSLog(@"Fourth tab selected");
        BehaviourViewController *BehaviourViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Behaviour"];
//        BehaviourViewController.msd_id = msd_id;
//        BehaviourViewController.usl_id = usl_id;
//        BehaviourViewController.clt_id = clt_id;
//        BehaviourViewController.brd_name = brd_Name;
        [self.navigationController pushViewController:BehaviourViewController animated:NO];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }


}

-(void)viewWillAppear:(BOOL)animated{
    firstTime = YES;
    [self httpPostRequest];
    }

- (void)viewDidLoad {
    
    _my_tabBar.delegate = self;
    _my_tabBar.selectedItem = [_my_tabBar.items objectAtIndex:0];
          [super viewDidLoad];
    
    self.selectMonthTableData.tableFooterView = [UIView new];
    self.viewMessageTable.tableFooterView = [UIView new];
    
    firstWebcall = YES;
    [self checkInternetConnectivityViewMessage];

    
    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    // Do any additional setup after loading the view.
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"white-menu-icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 25)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    msd_id = msd_id;
    usl_id = usl_id;
    clt_id = clt_id;
    brdName = brdName;
    firstTime = YES;
    check = @"0";
    pageNo = @"1";
    pageSize = @"300";
    
    msd_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"msd_Id"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    
    school_name = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"school_name"];
    
    brdName = [[NSUserDefaults standardUserDefaults]
               stringForKey:@"brd_name"];
    
    stdName = [[NSUserDefaults standardUserDefaults] stringForKey:@"std"];
    
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
    
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    
    announcementCount = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"announcementCount"];
    behaviourCount = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"behaviourCount"];
    
    
    DeviceType= @"IOS";

    
    NSDate *currentDate = [NSDate date];
    NSLog(@"Current Date = %@", currentDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:currentDate];
    [formatter setDateFormat:@"MM"];
    monthid = [formatter stringFromDate:currentDate];
    [formatter setDateFormat:@"dd"];
    day = [formatter stringFromDate:currentDate];
    [formatter setDateFormat:@"MMM"];
    NSString *monthYear = [formatter stringFromDate:currentDate];
    NSLog(@"Current Month = %@", monthid);
    NSLog(@"Current MonthYEar = %@", monthYear);
    monthYear = [NSString stringWithFormat: @"%@-%@ ", monthYear,year];
    NSLog(@"Current MonthYEar11 = %@", monthYear);
    [_SelectMonth setTitle:monthYear forState:UIControlStateNormal];

    [_selectMonthTableData setHidden:YES];
    self.viewMessageTable.delegate = self;
    self.viewMessageTable.dataSource = self;
    self.selectMonthTableData.dataSource = self;
    self.selectMonthTableData.delegate = self;
    _viewMessageConstraint.constant = 8;
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
}


-(void)checkInternetConnectivityViewMessage{
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
        if(firstWebcall == YES){
            firstWebcall = NO;
            [self httpPostRequest];
        }
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

-(void) httpPostRequest{
    //Create the response and Error
    if(firstTime == YES){
        firstWebcall = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSString *str =app_url @"PodarApp.svc/GetViewMessageData";
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:str];
                
                //Pass The String to server
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",msd_id,@"msd_id",monthid,@"month",check,@"check",pageNo,@"PageNo",pageSize,@"PageSize",nil];
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
                NSLog(@"got datedropdown==%@", resSrt);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  [urlData writeToFile:filePathnew atomically:YES];
                    [hud hideAnimated:YES];
                    // NSLog(@"File Saved !");
                });
            });
        });
        
    }
    else if(monthselecteed == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSString *str =app_url @"PodarApp.svc/GetDateDropdownValue";
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:str];
                
                //Pass The String to server
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",msd_id,@"msd_id",brdName,@"brd_name",nil];
                NSLog(@"the dropdown Details is =%@", newDatasetInfo);
                
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
                NSLog(@"got datedropdownresponse==%@", resSrt);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  [urlData writeToFile:filePathnew atomically:YES];
                    [hud hideAnimated:YES];
                    // NSLog(@"File Saved !");
                });
            });
        });
    }
    else if(isMonthSelected == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSString *str =app_url @"PodarApp.svc/GetViewMessageData";
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:str];
                
                //Pass The String to server
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",msd_id,@"msd_id",monthid,@"month",check,@"check",pageNo,@"PageNo",pageSize,@"PageSize",nil];
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
                NSLog(@"got datedropdown==%@", resSrt);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  [urlData writeToFile:filePathnew atomically:YES];
                    [hud hideAnimated:YES];
                    // NSLog(@"File Saved !");
                });
            });
        });
    }
    
    else if([ViewMessageStatus isEqualToString:@"0"]){
        
        [_SelectMonth setTitle:@"Select Month" forState:UIControlStateNormal];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSError *err;
        NSString *str =app_url @"PodarApp.svc/GetLastViewMessageData";
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:str];
        
        //Pass The String to server
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",msd_id,@"msd_id",@"",@"month",check,@"check",pageNo,@"PageNo",pageSize,@"PageSize",nil];
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
        NSLog(@"got datedropdown==%@", resSrt);
        [hud hideAnimated:YES];
        
        NSError *error = nil;
        NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
        
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
        LastViewMessageStatus= [parsedJsonArray valueForKey:@"Status"];
        NSLog(@"Status:%@",LastViewMessageStatus);
        
        ViewTableData = [receivedData objectForKey:@"ViewMessageResult"];
        //  NSLog(@"Size sibling:%lu",(unsigned long)[behaviourdetails count]);
        if([LastViewMessageStatus isEqualToString:@"1"]){
            ViewMessageStatus = @"1";
            for(int n = 0; n < [ViewTableData  count]; n++)
            {
                _ViewMessageItems= [[ViewMessageResult alloc]init];
                viewmessagedetails = [ViewTableData
                                      objectAtIndex:n];
                _ViewMessageItems.pmg_Message = [viewmessagedetails objectForKey:@"pmg_Message"];
                NSLog(@"Message:%@",  _ViewMessageItems.pmg_Message);
            }
        }
        else if([LastViewMessageStatus isEqualToString:@"0"]){
            
            _viewMessageConstraint.constant = 8;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        [self.viewMessageTable reloadData];
        
    }
    
    else if(loginClick == YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        loginClick = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSError *err;
        NSString *str =app_url @"PodarApp.svc/LogOut";
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:str];
        
        //Pass The String to server
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
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
        NSLog(@"got logout==%@", resSrt);
        
        [hud hideAnimated:YES];
    }
    
}

-(void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender
{
    if(monthselecteed == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        monthselecteed = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = nil;
                NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
                //    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                            (NSJSONReadingMutableContainers) error:&error];
                DropdownStatus = [parsedJsonArray valueForKey:@"Status"];
                MonthTableData = [receivedData objectForKey:@"DateDropdownValueDetails"];
                if([DropdownStatus isEqualToString:@"1"]){
                    for(int n = 0; n < [MonthTableData count]; n++)
                    {
                        _DateDropdownItems = [[DateDropdownValueDetails alloc]init];
                        dropdowndetails = [MonthTableData objectAtIndex:n];
                        _DateDropdownItems.monthid = [dropdowndetails objectForKey:@"monthid"];
                        _DateDropdownItems.MonthsName =[dropdowndetails objectForKey:@"MonthsName"];
                        NSLog(@"TelNo:%@",_DateDropdownItems.MonthsName);
                    }
                    
                }
                [_selectMonthTableData reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  [urlData writeToFile:filePathnew atomically:YES];
                    [hud hideAnimated:YES];
                    // NSLog(@"File Saved !");
                });
            });
        });
        
    }
    else if(firstTime == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                firstTime = NO;
                NSError *error = nil;
                NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                            (NSJSONReadingMutableContainers) error:&error];
                ViewMessageStatus = [parsedJsonArray valueForKey:@"Status"];
                ViewTableData = [receivedData objectForKey:@"ViewMessageResult"];
                if([ViewMessageStatus isEqualToString:@"1"]){
                    for(int n = 0; n < [ViewTableData count]; n++)
                    {
                        _ViewMessageItems = [[ViewMessageResult alloc]init];
                        viewmessagedetails = [ViewTableData objectAtIndex:n];
                        _ViewMessageItems.Fullname = [viewmessagedetails objectForKey:@"Fullname"];
                        _ViewMessageItems.pmg_subject =[viewmessagedetails objectForKey:@"pmg_subject"];
                        _ViewMessageItems.pmg_date =[viewmessagedetails objectForKey:@"pmg_date"];
                        _ViewMessageItems.pmg_Message =[viewmessagedetails objectForKey:@"pmg_Message"];
                        _ViewMessageItems.pmg_file_name =[viewmessagedetails objectForKey:@"pmg_file_name"];
                        _ViewMessageItems.pmg_file_path =[viewmessagedetails objectForKey:@"pmg_file_path"];
                        _ViewMessageItems.pmu_readunredStatus = [viewmessagedetails objectForKey:@"pmu_readunreadstatus"];
                        msgReadStatus = _ViewMessageItems.pmu_readunredStatus;
                        NSLog(@"Message:%@", _ViewMessageItems.pmg_Message);
                        // [_label_NoRecords setHidden:YES];
                        
                    }
                    [_viewMessageTable reloadData];
                }
                else if([ViewMessageStatus isEqualToString:@"0"]){
                    
                    [self httpPostRequest];
                }
                [self.viewMessageTable reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  [urlData writeToFile:filePathnew atomically:YES];
                    [hud hideAnimated:YES];
                    // NSLog(@"File Saved !");
                });
            });
        });
    }
    else if(isMonthSelected == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                isMonthSelected = NO;
                NSError *error = nil;
                NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                            (NSJSONReadingMutableContainers) error:&error];
                ViewMessageStatus = [parsedJsonArray valueForKey:@"Status"];
                ViewTableData = [receivedData objectForKey:@"ViewMessageResult"];
                if([ViewMessageStatus isEqualToString:@"1"]){
                    for(int n = 0; n < [ViewTableData count]; n++)
                    {
                        _ViewMessageItems = [[ViewMessageResult alloc]init];
                        viewmessagedetails = [ViewTableData objectAtIndex:n];
                        _ViewMessageItems.Fullname = [viewmessagedetails objectForKey:@"Fullname"];
                        _ViewMessageItems.pmg_subject =[viewmessagedetails objectForKey:@"pmg_subject"];
                        _ViewMessageItems.pmg_date =[viewmessagedetails objectForKey:@"pmg_date"];
                        _ViewMessageItems.pmg_Message =[viewmessagedetails objectForKey:@"pmg_Message"];
                        _ViewMessageItems.pmg_file_name =[viewmessagedetails objectForKey:@"pmg_file_name"];
                        _ViewMessageItems.pmg_file_path =[viewmessagedetails objectForKey:@"pmg_file_path"];
                        _ViewMessageItems.pmu_readunredStatus = [viewmessagedetails objectForKey:@"pmu_readunreadstatus"];
                        msgReadStatus = _ViewMessageItems.pmu_readunredStatus;
                        NSLog(@"Message:%@", _ViewMessageItems.pmg_Message);
                        // [_label_NoRecords setHidden:YES];
                        
                    }
                }
                else if([ViewMessageStatus isEqualToString:@"0"]){
                    
                    _viewMessageConstraint.constant = 8;
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found for this month" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             _viewMessageConstraint.constant = 8;
                                         }];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
                [self.viewMessageTable reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  [urlData writeToFile:filePathnew atomically:YES];
                    [hud hideAnimated:YES];
                    // NSLog(@"File Saved !");
                });
            });
        });
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _viewMessageTable){
        return 110;
    }
    else{
        return 25;
    }
    
}

- (IBAction)selectMonthBtn:(id)sender {
    
    monthselecteed = YES;
    [_selectMonthTableData setHidden:NO];
    
    _viewMessageConstraint.constant = 99;
    _selectMonthTableData.layer.borderWidth = 1;
    _selectMonthTableData.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self httpPostRequest];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        if(tableView == _selectMonthTableData){
            return [MonthTableData count];
        }
        else if(tableView == _viewMessageTable){
            return [ViewTableData count];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if(tableView == _viewMessageTable){
            //         static NSString *simpleTableIdentifier = @"MessageTableViewCell";
            
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
            // _cell.label_date.text = formatedDate;
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
                        
                        //                        if(_cell.attachmentClick.hidden == YES){
                        //                            //self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 230, -25,44,40)];_cell.attachmentClick.frame.size.width-10
                        //                            self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width+160, -25,44,40)];
                        //                            [_cell.label_date addSubview:self.badgeCount];
                        //                            self.badgeCount.value =  1;
                        //                        }
                        //                        else if(_cell.attachmentClick.hidden == NO){
                        //                            //  self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( 160, -50,74,40)];
                        //                            self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width-10, -25,44,40)];
                        //                            [_cell.label_date addSubview:self.badgeCount];
                        //                            self.badgeCount.value =  1;
                        //
                        //                        }
                        
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
                                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake( _cell.attachmentClick.frame.size.width+210, -25,44,40)];
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
        }
        else if(tableView == _selectMonthTableData){
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SiblingTableViewCell" owner:self options:nil];
                // cell = [nib objectAtIndex:0];
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            [cell.textLabel setFont: [cell.textLabel.font fontWithSize: 14]];
            cell.textLabel.text = [[MonthTableData objectAtIndex:indexPath.row] objectForKey:@"MonthYear"];
            
            return cell;
        }
        
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
//yocommentS
       NSString *urlToDownload = [@"http://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
//yocommentE
      //  NSString     *urlToDownload = filePath;
        //yocommentS
        //urlToDownload = [urlToDownload stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //yocommentE
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

-(void)attachmentButtonClick {
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == _selectMonthTableData){
        monthid = [[MonthTableData objectAtIndex:indexPath.row] objectForKey:@"monthid"];
        NSLog(@"MONTH ID AFTER SELECTion:%@",  monthanme);
        monthanme = [[MonthTableData objectAtIndex:indexPath.row] objectForKey:@"MonthYear"];
        
        [_selectMonthTableData setHidden:YES];
        monthid = monthid;
        isMonthSelected = YES;
        
        _viewMessageConstraint.constant = 8;
        [_SelectMonth setTitle:monthanme forState:UIControlStateNormal];
        //   [self checkInternetConnectivityViewMessage];
        [self httpPostRequest];
        
    }
    else if(tableView == _viewMessageTable){
        
        senderName = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"Fullname"];
        date = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_date"];
        subject = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_subject"];
        message = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_Message"];
        toUslId = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"usl_ID"];
        pmuId = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmu_ID"];
        filename = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_file_name"];
        filePath = [[ViewTableData objectAtIndex:indexPath.row] objectForKey:@"pmg_file_path"];
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
        
        //yocomment
        DetailMessageViewController *DetailMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail Message"];
        DetailMessageViewController.msd_id = msd_id;
        DetailMessageViewController.usl_id = usl_id;
        DetailMessageViewController.clt_id = clt_id;
        DetailMessageViewController.brd_Name = brdName;
        DetailMessageViewController.message = message;
        DetailMessageViewController.sender_name  = senderName;
        DetailMessageViewController.subject = subject;
        DetailMessageViewController.date =  date;
        DetailMessageViewController.toUslId = toUslId;
        DetailMessageViewController.pmuId  = pmuId;
        DetailMessageViewController.filename = filename;
        DetailMessageViewController.filePath = filePath;
        
        
        [self.navigationController pushViewController:DetailMessageViewController animated:YES];
       self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        //end yocomment
    }
    
}


-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    
    LoginArrayCount = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"LoginUserCount"];
    if (![LoginArrayCount isEqualToString:@"1"]) {
        // SiblingProfile
        if([isStudentResourcePresent isEqualToString:@"0"]){
            if(selectionIndex == 0){
                
                StudentProfileWithSiblingViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SiblingProfile"];
                secondViewController.msd_id = msd_id;
                secondViewController.usl_id = usl_id;
                secondViewController.clt_id = clt_id;
                [self.navigationController pushViewController:secondViewController animated:YES];
                
            }
            else if(selectionIndex ==1){
                SiblingStudentViewController *SiblingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Sibling"];
                SiblingViewController.msd_id = msd_id;
                SiblingViewController.usl_id = usl_id;
                SiblingViewController.clt_id = clt_id;
                SiblingViewController.schoolName = school_name;
                [self.navigationController pushViewController:SiblingViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
            }
            else if(selectionIndex == 2){
                ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
                ViewMessageViewController.msd_id = msd_id;
                ViewMessageViewController.usl_id = usl_id;
                ViewMessageViewController.clt_id = clt_id;
                ViewMessageViewController.brdName = brdName;
                //        NSLog(@"msdid", msd_id);
                [self.navigationController pushViewController:ViewMessageViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 3){
                PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
                PaymentInfoViewController.msd_id = msd_id;
                PaymentInfoViewController.clt_id = clt_id;
                [self.navigationController pushViewController:PaymentInfoViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 4){
                StudentResourcesViewController *StudentResourceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentResource"];
//                StudentResourceViewController.msd_id = msd_id;
//                StudentResourceViewController.usl_id = usl_id;
//                StudentResourceViewController.clt_id = clt_id;
//                StudentResourceViewController.brdName = brdName;
               
                [self.navigationController pushViewController:StudentResourceViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 5){
                ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
                AttendanceViewController.msd_id = msd_id;
                AttendanceViewController.usl_id = usl_id;
                AttendanceViewController.clt_id = clt_id;
                AttendanceViewController.brd_Name = brdName;
                [self.navigationController pushViewController:AttendanceViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 6){
                StudentInformationViewController *StudentInformationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformation"];
                StudentInformationViewController.msd_id = msd_id;
                //        secondViewController.usl_id = usl_id;
                //        secondViewController.clt_id = clt_id;
                //        secondViewController.name = name;
                //        secondViewController.school_name = school_name;
                //        secondViewController.teacherAnnouncementCount = teacher_announcementCount;
                [self.navigationController pushViewController:StudentInformationViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
            }
            
            else if(selectionIndex == 7){
                ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
                ChangePasswordViewController.msd_id = msd_id;
                ChangePasswordViewController.clt_id = clt_id;
                ChangePasswordViewController.usl_id = usl_id;
                ChangePasswordViewController.brd_Name = brdName;
                [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
                
            }
            else if(selectionIndex == 8){
                loginClick = YES;
                ViewMessageStatus =@"1";
                [self httpPostRequest];
                
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

                //            AboutUsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //            controller.view.frame=CGRectMake(50,250,300,230);
                //            controller.msd_id = msd_id;
                //            controller.usl_id = usl_id;
                //            controller.brd_Name = brdName;
                //            controller.clt_id = clt_id;
                //            controller.schoolName = school_name;
                //
                //            [self.view addSubview:controller.view];
                //            //[controller.view.center ]
                //            controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
                //                                                 self.view.frame.size.height / 2);
                //            AboutUsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //            //   controller.view.frame=CGRectMake(50,250,300,230);
                //            controller.msd_id = msd_id;
                //            controller.usl_id = usl_id;
                //            controller.brd_Name = brdName;
                //            controller.clt_id = clt_id;
                //
                //            //      [self.view addSubview:controller.view];
                //            //[controller.view.center ]
                //            //  controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
                //            //                                         self.view.frame.size.height / 2);
                //
                //            [self.navigationController pushViewController:controller animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
                //yocomment
//                if (settingsPopoverController == nil)
//                {
//                    AboutUsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
//                    settingsViewController.preferredContentSize = CGSizeMake(320, 300);
//                    
//                    settingsViewController.title = @"AboutUs";
//                    
//                    // [settingsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)]];
//                    
//                    //     [settingsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
//                    
//                    settingsViewController.modalInPopover = NO;
//                    
//                    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
//                    
//                    settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
//                    settingsPopoverController.delegate = self;
//                    //  settingsPopoverController.passthroughViews = @[btn];
//                    settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
//                    settingsPopoverController.wantsDefaultContentAppearance = NO;
//                    
//                    
//                    [settingsPopoverController presentPopoverAsDialogAnimated:YES
//                                                                      options:WYPopoverAnimationOptionFadeWithScale];
//                    
//                    
//                    
//                }
                //yocomment
                
            }
        }
        else if([isStudentResourcePresent isEqualToString:@""]){
            if(selectionIndex == 0){
                
                StudentProfileWithSiblingViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SiblingProfile"];
                secondViewController.msd_id = msd_id;
                secondViewController.usl_id = usl_id;
                secondViewController.clt_id = clt_id;
                [self.navigationController pushViewController:secondViewController animated:YES];
                
            }
            else if(selectionIndex ==1){
                SiblingStudentViewController *SiblingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Sibling"];
                SiblingViewController.msd_id = msd_id;
                SiblingViewController.usl_id = usl_id;
                SiblingViewController.clt_id = clt_id;
                SiblingViewController.schoolName = school_name;
                [self.navigationController pushViewController:SiblingViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
            }
            else if(selectionIndex == 2){
                ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
                ViewMessageViewController.msd_id = msd_id;
                ViewMessageViewController.usl_id = usl_id;
                ViewMessageViewController.clt_id = clt_id;
                ViewMessageViewController.brdName = brdName;
                //        NSLog(@"msdid", msd_id);
                [self.navigationController pushViewController:ViewMessageViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 3){
                PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
                PaymentInfoViewController.msd_id = msd_id;
                PaymentInfoViewController.clt_id = clt_id;
                [self.navigationController pushViewController:PaymentInfoViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 4){
                ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
                AttendanceViewController.msd_id = msd_id;
                AttendanceViewController.usl_id = usl_id;
                AttendanceViewController.clt_id = clt_id;
                AttendanceViewController.brd_Name = brdName;
                [self.navigationController pushViewController:AttendanceViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 5){
                StudentInformationViewController *StudentInformationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformation"];
                StudentInformationViewController.msd_id = msd_id;
                //        secondViewController.usl_id = usl_id;
                //        secondViewController.clt_id = clt_id;
                //        secondViewController.name = name;
                //        secondViewController.school_name = school_name;
                //        secondViewController.teacherAnnouncementCount = teacher_announcementCount;
                [self.navigationController pushViewController:StudentInformationViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
            }
            else if(selectionIndex == 6){
                ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
                ChangePasswordViewController.msd_id = msd_id;
                ChangePasswordViewController.clt_id = clt_id;
                ChangePasswordViewController.usl_id = usl_id;
                ChangePasswordViewController.brd_Name = brdName;
                [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
                
            }
            else if(selectionIndex == 7){
                loginClick = YES;
                ViewMessageStatus =@"1";
                
                [self httpPostRequest];
                
                LoginViewController *LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
                [self.navigationController pushViewController:LoginViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 8){
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

                //            AboutUsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //            controller.view.frame=CGRectMake(50,250,300,230);
                //            controller.msd_id = msd_id;
                //            controller.usl_id = usl_id;
                //            controller.brd_Name = brdName;
                //            controller.clt_id = clt_id;
                //            controller.schoolName = school_name;
                //
                //            [self.view addSubview:controller.view];
                //            //[controller.view.center ]
                //            controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
                //                                                 self.view.frame.size.height / 2);
                //                AboutUsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //                //   controller.view.frame=CGRectMake(50,250,300,230);
                //                controller.msd_id = msd_id;
                //                controller.usl_id = usl_id;
                //                controller.brd_Name = brdName;
                //                controller.clt_id = clt_id;
                //
                //                //      [self.view addSubview:controller.view];
                //                //[controller.view.center ]
                //                //  controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
                //                //                                         self.view.frame.size.height / 2);
                //
                //                [self.navigationController pushViewController:controller animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                //yocomment
//                if (settingsPopoverController == nil)
//                {
//                    AboutUsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
//                    settingsViewController.preferredContentSize = CGSizeMake(320, 300);
//                    
//                    settingsViewController.title = @"AboutUs";
//                    
//                    // [settingsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)]];
//                    
//                    //     [settingsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
//                    
//                    settingsViewController.modalInPopover = NO;
//                    
//                    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
//                    
//                    settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
//                    settingsPopoverController.delegate = self;
//                    //  settingsPopoverController.passthroughViews = @[btn];
//                    settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
//                    settingsPopoverController.wantsDefaultContentAppearance = NO;
//                    
//                    
//                    [settingsPopoverController presentPopoverAsDialogAnimated:YES
//                                                                      options:WYPopoverAnimationOptionFadeWithScale];
//                    
//                    
//                    
//                }
                //yocomment
                
            }
            
            
        }
    }
     else if([LoginArrayCount isEqualToString:@"1"]){
         NSLog(@"LoginArrayCount %@", LoginArrayCount);
         NSLog(@"Without sibling");
        if([isStudentResourcePresent isEqualToString:@"0"]) {
            NSLog(@"isStudentResourcePresent %@", isStudentResourcePresent );
            NSLog(@"With student resources");
        if(selectionIndex == 0){
            
            StudentDashboardWithoutSibling *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentDashboardWithoutSibling"];
//            secondViewController.msd_id = msd_id;
//            secondViewController.usl_id = usl_id;
//            secondViewController.clt_id = clt_id;
//            secondViewController.name = name;
//            secondViewController.school_name = school_name;
//            secondViewController.teacherAnnouncementCount = teacherAnnouncementCount;
            [self.navigationController pushViewController:secondViewController animated:YES];
        }
        else if(selectionIndex == 1){
            ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
//            ViewMessageViewController.msd_id = msd_id;
//            ViewMessageViewController.usl_id = usl_id;
//            ViewMessageViewController.clt_id = clt_id;
//            ViewMessageViewController.brdName = brd_name;
//            ViewMessageViewController.stdName = _std;
//            NSLog(@"msdid", msd_id);
            [self.navigationController pushViewController:ViewMessageViewController animated:YES];
            //            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 2){
            PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
            //            PaymentInfoViewController.msd_id = msd_id;
            //            PaymentInfoViewController.clt_id = clt_id;
            [self.navigationController pushViewController:PaymentInfoViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 3){
                        StudentResourcesViewController *StudentResourceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentResource"];
            //            StudentResourceViewController.msd_id = msd_id;
            //            StudentResourceViewController.usl_id = usl_id;
            //            StudentResourceViewController.clt_id = clt_id;
            //            StudentResourceViewController.brdName = brd_name;
            //            StudentResourceViewController.stdName = _std;
                        [self.navigationController pushViewController:StudentResourceViewController animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        
        else if(selectionIndex == 4){
            ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
            //            AttendanceViewController.msd_id = msd_id;
            //            AttendanceViewController.usl_id = usl_id;
            //            AttendanceViewController.clt_id = clt_id;
            //            AttendanceViewController.brd_Name = brd_name;
            [self.navigationController pushViewController:AttendanceViewController animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 5){
            StudentInformationViewController *StudentInformationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformation"];
            //StudentInformationViewController.msd_id = msd_id;
            //        secondViewController.usl_id = usl_id;
            //        secondViewController.clt_id = clt_id;
            //        secondViewController.name = name;
            //        secondViewController.school_name = school_name;
            //        secondViewController.teacherAnnouncementCount = teacher_announcementCount;
            [self.navigationController pushViewController:StudentInformationViewController animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            
        }
        else if(selectionIndex == 6){
            ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
            //            ChangePasswordViewController.msd_id = msd_id;
            //            ChangePasswordViewController.clt_id = clt_id;
            //            ChangePasswordViewController.usl_id = usl_id;
            //            ChangePasswordViewController.brd_Name = brd_name;
            [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            
            
        }
        else if(selectionIndex == 7){
            loginClick = YES;
            _Status = @"0";
            [self httpPostRequest];
            LoginViewController *LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [self.navigationController pushViewController:LoginViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 8){
            
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

            //       controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
            //     //   controller = [[AboutUsViewController alloc] init];
            //   //     controller.view.frame=CGRectMake(50,250,300,230);
            //        controller.msd_id = msd_id;
            //        controller.usl_id = usl_id;
            //        controller.brd_Name = brd_name;
            //        controller.clt_id = clt_id;
            //        controller.schoolName = school_name;
            //
            //     //   [self.view addSubview:controller.view];
            //        //[controller.view.center ]
            //      //  controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
            //                                 //        self.view.frame.size.height / 2);
            //
            //   //     [_closeClick addTarget:self action:@selector(dismissPopup:) forControlEvents:UIControlEventTouchUpInside];
            //      //  [controller.closeClick addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
            //        [self.navigationController pushViewController:controller animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            //
            
            //            if (settingsPopoverController == nil)
            {
                //                AboutUsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //                settingsViewController.preferredContentSize = CGSizeMake(320, 300);
                //
                //                settingsViewController.title = @"AboutUs";
                //
                //                // [settingsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)]];
                //
                //                //     [settingsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
                //
                //                settingsViewController.modalInPopover = NO;
                //
                //                UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
                //
                //                settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
                //                settingsPopoverController.delegate = self;
                //                //  settingsPopoverController.passthroughViews = @[btn];
                //                settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
                //                settingsPopoverController.wantsDefaultContentAppearance = NO;
                //
                //
                //                [settingsPopoverController presentPopoverAsDialogAnimated:YES
                //                                                                  options:WYPopoverAnimationOptionFadeWithScale];
            }
            
        }
    }
    else{
          NSLog(@"Without student resources");
        if(selectionIndex == 0){
            
            StudentDashboardWithoutSibling *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentDashboardWithoutSibling"];
            //            secondViewController.msd_id = msd_id;
            //            secondViewController.usl_id = usl_id;
            //            secondViewController.clt_id = clt_id;
            //            secondViewController.name = name;
            //            secondViewController.school_name = school_name;
            //            secondViewController.teacherAnnouncementCount = teacherAnnouncementCount;
            [self.navigationController pushViewController:secondViewController animated:YES];
        }
        else if(selectionIndex == 1){
                        ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
            //            ViewMessageViewController.msd_id = msd_id;
            //            ViewMessageViewController.usl_id = usl_id;
            //            ViewMessageViewController.clt_id = clt_id;
            //            ViewMessageViewController.brdName = brd_name;
            //            ViewMessageViewController.stdName = _std;
            //            NSLog(@"msdid", msd_id);
                        [self.navigationController pushViewController :ViewMessageViewController animated:YES];
            //            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            
//            ViewMessageViewController *navigationTabController = [self.storyboard instantiateViewControllerWithIdentifier:@"tab_controller"];
//            
//            [ self presentModalViewController:navigationTabController animated:YES];
            
        }
        else if(selectionIndex == 2){
            PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
            //            PaymentInfoViewController.msd_id = msd_id;
            //            PaymentInfoViewController.clt_id = clt_id;
            [self.navigationController pushViewController:PaymentInfoViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 3){
            ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
            //            AttendanceViewController.msd_id = msd_id;
            //            AttendanceViewController.usl_id = usl_id;
            //            AttendanceViewController.clt_id = clt_id;
            //            AttendanceViewController.brd_Name = brd_name;
            [self.navigationController pushViewController:AttendanceViewController animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 4){
            StudentInformationViewController *StudentInformationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformation"];
            //            StudentInformationViewController.msd_id = msd_id;
            //        secondViewController.usl_id = usl_id;
            //        secondViewController.clt_id = clt_id;
            //        secondViewController.name = name;
            //        secondViewController.school_name = school_name;
            //        secondViewController.teacherAnnouncementCount = teacher_announcementCount;
            [self.navigationController pushViewController:StudentInformationViewController animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 5){
            ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
            //            ChangePasswordViewController.msd_id = msd_id;
            //            ChangePasswordViewController.clt_id = clt_id;
            //            ChangePasswordViewController.usl_id = usl_id;
            //            ChangePasswordViewController.brd_Name = brd_name;
            [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            
            
        }
        else if(selectionIndex == 6){
           loginClick = YES;
            _Status = @"0";
            [self httpPostRequest];
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
            

            //            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
            //            //   controller = [[AboutUsViewController alloc] init];
            //            //     controller.view.frame=CGRectMake(50,250,300,230);
            //            controller.msd_id = msd_id;
            //            controller.usl_id = usl_id;
            //            controller.brd_Name = brd_name;
            //            controller.clt_id = clt_id;
            //            controller.schoolName = school_name;
            //
            //            //   [self.view addSubview:controller.view];
            //            //[controller.view.center ]
            //            //  controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
            //            //        self.view.frame.size.height / 2);
            //
            //            //     [_closeClick addTarget:self action:@selector(dismissPopup:) forControlEvents:UIControlEventTouchUpInside];
            //            //  [controller.closeClick addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
            //            [self.navigationController pushViewController:controller animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            //
            //if (settingsPopoverController == nil)
            //            {
            //                AboutUsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
            //                settingsViewController.preferredContentSize = CGSizeMake(320, 300);
            //
            //                settingsViewController.title = @"AboutUs";
            //
            //                // [settingsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)]];
            //
            //                //     [settingsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
            //
            //                settingsViewController.modalInPopover = NO;
            //                
            //                UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            //                
            //                settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            //                settingsPopoverController.delegate = self;
            //                //  settingsPopoverController.passthroughViews = @[btn];
            //                settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            //                settingsPopoverController.wantsDefaultContentAppearance = NO;
            //                
            //                
            //                [settingsPopoverController presentPopoverAsDialogAnimated:YES
            //                                                                  options:WYPopoverAnimationOptionFadeWithScale];
            //                
            //                
            //            }
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


- (IBAction)viewMessageBtn_Action:(id)sender {
    firstTime = YES;
    [self httpPostRequest];

}
@end
