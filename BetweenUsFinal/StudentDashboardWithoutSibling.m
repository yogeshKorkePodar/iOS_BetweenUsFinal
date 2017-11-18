//
//  StudentDashboardWithoutSibling.m
//  BetweenUsFinal
//
//  Created by anand chawla on 01/08/17.
//  Copyright © 2017 podar. All rights reserved.
//
#import "URL_Constant.h"
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
#import "AboutUsViewController.h"
#import "WYPopoverController.h"
#import "StudentResourcesViewController.h"

@interface StudentDashboardWithoutSibling () <RestAPIDelegate,WYPopoverControllerDelegate>
{
    WYPopoverController *popoverController;
}
@end

@implementation StudentDashboardWithoutSibling

@synthesize rol_id,msd_id,usl_id,clt_id,school_name,brd_name,org_id,name,teacherAnnouncementCount,roll_no_label,school_name_label,parent_label,Brd_Id,sec_Id,school_icon,drawername,drawerstd,drawerRollNo,draweracademicYear;

-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
   
}

- (IBAction)message_button:(UIButton *)sender {
    NSLog(@"<Message button pressed");
}

- (IBAction)feesinfo_button:(UIButton *)sender {
}

- (IBAction)studentinfo_button:(UIButton *)sender {
}

- (IBAction)attendance_button:(UIButton *)sender {
}

- (IBAction)student_resources_button:(UIButton *)sender {
}

- (IBAction)admission_kit_button:(UIButton *)sender {
}

-(void) viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
    NSLog(@"<< Inside StudentDashboardWithoutSibling > viewWillAppear");
    _admissionKit_button.hidden = YES;
    _admissionKit_label.hidden = YES;
    
    [ _student_resources_button  setHidden:YES];
    [_student_resources_label setHidden:YES];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iOS 3.2 or later.
        
        
//        _message_width.constant = 60;
//        _message_height.constant = 60;
//        _studinfo_btn_width.constant = 60;
//        _studinfo_btn_height.constant = 60;
//        _studRes_btn_widht.constant = 60;
//        _studRes_btn_height.constant = 60;
//        _feesinfo_btn_width.constant = 60;
//        _feesinfo_btn_height.constant = 60;
//        _attendance_btn_width.constant = 60;
//        _attendance_btn_height.constant = 60;
//        _admissionkit_btn_widht.constant =60;
//        _admissionkit_btn_height.constant = 60;
        
        _message_btn_leading_constrain.constant =140;
        _studinfo_btn_leading_constrain.constant = 140;
        _studRes_btn_leading_constrain.constant = 140;
        _feesinfo_btn_trailing_constrain.constant = 140;
        _attendance_btn_trailing_constrain.constant = 140;
        _admissionkit_btn_trailing_constrain.constant = 140;
        _school_icon_height.constant = 200;
        _watermark_background_height.constant = 600;

        
        
    }
    else
    {
        // The device is an iPhone or iPod touch.
        _watermark_background_height.constant = 300;
        
    }

}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    //to make arrow white
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    firstWebcall = YES;
    self.restApi.delegate = self;
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];

    NSLog(@"<< Inside StudentDashboardWithoutSibling > viewDidLoad");
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"white-menu-icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 25)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    firstTime = YES;
    pageNo = @"1";
    pageSize = @"300";
    check = @"0";
    
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
    
    school_name = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"school_name"];
    msd_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"msd_Id"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    DeviceType= @"IOS";
    NSLog(@"Device Token:%@",DeviceToken);
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    
    if([device isEqualToString:@"ipad"]){
        
        
    }else if([device isEqualToString:@"iphone"]){
        
    }
    
    org_id =[[NSUserDefaults standardUserDefaults]stringForKey:@"Org_id"];
    sec_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"sec_id"];
    rol_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Roll_id"];
    Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
    name = [[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
    drawerstd = [[NSUserDefaults standardUserDefaults]stringForKey:@"Std"];
    drawerRollNo = [[NSUserDefaults standardUserDefaults]stringForKey:@"RollNo"];
    brd_name = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"brd_name"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            parent_label.text = name;
            school_name_label.text = school_name;
            _std_label.text= drawerstd;
            roll_no_label.text = drawerRollNo;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        });
    });
    
    
    [[NSUserDefaults standardUserDefaults] setObject:msd_id forKey:@"msd_Id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:clt_id forKey:@"clt_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:usl_id forKey:@"usl_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:school_name forKey:@"school_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:brd_name forKey:@"brd_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:isStudentResourcePresent forKey:@"isStudenResourcePresent"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    NSLog(@"MSD Id PRofile:%@",msd_id);
    NSLog(@"Schoolname:%@",school_name);
    NSLog(@"Brd name saved:%@",brd_name);
    
    [self setLogo];
    
    [self checkInternetConnectivity];

    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self needsUpdate];
    
}

