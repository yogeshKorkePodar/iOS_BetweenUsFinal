//
//  TeacherSubjectListViewController.m
//  BetweenUs
//
//  Created by podar on 29/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherSubjectListViewController.h"
#import "NavigationMenuButton.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "SubjectResult.h"
#import "TeacherAttendanceTableViewCell.h"
#import "TeacherTopicListViewController.h"
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

@interface TeacherSubjectListViewController ()
{
NSDictionary *newDatasetinfoTeacherLogout,*newDatasetinfoTeacherSubjectList,*subjectdetailsdictionary;
BOOL loginClick,firstTime;
NSString *classTeacher;
}
@property (nonatomic, strong) SubjectResult *SubjectResultItems;
@end

@implementation TeacherSubjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    firstTime = YES;

    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];
    
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    DeviceType= @"IOS";
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    brd_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];
    
    Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
    
    
    classTeacher = [[NSUserDefaults standardUserDefaults]stringForKey:@"classTeacher"];
    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"string"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.subjectListTableView.delegate = self;
    self.subjectListTableView.dataSource = self;
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
-(void)webserviceCall{
    if(loginClick==YES){
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
    else if(firstTime == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetTeacherSubjectList";
        
        //Pass The String to server
        newDatasetinfoTeacherSubjectList= [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherSubjectList options:NSJSONWritingPrettyPrinted error:&error];
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
    else if(firstTime == YES){
        firstTime = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherSubjectList options:kNilOptions error:&err];
                
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
                    SubjectListStatus = [parsedJsonArray valueForKey:@"Status"];
                    subjectListArray = [receivedData valueForKey:@"SubjectResult"];
                    
                    NSLog(@"Status:%@",SubjectListStatus);
                    if([SubjectListStatus isEqualToString:@"1"]){
                        [self.subjectListTableView setHidden:NO];
                        for(int n = 0; n < [subjectListArray  count]; n++){
                            _SubjectResultItems = [[SubjectResult alloc]init];
                            subjectdetailsdictionary = [subjectListArray objectAtIndex:n];
                        }
                        
                    }
                    else if([SubjectListStatus isEqualToString:@"0"]){
                        [self.subjectListTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [self.subjectListTableView reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [subjectListArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"TeacherAttendanceTableViewCell";
    
    TeacherAttendanceTableViewCell *cell = (TeacherAttendanceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TeacherAttendanceTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    cell.sectionLabel.backgroundColor = [UIColor colorWithRed:228.0/255.0f green:165/255.0f blue:2/255.0f alpha:1.0];
    cell.shiftlabel.backgroundColor =  [UIColor colorWithRed:228.0/255.0f green:165/255.0f blue:2/255.0f alpha:1.0];
    cell.std_div_label.backgroundColor = [UIColor colorWithRed:228.0/255.0f green:165/255.0f blue:2/255.0f alpha:1.0];
    cell.wholeview.backgroundColor =  [UIColor colorWithRed:228.0/255.0f green:165/255.0f blue:2/255.0f alpha:1.0];
    cell.teacherbtnBg.backgroundColor = [UIColor colorWithRed:189.0/255.0f green:142.0/255.0f blue:21/255.0f alpha:1.0];
    cell.nextBtnBg.backgroundColor = [UIColor colorWithRed:189.0/255.0f green:142.0/255.0f blue:21/255.0f alpha:1.0];
    subject = [[subjectListArray objectAtIndex:indexPath.row]objectForKey:@"sbj_name"];
    cell.sectionLabel.text = subject;
    shift = [[subjectListArray objectAtIndex:indexPath.row] objectForKey:@"sft_Name"];
    cell.shiftlabel.text = shift;
    classname = [[subjectListArray objectAtIndex:indexPath.row]objectForKey:@"classs"];
    cell.std_div_label.text = classname;
    if([device isEqualToString:@"ipad"]){
        [cell.sectionLabel setFont: [cell.sectionLabel.font fontWithSize: 16.0]];
        [cell.shiftlabel setFont: [cell.shiftlabel.font fontWithSize: 16.0]];
        [cell.std_div_label setFont: [cell.std_div_label.font fontWithSize: 16.0]];
    }
    else if([device isEqualToString:@"iphone"]){
        [cell.sectionLabel setFont: [cell.sectionLabel.font fontWithSize: 14.0]];
        [cell.shiftlabel setFont: [cell.shiftlabel.font fontWithSize: 14.0]];
        [cell.std_div_label setFont: [cell.std_div_label.font fontWithSize: 14.0]];
    }
    
    return cell;
    
    
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        
        if ([device isEqualToString:@"ipad"]) {
            return 60;
        }else if([device isEqualToString:@"iphone"]){
            return 45;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TeacherTopicListViewController *teacherTopicListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherTopicList"];
    subjecListClsID = [[subjectListArray objectAtIndex:indexPath.row]objectForKey:@"cls_ID"];
    subject = [[subjectListArray objectAtIndex:indexPath.row]objectForKey:@"sbj_name"];
    selectedstd = [[subjectListArray objectAtIndex:indexPath.row]objectForKey:@"classs"];
    [[NSUserDefaults standardUserDefaults] setObject:subjecListClsID forKey:@"class_Id_SubjectList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:subject forKey:@"subjectName_SubjectList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:selectedstd forKey:@"stdName_SubjectList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController pushViewController:teacherTopicListViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
}

-(void)screenTappedOnceTeacherTopicList{
    TeacherTopicListViewController *teacherTopicListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherTopicList"];
    [self.navigationController pushViewController:teacherTopicListViewController animated:YES];
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
