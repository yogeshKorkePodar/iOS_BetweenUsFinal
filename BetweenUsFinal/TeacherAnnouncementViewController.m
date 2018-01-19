//
//  TeacherAnnouncementViewController.m
//  BetweenUs
//
//  Created by podar on 29/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherAnnouncementViewController.h"
#import "TeacherAttendanceViewController.h"
#import "TeacherBehaviourViewController.h"
#import "NavigationMenuButton.h"
#import "TeacherProfileViewController.h"
#import "TeacherAttendanceViewController.h"
#import "CCKFNavDrawer.h"
#import "DrawerView.h"
#import "ChangePassswordViewController.h"
#import "AboutUsViewController.h"
#import "WYPopoverController.h"
#import "LoginViewController.h"
#import "RestAPI.h"
#import "URL_Constant.h"
#import "TeacherBehaviourViewController.h"
#import "AnnouncementResult2.h"
#import "AnnouncementTableViewCell.h"
#import "TeacherSubjectListViewController.h"
#import "TeacherMessageViewController.h"
#import "TeacherSMSViewController.h"
#import "TeacherSentMessageViewController.h"
#import "TeacherProfileNoClassTeacherViewController.h"
#import "TeacherAnnouncementTableViewCell.h"
#import "MBProgressHUD.h"



@interface TeacherAnnouncementViewController ()
{
    NSDictionary *newDatasetinfoTeacherAnnouncement,*announcemntdetailsdictionry,*newDatasetinfoTeacherLogout;
    BOOL announcmentClick,firstTimeAnnouncement,loginClick;
}
@property (nonatomic, strong) AnnouncementResult2 *AnnouncementResultItems;
@property (nonatomic, strong) TeacherAnnouncementTableViewCell *cell;
@end

@implementation TeacherAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];
    
    _my_tabBar.delegate = self;
    _my_tabBar.selectedItem = [_my_tabBar.items objectAtIndex:0];

    
    firstTimeAnnouncement = YES;
    DeviceType= @"IOS";
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    brd_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];
    
    classTeacher = [[NSUserDefaults standardUserDefaults]stringForKey:@"classTeacher"];
    
    if ([classTeacher isEqualToString:@"0"]){
        _attendance_tab.enabled = NO;
        _behaviour_tab.enabled = NO;
        
    }
    
        _announcementTableView.delegate = self;
    _announcementTableView.dataSource = self;
    self.announcementTableView.estimatedRowHeight = 500.0; // put max you expect here.
    self.announcementTableView.rowHeight = UITableViewAutomaticDimension;
   
    if([classTeacher isEqualToString:@"0"]){
             [buttonView setHidden:YES];
        _buttonViewHeight.constant = 0;
    }
    
    
    [self checkInternetConnectivity];


}


-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
   
    if(item.tag==1)
    {
        NSLog(@"First tab selected");
        TeacherAnnouncementViewController *TeacherAnnouncementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAnnouncement"];
            [self.navigationController pushViewController:TeacherAnnouncementViewController animated:NO];
        
    }
    else if(item.tag==2)
        
    {
        NSLog(@"Second tab selected");
        
        TeacherAttendanceViewController *TeacherAttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAttendance"];
             [self.navigationController pushViewController:TeacherAttendanceViewController animated:NO];
        
    }
    else if(item.tag==3)
        
    {
        NSLog(@"Third tab selected");
        TeacherBehaviourViewController *TeacherBehaviourViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherBehaviour"];
               [self.navigationController pushViewController:TeacherBehaviourViewController animated:NO];
               
        
    }
    
    
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