-(BOOL) needsUpdate{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([lookup[@"resultCount"] integerValue] == 1){
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        if (![appStoreVersion isEqualToString:currentVersion]){
            NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
            newVersion = @"New Version Available";
            [self update];
            return YES;
        }
    }
    return NO;
}

-(void)update{
    if([newVersion isEqualToString:@"New Version Available"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"New Version is Available" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        //      [self presentViewController:alertController animated:YES completion:nil];
        
    }
}




-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
       [self.rootNav drawerToggle];
}


-(void)checkInternetConnectivity{
    
    messageReadCount = [[NSMutableArray alloc] init];
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
     
     if(self.internetActive == YES){
         
         [self httpPostRequest];
     }
     else{
         
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 name = [[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
                 drawerstd = [[NSUserDefaults standardUserDefaults]stringForKey:@"Std"];
                 drawerRollNo = [[NSUserDefaults standardUserDefaults]stringForKey:@"RollNo"];
                 org_id =[[NSUserDefaults standardUserDefaults]stringForKey:@"Org_id"];
                 sec_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"sec_id"];
                 rol_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Roll_id"];
                 Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
                 messageReadCountWithNoInternet = [[NSUserDefaults standardUserDefaults] arrayForKey:@"messageCount"];
                 // messageReadCount = 0;
                 
                 [self setLogo];
                 
                 
                 parent_label.text = name;
                 school_name_label.text = school_name;
                 _std_label.text= drawerstd;
                 roll_no_label.text = drawerRollNo;
                 self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.message_button.frame.size.width - 28, -20,44,40)];
                 [self.message_button addSubview:self.badgeCount];
                 self.badgeCount.value =  [messageReadCountWithNoInternet count];
                 
                 
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 
                 [self presentViewController:alertController animated:YES completion:nil];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //  [urlData writeToFile:filePathnew atomically:YES];
                     [hud hideAnimated:YES];
                     // NSLog(@"File Saved !");
                 });
             });
         });
         
     }

 }

