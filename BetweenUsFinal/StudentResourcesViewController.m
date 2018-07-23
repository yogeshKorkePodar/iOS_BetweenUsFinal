//
//  StudentResourcesViewController.m
//  TestAutoLayout
//
//  Created by podar on 18/06/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "StudentResourcesViewController.h"
#import "RestAPI.h"
#import "CycleTest.h"
#import "Subject.h"
#import "TopicList.h"
#import "CCKFNavDrawer.h"
#import "ResourceViewController2.h"
#import "LoginViewController.h"
#import "StudentInformationViewController.h"
#import "StudentProfileWithSiblingViewController.h"
#import "StudentDashboardWithoutSibling.h"
#import "ChangePassswordViewController.h"
#import "AboutUsViewController.h"
#import "PaymentInfoViewController.h"
#import "ViewAttendanceViewController.h"
#import "SiblingStudentViewController.h"
#import "ViewMessageViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "WYPopoverController.h"
@interface StudentResourcesViewController (){
    BOOL cycleTest,subjectbool,firstTime,cycletestClick,subjectClick,cycleTestClickTopic,loginClick,firstWebcall;
    WYPopoverController *settingsPopoverController;
    UITableView *table;
    UITableView *table2;
    UIAlertView *alertcycle;
    UIAlertView *alertsubject;
}

@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) CycleTest *CycleTest;
@property (nonatomic, strong) CycleTest *CycleItem;
@property (nonatomic, strong) Subject *Subject;
@property (nonatomic, strong) Subject *SubjectItem;
@property (nonatomic, strong) TopicList *TopicList;
@property (nonatomic, strong) TopicList *TopicListtItem;
//yocomment
//@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@end

@implementation StudentResourcesViewController
@synthesize msd_id,usl_id,clt_id,Status,brdName,school_name,click_subject,click_cycletest,topic_tableData,stdName,cycleTableData,subjectTableData;

-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    firstWebcall = YES;
    [self checkInternetConnectivity];
    //Hide back button
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         //forBarMetrics:UIBarMetricsDefault];
    //self.navigationItem.hidesBackButton=YES;
    
    self.navigationItem.hidesBackButton = YES;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    // Do any additional setup after loading the view.
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"white-menu-icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 25)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;

    
    //Add drawer image button
    //yocomment
//    UIImage *faceImage = [UIImage imageNamed:@"drawer_icon.png"];
//    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
//    face.bounds = CGRectMake( 10, 0, 15, 15 );
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
    
    //yocomment
   // self.rootNav = (CCKFNavDrawer *)self.navigationController;
   // [self.rootNav setCCKFNavDrawerDelegate:self];
//yocomment
    
    //Set Border to button
   // [self.cycletestView.layer setBorderWidth:1.0];
    //[self.cycletestView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];

    
    msd_id = msd_id;
    clt_id = clt_id;
    usl_id = usl_id;
    brdName = brdName;
    stdName = stdName;
    firstTime= YES;
    
    
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

    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    DeviceType= @"IOS";
    
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
    NSLog(@"std anme studentresource =%@", stdName);
    [cycleTableData setHidden:YES];
    [subjectTableData setHidden:YES];
    self.cycleTableData.delegate = self;
    self.cycleTableData.dataSource = self;
    self.subjectTableData.dataSource = self;
    self.subjectTableData.delegate = self;
    self.topic_tableData.delegate = self;
    self.topic_tableData.dataSource = self;
    cycleTableData.frame = self.view.bounds;
    // or
  //  settingsTable.view.frame = self.view.frame;
    [self httpPostRequest];
}

