//
//  BehaviourViewController.m
//  BetweenUsFinal
//
//  Created by podar on 22/08/17.
//  Copyright © 2017 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "BehaviourViewController.h"
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
#import "AboutUsViewController.h"
#import "BehavioursResult.h"
#import "BehaviourTableViewCell.h"
#import "StudentProfileWithSiblingViewController.h"
#import "SiblingStudentViewController.h"
#import "StudentResourcesViewController.h"


@interface BehaviourViewController (){
     BOOL message,announcement,attendance,behaviour,firstTime,loginClick,firstWebcall;
}
@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) BehavioursResult *BehaviourDetails;
@property (nonatomic, strong) BehavioursResult *BehaviourItems;

@end

@implementation BehaviourViewController
@synthesize msd_id,usl_id,clt_id,brd_name,schoolName;

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
- (void)viewDidLoad {
    
    firstWebcall = YES;
    [self checkInternetConnectivity];
    
    _my_tabBar.delegate = self;
    _my_tabBar.selectedItem = [_my_tabBar.items objectAtIndex:3];
    isStudentResourcePresent = @"";
    [super viewDidLoad];
    
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
    clt_id = clt_id;
    usl_id = usl_id;
    brd_name = brd_name;
    schoolName = schoolName;
    firstTime = YES;
    
    msd_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"msd_Id"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    
    schoolName = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"school_name"];
    
    brd_name = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"brd_name"];
    
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    
    announcementCount = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"announcementCount"];
    behaviourCount = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"behaviourCount"];
    
    DeviceType= @"IOS";
    
    self.behaviourTableView.dataSource = self;
    self.behaviourTableView.delegate = self;
    
    announcementCount = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"announcementCount"];
    behaviourCount = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"behaviourCount"];


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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}


-(void) httpPostRequest{
    if(firstTime == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //Create the response and Error
                NSError *err;
                NSString *str = app_url @"PodarApp.svc/GetBehavioursData";
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:str];
                
                //Pass The String to server
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:msd_id,@"msd_id",usl_id,@"usl_id",clt_id,@"clt_id",nil];
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
    else if(loginClick == YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        loginClick = NO;
        NSError *err;
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
    if(firstTime == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                firstTime = NO;
                NSError *error = nil;
                NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
                //  NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
                behaviourStatus = [parsedJsonArray valueForKey:@"Status"];
                NSLog(@"Status:%@",behaviourStatus);
                
                //  stundentDetails = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
                
                behaviourdetails = [receivedData objectForKey:@"BehavioursResult"];
                //  NSLog(@"Size sibling:%lu",(unsigned long)[behaviourdetails count]);
                if([behaviourStatus isEqualToString:@"1"]){
                    [self.behaviourTableView setHidden:NO];
                    for(int n = 0; n < [behaviourdetails  count]; n++)
                    {
                        _BehaviourItems = [[BehavioursResult alloc]init];
                        behaviordictonarydetails = [behaviourdetails objectAtIndex:n];
                        _BehaviourItems.sbj_name = [behaviordictonarydetails objectForKey:@"sbj_name"];
                        _BehaviourItems.msg_date =[behaviordictonarydetails objectForKey:@"msg_date"];
                        _BehaviourItems.msg_Message = [behaviordictonarydetails objectForKey:@"msg_Message"];            NSLog(@"Behaviour:%@", _BehaviourItems.msg_Message);
                        // [cellBehaviourCount:%lu",(unsigned long)[behaviourdetails count]);
                    }
                }else if([behaviourStatus isEqualToString:@"0"]){
                    [self.behaviourTableView setHidden:YES];
                    //        UILabel *lbl1 = [[UILabel alloc] init];
                    //        // [lbl1 setFrame:CGRectMake(0,5,100,20)];
                    //        [lbl1 setFrame: CGRectMake(90, 10, 150, 150)];
                    //        lbl1.textAlignment = NSTextAlignmentCenter;
                    //        lbl1.backgroundColor=[UIColor clearColor];
                    //        lbl1.textColor=[UIColor blackColor];
                    //        lbl1.userInteractionEnabled=YES;
                    //        lbl1.font = [UIFont fontWithName:@"Arial-Bold" size:14.0f];
                    //        // [lbl1 sizeToFit];
                    //        [self.view addSubview:lbl1];
                    //        lbl1.text= @"No Records Found";
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                [self.behaviourTableView reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  [urlData writeToFile:filePathnew atomically:YES];
                    [hud hideAnimated:YES];
                    // NSLog(@"File Saved !");
                });
                
            });
        });
    }
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        //        if([behaviourStatus isEqualToString:@"1"]){
        //            return [behaviourdetails count];
        //        }
        return [behaviourdetails count];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception:%@",exception);
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        
        static NSString *simpleTableIdentifier = @"BehaviourTableViewCell";
        
        BehaviourTableViewCell *cell = (BehaviourTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BehaviourTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.date.text = [[behaviourdetails objectAtIndex:indexPath.row] objectForKey:@"msg_date"];
        cell.behaviourmsg.text =[[behaviourdetails objectAtIndex:indexPath.row] objectForKey:@"msg_Message"];
        cell.studentNameLabel.text = [[behaviourdetails objectAtIndex:indexPath.row] objectForKey:@"sbj_name"];
        return cell;
    }
    
    @catch(NSException *exception){
        NSLog(@"Exception:%@",exception);
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}


-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
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
                SiblingViewController.schoolName = schoolName;
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

@end
