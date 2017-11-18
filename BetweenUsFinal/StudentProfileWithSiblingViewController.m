//
//  StudentProfileWithSiblingViewController.m
//  TestAutoLayout
//
//  Created by podar on 15/06/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "StudentProfileWithSiblingViewController.h"
#import "StudentInformationViewController.h"
#import "RestAPI.h"
#import "stundentListDetails.h"
#import "PaymentInfoViewController.h"
#import "SiblingStudentViewController.h"
#import "StudentResourcesViewController.h"
#import "ViewMessageViewController.h"
#import "ViewAttendanceViewController.h"
#import "CCKFNavDrawer.h"
#import "ChangePassswordViewController.h"
#import "LoginViewController.h"
#import "AboutUsViewController.h"
#import "ViewMessageResult.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "WYPopoverController.h"

//yocomment below line is removed from interface
//StudentInformationViewControllerDelegate,
@interface StudentProfileWithSiblingViewController ()<WYPopoverControllerDelegate>{
     BOOL studentInfo,paymentInfo,sibling,studentResource,message,attendance,firstTime,loginClick,firstWebcall;
      UITapGestureRecognizer *tapGestRecog ;
    MBProgressHUD *hud;
    WYPopoverController *settingsPopoverController;
}

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,strong) NSString * std;
@property(nonatomic,strong) NSString * roll_no;
@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) stundentListDetails *stundentListDetails;
@property (nonatomic, strong) ViewMessageResult *ViewMessageItems;
@property (nonatomic, strong) AboutUsViewController *AboutUs;
@property (nonatomic, strong) stundentListDetails *item;
@end

@implementation StudentProfileWithSiblingViewController
@synthesize rol_id,msd_id,usl_id,clt_id,school_name,brd_name,org_id,name,teacherAnnouncementCount,btn_sibling,btn_paymentInfo,btn_studentInformation,label_div,label_std,label_schoolName,btn_studentResource,label_studentName;

-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}

-(void)
viewWillAppear:(BOOL)animated{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iOS 3.2 or later.
        _message_leading.constant = 130;
        _stud_info_leading.constant = 130;
        _stud_res_leading_constrain.constant = 130;
        _sibling_trailing.constant = 130;
        _attendance_trailing.constant = 130;
        _fees_info_trailing.constant = 130;
        
        _watermark_background_height.constant = 600;
        
    }
    else
    {
        // The device is an iPhone or iPod touch.
        _watermark_background_height.constant = 300;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //to make arrow white
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    firstWebcall = YES;
    firstTime = YES;
    
    _admissionKit_label.hidden = YES;
    _admissionKit_button.hidden = YES;
    
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
    pageNo = @"1";
    pageSize = @"300";
    check = @"0";
    msd_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"msd_Id"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    
   

    self.std = @"Std : ";
    self.roll_no = @"Roll No ";
     NSLog(@"MSD Id withSibling:%@",msd_id);
    
    messageReadCount = [[NSMutableArray alloc] init];
    
    school_name = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"school_name"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    DeviceType= @"IOS";
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
    
    name = [[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
    drawerstd = [[NSUserDefaults standardUserDefaults]stringForKey:@"Std"];
    drawerRollNo = [[NSUserDefaults standardUserDefaults]stringForKey:@"RollNo"];
    org_id =[[NSUserDefaults standardUserDefaults]stringForKey:@"Org_id"];
    sec_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"sec_id"];
    rol_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Roll_id"];
    Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
    [self setLogo];
    label_studentName.text = name;
    label_schoolName.text = school_name;
    label_std .text= drawerstd;
    self.label_div.text = drawerRollNo;

    [[NSUserDefaults standardUserDefaults] setObject:msd_id forKey:@"msd_Id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:clt_id forKey:@"clt_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:usl_id forKey:@"usl_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:school_name forKey:@"school_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:isStudentResourcePresent forKey:@"isStudenResourcePresent"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Hide back button
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton=YES;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];

    //tap gestrure
    UITapGestureRecognizer *tapGestRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnce)];
    [tapGestRecog setNumberOfTapsRequired:1];
    [_btn_message addGestureRecognizer:tapGestRecog];
    tapGestRecog.delegate = self;
    
    UITapGestureRecognizer *tapGestpaymenthistory =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOncePaymentHistory)];
    [tapGestpaymenthistory setNumberOfTapsRequired:1];
    [btn_paymentInfo addGestureRecognizer:tapGestpaymenthistory];
    tapGestpaymenthistory.delegate = self;
    
    UITapGestureRecognizer *tapGeststudentInfo =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceStudentInfo)];
    [tapGeststudentInfo setNumberOfTapsRequired:1];
    [btn_studentInformation addGestureRecognizer:tapGeststudentInfo];
    tapGeststudentInfo.delegate = self;
    
    UITapGestureRecognizer *tapGestAttendance =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceAttendance)];
    [tapGestAttendance setNumberOfTapsRequired:1];
    [_attendance_btn addGestureRecognizer:tapGestAttendance];
    tapGestAttendance.delegate = self;
    
    
    UITapGestureRecognizer *tapGeststudentResource =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceStudentResource)];
    [tapGeststudentResource setNumberOfTapsRequired:1];
    [btn_studentResource addGestureRecognizer:tapGeststudentResource];
    tapGeststudentResource.delegate = self;
    
    UITapGestureRecognizer *tapGestSibling=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceSibling)];
    [tapGestSibling setNumberOfTapsRequired:1];
    [btn_sibling addGestureRecognizer:tapGestSibling];
    tapGestSibling.delegate = self;
    

    
    
    
    
    //get current Month
    
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    day = [dateComponents month];
    month = [NSString stringWithFormat:@"%ld", day];
    
    NSLog(@"tMonth =%@", month);