-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)checkInternetConnectivity{
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
        if(firstWebcall == YES){
            firstWebcall == NO;
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
    @try{
    if(firstTime==YES){
        //Cycle Test
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{

        NSError *err;
                NSString *str =app_url @"CycleTestDropDown";
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:str];
        
                //Pass The String to server
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:brdName,@"brd_name",nil];
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
                NSLog(@"got response==%@", resSrt);
      
        
        NSDictionary *receivedDataCycle =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
        
        //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
        
        NSArray *parsedJsonArrayCycle = [NSJSONSerialization JSONObjectWithData:responseData options:
                                    (NSJSONReadingMutableContainers) error:&err];
        Status = [parsedJsonArrayCycle valueForKey:@"Status"];
        
        NSLog(@"CycleStatus:%@",Status);
        cycleData = [receivedDataCycle objectForKey:@"CycleTest"];
        NSLog(@"CycleSize:%lu",(unsigned long)[cycleData count]);
        _CycleItem = [[CycleTest alloc]init];
        CycleDetails = [cycleData objectAtIndex:0];
       _CycleItem.cyc_name = [CycleDetails objectForKey:@"cyc_name"];
        cyclename =  _CycleItem.cyc_name;
        [click_cycletest setTitle:cyclename forState:UIControlStateNormal];
        NSLog(@"CycleName:%@",_CycleItem.cyc_name);
    
        //Subject List
                NSError *err1;
                NSString *str1 =app_url @"SubjectDropdown";
                str1 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url1 = [NSURL URLWithString:str1];
        
                //Pass The String to server
                NSDictionary *newDatasetInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",msd_id,@"msd_id",cyclename,@"cycleTest",nil];
                NSLog(@"the data Details is =%@", newDatasetInfo1);
        
                //convert object to data
                NSData* jsonData1 = [NSJSONSerialization dataWithJSONObject:newDatasetInfo1 options:kNilOptions error:&err1];
                NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url1];
                [request1 setHTTPMethod:POST];
                [request1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request1 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
                //Apply the data to the body
                [request1 setHTTPBody:jsonData1];
        
                self.restApi.delegate = self;
                [self.restApi httpRequest:request1];
                NSURLResponse *response1;
        
                NSData *responseData1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:&response1 error:&err1];
                NSString *resSrt1 = [[NSString alloc]initWithData:responseData1 encoding:NSASCIIStringEncoding];
                
                //This is for Response
                NSLog(@"got response==%@", resSrt1);
        
        
        NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingAllowFragments error:&err1];
        
                //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
        
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData1 options:
                                            (NSJSONReadingMutableContainers) error:&err1];
                SubjectStatus = [parsedJsonArray valueForKey:@"Status"];
        
                NSLog(@"SubjectStatus:%@",SubjectStatus);
                subjectData = [receivedData objectForKey:@"Subject"];
                NSLog(@"Size:%lu",(unsigned long)[subjectData count]);
        if([SubjectStatus isEqualToString:@"1"]){
                _SubjectItem = [[Subject alloc]init];
                subjectDetails = [subjectData objectAtIndex:0];
                _SubjectItem.sbj_name = [subjectDetails objectForKey:@"sbj_name"];
                subject =  _SubjectItem.sbj_name;
        [click_subject setTitle:subject forState:UIControlStateNormal];
                NSLog(@"SubjectName:%@",_SubjectItem.sbj_name);
        }
        

        //Topic List
        NSError *err2;
        NSString *str2 =app_url @"GetTopicList";
                str2 = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url2 = [NSURL URLWithString:str2];
        //[self getData];
                //Pass The String to server
        NSDictionary *newDatasetInfo2 = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",brdName,@"brd_name",cyclename,@"cycleTest",stdName,@"std_name",subject,@"subject",nil];
                NSLog(@"the data Details is =%@", newDatasetInfo2);
        
                //convert object to data
                NSData* jsonData2 = [NSJSONSerialization dataWithJSONObject:newDatasetInfo2 options:kNilOptions error:&err2];
                NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
                [request2 setHTTPMethod:POST];
                [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request2 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
                //Apply the data to the body
                [request2 setHTTPBody:jsonData2];
        
                self.restApi.delegate = self;
                [self.restApi httpRequest:request2];
                NSURLResponse *response2;
        
                NSData *responseData2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&err2];
                NSString *resSrt2 = [[NSString alloc]initWithData:responseData2 encoding:NSASCIIStringEncoding];
                
                //This is for Response
                NSLog(@"got responsetopic==%@", resSrt2);
        
        
        [hud hideAnimated:YES];
        NSDictionary *receivedData1 =[NSJSONSerialization JSONObjectWithData:responseData2 options:NSJSONReadingAllowFragments error:&err2];
        
    //    NSMutableDictionary *returnedDict1 = [NSJSONSerialization JSONObjectWithData:responseData2 options:kNilOptions error:&err2];
        NSArray *parsedJsonArray1 = [NSJSONSerialization JSONObjectWithData:responseData2 options:
                                    (NSJSONReadingMutableContainers) error:&err2];
        TopicStatus = [parsedJsonArray1 valueForKey:@"Status"];
        
        
        //  NSLog(@"Size:%lu",(unsigned long)[stundentDetasils count]);
        if([TopicStatus isEqualToString:@"1"]){
            [lbl1 setHidden:YES];
            TopicStatus = [parsedJsonArray1 valueForKey:@"Status"];
            topicData = [receivedData1 objectForKey:@"TopicList"];
            NSLog(@"TopicSize:%lu",(unsigned long)[topicData count]);
            if([TopicStatus isEqualToString:@"1"]){
                [lbl1 setHidden:YES];
                [topic_tableData setHidden:NO];
                [lbl1 setHidden:YES];
                for(int n = 0; n < [topicData count]; n++)
                {
                    _TopicListtItem = [[TopicList alloc]init];
                    NSDictionary* topicdetails = [topicData objectAtIndex:n];
                    _TopicListtItem.crf_topicname = [topicdetails objectForKey:@"crf_topicname"];
                    topic =_TopicListtItem.crf_topicname;
                    NSLog(@"TopicName:%@",_TopicListtItem.crf_topicname);
                }
            }
        }
        else if([TopicStatus isEqualToString:@"0"]){
//            [lbl1 setHidden:NO];
            [topic_tableData setHidden:YES];
//            lbl1 = [[UILabel alloc] init];
//            // [lbl1 setFrame:CGRectMake(0,5,100,20)];
//            [lbl1 setFrame: CGRectMake(100, 10, 250, 620)];
//            lbl1.font= [UIFont systemFontOfSize:14.0];
//            lbl1.backgroundColor=[UIColor clearColor];
//            lbl1.textColor=[UIColor blackColor];
//            lbl1.userInteractionEnabled=YES;
//            lbl1.font = [UIFont fontWithName:@"Arial-Bold" size:14.0f];
//            // [lbl1 sizeToFit];
//            [self.view addSubview:lbl1];
//            lbl1.text= @"No Records Found";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }

        [topic_tableData reloadData];
        
        
        
            });
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            //  [urlData writeToFile:filePathnew atomically:YES];
            [hud hideAnimated:YES];
            // NSLog(@"File Saved !");
        });
    }
    else if(cycleTest == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{

        NSError *err;
                NSString *str =app_url @"CycleTestDropDown";
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:str];
        
                //Pass The String to server
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:brdName,@"brd_name",nil];
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
                NSLog(@"got response==%@", resSrt);
            });
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            //  [urlData writeToFile:filePathnew atomically:YES];
            [hud hideAnimated:YES];
            // NSLog(@"File Saved !");
        });
    }
    else if(subjectbool == YES){
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{

                NSError *err;
                NSString *str =app_url @"SubjectDropdown";
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:str];
        
                //Pass The String to server
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",msd_id,@"msd_id",cycletest,@"cycleTest",nil];
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
                NSLog(@"got response==%@", resSrt);
            });
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            //  [urlData writeToFile:filePathnew atomically:YES];
            [hud hideAnimated:YES];
            // NSLog(@"File Saved !");
        });

    }
    else if(cycletestClick == YES){
        
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{

        NSError *err;
        NSString *str =app_url @"SubjectDropdown";
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:str];
        
        //Pass The String to server
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",msd_id,@"msd_id",cycletest,@"cycleTest",nil];
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
        NSLog(@"got response==%@", resSrt);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  [urlData writeToFile:filePathnew atomically:YES];
                    [hud hideAnimated:YES];
                    // NSLog(@"File Saved !");
                });        
