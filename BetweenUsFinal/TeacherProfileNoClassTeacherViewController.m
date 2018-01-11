//
//  TeacherProfileNoClassTeacherViewController.m
//  BetweenUs
//
//  Created by podar on 28/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherProfileNoClassTeacherViewController.h"
#import "NavigationMenuButton.h"
#import "ViewMessageResult.h"
#import "AnnouncementResult2.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "TeacherSMSViewController.h"
#import "TeacherMessageViewController.h"
#import "TeacherBehaviourViewController.h"
#import "TeacherAttendanceViewController.h"
#import "TeacherSubjectListViewController.h"
#import "TeacherAnnouncementViewController.h"
#import "ChangePassswordViewController.h"
#import "LoginViewController.h"
#import "AboutUsViewController.h"
#import "URL_Constant.h"

@interface TeacherProfileNoClassTeacherViewController ()
{
    NSDictionary *newDatasetinfoTeacherAnnouncement,*newDatasetinfoTeacherMessage,*viewmessagedetails,*announcemntdetailsdictionry,*newDatasetinfoTeacherLogout;
    BOOL loginClick;

}

@property (nonatomic, strong) ViewMessageResult *ViewMessageItems;
@property (nonatomic, strong) AnnouncementResult2 *AnnouncementResultItems;
@end

@implementation TeacherProfileNoClassTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //to make arrow white
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];
    
    //get values
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    check = @"0";
    pageNo = @"1";
    pageSize=@"500";
    name = [[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
    school_name = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"school_name"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    brd_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];
    
    Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
    DeviceType= @"IOS";
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    classTeacher = [[NSUserDefaults standardUserDefaults]stringForKey:@"classTeacher"];
    org_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Org_id"];
    
    [[NSUserDefaults standardUserDefaults] setObject:clt_id forKey:@"clt_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:usl_id forKey:@"usl_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:school_name forKey:@"school_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:brd_name forKey:@"brd_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Admin Profile board name==%@", brd_name);
    
    month = @"0";

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _teacherNameLabel.text = name;
            _schoolNameLabel.text = school_name;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        });
    });

    [self setLogo];
    [self checkInternetConnectivity];
    [self webserviceCallForMessage];
    [self webserviceCallForAnnouncement];

}


