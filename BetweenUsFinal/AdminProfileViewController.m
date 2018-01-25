//
//  AdminProfileViewController.m
//  BetweenUs
//
//  Created by podar on 14/09/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "AdminProfileViewController.h"
#import "CCKFNavDrawer.h"
#import "DrawerView.h"
#import "NavigationMenuButton.h"
#import "AdminViewMessageViewController.h"
#import "AdminAnnouncementViewController.h"
#import "ChangePassswordViewController.h"
#import "AboutUsViewController.h"
#import "WYPopoverController.h"
#import "LoginViewController.h"
#import "RestAPI.h"
#import "ViewMessageResult.h"
#import "AdminWriteMessageViewController.h"
#import "AdminSchoolSMSViewController.h"
@interface AdminProfileViewController (){
    
    BOOL loginClick;
    WYPopoverController *settingsPopoverController;
    UITapGestureRecognizer *tapGestRecog ;
    NSDictionary *newDatasetinfoAdminViewMessages,*newDatasetinfoAdminLogout;
}
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (nonatomic, strong) ViewMessageResult *ViewMessageItems;
@end

@implementation AdminProfileViewController

@synthesize usl_id,clt_id,name,school_name,brd_name,rol_id,org_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Hide back button
    self.navigationItem.title = @"Dashboard";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];

    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    
    UIImage *message = [UIImage imageNamed:@"messagebox_92x92.png"];
    UIImage *sms = [UIImage imageNamed:@"sms_92x92.png"];
    UIImage *announcement = [UIImage imageNamed:@"announcementicon_92x92.png"];
   
    
    if([device isEqualToString:@"ipad"]){
        _leftConstraintMessage.constant = 120;
        _rightConstraintSMS.constant = 120;
       
        _rightConstarintSMSLabel.constant = 140;
      _leftConstarintMessageLabel.constant = 125;
        _heightConstarintMessage.constant = 92;
        _heightConstarintAnnouncement.constant = 92;
        _widthConstarintAnnouncement.constant = 92;
        _topConstarintAnnouncementLabel.constant = 20;
        [_label_school_name setFont: [_label_school_name.font fontWithSize: 15.0]];
        [_label_admin_name setFont: [_label_admin_name.font fontWithSize: 16.0]];
        self.view.updateConstraints;
    }else if([device isEqualToString:@"iphone"]){
        
    }
    org_id = org_id;
    school_name = school_name;
    rol_id = rol_id;
    check = @"0";
    pageNo = @"1";
    pageSize=@"500";
    name = [[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
    school_name = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"school_name"];
    
    org_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Org_id"];
   
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    brd_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];
    
    Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
    
    [[NSUserDefaults standardUserDefaults] setObject:clt_id forKey:@"clt_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:usl_id forKey:@"usl_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:school_name forKey:@"school_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:brd_name forKey:@"brd_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Admin Profile board name==%@", brd_name);

    _label_admin_name.text = name;
    _label_school_name.text = school_name;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _label_admin_name.text = name;
            _label_school_name.text = school_name;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        });
    });
    
    [[NSUserDefaults standardUserDefaults] setObject:clt_id forKey:@"clt_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:usl_id forKey:@"usl_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:school_name forKey:@"school_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:brd_name forKey:@"brd_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self setLogo];
    
    [self checkInternetConnectivity];
    
    
    UITapGestureRecognizer *tapGestAnnouncentButton=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceAnnouncement)];
    [tapGestAnnouncentButton setNumberOfTapsRequired:1];
    [_admin_announcement_click addGestureRecognizer:tapGestAnnouncentButton];
    tapGestAnnouncentButton.delegate = self;
    
    /*UITapGestureRecognizer *tapGestMessageButton=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceMessage)];
    [tapGestMessageButton setNumberOfTapsRequired:1];
    [_admin_message_click addGestureRecognizer:tapGestMessageButton];
    tapGestMessageButton.delegate = self;*/
    
    UITapGestureRecognizer *tapGestAnnouncentLabel =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceAnnouncement)];
    [tapGestAnnouncentLabel setNumberOfTapsRequired:1];
    [_label_announcement addGestureRecognizer:tapGestAnnouncentLabel];
    tapGestAnnouncentLabel.delegate = self;
  /*
    UITapGestureRecognizer *tapGestSMS =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceSMS)];
    [tapGestSMS setNumberOfTapsRequired:1];
    [_admin_sms_click addGestureRecognizer:tapGestSMS];
    tapGestSMS.delegate = self;
    */
    //Add drawer image button
    
    
       [self webserviceCall];
}
-(void)handleDrawerAdminProfile{
      [self.rootNav drawerToggle];
}