//        NSError *err;
//        NSString *str = app_url @"GetTopicList";
//        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *url = [NSURL URLWithString:str];
//        
//        //Pass The String to server
//        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",brdName,@"brd_name",cyclename,@"cycleTest",stdName,@"std_name",subject,@"subject",nil];
//        NSLog(@"the data Details is =%@", newDatasetInfo);
//        
//        //convert object to data
//        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&err];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        [request setHTTPMethod:POST];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        
//        //Apply the data to the body
//        [request setHTTPBody:jsonData];
//        
//        self.restApi.delegate = self;
//        [self.restApi httpRequest:request];
//        NSURLResponse *response;
//        
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
//        NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
//        
//        //This is for Response
//        NSLog(@"got response==%@", resSrt);
            });
        });
        [hud hideAnimated: YES];

    }
    else if(subjectClick == YES){
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{

        NSError *err;
        NSString *str =app_url @"GetTopicList";
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:str];
        
        //Pass The String to server
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",brdName,@"brd_name",cyclename,@"cycleTest",stdName,@"std_name",subject,@"subject",nil];
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
        NSLog(@"got response==%@", resSrt);
            });
        });
        [hud hideAnimated:YES];
    }
    else if(cycleTestClickTopic == YES){
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{

        NSError *err;
        NSString *str =app_url @"GetTopicList";
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:str];
        
        //Pass The String to server
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",brdName,@"brd_name",cyclename,@"cycleTest",stdName,@"std_name",subject,@"subject",nil];
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
        NSLog(@"got response==%@", resSrt);
        
      //  [hud hideAnimated:YES];
        NSError *error = nil;
        NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
   //     NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
        
        
        
        TopicStatus = [parsedJsonArray valueForKey:@"Status"];
        
        NSLog(@"Status:%@",TopicStatus);
        
        //NSLog(@"Size:%lu",(unsigned long)[subjectData count]);
        
        if([TopicStatus isEqualToString:@"1"]){
            [lbl1 setHidden:YES];
            TopicStatus = [parsedJsonArray valueForKey:@"Status"];
            topicData = [receivedData objectForKey:@"TopicList"];
            NSLog(@"TopicSize:%lu",(unsigned long)[topicData count]);
            if([TopicStatus isEqualToString:@"1"]){
                
                [topic_tableData setHidden:NO];
              //  [lbl1 setHidden:YES];
                
                for(int n = 0; n < [topicData count]; n++)
                {
                    _TopicListtItem = [[TopicList alloc]init];
                    NSDictionary* topicdetails = [topicData objectAtIndex:n];
                    _TopicListtItem.crf_topicname = [topicdetails objectForKey:@"crf_topicname"];
                    topic =_TopicListtItem.crf_topicname;
                    NSLog(@"TopicName:%@",_TopicListtItem.crf_topicname);
                }
            }
             [topic_tableData reloadData];                                      
          }
        
        else if([TopicStatus isEqualToString:@"0"]){
//            [lbl1 setHidden:NO];
            [topic_tableData setHidden:YES];
//            lbl1 = [[UILabel alloc] init];
//            // [lbl1 setFrame:CGRectMake(0,5,100,20)];
//            [lbl1 setFrame: CGRectMake(100, 10, 250, 620)];
//            lbl1.font= [UIFont systemFontOfSize:14.0];
//            
//            lbl1.backgroundColor=[UIColor clearColor];
//            lbl1.textColor=[UIColor blackColor];
//            lbl1.userInteractionEnabled=YES;
//            lbl1.font = [UIFont fontWithName:@"Arial-Bold" size:14.0f];
//            // [lbl1 sizeToFit];
//            [self.view addSubview:lbl1];
//            lbl1.text= @"No Records Found";
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        [topic_tableData reloadData];
            });
        });
        [hud hideAnimated:YES];

    }
    else if(loginClick == YES){
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        loginClick = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{

        NSError *err;
        NSString *str =app_url @"LogOut";
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
            });
        });
        [hud hideAnimated:YES];
    }

    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