-(void) httpPostRequest{
    
    if(firstTime == YES){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSString *str = app_url @"PodarApp.svc/GetStundentDetails";
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:str];
                
                //Pass The String to server
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:msd_id,@"msd_id",clt_id,@"clt_id",usl_id,@"usl_id",nil];
                NSLog(@"Post parameters data Details is =%@", newDatasetInfo);
                
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
                NSLog(@" Response received==%@", resSrt);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  [urlData writeToFile:filePathnew atomically:YES];
                    [hud hideAnimated:YES];
                    
                    // NSLog(@"File Saved !");
                });
            });
        });
    }
    else if([_Status isEqualToString:@"1"]){
        _Status = @"0";
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSString *str = app_url @"PodarApp.svc/GetViewMessageData";
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:str];
                
                //Pass The String to server
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",msd_id,@"msd_id",month,@"month",check,@"check",pageNo,@"PageNo",pageSize,@"PageSize",nil];
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
                NSError *error = nil;
                if(responseData==nil){
                    NSLog(@"No Data:%@",@"No Data:%@");
                }
                else{
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                    
                    //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
                    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                    ViewMessageStatus= [parsedJsonArray valueForKey:@"Status"];
                    NSLog(@"Status:%@",ViewMessageStatus);
                    
                    ViewTableData = [receivedData objectForKey:@"ViewMessageResult"];
                    if([ViewMessageStatus isEqualToString:@"1"]){
                        ViewMessageStatus = @"1";
                        for(int n = 0; n < [ViewTableData  count]; n++)
                        {
                            _ViewMessageItems= [[ViewMessageResult alloc]init];
                            viewmessagedetails = [ViewTableData
                                                  objectAtIndex:n];
                            _ViewMessageItems.pmu_readunredStatus = [viewmessagedetails objectForKey:@"pmu_readunreadstatus"];
                            messageReadStatus =_ViewMessageItems.pmu_readunredStatus;
                            NSLog(@"MessageStatus:%@",  _ViewMessageItems.pmu_readunredStatus);
                            if([messageReadStatus isEqualToString:@"1"]){
                                
                                
                                [messageReadCount addObject:messageReadStatus];
                                
                                NSLog(@"Size ReadMesssage:%lu",(unsigned long)[messageReadCount count]);
                                badgeCountNo = [messageReadCount count];
                                self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.message_button.frame.size.width - 28, -20,44,40)];
                                [self.message_button addSubview:self.badgeCount];
                                self.badgeCount.value =  [messageReadCount count];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:messageReadCount forKey:@"messageCount"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                
                            }
                            
                        }
                    }
                    else if([ViewMessageStatus isEqualToString:@"0"]){
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        NSError *err;
                        NSString *str = app_url @"PodarApp.svc/GetLastViewMessageData";
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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [hud hideAnimated:YES];
                        });
                        
                        NSError *error = nil;
                        NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                        NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                        LastViewMessageStatus= [parsedJsonArray valueForKey:@"Status"];
                        NSLog(@"Status:%@",LastViewMessageStatus);
                        
                        ViewTableData = [receivedData objectForKey:@"ViewMessageResult"];
                        if([LastViewMessageStatus isEqualToString:@"1"]){
                            ViewMessageStatus = @"1";
                            for(int n = 0; n < [ViewTableData  count]; n++)
                            {
                                _ViewMessageItems= [[ViewMessageResult alloc]init];
                                viewmessagedetails = [ViewTableData
                                                      objectAtIndex:n];
                                _ViewMessageItems.pmu_readunredStatus = [viewmessagedetails objectForKey:@"pmu_readunreadstatus"];
                                messageReadStatus =_ViewMessageItems.pmu_readunredStatus;
                                NSLog(@"MessageStatus:%@",  _ViewMessageItems.pmu_readunredStatus);
                                if([messageReadStatus isEqualToString:@"1"]){
                                    
                                    [messageReadCount addObject:messageReadStatus];
                                    
                                    NSLog(@"Size ReadMesssage:%lu",(unsigned long)[messageReadCount count]);
                                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.message_button.frame.size.width - 28, -20,44,40)];
                                    [self.message_button addSubview:self.badgeCount];
                                    
                                    if([messageReadCount count]==0){
                                        
                                        [self.message_button willRemoveSubview:self.badgeCount];
                                        
                                        [[NSUserDefaults standardUserDefaults] setObject:messageReadCount forKey:@"messageCount"];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                    }
                                    else{
                                        self.badgeCount.value =  [messageReadCount count];
                                        
                                        [[NSUserDefaults standardUserDefaults] setObject:messageReadCount forKey:@"messageCount"];
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }
                
            });
        });
    }
    else if(loginClick ==YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        loginClick = NO;
        NSError *err;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSString *str = app_url @"PodarApp.svc/LogOut";
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
    NSLog(@" Inside getReceivedData");
    
    if(firstTime == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                firstTime = NO;
                NSError *error = nil;
                NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
                _Status = [parsedJsonArray valueForKey:@"Status"];
                NSLog(@"Status:%@",_Status);
                
                NSArray* stundentDetails = [receivedData objectForKey:@"stundentListDetails"];
                
                if([_Status isEqualToString:@"1"]){
                    for(int n = 0; n < [stundentDetails  count]; n++)
                    {
                        _item = [[stundentListDetails alloc]init];
                        NSDictionary* studentinfodetails = [stundentDetails objectAtIndex:n];
                        _item.org_id = [studentinfodetails objectForKey:@"org_id"];
                        _item.Brd_Name =[studentinfodetails objectForKey:@"Brd_Name"];
                        _item.behaviourcnt = [studentinfodetails objectForKey:@"behaviourcnt"];
                        _item.annoucementCnt = [studentinfodetails objectForKey:@"annoucementCnt"];
                        _item.std_Name = [studentinfodetails objectForKey:@"std_Name"];
                        _item.msd_RollNo = [studentinfodetails objectForKey:@"msd_RollNo"];
                        _item.stu_display = [studentinfodetails objectForKey:@"stu_display"];
                        _item.div_name = [studentinfodetails objectForKey:@"div_name"];
                        _item.sec_ID = [studentinfodetails objectForKey:@"sec_ID"];
                        _item.Brd_ID = [studentinfodetails objectForKey:@"Brd_ID"];
                        _item.acy_Year =  [studentinfodetails objectForKey:@"acy_Year"];
                        _item.StudentResourceExist = [studentinfodetails objectForKey:@"StudentResourceExist"];
                        _item.behaviourcnt = [studentinfodetails objectForKey:@"behaviourcnt"];
                        _item.annoucementCnt = [studentinfodetails objectForKey:@"annoucementCnt"];
                        _item.acy_id = [studentinfodetails objectForKey:@"acy_id"];
                        _item.sch_id = [studentinfodetails objectForKey:@"sch_id"];
                        _item.cls_ID = [studentinfodetails objectForKey:@"cls_ID"];
                        _item.stu_id = [studentinfodetails objectForKey:@"stu_id"];
                        
                        isStudentResourcePresent = _item.StudentResourceExist;
                        org_id = _item.org_id;
                        Brd_Id = _item.Brd_ID;
                        sec_Id = _item.sec_ID;
                        brd_name = _item.Brd_Name;
                        _std =_item.std_Name;
                        acy_yrID = _item.acy_id;
                        sch_id = _item.sch_id;
                        cls_id = _item.cls_ID;
                        stud_id = _item.stu_id;
                        
                        announcementCount = _item.annoucementCnt;
                        behaviourCount = _item.behaviourcnt;
                    
                        NSLog(@"Brd name:%@",_item.Brd_Name);
                        NSLog(@"profileerollno:%@",_item.msd_RollNo);
                        
                        parent_label.text = _item.stu_display;
                        drawername = parent_label.text;
                        school_name_label.text = school_name;
                        _std_label.text=[NSString stringWithFormat: @"%@ %@ - %@ ", @"Std : ", _item.std_Name,_item.div_name];
                        drawerstd = _std_label.text;
                        draweracademicYear = _item.acy_Year;
                        
                        if([isStudentResourcePresent isEqualToString:@""]){
                            [ _student_resources_button  setHidden:YES];
                            [_student_resources_label setHidden:YES];
                        }
                        else if([isStudentResourcePresent isEqualToString:@"0"]){
                            [_student_resources_button setHidden:NO];
                            [_student_resources_label setHidden:NO];
                            
                        }
                        self.roll_no = [NSString stringWithFormat: @"%@ : %@ ", @"Roll No ", _item.msd_RollNo];
                        self.roll_no_label.text = self.roll_no;
                        
                        [[NSUserDefaults standardUserDefaults] setObject:announcementCount forKey:@"announcementCount"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:behaviourCount forKey:@"behaviourCount"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:sch_id forKey:@"sch_id"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:stud_id forKey:@"stud_id"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:acy_yrID forKey:@"acy_id"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:cls_id forKey:@"cls_id"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:self.roll_no forKey:@"RollNo"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:isStudentResourcePresent forKey:@"isStudenResourcePresent"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:self.drawerstd forKey:@"Std"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:drawername forKey:@"name"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:draweracademicYear forKey:@"academicYear"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:_std forKey:@"std"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:Brd_Id forKey:@"Brd_ID"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:org_id forKey:@"Org_id"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[NSUserDefaults standardUserDefaults] setObject:sec_Id forKey:@"sec_id"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [self setLogo];
                        [self httpPostRequest];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [hud hideAnimated:YES];
                        });
                        
                    }
                    
                }
            });
        });
    }
    
}
 