-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)webserviceCall{
        if(loginClick==YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *urlString = app_url @"PodarApp.svc/LogOut";
      //  newDatasetinfoAdminLogout = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
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
                if([ViewMessageStatus isEqualToString:@"1"]){
                    ViewMessageStatus = @"1";
                    for(int n = 0; n < [ViewTableData  count]; n++)
                    {
                        _ViewMessageItems= [[ViewMessageResult alloc]init];
                        viewmessagedetails = [ViewTableData
                                              objectAtIndex:n];
                        _ViewMessageItems.pmu_readunredStatus = [viewmessagedetails objectForKey:@"pmu_readunreadstatus"];
                        messageReadStatus =_ViewMessageItems.pmu_readunredStatus;
                        NSLog(@"<<<<<<<< MessageStatus:%@",  _ViewMessageItems.pmu_readunredStatus);
                        if([messageReadStatus isEqualToString:@"1"]){
                            
                            
                            [messageReadCount addObject:messageReadStatus];
                            
                            NSLog(@"<<<<<<<<< Size ReadMesssage:%lu",(unsigned long)[messageReadCount count]);
                            badgeCountNo = [messageReadCount count];
                            if([device isEqualToString:@"ipad"]){
                                 self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.admin_message_click.frame.size.width - 40, -20,44,40)];
                            }else if([device isEqualToString:@"iphone"]){
                            self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.admin_message_click.frame.size.width - 28, -20,44,40)];
                            }
                            [self.admin_message_click addSubview:self.badgeCount];
                            self.badgeCount.value =  [messageReadCount count];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:messageReadCount forKey:@"messageCount"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                        }
                    }
                }
            
                [hud hideAnimated:YES];
            }
        });
    });
    
    }
}

-(void)setLogo{
    NSLog(@"<<<<<<<< Admin >>>>>>>> brd_name==%@", brd_name);
    NSLog(@"<<<<<<<< Admin >>>>>>>> org_id==%@", org_id);
    NSLog(@"<<<<<<<< Admin >>>>>>>> school_name==%@", school_name);
    NSLog(@"<<<<<<<< Admin >>>>>>>> clt_id==%@", clt_id);

    if((([org_id isEqualToString: @"2"]) && ([brd_name isEqualToString: @"CBSE"]) && ((![school_name containsString:@"Podar Jumbo"])))){
        _img_logo.image = [UIImage imageNamed:@"CBSE Logo 200x100 pix (2).png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([brd_name isEqualToString: @"ICSE"]))){
        _img_logo.image = [UIImage imageNamed:@"ICSE_Logo.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([brd_name isEqualToString: @"CIE"]))){
        _img_logo.image = [UIImage imageNamed:@"cie_250x100_old.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([brd_name isEqualToString: @"SSC"]))){
        _img_logo.image = [UIImage imageNamed:@"ssc_250x80.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([brd_name isEqualToString: @"IB"]))){
        _img_logo.image = [UIImage imageNamed:@"Podar ORT.png"];

    }
    else if((([org_id isEqualToString: @"2"]) && (([school_name containsString:@"Podar Jumbo"])))){
        _img_logo.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([brd_name isEqualToString: @"ICSE."]))){
        _img_logo.image = [UIImage imageNamed:@"lilavati_250x125.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([brd_name isEqualToString: @"CBSE."]))){
        _img_logo.image = [UIImage imageNamed:@"rnpodar_225x100.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([brd_name isEqualToString: @"IB"]))){
        _img_logo.image = [UIImage imageNamed:@"ib_250x100.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([brd_name isEqualToString: @"SSC"]))){
        _img_logo.image = [UIImage imageNamed:@"ssc_250x100.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([clt_id isEqualToString: @"39"]))){
        _img_logo.image = [UIImage imageNamed:@"pwc_225x225.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([clt_id isEqualToString: @"38"]))){
        _img_logo.image = [UIImage imageNamed:@"pic_225x225.png"];
    }
    else if((([org_id isEqualToString: @"3"]) && ([brd_name isEqualToString: @"CBSE"]))){
         _img_logo.image = [UIImage imageNamed:@"pws_300x95.png"];
    }
    else if((([org_id isEqualToString: @"3"]) && ([Brd_Id isEqualToString: @"1"]) && (([school_name containsString:@"Podar Jumbo"])))){
         _img_logo.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if((([org_id isEqualToString: @"1"]) && ([Brd_Id isEqualToString: @"1"]) && (([school_name containsString:@"Podar Jumbo"])))){
        _img_logo.image = [UIImage imageNamed:@"CBSE Logo 200x100 pix (2).png"];
    }
    else{
        _img_logo.hidden = NO;
    }

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
        
   //     [self webserviceCall];
        
        //        if(firstWebcall == YES){
        //            firstWebcall == NO;
        //            [self httpPostRequest];
        //        }
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
                
                _label_admin_name.text = name;
                _label_school_name.text = school_name;
                if([device isEqualToString:@"ipad"]){
                self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.admin_message_click.frame.size.width - 40, -20,44,40)];
                }
                else if([device isEqualToString:@"iphone"]){
                     self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.admin_message_click.frame.size.width - 28, -20,44,40)];
                }
                [self.admin_message_click addSubview:self.badgeCount];
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
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"went here ...");
    if(self.internetActive == YES){
        if ([touch.view isKindOfClass:[UIButton class]])
        {
            // we touched a button, slider, or other UIControl
            
            if(touch.view == _admin_message_click){
              
               // tapGestRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceMessage)];
            }
            else if(touch == _admin_announcement_click){
                              tapGestRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceAnnouncement)];
                
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
        [self webserviceCallForLogout];
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

-(void)webserviceCallForLogout{
    
    NSString *usl_id,*DeviceToken,*DeviceType;
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceType= @"IOS";
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *urlString = app_url @"PodarApp.svc/LogOut";
    
    
    //Pass The String to server
    newDatasetinfoAdminLogout= [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminLogout options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServerLogout:urlString jsonString:jsonInputString];
    
    
}
////////////////////

-(void)checkWithServerLogout:(NSString *)urlname jsonString:(NSString *)jsonString{
    loginClick = NO;
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



@end