//yocomment
//    //Add drawer image button
//    UIImage *faceImage = [UIImage imageNamed:@"drawer_icon.png"];
//    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
//    face.bounds = CGRectMake( 15, 0, 15, 15 );
//    UITapGestureRecognizer *tapdrawer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrawer)];
//    [tapdrawer setNumberOfTapsRequired:1];
//    [face addGestureRecognizer:tapdrawer];
//    tapdrawer.delegate = self;
//    [face addTarget:self action:@selector(handleDrawer) forControlEvents:UIControlEventTouchUpInside];
//    [face setImage:faceImage forState:UIControlStateNormal];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:face];
//    self.navigationItem.leftBarButtonItem = backButton;
//    [self.navigationItem setHidesBackButton:YES animated:YES];
//    [self.navigationItem setBackBarButtonItem:nil];
//    
//    self.rootNav = (CCKFNavDrawer *)self.navigationController;
//    [self.rootNav setCCKFNavDrawerDelegate:self];
//yocomment
   // [self httpPostRequest];
    [self needsUpdate];
    [self  checkInternetConnectivity];
    
}

-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)handleDrawer{
    [self.rootNav drawerToggle];
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

-(void)checkInternetConnectivity{
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    [hud hideAnimated:YES];
    

    
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
        if(firstWebcall == YES){
            firstWebcall = NO;
            [self httpPostRequest];
        }
    }
    else{
        
        name = [[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
        drawerstd = [[NSUserDefaults standardUserDefaults]stringForKey:@"Std"];
        drawerRollNo = [[NSUserDefaults standardUserDefaults]stringForKey:@"RollNo"];
        org_id =[[NSUserDefaults standardUserDefaults]stringForKey:@"Org_id"];
        sec_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"sec_id"];
        rol_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Roll_id"];
        Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
        messageReadCount = [[NSUserDefaults standardUserDefaults] arrayForKey:@"messageCount"];
        
        [self setLogo];
        label_studentName.text = name;
        label_schoolName.text = school_name;
        label_std .text= drawerstd;
        self.label_div.text = drawerRollNo;
        self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.btn_message.frame.size.width - 34, -20,44,40)];
        [self.btn_message addSubview:self.badgeCount];
        self.badgeCount.value =  [messageReadCount count];
        
        
        
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
     //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
    NSError *err;
    NSString *str = app_url @"PodarApp.svc/GetStundentDetails";
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
    
    //Pass The String to server
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:msd_id,@"msd_id",clt_id,@"clt_id",usl_id,@"usl_id",nil];
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
    NSLog(@"got studentinforesponse==%@", resSrt);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  [urlData writeToFile:filePathnew atomically:YES];
                    [hud hideAnimated:YES];
                    // NSLog(@"File Saved !");
                    
                });

            });
        });
    }
    else if([_Status isEqualToString:@"1"]){
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
        }else{
        NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
     //   NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
        ViewMessageStatus= [parsedJsonArray valueForKey:@"Status"];
        NSLog(@"Status:%@",ViewMessageStatus);
        
        ViewTableData = [receivedData objectForKey:@"ViewMessageResult"];
         NSLog(@"Size viewmessage:%lu",(unsigned long)[ViewTableData count]);
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
                    self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.btn_message.frame.size.width - 34, -20,44,40)];
                    [self.btn_message addSubview:self.badgeCount];
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
            [hud hideAnimated:YES];
         
            
            NSError *error = nil;
            NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
  //          NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
            LastViewMessageStatus= [parsedJsonArray valueForKey:@"Status"];
            NSLog(@"Status:%@",LastViewMessageStatus);
            
            ViewTableData = [receivedData objectForKey:@"ViewMessageResult"];
            //  NSLog(@"Size sibling:%lu",(unsigned long)[behaviourdetails count]);
            if([LastViewMessageStatus isEqualToString:@"1"]){
                ViewMessageStatus = @"1";
                for(int n = 0; n < [ViewTableData  count]; n++)
                {
                    @try{
                    _ViewMessageItems= [[ViewMessageResult alloc]init];
                    viewmessagedetails = [ViewTableData
                                          objectAtIndex:n];
                    _ViewMessageItems.pmu_readunredStatus = [viewmessagedetails objectForKey:@"pmu_readunreadstatus"];
                    messageReadStatus =_ViewMessageItems.pmu_readunredStatus;
                    NSLog(@"MessageStatus:%@",  _ViewMessageItems.pmu_readunredStatus);
                    if([messageReadStatus isEqualToString:@"1"]){
                        
                        [messageReadCount addObject:messageReadStatus];
                        
                        NSLog(@"Size ReadMesssage:%lu",(unsigned long)[messageReadCount count]);
                        self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.btn_message.frame.size.width - 34, -20,44,40)];
                        [self.btn_message addSubview:self.badgeCount];
                        self.badgeCount.value =  [messageReadCount count];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:messageReadCount forKey:@"messageCount"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    }
                    
                }
                    @catch (NSException *exception) {
                        NSLog(@"Exception: %@", exception);
                    }
                }
            }
            
        }
        }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  [urlData writeToFile:filePathnew atomically:YES];
                    [hud hideAnimated:YES];
                    // NSLog(@"File Saved !");
                
        });

            });
        });
        
    }
    else if(loginClick == YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        loginClick = NO;
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
      if(firstTime == YES){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              dispatch_async(dispatch_get_main_queue(), ^{
          firstTime = NO;
    NSError *error = nil;
    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
 //   NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
    _Status = [parsedJsonArray valueForKey:@"Status"];
    NSLog(@"Status:%@",_Status);
    
    NSArray* stundentDetails = [receivedData objectForKey:@"stundentListDetails"];
    
    //  NSLog(@"Size:%lu",(unsigned long)[stundentDetasils count]);
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

            acy_yrID = _item.acy_id;
            sch_id = _item.sch_id;
            cls_id = _item.cls_ID;
            stud_id = _item.stu_id;

            isStudentResourcePresent = _item.StudentResourceExist;
            org_id = _item.org_id;
            Brd_Id = _item.Brd_ID;
            sec_Id = _item.sec_ID;
            brd_name = _item.Brd_Name;
            _std = _item.std_Name;
            behaviourCount = _item.behaviourcnt;
            announcementCount = _item.annoucementCnt;
            
            NSLog(@"Brd name:%@",_item.Brd_Name);
            NSLog(@"profileerollno:%@",_item.msd_RollNo);
            
            label_studentName.text = _item.stu_display;
            label_schoolName.text = school_name;
            label_std .text=[NSString stringWithFormat: @"%@ %@ - %@ ", @"Std : ", _item.std_Name,_item.div_name];
            //lable_std.text = self.std;
            self.roll_no = [NSString stringWithFormat: @"%@ : %@ ", self.roll_no, _item.msd_RollNo];
            self.label_div.text = self.roll_no;
            drawerstd = label_std.text;
             drawername = label_studentName.text;
            draweracademicYear = _item.acy_Year;
            
            if([isStudentResourcePresent isEqualToString:@""]){
                [btn_studentResource setHidden:YES];
                [_studentresource_label setHidden:YES];
            }
            else if([isStudentResourcePresent isEqualToString:@"0"]){
                [btn_studentResource setHidden:NO];
                [_studentresource_label setHidden:NO];
                
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:announcementCount forKey:@"announcementCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:sch_id forKey:@"sch_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:stud_id forKey:@"stud_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:acy_yrID forKey:@"acy_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:cls_id forKey:@"cls_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            

            
            [[NSUserDefaults standardUserDefaults] setObject:behaviourCount forKey:@"behaviourCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:isStudentResourcePresent forKey:@"isStudenResourcePresent"];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.roll_no forKey:@"RollNo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:drawerstd forKey:@"Std"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:drawername forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:brd_name forKey:@"brd_name"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:_std forKey:@"std"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:school_name forKey:@"school_name"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:Brd_Id forKey:@"Brd_ID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:org_id forKey:@"Org_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:sec_Id forKey:@"sec_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];


            
            [[NSUserDefaults standardUserDefaults] setObject:draweracademicYear forKey:@"academicYear"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self setLogo];
            [self httpPostRequest];
            dispatch_async(dispatch_get_main_queue(), ^{
                //  [urlData writeToFile:filePathnew atomically:YES];
                [hud hideAnimated:YES];
                // NSLog(@"File Saved !");
            });
        }
        
    }
              });
          });
      }
    
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"went here ...");
    if(self.internetActive == YES){
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        // we touched a button, slider, or other UIControl
        
        if(touch.view == _btn_message){
            message = YES;
            tapGestRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnce)];
        }
        else if(touch == btn_paymentInfo){
            paymentInfo = YES;
            tapGestRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOncePaymentHistory)];
            
        }
        else if(touch.view == btn_studentInformation){
            studentInfo = YES;
            tapGestRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceStudentInfo)];
        }
        else if(touch.view == _attendance_btn){
            attendance = YES;
            tapGestRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceAttendance)];
            
        }
        else if(touch.view == btn_studentResource){
            studentResource = YES;
            tapGestRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceStudentResource)];
        }
        else if(touch.view == btn_sibling) {
            sibling = YES;
               tapGestRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceSibling)];
        }
        
        return YES; // ignore the touch
        
    }
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }

    return NO; // handle the touch
}