-(void) setLogo{
    
    if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"1"]) && ((![sec_Id isEqualToString: @"1"])))){
        
        school_icon.image = [UIImage imageNamed:@"CBSE Logo 200x100 pix (2).png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"2"]) && ((![sec_Id isEqualToString: @"1"])))){
        school_icon.image = [UIImage imageNamed:@"ICSE_Logo.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"3"]) && ((![sec_Id isEqualToString: @"1"])))){
        school_icon.image = [UIImage imageNamed:@"cie_250x100_old.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"5"]) && ((![sec_Id isEqualToString: @"1"])))){
        school_icon.image = [UIImage imageNamed:@"ssc_250x80.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"4"]))){
        school_icon.image = [UIImage imageNamed:@"Podar ORT.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([sec_Id isEqualToString: @"5"]) && (([school_name containsString:@"Podar Jumbo"])))){
        school_icon.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"1"]) && (([sec_Id isEqualToString: @"1"])))){
        school_icon.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if(([org_id isEqualToString:@"2"]) && ([brd_name isEqualToString:@"ICSE"]) && ([sec_Id isEqualToString:@"1"])){
        school_icon.image = [UIImage imageNamed:@"PJK.png"];
        
    }
    else if((([org_id isEqualToString: @"4"]) && ([Brd_Id isEqualToString: @"10"]))){
        school_icon.image = [UIImage imageNamed:@"lilavati_250x125.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([Brd_Id isEqualToString: @"1"]))){
        school_icon.image = [UIImage imageNamed:@"rnpodar_225x100.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([Brd_Id isEqualToString: @"4"]))){
        school_icon.image = [UIImage imageNamed:@"ib_250x100.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([Brd_Id isEqualToString: @"5"]))){
        school_icon.image = [UIImage imageNamed:@"ssc_250x100.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([clt_id isEqualToString: @"39"]))){
        school_icon.image = [UIImage imageNamed:@"pwc_225x225.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([clt_id isEqualToString: @"38"]))){
        school_icon.image = [UIImage imageNamed:@"pic_225x225.png"];
    }
    else if((([org_id isEqualToString: @"3"]) && ([Brd_Id isEqualToString: @"1"]) && ((![sec_Id isEqualToString: @"1"])))){
        school_icon.image = [UIImage imageNamed:@"pws_300x95.png"];
    }
    else if((([org_id isEqualToString: @"3"]) && ([Brd_Id isEqualToString: @"1"]) && (([sec_Id isEqualToString: @"1"])))){
        school_icon.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if((([org_id isEqualToString: @"3"]) && ([Brd_Id isEqualToString: @"1"]) && (([sec_Id isEqualToString: @"1"])) && ([school_name containsString:@"Podar Jumbo"]))){
        school_icon.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if((([org_id isEqualToString: @"1"]))){
        //   school_icon.image = [UIImage imageNamed:@"cbse_225x225.png"];
        
        school_icon.image = [UIImage imageNamed:@"CBSE Logo 200x100 pix (2).png"];
        
    }
    else{
        school_icon.hidden = NO;
    }
    
}

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
    if([isStudentResourcePresent isEqualToString:@"0"]) {
        
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
            //tab_controller
            //tab_controller_navigation
            ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
            ViewMessageViewController.msd_id = msd_id;
            ViewMessageViewController.usl_id = usl_id;
            ViewMessageViewController.clt_id = clt_id;
            ViewMessageViewController.brdName = brd_name;
            ViewMessageViewController.stdName = _std;
            NSLog(@"msdid", msd_id);
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
            [self.navigationController pushViewController:StudentResourceViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
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
            //           NSLog(@"<<<<< About Us clicked >>>>>>>>");
            
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
    else{
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
            [self.navigationController pushViewController:LoginViewController animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
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

@end