-(void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender
{
    
    if(cycleTest ==YES){
        NSError *error = nil;
            NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
       //     NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                            (NSJSONReadingMutableContainers) error:&error];
                Status = [parsedJsonArray valueForKey:@"Status"];
        
                NSLog(@"Status:%@",Status);
                cycleTest = NO;
                cycleData = [receivedData objectForKey:@"CycleTest"];
                NSLog(@"Size:%lu",(unsigned long)[cycleData count]);
                if([Status isEqualToString:@"1"]){
                    for(int n = 0; n < [cycleData count]; n++)
                    {
                        _CycleItem = [[CycleTest alloc]init];
                        NSDictionary* parentStatedetails = [cycleData objectAtIndex:n];
                        _CycleItem.cyc_name = [parentStatedetails objectForKey:@"cyc_name"];
                        _CycleItem.cyc_id =[parentStatedetails objectForKey:@"cyc_id"];
                        NSLog(@"CycleName:%@",_CycleItem.cyc_name);
                    }
                }
                [self.cycleTableData reloadData];
                
                
            }
    else if(subjectbool==YES){
        NSError *error = nil;
        NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
   //     NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
        (NSJSONReadingMutableContainers) error:&error];
        SubjectStatus = [parsedJsonArray valueForKey:@"Status"];
                        
        NSLog(@"Status:%@",SubjectStatus);
        subjectData = [receivedData objectForKey:@"Subject"];
        
        //NSLog(@"Size:%lu",(unsigned long)[subjectData count]);
        
        if([SubjectStatus isEqualToString:@"1"]){
            
            [subjectTableData setHidden:NO];
            for(int n = 0; n < [subjectData count]; n++)
                
            {
                _SubjectItem = [[Subject alloc]init];
                NSDictionary* parentStatedetails = [subjectData objectAtIndex:n];
                _SubjectItem.sbj_name = [parentStatedetails objectForKey:@"sbj_name"];
                NSLog(@"SubjectName:%@",_SubjectItem.sbj_name);
            }
            
        }
        else if([SubjectStatus isEqualToString:@"0"]){
            
            [subjectTableData setHidden:YES];
        }
        [self.subjectTableData reloadData];
    }
    else if(cycletestClick==YES){
        
        
        NSError *error = nil;
        NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
     //   NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                    (NSJSONReadingMutableContainers) error:&error];
        SubjectStatus = [parsedJsonArray valueForKey:@"Status"];
        
        NSLog(@"Status:%@",SubjectStatus);
        subjectData = [receivedData objectForKey:@"Subject"];
        
        //NSLog(@"Size:%lu",(unsigned long)[subjectData count]);
        
        if([SubjectStatus isEqualToString:@"1"]){
            
           // [subjectTableData setHidden:NO];
            [lbl1 setHidden:YES];

            cycletestClick = NO;
            subjectClick = NO;
            cycleTestClickTopic = YES;
                NSDictionary* parentStatedetails = [subjectData objectAtIndex:0];
                _SubjectItem.sbj_name = [parentStatedetails objectForKey:@"sbj_name"];
                subject = _SubjectItem.sbj_name;
                NSLog(@"SubjectName:%@",_SubjectItem.sbj_name);
                [click_subject setTitle: subject forState:UIControlStateNormal];
            [self httpPostRequest];
        }
        else if([SubjectStatus isEqualToString:@"0"]){
            [lbl1 setHidden:YES];
            [click_subject setTitle:@"" forState:UIControlStateNormal];
            cycletestClick = NO;
            subjectClick = NO;
            cycleTestClickTopic = YES;
            [self httpPostRequest];
            [subjectTableData setHidden:YES];
        }
        [self.subjectTableData reloadData];
        
        
        
    }
    else if(subjectClick == YES){
        NSError *error = nil;
        NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
    //    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                    (NSJSONReadingMutableContainers) error:&error];
        TopicStatus = [parsedJsonArray valueForKey:@"Status"];
        
        NSLog(@"Status:%@",TopicStatus);
        
        //NSLog(@"Size:%lu",(unsigned long)[subjectData count]);
        
        if([TopicStatus isEqualToString:@"1"]){
            [lbl1 setHidden:YES];

            TopicStatus = [parsedJsonArray valueForKey:@"Status"];
            topicData = [receivedData objectForKey:@"TopicList"];
            NSLog(@"TopicSize:%lu",(unsigned long)[topicData count]);
            if([TopicStatus isEqualToString:@"1"]){
                
                [topic_tableData setHidden:NO];
                [lbl1 setHidden:YES];

                for(int n = 0; n < [topicData count]; n++)
                {
                    _TopicListtItem = [[TopicList alloc]init];
                    NSDictionary* topicdetails = [topicData objectAtIndex:n];
                    _TopicListtItem.crf_topicname = [topicdetails objectForKey:@"crf_topicname"];
                    topic =_TopicListtItem.crf_topicname;
                    NSLog(@"TopicName:%@",_TopicListtItem.crf_topicname);
                }
            }
            
            
        }
        else if([TopicStatus isEqualToString:@"0"]){
//            [lbl1 setHidden:NO];
            [topic_tableData setHidden:YES];
//            lbl1 = [[UILabel alloc] init];
//            // [lbl1 setFrame:CGRectMake(0,5,100,20)];
//            [lbl1 setFrame: CGRectMake(100, 10, 250, 620)];
//            lbl1.font= [UIFont systemFontOfSize:14.0];
//
//            lbl1.backgroundColor=[UIColor clearColor];
//            lbl1.textColor=[UIColor blackColor];
//            lbl1.userInteractionEnabled=YES;
//            lbl1.font = [UIFont fontWithName:@"Arial-Bold" size:14.0f];
//            // [lbl1 sizeToFit];
//            [self.view addSubview:lbl1];
//            lbl1.text= @"No Records Found";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        [topic_tableData reloadData];
    }
    
    else if(cycleTestClickTopic == YES){
        cycleTestClickTopic = NO;
        NSError *error = nil;
        NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
  //      NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                    (NSJSONReadingMutableContainers) error:&error];
        TopicStatus = [parsedJsonArray valueForKey:@"Status"];
        
        NSLog(@"Status:%@",TopicStatus);
        
        //NSLog(@"Size:%lu",(unsigned long)[subjectData count]);
        
        if([TopicStatus isEqualToString:@"1"]){
            [lbl1 setHidden:YES];

            TopicStatus = [parsedJsonArray valueForKey:@"Status"];
            topicData = [receivedData objectForKey:@"TopicList"];
            NSLog(@"TopicSize:%lu",(unsigned long)[topicData count]);
            if([TopicStatus isEqualToString:@"1"]){
                
                [topic_tableData setHidden:NO];
                [lbl1 setHidden:YES];
                
                for(int n = 0; n < [topicData count]; n++)
                {
                    _TopicListtItem = [[TopicList alloc]init];
                    NSDictionary* topicdetails = [topicData objectAtIndex:n];
                    _TopicListtItem.crf_topicname = [topicdetails objectForKey:@"crf_topicname"];
                    topic =_TopicListtItem.crf_topicname;
                    NSLog(@"TopicName:%@",_TopicListtItem.crf_topicname);
                }
            }
            
            [topic_tableData reloadData];

        }
        
        else if([TopicStatus isEqualToString:@"0"]){
//            [lbl1 setHidden:NO];
           [topic_tableData setHidden:YES];
//            lbl1 = [[UILabel alloc] init];
//            // [lbl1 setFrame:CGRectMake(0,5,100,20)];
//            [lbl1 setFrame: CGRectMake(100, 10, 250, 620)];
//            lbl1.font= [UIFont systemFontOfSize:14.0];
//            
//            lbl1.backgroundColor=[UIColor clearColor];
//            lbl1.textColor=[UIColor blackColor];
//            lbl1.userInteractionEnabled=YES;
//            lbl1.font = [UIFont fontWithName:@"Arial-Bold" size:14.0f];
//            // [lbl1 sizeToFit];
//            [self.view addSubview:lbl1];
//            lbl1.text= @"No Records Found";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Information" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
       
    }
    
    
}


-(void) setData{
    
    [click_cycletest setTitle: _CycleItem.cyc_name forState:UIControlStateNormal];
    [click_subject setTitle:_SubjectItem forState:UIControlStateNormal];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        if(tableView == table2){
            return [cycleData count];
        }
        else if(tableView == subjectTableData){
            return [subjectData count];
        }
        else if(tableView == topic_tableData){
            return [topicData count];
        }
        else if(tableView == table){
            return [subjectData count];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SiblingTableViewCell" owner:self options:nil];
        // cell = [nib objectAtIndex:0];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
//    //std = [NSString stringWithFormat: @"Std:",std];
//    
    if(tableView==table2){
        
        [cell.textLabel setFont: [cell.textLabel.font fontWithSize: 14]];
         cycletest= [[cycleData objectAtIndex:indexPath.row] objectForKey:@"cyc_name"];
        cell.textLabel.text = [[cycleData objectAtIndex:indexPath.row] objectForKey:@"cyc_name"];
    }
    else if(tableView == subjectTableData){
        
        [cell.textLabel setFont: [cell.textLabel.font fontWithSize: 14]];
        subject = [[subjectData objectAtIndex:indexPath.row] objectForKey:@"sbj_name"];
        cell.textLabel.text = [[subjectData objectAtIndex:indexPath.row] objectForKey:@"sbj_name"];
    }
    else if(tableView == topic_tableData){
        topic = [[topicData objectAtIndex:indexPath.row] objectForKey:@"crf_topicname"];
        cell.textLabel.text = [[topicData objectAtIndex:indexPath.row] objectForKey:@"crf_topicname"];
    }
    else if(tableView == table){
        [cell.textLabel setFont: [cell.textLabel.font fontWithSize: 14]];
        subject = [[subjectData objectAtIndex:indexPath.row] objectForKey:@"sbj_name"];
        cell.textLabel.text = [[subjectData objectAtIndex:indexPath.row] objectForKey:@"sbj_name"];

    }
    return cell;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(tableView == table2){
        [alertcycle dismissWithClickedButtonIndex:0 animated:YES];
        [_clicktopic_label setHidden:NO];
        cyclename = [[cycleData objectAtIndex:indexPath.row] objectForKey:@"cyc_name"];
        selectedCycleTest  = [[cycleData objectAtIndex:indexPath.row] objectForKey:@"cyc_name"];
        [click_cycletest setTitle:cyclename forState:UIControlStateNormal];
        [cycleTableData setHidden:YES];
        cycletest = selectedCycleTest;
        firstTime = NO;
        cycletestClick = YES;
        [lbl1 setHidden: YES];
        [click_subject setHidden:NO];
        [self httpPostRequest];
        NSLog(@"SelectedcycleTEST:%@",cycletest);
    }
      else if(tableView == table){
        [alertsubject dismissWithClickedButtonIndex:0 animated:YES];
        subjectname = [[subjectData objectAtIndex:indexPath.row] objectForKey:@"sbj_name"];
        selectedSubject  = [[subjectData objectAtIndex:indexPath.row] objectForKey:@"sbj_name"];
        [click_subject setTitle:subjectname forState:UIControlStateNormal];
        [subjectTableData setHidden:YES];
        [topic_tableData setHidden:NO];
        firstTime = NO;
        subjectbool=NO;
        [lbl1 setHidden: YES];
        cycletestClick = NO;
        subject = selectedSubject;
        subjectClick = YES;
        [self httpPostRequest];
        NSLog(@"SelectedSubjectID:%@",subject);
    }
    else if(tableView == topic_tableData){
        topicname = [[topicData objectAtIndex:indexPath.row] objectForKey:@"crf_topicname"];
        selectedTopic = [[topicData objectAtIndex:indexPath.row] objectForKey:@"crf_topicname"];
        crf_id = [[topicData objectAtIndex:indexPath.row] objectForKey:@"crf_id"];
        topic = selectedTopic;
        NSLog(@"SelectedTopicID:%@",topic);
        
        NSLog(@"SelectedCRlTopicID:%@",crf_id);
        ResourceViewController2 *ResourceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Resource"];
//        ResourceViewController.msd_id = msd_id;
//        ResourceViewController.usl_id = usl_id;
//        ResourceViewController.clt_id = clt_id;
//        ResourceViewController.brd_Name = brdName;
//        ResourceViewController.crf_id = crf_id;
        
        [[NSUserDefaults standardUserDefaults] setObject:crf_id forKey:@"crf_id"];
        
        [self.navigationController pushViewController:ResourceViewController animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


- (IBAction)btn_cycleTest:(id)sender {
//    if(self.internetActive == YES){
//        [lbl1 setHidden:YES];
//      //  [_topicView setUserInteractionEnabled:NO];
//        
//        [_clicktopic_label setUserInteractionEnabled:NO];
//        cycleTableData.layer.borderWidth = 1;
//       cycleTableData.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//     //   [_clicktopic_label setHidden:YES];
//    cycleTest = YES;
//        
//    [cycleTableData setHidden:NO];
//    [subjectTableData setHidden:YES];
//    [click_subject setHidden:YES];
//    [self httpPostRequest];
//    }
//    else if(self.internetActive == NO){
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
    
    alertcycle = [[UIAlertView alloc] initWithTitle:@"Cycle Test"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:(NSString *)nil];
        if(self.internetActive == YES){
            [lbl1 setHidden:YES];
          //  [_topicView setUserInteractionEnabled:NO];
            cycleTest = YES;
        [self httpPostRequest];
        }
        else if(self.internetActive == NO){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
    
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
    
            [self presentViewController:alertController animated:YES completion:nil];
        }
    
    
    table2 = [[UITableView alloc] init];
    table2.delegate = self;
    table2.dataSource = self;
    [alertcycle setValue:table2 forKey:@"accessoryView"];
    [alertcycle show];

    
    
}
- (IBAction)btn_subject:(id)sender {
//    if(self.internetActive == YES){
//        [lbl1 setHidden:YES];
//        firstTime = NO;
//        subjectTableData.layer.borderWidth = 1;
//        subjectTableData.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//     cycletest=click_cycletest.currentTitle;
//    subjectbool = YES;
//    [click_subject setHidden:NO];
//    [cycleTableData setHidden:YES];
//    [topic_tableData setHidden:YES];
//    [self httpPostRequest];
//    }
//    else if(self.internetActive == NO){
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//    
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"click for submission \n\n\n\n "delegate:self  cancelButtonTitle:@"click for submission"
//   //                                       otherButtonTitles:nil];
////    UITableView *tblView= [[UITableView alloc]initWithFrame:CGRectMake(0,50,320,100)];
// //   tblView.delegate = self;
//   // tblView.dataSource = self;
//   // [alert addSubview:subjectTableData];
//    
//    
//    // subjectTableData = [[UITableView alloc]initWithFrame:CGRectMake(10, 40, 264, 120)];
//   // subjectTableData.delegate = self;
// //   subjectTableData.dataSource = self;
//    [alert addSubview:subjectTableData];
//    
//[alert show];
//
    
    alertsubject= [[UIAlertView alloc] initWithTitle:@"Subject"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Close"
                                       otherButtonTitles:(NSString *)nil];
    if(self.internetActive == YES){
                [lbl1 setHidden:YES];
                firstTime = NO;
             cycletest=click_cycletest.currentTitle;
            subjectbool = YES;
            [click_subject setHidden:NO];
            [self httpPostRequest];
            }
            else if(self.internetActive == NO){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            

    table = [[UITableView alloc] init];
   table.delegate = self;
   table.dataSource = self;
    [alertsubject setValue:table forKey:@"accessoryView"];
    [alertsubject show];

}
//-(void) getData{
//    subject =[subjectDetails objectForKey:@"sbj_name"];
//    stdName = stdName;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == topic_tableData){
        return 40;
    }
    else{
        return 30;
    }
    
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
    firstTime = NO;
    cycleTestClickTopic = NO;
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
    
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
                //yocomment
                //SiblingViewController.schoolName = schoolName;
                [self.navigationController pushViewController:SiblingViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
            }
            else if(selectionIndex == 2){
                ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
                ViewMessageViewController.msd_id = msd_id;
                ViewMessageViewController.usl_id = usl_id;
                ViewMessageViewController.clt_id = clt_id;
                //yocomment
                //ViewMessageViewController.brdName = brdName;
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
                //yocomment
                //  AttendanceViewController.brd_Name = brdName;
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
                //yocomment
                // ChangePasswordViewController.brd_Name = brdName;
                [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
                
            }
            else if(selectionIndex == 8){
                loginClick = YES;
                subjectClick = NO;
                cycletestClick = NO;
                //yocomment
                //ViewMessageStatus =@"1";
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
                //yocomment
                //  SiblingViewController.schoolName = school_name;
                [self.navigationController pushViewController:SiblingViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
            }
            else if(selectionIndex == 2){
                ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
                ViewMessageViewController.msd_id = msd_id;
                ViewMessageViewController.usl_id = usl_id;
                ViewMessageViewController.clt_id = clt_id;
                //yocomment
                // ViewMessageViewController.brdName = brdName;
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
                //yocomment
                //AttendanceViewController.brd_Name = brdName;
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
                //yocomment
                // ChangePasswordViewController.brd_Name = brdName;
                [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
                
            }
            else if(selectionIndex == 7){
                loginClick = YES;
                subjectClick = NO;
                cycletestClick = NO;

                //yocomment
                // ViewMessageStatus =@"1";
                
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
                subjectClick = NO;
                cycletestClick = NO;

                Status = @"0";
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
                subjectClick = NO;
                cycletestClick = NO;

                Status = @"0";
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


@end