-(void)screenTappedOncePaymentHistory{
    ViewMessageStatus = @"0";
    LastViewMessageStatus = @"0";
    paymentInfo = NO;
    PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
    PaymentInfoViewController.msd_id = msd_id;
    PaymentInfoViewController.clt_id = clt_id;
    PaymentInfoViewController.brdName = brd_name;
    
    [self.navigationController pushViewController:PaymentInfoViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

-(void)screenTappedOnceStudentResource{
    studentResource = NO;
    //yocomment
    StudentResourcesViewController *StudentResourceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentResource"];
    StudentResourceViewController.msd_id = msd_id;
    StudentResourceViewController.usl_id = usl_id;
    StudentResourceViewController.clt_id = clt_id;
    StudentResourceViewController.brdName = brd_name;
    StudentResourceViewController.stdName = _std;
    [self.navigationController pushViewController:StudentResourceViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    //yocomment
}

-(void)screenTappedOnce{
    if(message == YES){
        message = NO;
        ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
        ViewMessageViewController.msd_id = msd_id;
        ViewMessageViewController.usl_id = usl_id;
        ViewMessageViewController.clt_id = clt_id;
        ViewMessageViewController.brdName = brd_name;
        ViewMessageViewController.stdName = _std;
        [self.navigationController pushViewController:ViewMessageViewController animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        
        
    }
    
}
-(void)screenTappedOnceStudentInfo{
    studentInfo = NO;
    StudentInformationViewController *StudentInformationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformation"];
    StudentInformationViewController.msd_id = msd_id;
    StudentInformationViewController.brdName = brd_name;
    //        secondViewController.usl_id = usl_id;
    //        secondViewController.clt_id = clt_id;
    //        secondViewController.name = name;
    //        secondViewController.school_name = school_name;
    //        secondViewController.teacherAnnouncementCount = teacher_announcementCount;
    [self.navigationController pushViewController:StudentInformationViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

-(void) screenTappedOnceAttendance{
    attendance = NO;
    //yocomment
    ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
    AttendanceViewController.msd_id = msd_id;
    AttendanceViewController.usl_id = usl_id;
    AttendanceViewController.clt_id = clt_id;
    AttendanceViewController.brd_Name = brd_name;
    [self.navigationController pushViewController:AttendanceViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

-(void) screenTappedOnceSibling{
    sibling = NO;
            SiblingStudentViewController *SiblingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Sibling"];
            SiblingViewController.msd_id = msd_id;
            SiblingViewController.usl_id = usl_id;
            SiblingViewController.clt_id = clt_id;
            SiblingViewController.brdName = brd_name;
            SiblingViewController.schoolName = school_name;
            [self.navigationController pushViewController:SiblingViewController animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}


//- (void)passDataForward
//{
//    
//    if(studentInfo==YES) {
//        studentInfo = NO;
//        StudentInformationViewController *StudentInformationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformation"];
//        StudentInformationViewController.msd_id = msd_id;
//        StudentInformationViewController.brdName = brd_name;
//        
//        [self.navigationController pushViewController:StudentInformationViewController animated:YES];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
//    }
//    else if(paymentInfo==YES){
//        paymentInfo = NO;
//        PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
//        PaymentInfoViewController.msd_id = msd_id;
//        PaymentInfoViewController.clt_id = clt_id;
//        PaymentInfoViewController.brdName = brd_name;
//        [self.navigationController pushViewController:PaymentInfoViewController animated:YES];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
//    }
//    else if(sibling == YES){
//        sibling = NO;
//        SiblingStudentViewController *SiblingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Sibling"];
//        SiblingViewController.msd_id = msd_id;
//        SiblingViewController.usl_id = usl_id;
//        SiblingViewController.clt_id = clt_id;
//        SiblingViewController.brdName = brd_name;
//        SiblingViewController.schoolName = school_name;
//        [self.navigationController pushViewController:SiblingViewController animated:YES];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
//    }
//    else if(studentResource == YES){
//        studentResource = NO;
//        StudentResourcesViewController *StudentResourceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentResource"];
//        StudentResourceViewController.msd_id = msd_id;
//        StudentResourceViewController.usl_id = usl_id;
//        StudentResourceViewController.clt_id = clt_id;
//        StudentResourceViewController.brdName = brd_name;
//        StudentResourceViewController.stdName = _std;
//        NSLog(@"Std name Profile:%@",_std);
//        [self.navigationController pushViewController:StudentResourceViewController animated:YES];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
//    }
//    else if(message == YES){
//        message = NO;
//        ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
//        ViewMessageViewController.msd_id = msd_id;
//        ViewMessageViewController.msd_id = msd_id;
//        ViewMessageViewController.usl_id = usl_id;
//        ViewMessageViewController.clt_id = clt_id;
//        ViewMessageViewController.brdName = brd_name;
//        ViewMessageViewController.stdName = _std;
//  //      NSLog(@"msdid", msd_id);
//        [self.navigationController pushViewController:ViewMessageViewController animated:YES];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
//        
//    }
//    else if(attendance==YES){
//        attendance = NO;
//        ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
//        AttendanceViewController.msd_id = msd_id;
//        AttendanceViewController.usl_id = usl_id;
//        AttendanceViewController.clt_id = clt_id;
//        AttendanceViewController.brd_Name = brd_name;
//        [self.navigationController pushViewController:AttendanceViewController animated:YES];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
//        
//    }
//}


- (IBAction)studentInformation_btn:(id)sender {
  //  studentInfo = YES;
 //   [btn_studentInformation addTarget:self action:@selector(passDataForward) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)sibling_btn:(id)sender {
//    sibling = YES;
//    [btn_sibling addTarget:self action:@selector(passDataForward) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)paymentInfo_btn:(id)sender {
 //   paymentInfo = YES;
 //   [btn_paymentInfo addTarget:self action:@selector(passDataForward) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)studentResource:(id)sender {
 //  studentResource = YES;
  //  [btn_studentResource addTarget:self action:@selector(passDataForward) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)Message:(id)sender {
 //   message = YES;
   // [_btn_message addTarget:self action:@selector(passDataForward) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)Attendance:(id)sender {
 //   attendance = YES;
   // [_attendance_btn addTarget:self action:@selector(passDataForward) forControlEvents:/UIControlEventTouchUpInside];
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
   if (controller == settingsPopoverController)
    {
        settingsPopoverController.delegate = nil;
        settingsPopoverController = nil;
    }
}
-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
//    NSString* myString = [@(selectionIndex) stringValue];
//    NSLog(@"CCKFNavDrawerSelection=%i", selectionIndex);
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
    
    LoginArrayCount = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"LoginUserCount"];
    
   NSLog(@"LoginCount %@", LoginArrayCount);
    
    //Sibling
    if(![LoginArrayCount isEqualToString:@"1"]){
        NSLog(@"Sibling profile");

       
        if([isStudentResourcePresent isEqualToString:@"0"]){
            
            NSLog(@"isStudentResourcePresent %@", isStudentResourcePresent);
            NSLog(@"With student resources");


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
        ViewMessageViewController.brdName = brd_name;
        ViewMessageViewController.stdName = _std;
  //      NSLog(@"msdid", msd_id);
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
        //yocomment
        StudentResourcesViewController *StudentResourceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentResource"];
        StudentResourceViewController.msd_id = msd_id;
        StudentResourceViewController.usl_id = usl_id;
        StudentResourceViewController.clt_id = clt_id;
        StudentResourceViewController.brdName = brd_name;
        StudentResourceViewController.stdName = _std;
        [self.navigationController pushViewController:StudentResourceViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }

    else if(selectionIndex == 5){
        ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
//        AttendanceViewController.msd_id = msd_id;
//        AttendanceViewController.usl_id = usl_id;
//        AttendanceViewController.clt_id = clt_id;
//        AttendanceViewController.brd_Name = brd_name;
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
        ChangePasswordViewController.brd_Name = brd_name;
        [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        
        
    }
    else if(selectionIndex == 8){
        loginClick = YES;
        _Status = @"0";
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

        
       
    
    }
    }
        else if([isStudentResourcePresent isEqualToString:@""]){
            
            NSLog(@"isStudentResourcePresent %@", isStudentResourcePresent);
            NSLog(@"Without student resources");

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
                ViewMessageViewController.brdName = brd_name;
                ViewMessageViewController.stdName = _std;
                //      NSLog(@"msdid", msd_id);
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
                //                AttendanceViewController.msd_id = msd_id;
                //                AttendanceViewController.usl_id = usl_id;
                //                AttendanceViewController.clt_id = clt_id;
                //                AttendanceViewController.brd_Name = brd_name;
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
                ChangePasswordViewController.brd_Name = brd_name;
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
                
                
             
            }
        

        }
    }
    else if([LoginArrayCount isEqualToString:@"1"]){
        if([isStudentResourcePresent isEqualToString:@"0"]){
        if(selectionIndex == 0){
            
            StudentProfileWithSiblingViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SiblingProfile"];
            secondViewController.msd_id = msd_id;
            secondViewController.usl_id = usl_id;
            secondViewController.clt_id = clt_id;
            [self.navigationController pushViewController:secondViewController animated:YES];
        }
        else if(selectionIndex == 1){
            ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
            ViewMessageViewController.msd_id = msd_id;
            ViewMessageViewController.usl_id = usl_id;
            ViewMessageViewController.clt_id = clt_id;
            ViewMessageViewController.brdName = brd_name;
            ViewMessageViewController.stdName = _std;
 //           NSLog(@"msdid", msd_id);
            [self.navigationController pushViewController:ViewMessageViewController animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 2){
            PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
            PaymentInfoViewController.msd_id = msd_id;
            PaymentInfoViewController.clt_id = clt_id;
            [self.navigationController pushViewController:PaymentInfoViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }
        else if(selectionIndex == 3){
            StudentResourcesViewController *StudentResourceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentResource"];
            StudentResourceViewController.msd_id = msd_id;
            StudentResourceViewController.usl_id = usl_id;
            StudentResourceViewController.clt_id = clt_id;
            StudentResourceViewController.brdName = brd_name;
            StudentResourceViewController.stdName = _std;
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

//
           
        }
        }
        else if([isStudentResourcePresent isEqualToString:@"1"]){
            if(selectionIndex == 0){
                
                StudentProfileWithSiblingViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SiblingProfile"];
                secondViewController.msd_id = msd_id;
                secondViewController.usl_id = usl_id;
                secondViewController.clt_id = clt_id;
                [self.navigationController pushViewController:secondViewController animated:YES];
            }
            else if(selectionIndex == 1){
                ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
                ViewMessageViewController.msd_id = msd_id;
                ViewMessageViewController.usl_id = usl_id;
                ViewMessageViewController.clt_id = clt_id;
                ViewMessageViewController.brdName = brd_name;
                ViewMessageViewController.stdName = _std;
                //           NSLog(@"msdid", msd_id);
                [self.navigationController pushViewController:ViewMessageViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 2){
                PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
                PaymentInfoViewController.msd_id = msd_id;
                PaymentInfoViewController.clt_id = clt_id;
                [self.navigationController pushViewController:PaymentInfoViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 3){
                ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
//                AttendanceViewController.msd_id = msd_id;
//                AttendanceViewController.usl_id = usl_id;
//                AttendanceViewController.clt_id = clt_id;
//                AttendanceViewController.brd_Name = brd_name;
                [self.navigationController pushViewController:AttendanceViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 4){
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
            else if(selectionIndex == 5){
                ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
//                ChangePasswordViewController.msd_id = msd_id;
//                ChangePasswordViewController.clt_id = clt_id;
//                ChangePasswordViewController.usl_id = usl_id;
//                ChangePasswordViewController.brd_Name = brd_name;
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

            }

        }

    }
    
}
-(void) setLogo{
    
    if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"1"]) && ((![sec_Id isEqualToString: @"1"])))){
        
        _schoolLogo.image = [UIImage imageNamed:@"CBSE Logo 200x100 pix (2).png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"2"]) && ((![sec_Id isEqualToString: @"1"])))){
       
        _schoolLogo.image = [UIImage imageNamed:@"ICSE_Logo.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"3"]) && ((![sec_Id isEqualToString: @"1"])))){
        _schoolLogo.image = [UIImage imageNamed:@"cie_250x100_old.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"5"]) && ((![sec_Id isEqualToString: @"1"])))){
        _schoolLogo.image = [UIImage imageNamed:@"ssc_250x80.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"4"]))){
        _schoolLogo.image = [UIImage imageNamed:@"Podar ORT.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([sec_Id isEqualToString: @"5"]) && (([school_name containsString:@"Podar Jumbo"])))){
        _schoolLogo.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([Brd_Id isEqualToString: @"1"]) && (([sec_Id isEqualToString: @"1"])))){
        _schoolLogo.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if(([org_id isEqualToString:@"2"]) && ([brd_name isEqualToString:@"ICSE"]) && ([sec_Id isEqualToString:@"1"])){
        _schoolLogo.image = [UIImage imageNamed:@"PJK.png"];
        
    }
    else if((([org_id isEqualToString: @"4"]) && ([Brd_Id isEqualToString: @"10"]))){
        _schoolLogo.image = [UIImage imageNamed:@"lilavati_250x125.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([Brd_Id isEqualToString: @"1"]))){
        _schoolLogo.image = [UIImage imageNamed:@"rnpodar_225x100.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([Brd_Id isEqualToString: @"4"]))){
        _schoolLogo.image = [UIImage imageNamed:@"ib_250x100.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([clt_id isEqualToString: @"39"]))){
        _schoolLogo.image = [UIImage imageNamed:@"pwc_225x225.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([clt_id isEqualToString: @"38"]))){
        _schoolLogo.image = [UIImage imageNamed:@"pic_225x225.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([Brd_Id isEqualToString: @"5"]))){
        _schoolLogo.image = [UIImage imageNamed:@"ssc_250x100.png"];
    }
    else if((([org_id isEqualToString: @"3"]) && ([Brd_Id isEqualToString: @"1"]) && ((![sec_Id isEqualToString: @"1"])))){
        _schoolLogo.image = [UIImage imageNamed:@"pws_300x95.png"];
    }
    else if((([org_id isEqualToString: @"3"]) && ([Brd_Id isEqualToString: @"1"]) && (([sec_Id isEqualToString: @"1"])))){
        _schoolLogo.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if((([org_id isEqualToString: @"3"]) && ([Brd_Id isEqualToString: @"1"]) && (([sec_Id isEqualToString: @"1"])) && ([school_name containsString:@"Podar Jumbo"]))){
        _schoolLogo.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if((([org_id isEqualToString: @"1"]))){
        _schoolLogo.image = [UIImage imageNamed:@"CBSE Logo 200x100 pix (2).png"];
    }
    else{
        _schoolLogo.hidden = NO;
    }
    
}


@end