-(void)webserviceCall{
    if(firstTimeAnnouncement == YES){
        
        NSString *urlString = app_url @"PodarApp.svc/GetTeacherAnnouncement";
        
        //Pass The String to server
        newDatasetinfoTeacherAnnouncement = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAnnouncement options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(loginClick==YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *urlString = app_url @"PodarApp.svc/LogOut";
        //  newDatasetinfoAdminLogout = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        //Pass The String to server
        newDatasetinfoTeacherLogout= [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherLogout options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else if(announcmentClick == YES){
        NSString *urlString = app_url @"PodarApp.svc/UpdateAnnoucementReadStatus";
        
        //Pass The String to server
        newDatasetinfoTeacherAnnouncement = [NSDictionary dictionaryWithObjectsAndKeys:msg_id,@"msg_id",usl_id,@"usl_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAnnouncement options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    
}

-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    if(firstTimeAnnouncement == YES){
        firstTimeAnnouncement = NO;
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
                        [self.announcementTableView setHidden:NO];
                        for(int n = 0; n < [teacherAnnoucementArray  count]; n++)
                        {
                            _AnnouncementResultItems = [[AnnouncementResult2 alloc]init];
                            announcemntdetailsdictionry = [teacherAnnoucementArray objectAtIndex:n];
                            _AnnouncementResultItems.msg_date =[announcemntdetailsdictionry objectForKey:@"msg_date"];
                            _AnnouncementResultItems.msg_Message = [announcemntdetailsdictionry objectForKey:@"msg_Message"];
                            NSLog(@"Announcement:%@", _AnnouncementResultItems.msg_Message);
                            // [cellBehaviourCount:%lu",(unsigned long)[behaviourdetails count]);
                        }
                    }
                    else if([AnnouncementStatus isEqualToString:@"0"]){
                        //  [self.announcemntTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }
                [self.announcementTableView reloadData];
                [hud hideAnimated:YES];
                
            });
        });
    }
    else if(loginClick == YES){
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
    else if(announcmentClick == YES){
        announcmentClick = NO;
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
                    announcementReadStatus = [parsedJsonArray valueForKey:@"Status"];
                    NSLog(@"Status:%@",AnnouncementStatus);
                    
                    if([AnnouncementStatus isEqualToString:@"1"]){
                        firstTimeAnnouncement = YES;
                        [self webserviceCall];
                    }
                    else if([AnnouncementStatus isEqualToString:@"0"]){
                        
                    }
                }
                [self.announcementTableView reloadData];
                [hud hideAnimated:YES];
                
            });
        });
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [teacherAnnoucementArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* _cell = (MessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    if (_cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil];
        _cell = [nib objectAtIndex:0];
    }
    _cell.attachmentClick.tag = indexPath.row;
    [_cell.attachmentClick addTarget:self action:@selector(attachment:) forControlEvents:UIControlEventTouchUpInside];
    [_cell.attachmentClick setTag:indexPath.row];

    */
    static NSString *simpleTableIdentifier = @"TeacherAnnouncementTableViewCell";
    
     _cell = (TeacherAnnouncementTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    if (_cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TeacherAnnouncementTableViewCell" owner:self options:nil];
        _cell = [nib objectAtIndex:0];
        
      /*  [tableView registerNib:[UINib nibWithNibName:@"TeacherAnnouncementTableViewCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        _cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
       */
    }
    
    fulldate = [[teacherAnnoucementArray objectAtIndex:indexPath.row] objectForKey:@"msg_date"];
    ReadStatus = [[teacherAnnoucementArray objectAtIndex:indexPath.row] objectForKey:@"pmu_readunreadstatus"];
    dateitems = [fulldate componentsSeparatedByString:@" "];
    date = dateitems[0];
    NSLog(@"firstdate==%@", date);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"MM/dd/yyyy";
    
    NSDate *yourDate = [dateFormat dateFromString:date];
    
    NSLog(@"your date%@",yourDate);
    dateFormat.dateFormat = @"dd-MMM-yyyy";
    NSLog(@"formated date%@",[dateFormat stringFromDate:yourDate]);
    formatedDate = [dateFormat stringFromDate:yourDate];
    
    _cell.datelabel.text = formatedDate;
    announcementMsg = [[teacherAnnoucementArray objectAtIndex:indexPath.row] objectForKey:@"msg_Message"];
    NSLog(@"Announcement msg %@",announcementMsg);
    
    [_cell.announcementText setText:announcementMsg];
    NSLog(@"Date:%@",[[teacherAnnoucementArray objectAtIndex:indexPath.row] objectForKey:@"msg_date"]);
    CGSize sizeThatFitsTextView = [_cell.announcementText sizeThatFits:CGSizeMake(_cell.announcementText.frame.size.width, MAXFLOAT)];
    _cell.announcementHeight.constant = sizeThatFitsTextView.height;
    
     if([ReadStatus isEqualToString:@"1"]){
        if([device isEqualToString:@"ipad"]){
            [_cell.announcementText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
            self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(650, -10,  30,35)];
            [_cell.datelabel addSubview:self.badgeCount];
            //   [_cell.attachmentClick addSubview:self.badgeCount];
            self.badgeCount.value =  1;
        }
        else if([device isEqualToString:@"iphone"]){
            [_cell.announcementText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
            self.badgeCount = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(_cell.datelabel.frame.size.width-60, -10,  30,35)];
            [_cell.datelabel addSubview:self.badgeCount];
            //   [_cell.attachmentClick addSubview:self.badgeCount];
            self.badgeCount.value =  1;
        }
    }
    else if([ReadStatus isEqualToString:@"0"]){
        [_cell.announcementText setFont:[UIFont fontWithName:@"Arial" size:13]];
    }
    
    return _cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    announcmentClick = YES;
    announcementUslId = [[teacherAnnoucementArray objectAtIndex:indexPath.row] objectForKey:@"usl_id"];
    msg_id =[[teacherAnnoucementArray objectAtIndex:indexPath.row] objectForKey:@"msg_ID"];
    [self webserviceCall];
    
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


- (IBAction)behaviourClick:(id)sender {
    TeacherBehaviourViewController *teacherBehaviourViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherBehaviour"];
    [self.navigationController pushViewController:teacherBehaviourViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}


- (IBAction)attendanceClick:(id)sender {
    TeacherAttendanceViewController *teacherAttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAttendance"];
    
    
    [self.navigationController pushViewController:teacherAttendanceViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
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