-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)setLogo{
    if((([org_id isEqualToString: @"2"]) && ([brd_name isEqualToString: @"CBSE"]) && ((![school_name containsString:@"Podar Jumbo"])))){
        
        _image_logo.image = [UIImage imageNamed:@"CBSE Logo 200x100 pix (2).png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([brd_name isEqualToString: @"ICSE"]))){
        _image_logo.image = [UIImage imageNamed:@"ICSE_Logo.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([brd_name isEqualToString: @"CIE"]))){
        _image_logo.image = [UIImage imageNamed:@"cie_250x100_old.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([brd_name isEqualToString: @"SSC"]))){
        _image_logo.image = [UIImage imageNamed:@"ssc_250x80.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && ([brd_name isEqualToString: @"IB"]))){
        _image_logo.image = [UIImage imageNamed:@"Podar ORT.png"];
    }
    else if((([org_id isEqualToString: @"2"]) && (([school_name containsString:@"Podar Jumbo"])))){
        _image_logo.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([brd_name isEqualToString: @"ICSE"]))){
        _image_logo.image = [UIImage imageNamed:@"lilavati_250x125.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([brd_name isEqualToString: @"CBSE"]))){
        _image_logo.image = [UIImage imageNamed:@"rnpodar_225x100.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([brd_name isEqualToString: @"IB"]))){
        _image_logo.image = [UIImage imageNamed:@"ib_250x100.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([brd_name isEqualToString: @"SSC"]))){
        _image_logo.image = [UIImage imageNamed:@"ssc_250x100.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([clt_id isEqualToString: @"39"]))){
        _image_logo.image = [UIImage imageNamed:@"pwc_225x225.png"];
    }
    else if((([org_id isEqualToString: @"4"]) && ([clt_id isEqualToString: @"38"]))){
        _image_logo.image = [UIImage imageNamed:@"pic_225x225.png"];
    }
    else if((([org_id isEqualToString: @"3"]) && ([brd_name isEqualToString: @"CBSE "]))){
        _image_logo.image = [UIImage imageNamed:@"pws_300x95.png"];
    }
    else if((([org_id isEqualToString: @"3"]) && ([Brd_Id isEqualToString: @"1"]) && (([school_name containsString:@"Podar Jumbo"])))){
        _image_logo.image = [UIImage imageNamed:@"PJK.png"];
    }
    else if((([org_id isEqualToString: @"1"]))){
        _image_logo.image = [UIImage imageNamed:@"CBSE Logo 200x100 pix (2).png"];
    }
    else{
        _image_logo.hidden = NO;
    }
    
}


-(void)checkInternetConnectivity{
    messageReadCount = [[NSMutableArray alloc] init];
    announcementReadCount = [[NSMutableArray alloc]init];
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
        
        
    }
    else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                name = [[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
                drawerstd = [[NSUserDefaults standardUserDefaults]stringForKey:@"Std"];
                org_id =[[NSUserDefaults standardUserDefaults]stringForKey:@"Org_id"];
                sec_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"sec_id"];
                rol_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Roll_id"];
                rol_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"rol_id"];
                Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
                messageReadCountWithNoInternet = [[NSUserDefaults standardUserDefaults] arrayForKey:@"messageCount"];
                announcementReadCountWithNoInternet = [[NSUserDefaults standardUserDefaults]arrayForKey:@"AnnouncementCount"];
                
                [self setLogo];
                
                _teacherNameLabel.text = name;
                _schoolNameLabel.text = school_name;
                
                self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.MessageClick.frame.size.width - 28, -20,44,40)];
                [self.MessageClick addSubview:self.badgeCount];
                self.badgeCount.value =  [messageReadCountWithNoInternet count];
                
                self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.announcementClick.frame.size.width - 28, -20,44,40)];
                [self.announcementClick addSubview:self.badgeCount];
                self.badgeCount.value =  [announcementReadCountWithNoInternet count];
                
                
                
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
-(void)webserviceCallForLogout{
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *urlString = app_url @"PodarApp.svc/LogOut";
    //  newDatasetinfoAdminLogout = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
    
    //Pass The String to server
    newDatasetinfoTeacherLogout= [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherLogout options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServerLogout:urlString jsonString:jsonInputString];
    
}
-(void)webserviceCallForMessage{
    
    NSString *urlString = app_url @"PodarApp.svc/GetSentMessageDataTeacher";
    
    NSDate *currentDate = [NSDate date];
    NSLog(@"Current Date = %@", currentDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    month = [formatter stringFromDate:currentDate];
    NSLog(@"<<< Month detected >>>>> : %@", month);
    
    //Pass The String to server
    newDatasetinfoTeacherMessage = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",pageNo,@"PageNo",pageSize,@"PageSize",check,@"check",@"0",@"month",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherMessage options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServerMessage:urlString jsonString:jsonInputString];
    
}

-(void)webserviceCallForAnnouncement{
    
    NSString *urlString = app_url @"PodarApp.svc/GetTeacherAnnouncement";
    
    //Pass The String to server
    newDatasetinfoTeacherAnnouncement = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAnnouncement options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServerAnnouncement:urlString jsonString:jsonInputString];
    
}

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

-(void)checkWithServerAnnouncement:(NSString *)urlname jsonString:(NSString *)jsonString{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err;
            NSData* responseData = nil;
            NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            responseData = [NSMutableData data] ;
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAnnouncement options:kNilOptions error:&err];
            
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
                AnnouncementStatus = [parsedJsonArray valueForKey:@"Status"];
                teacherAnnoucementArray = [receivedData valueForKey:@"AnnouncementResult"];
                NSLog(@"Status:%@",AnnouncementStatus);
                
                if([AnnouncementStatus isEqualToString:@"1"]){
                    AnnouncementStatus = @"1";
                    for(int n = 0; n < [teacherAnnoucementArray  count]; n++)
                    {
                        _AnnouncementResultItems= [[AnnouncementResult2 alloc]init];
                        announcemntdetailsdictionry = [teacherAnnoucementArray
                                                       objectAtIndex:n];
                        _AnnouncementResultItems.pmu_readunreadstatus = [announcemntdetailsdictionry objectForKey:@"pmu_readunreadstatus"];
                        announcementReadStatus =_AnnouncementResultItems.pmu_readunreadstatus;
                        NSLog(@"MessageStatus:%@",  _AnnouncementResultItems.pmu_readunreadstatus);
                        if([announcementReadStatus isEqualToString:@"1"]){
                            
                            
                            [announcementReadCount addObject:announcementReadStatus];
                            
                            NSLog(@"Size ReadMesssage:%lu",(unsigned long)[announcementReadCount count]);
                            badgeCountNo = [announcementReadCount count];
                            if([device isEqualToString:@"ipad"]){
                                self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.announcementClick.frame.size.width - 40, -20,44,40)];
                            }
                            else if([device isEqualToString:@"iphone"]){
                                self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.announcementClick.frame.size.width - 28, -20,44,40)];
                            }
                            
                            [self.announcementClick addSubview:self.badgeCount];
                            self.badgeCount.value =  [announcementReadCount count];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:announcementReadCount forKey:@"AnnouncementCount"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                        }
                    }
                    
                }
                
                [hud hideAnimated:YES];
            }
        });
    });
}


-(void)checkWithServerMessage:(NSString *)urlname jsonString:(NSString *)jsonString{
    
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err;
            NSData* responseData = nil;
            NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            responseData = [NSMutableData data] ;
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherMessage options:kNilOptions error:&err];
            
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
                
                
                MessageStatus = [parsedJsonArray valueForKey:@"Status"];
                TeacherViewMessageTableData = [receivedData objectForKey:@"ViewMessageResult"];
                if([MessageStatus isEqualToString:@"1"]){
                    MessageStatus = @"1";
                    for(int n = 0; n < [TeacherViewMessageTableData  count]; n++)
                    {
                        _ViewMessageItems= [[ViewMessageResult alloc]init];
                        viewmessagedetails = [TeacherViewMessageTableData
                                              objectAtIndex:n];
                        _ViewMessageItems.pmu_readunredStatus = [viewmessagedetails objectForKey:@"pmu_readunreadstatus"];
                        messageReadStatus =_ViewMessageItems.pmu_readunredStatus;
                        NSLog(@"MessageStatus:%@",  _ViewMessageItems.pmu_readunredStatus);
                        if([messageReadStatus isEqualToString:@"1"]){
                            
                            
                            [messageReadCount addObject:messageReadStatus];
                            
                            NSLog(@"Size ReadMesssage:%lu",(unsigned long)[messageReadCount count]);
                            badgeCountNo = [messageReadCount count];
                            if([device isEqualToString:@"ipad"]){
                                self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.MessageClick.frame.size.width - 40, -20,44,45)];
                            }
                            else if([device isEqualToString:@"iphone"]){
                                self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.MessageClick.frame.size.width - 30, -20,44,45)];
                            }
                            
                            [self.MessageClick addSubview:self.badgeCount];
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

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
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
        [self webserviceCallForLogout];
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
        }    }
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
