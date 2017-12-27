//
//  AdminSchoolSMSViewController.m
//  BetweenUs
//
//  Created by podar on 05/10/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "NavigationMenuButton.h"
#import "AdminSchoolSMSViewController.h"
#import "AdminWriteMessageTeacherViewController.h"
#import "AdminWriteMessageViewController.h"
#import "WriteMessageStudentTableViewCell.h"
#import "WYPopoverController.h"
#import "MBProgressHUD.h"
#import "AdminSentMessagesViewController.h"
#import "CCKFNavDrawer.h"
#import "ViewMessageResult.h"
#import "WYPopoverController.h"
#import "MBProgressHUD.h"
#import "AdminViewMessageViewController.h"
#import "RestAPI.h"
#import "DetailMessageViewController.h"
#import "ChangePassswordViewController.h"
#import "AdminProfileViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "AdminMessageTableViewCell.h"
#import "AdminAnnouncementViewController.h"
#import "AcedmicYearResult.h"
#import "AdminDropResult.h"
#import "AdminStudentListViewController.h"
#import "AdminWriteMessageTeacherViewController.h"
#import "MsgTeacherResult.h"
#import "AdminTeacherTableViewCell.h"
#import "AdminSendMessageViewController.h"
#import "AdminSchoolSMSTAbleViewCell.h"
#import "AdminSendSMSViewController.h"
#import "AdminSchoolSMSTeacherViewController.h"
#import "AdminSchoolSMSDirectViewController.h"
#import "AdminStudentSMSViewController.h"
#import "AdminTeacherSMSViewController.h"

@interface AdminSchoolSMSViewController ()
{
    MBProgressHUD *hud;
    WYPopoverController *settingsPopoverController;
 //   AdminTeacherTableViewCell *cell;
    NSIndexPath *path;
    NSInteger *cellRow;
    UITapGestureRecognizer *tapGestRecog ;
    NSDictionary *newDatasetinfoAdminSchoolSMS_academicYear,*newDatasetinfoAdminSchoolSMS,*newDatasetinfoAdminLogout;
  
    UIAlertView *alertcycle,*alertCategory;
    UITableView *academicYearTaleView;
    UITableView *categoryTableView;
    UITapGestureRecognizer *tapGesture,*tapGestureTextfield;
    
    BOOL academicYear,loginClick,firstTime,firstTimeList,academicYearSelected,closeBtnClick,*ListSearch,checkboxAllClicked,individualButtonClicked,selectAll;
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
//@property (nonatomic, strong) MsgStudentResult *MsgStudentResultItems;
//@property(nonatomic,strong)   AdminSchoolSMSTableViewCell *SchoolSMScell;
@property (nonatomic, strong) AcedmicYearResult *AcedemicYearItems;
@property (nonatomic, strong) AdminDropResult *AdminDropResultItems;
@end

@implementation AdminSchoolSMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Hide back button
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.title = @"School SMS";
    
    //Add drawer image button
    UIImage *faceImage = [UIImage imageNamed:@"drawer_icon.png"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake( 10, 0, 15, 15 );
    
    UITapGestureRecognizer *tapdrawer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrawer)];
    [tapdrawer setNumberOfTapsRequired:1];
    [face addGestureRecognizer:tapdrawer];
    tapdrawer.delegate = self;
    [face addTarget:self action:@selector(handleDrawer) forControlEvents:UIControlEventTouchUpInside];
    [face setImage:faceImage forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:face];
    self.navigationItem.leftBarButtonItem = backButton;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setBackBarButtonItem:nil];
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];

    
    firstTime = YES;
    searchKey =@"";
    searchValue = @"";
    DeviceType= @"IOS";
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
     CategoryTableData = [NSArray arrayWithObjects:@"Student", @"Teacher", @"Direct", nil];
    self.AdminSchoolSMSTableView.delegate = self;
    self.AdminSchoolSMSTableView.dataSource = self;
    _enterSearchValueTextfield.delegate = self;
    [_SearchView setHidden:YES];
    _topConstraintToAcademicYearFromLabel.constant = 0;
    [_close_click setHidden:YES];
    studIDArraySMS = [[NSMutableArray alloc] init];
    pathArray = [[NSMutableArray alloc] init];
    clsIDArraySMS = [[NSMutableArray alloc]init];
    arrayForTag =  [[NSMutableArray alloc]init];

   
    UITapGestureRecognizer *tapGestAcademicYearDropDownView =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceDopDownView)];
    [tapGestAcademicYearDropDownView setNumberOfTapsRequired:1];
    [_academicDropDownView addGestureRecognizer:tapGestAcademicYearDropDownView];
    tapGestAcademicYearDropDownView.delegate = self;
    
    UITapGestureRecognizer *tapGestAcademicYearDropDownImage =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceDropDownImage)];
    [tapGestAcademicYearDropDownImage setNumberOfTapsRequired:1];
    [_Academicdropdown addGestureRecognizer:tapGestAcademicYearDropDownImage];
    tapGestAcademicYearDropDownImage.delegate = self;
    
    UITapGestureRecognizer *tapGestStudentSMS =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceStudentSMS)];
    [tapGestStudentSMS setNumberOfTapsRequired:1];
    [_StudentSMS_click addGestureRecognizer:tapGestStudentSMS];
    tapGestStudentSMS.delegate = self;
    
    UITapGestureRecognizer *tapGestSchoolSMS =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceSchoolSMS)];
    [tapGestSchoolSMS setNumberOfTapsRequired:1];
    [_SchoolSMS_click addGestureRecognizer:tapGestSchoolSMS];
    tapGestSchoolSMS.delegate = self;

    
    UITapGestureRecognizer *tapGestTeacherSMS =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceTeachertSMS)];
    [tapGestTeacherSMS setNumberOfTapsRequired:1];
    [_TeacherSMS_click addGestureRecognizer:tapGestTeacherSMS];
    tapGestTeacherSMS.delegate = self;

    
    tapGestureTextfield =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
    [tapGestureTextfield setNumberOfTapsRequired:1];
    [_enterSearchValueTextfield addGestureRecognizer:tapGestureTextfield];
    tapGestureTextfield.delegate = self;
    
    
    [self checkInternetConnectivity];
}

-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)screenTappedOnceSchoolSMS{
    AdminSchoolSMSViewController *adminSchoolSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMS"];
    
    [self.navigationController pushViewController:adminSchoolSMSViewController animated:YES];
    

}
-(void)screenTappedOnceTeachertSMS{
    AdminTeacherSMSViewController *adminTeacherSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminTeacherSMS"];
    
    [self.navigationController pushViewController:adminTeacherSMSViewController animated:YES];

}
-(void)handleDrawer{
    [self.rootNav drawerToggle];
}

-(void)TextfieldAdminUsername{
    [_close_click setHidden:NO];
  
    
}
-(void)TextfieldAdminUsernameCloseButton{
    _enterSearchValueTextfield.text = @"";
    searchValue = @"";
    closeBtnClick = YES;
    [arrayForTag removeAllObjects];
    
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    //  [studIDArraySMS removeAllObjects];
    [clsIDArraySMS removeAllObjects];
    //   studIDSMS = [studIDArraySMS componentsJoinedByString:@","];
    clsIDSMS = [clsIDArraySMS componentsJoinedByString:@","];
    //  NSLog(@"Stu id after all det: %@", studIDSMS);
    NSLog(@"Cls id after all det: %@", clsIDSMS);
    [self webserviceCall];

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"went here ...");
    
  //  if([touch.view isKindOfClass:[UITextField class]]){
        if(touch.view==_enterSearchValueTextfield){
            [_close_click setHidden:NO];
            //   tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
            [self TextfieldAdminUsername];
        
        }
  //  }
  //  else if([touch.view isKindOfClass:[UIImageView class]]){
       else if(touch.view == _academicDropDownView){
            alertcycle = [[UIAlertView alloc] initWithTitle:@"Academic Year"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:(NSString *)nil];
            if(self.internetActive == YES){
                
                academicYear = YES;
                [self webserviceCall];
            }
            else if(self.internetActive == NO){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            academicYearTaleView = [[UITableView alloc] init];
            academicYearTaleView.delegate = self;
            academicYearTaleView.dataSource = self;
            [alertcycle setValue:academicYearTaleView forKey:@"accessoryView"];
            [alertcycle show];

        }
        return YES;
  //  }
    
    return NO; // handle the touch
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)screenTappedOnceStudentSMS{
    AdminStudentSMSViewController *adminStudentSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminStudentSMS"];
    [self.navigationController pushViewController:adminStudentSMSViewController animated:YES];
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
    if(firstTime==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminAcedmicYearList";
        
        //Pass The String to server
        newDatasetinfoAdminSchoolSMS_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSMS_academicYear options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else if(academicYear==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminAcedmicYearList";
        
        //Pass The String to server
        newDatasetinfoAdminSchoolSMS_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSMS_academicYear options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(firstTimeList==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminSchoolSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSMS options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(academicYearSelected == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminSchoolSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSMS options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(ListSearch==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminSchoolSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSMS options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(closeBtnClick==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminSchoolSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSMS options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(loginClick==YES){
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
    

}

-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    if(firstTime==YES){
        firstTime=NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSMS_academicYear options:kNilOptions error:&err];
                
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
                    
                    AcademiYearStatus = [parsedJsonArray valueForKey:@"Status"];
                    AcademicYearTableData = [receivedData objectForKey:@"AcedmicYearResult"];
                    if([AcademiYearStatus isEqualToString:@"1"]){
                        _AcedemicYearItems = [[AcedmicYearResult alloc]init];
                        academicYearDetails = [AcademicYearTableData objectAtIndex:0];
                        firstTimeList = YES;
                        selectedAcademicYearId =[academicYearDetails objectForKey:@"acy_id"];
                        currentacademicYear = [academicYearDetails objectForKey:@"acy_Year"];
                        
                        [_AcademicYear_Click setTitle:currentacademicYear forState:UIControlStateNormal];
                        [self webserviceCall];
                    }
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if(academicYear ==YES){
        academicYear=NO;
    }
    else if(firstTimeList == YES){
        firstTimeList = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSMS options:kNilOptions error:&err];
                
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
                    
                    ListStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminSchoolSMSData = [receivedData objectForKey:@"AdminDropResult"];
                    if([ListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([ListStatus isEqualToString:@"0"]){
                        [_AdminSchoolSMSTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_AdminSchoolSMSTableView reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
        
    }
    else if(academicYearSelected == YES){
        academicYearSelected = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSMS options:kNilOptions error:&err];
                
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
                    
                    ListStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminSchoolSMSData = [receivedData objectForKey:@"AdminDropResult"];
                    if([ListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([ListStatus isEqualToString:@"0"]){
                        [_AdminSchoolSMSTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [_AdminSchoolSMSTableView reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
        
    }
    else if(ListSearch == YES){
        ListSearch = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSMS options:kNilOptions error:&err];
                
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
                    
                    ListStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminSchoolSMSData = [receivedData objectForKey:@"AdminDropResult"];
                    if([ListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([ListStatus isEqualToString:@"0"]){
                        //   [_studentTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [_AdminSchoolSMSTableView reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
        
        
    }
    else if(closeBtnClick == YES){
        closeBtnClick = NO;
        [_close_click setHidden:YES];
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSMS options:kNilOptions error:&err];
                
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
                    
                    ListStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminSchoolSMSData = [receivedData objectForKey:@"AdminDropResult"];
                    if([ListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([ListStatus isEqualToString:@"0"]){
                        [_AdminSchoolSMSTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_AdminSchoolSMSTableView reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
        
    }
    else if(loginClick == YES){
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

}

- (IBAction)SelectCategory_Btn:(id)sender {
    alertCategory = [[UIAlertView alloc] initWithTitle:@"Category"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:(NSString *)nil];
    
    categoryTableView = [[UITableView alloc] init];
    categoryTableView.delegate = self;
    categoryTableView.dataSource = self;
    [alertCategory setValue:categoryTableView forKey:@"accessoryView"];
    [alertCategory show];
}

- (IBAction)SearchKeyBtn:(id)sender {

}

- (IBAction)SendSMSBtn:(id)sender {
    
    if(checkboxAllClicked ==NO && individualButtonClicked == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(selectAll == NO && clsIDArraySMS.count == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        clsIDSMS = [clsIDArraySMS componentsJoinedByString:@","];
        
        NSLog(@"all cls id  %@",clsIDSMS);
        
        [[NSUserDefaults standardUserDefaults] setObject:clsIDSMS forKey:@"clsIDSMS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        AdminSendSMSViewController *adminSendSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SchoolSendSMS"];
   
        [self.navigationController pushViewController:adminSendSMSViewController animated:YES];
    }

}
-(void)screenTappedOnceDopDownView{
    alertcycle = [[UIAlertView alloc] initWithTitle:@"Academic Year"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:(NSString *)nil];
    if(self.internetActive == YES){
        
        academicYear = YES;
        [self webserviceCall];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    academicYearTaleView = [[UITableView alloc] init];
    academicYearTaleView.delegate = self;
    academicYearTaleView.dataSource = self;
    [alertcycle setValue:academicYearTaleView forKey:@"accessoryView"];
    [alertcycle show];

}

-(void)screenTappedOnceDropDownImage{
    
    alertcycle = [[UIAlertView alloc] initWithTitle:@"Academic Year"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:(NSString *)nil];
    if(self.internetActive == YES){
        
        academicYear = YES;
        [self webserviceCall];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    academicYearTaleView = [[UITableView alloc] init];
    academicYearTaleView.delegate = self;
    academicYearTaleView.dataSource = self;
    [alertcycle setValue:academicYearTaleView forKey:@"accessoryView"];
    [alertcycle show];

}
- (IBAction)AcademicYearBtn:(id)sender {

    alertcycle = [[UIAlertView alloc] initWithTitle:@"Academic Year"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:(NSString *)nil];
    if(self.internetActive == YES){
        
        academicYear = YES;
        [self webserviceCall];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
}
    
    academicYearTaleView = [[UITableView alloc] init];
    academicYearTaleView.delegate = self;
    academicYearTaleView.dataSource = self;
    [alertcycle setValue:academicYearTaleView forKey:@"accessoryView"];
    [alertcycle show];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        if(tableView == academicYearTaleView){
            return [AcademicYearTableData count];
        }
        else if(tableView == _AdminSchoolSMSTableView){
            return [AdminSchoolSMSData count];
        }
        else if(tableView == categoryTableView)
            return [CategoryTableData count];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if(tableView==academicYearTaleView){
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
                
                
                [cell.textLabel setFont: [cell.textLabel.font fontWithSize: 14]];
                acy_year= [[AcademicYearTableData objectAtIndex:indexPath.row] objectForKey:@"acy_Year"];
                cell.textLabel.text = acy_year;
            }
            return cell;
        }
        else if(tableView == _AdminSchoolSMSTableView){
            
            static NSString *simpleTableIdentifier = @"AdminSchoolSMSTableViewCell";
            
           AdminSchoolSMSTableViewCell  *_SchoolSMScell = (AdminSchoolSMSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (_SchoolSMScell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminSchoolSMSTableViewCell" owner:self options:nil];
                _SchoolSMScell = [nib objectAtIndex:0];
                            if (indexPath.row % 2 == 0) {
                                _SchoolSMScell.shiftLabel_cell.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:229.0/255.0f blue:222/255.0f alpha:1.0];
                                _SchoolSMScell.sectionLabel_cell.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:229.0/255.0f blue:222/255.0f alpha:1.0];
                                _SchoolSMScell.checBoxCell.backgroundColor =[UIColor colorWithRed:255.0/255.0f green:229.0/255.0f blue:222/255.0f alpha:1.0];
                                _SchoolSMScell.stdLabel_cell.backgroundColor =[UIColor colorWithRed:255.0/255.0f green:229.0/255.0f blue:222/255.0f alpha:1.0];
                                
                                //255 229 222
                                //244 202 190
                
                
                            }
                            else
                            {
                                _SchoolSMScell.shiftLabel_cell.backgroundColor = [UIColor colorWithRed:244.0/255.0f green:202.0/255.0f blue:190/255.0f alpha:1.0];
                                _SchoolSMScell.sectionLabel_cell.backgroundColor = [UIColor colorWithRed:244.0/255.0f green:202.0/255.0f blue:190/255.0f alpha:1.0];
                                _SchoolSMScell.checBoxCell.backgroundColor =[UIColor colorWithRed:245.0/255.0f green:202.0/255.0f blue:190/255.0f alpha:1.0];
                                _SchoolSMScell.stdLabel_cell.backgroundColor =[UIColor colorWithRed:244.0/255.0f green:202.0/255.0f blue:190/255.0f alpha:1.0];
                            }
            }
            UIImage *btnCheckedImage = [UIImage imageNamed:@"smschecked_red_32x32.png"];
            UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
            
            [_SchoolSMScell.checBoxCell addTarget:self action:@selector(checkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            _SchoolSMScell.checBoxCell.tag = indexPath.row;
            NSNumber *abc = [NSNumber numberWithInt:_SchoolSMScell.checBoxCell.tag];
            [_SchoolSMScell.checBoxCell setTag:indexPath.row];
            
            
            int rows = [tableView numberOfRowsInSection:indexPath.section];
            
            if(![self isSelectedCheckBox:_SchoolSMScell.checBoxCell.tag] && checkboxAllClicked==NO)
            {
                [_SchoolSMScell.checBoxCell setImage:btnUnCheckedImage forState:UIControlStateNormal];
            }
            else if([self isSelectedCheckBox:_SchoolSMScell.checBoxCell.tag] && checkboxAllClicked==NO){
                [_SchoolSMScell.checBoxCell setImage:btnCheckedImage forState:UIControlStateNormal];
            }
            
            
            if(![self isSelectedCheckBox:_SchoolSMScell.checBoxCell.tag] && checkboxAllClicked == YES)
            {
                [_SchoolSMScell.checBoxCell setImage:btnUnCheckedImage forState:UIControlStateNormal];
            }
            else if([self isSelectedCheckBox:_SchoolSMScell.checBoxCell.tag] && checkboxAllClicked == YES ){
                [_SchoolSMScell.checBoxCell setImage:btnCheckedImage forState:UIControlStateNormal];
                
            }

            
            if(checkboxAllClicked == YES && individualButtonClicked==NO){
                if(_checkAllClick.selected == YES){
                    NSInteger nSections = [tableView numberOfSections];
                    for (int j=0; j<nSections; j++) {
                        NSInteger nRows = [tableView numberOfRowsInSection:j];
                        for (int i=0; i<nRows; i++) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:j];
                            cellRow= indexPath.row;
                            
                            NSString *inStr = [NSString stringWithFormat: @"%ld", cellRow];
                            NSLog(@"Index: %@", inStr);
                            [arrayForTag addObject:inStr];
                            clsIDSMS = [[AdminSchoolSMSData objectAtIndex:cellRow] objectForKey:@"cls_ID"];
                            [clsIDArraySMS addObject:clsIDSMS];
                              NSOrderedSet *mySetClsID = [[NSOrderedSet alloc] initWithArray:clsIDArraySMS];
                            clsIDArraySMS = [[NSMutableArray alloc] initWithArray:[mySetClsID array]];
                            clsIDSMS = [clsIDArraySMS componentsJoinedByString:@","];
                            NSLog(@"Cls id after all selection: %@", clsIDSMS);
                        }
                    }
                    
                    _SchoolSMScell.checBoxCell.selected = YES;
                    [_SchoolSMScell.checBoxCell setTag:indexPath.row];
                    [_SchoolSMScell.checBoxCell setImage:btnCheckedImage forState:UIControlStateNormal];
                    
                    
                }
                else if(_checkAllClick.selected == NO){
                    _SchoolSMScell.checBoxCell.selected = YES;
                    [_SchoolSMScell.checBoxCell setTag:indexPath.row];
                    [_SchoolSMScell.checBoxCell setImage:btnUnCheckedImage forState:UIControlStateNormal];
                    
                }
            }
            
            //Set Data
            _SchoolSMScell.shiftLabel_cell = [[AdminSchoolSMSData objectAtIndex:indexPath.row] objectForKey:@"sft_name"];
            _SchoolSMScell.sectionLabel_cell.text = [[AdminSchoolSMSData objectAtIndex:indexPath.row] objectForKey:@"sec_Name"];
            
            std_name =[[AdminSchoolSMSData objectAtIndex:indexPath.row] objectForKey:@"std_Name"];
            div_name = [[AdminSchoolSMSData objectAtIndex:indexPath.row] objectForKey:@"div_name"];
            _SchoolSMScell.stdLabel_cell.text = [NSString stringWithFormat:@"%@-%@",std_name,div_name];
            
            return _SchoolSMScell;
        
        
        }
        else if(tableView == categoryTableView){
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SiblingTableViewCell" owner:self options:nil];
                // cell = [nib objectAtIndex:0];
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
                
                
                [cell.textLabel setFont: [cell.textLabel.font fontWithSize: 14]];
                cell.textLabel.text =  [CategoryTableData objectAtIndex:indexPath.row];
                //[_selectCategory_Click setTitle:currentacademicYear forState:UIControlStateNormal];
            }
            return cell;

        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _AdminSchoolSMSTableView){
         return 40;
    }
    else{
        return 30;
    }
    
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == academicYearTaleView){
        [alertcycle dismissWithClickedButtonIndex:0 animated:YES];
        
        selectedAcademicYearId = [[AcademicYearTableData objectAtIndex:indexPath.row] objectForKey:@"acy_id"];
        selectedAcademicYear  = [[AcademicYearTableData objectAtIndex:indexPath.row] objectForKey:@"acy_Year"];
        [_AcademicYear_Click setTitle:selectedAcademicYear forState:UIControlStateNormal];
        academicYearSelected = YES;
        [self webserviceCall];
        NSLog(@"SelectedcycleTEST:%@",selectedAcademicYear);
    }
    else if(tableView == categoryTableView){
        category = [CategoryTableData objectAtIndex:indexPath.row];
        if([category isEqualToString:@"Student"]){
            NSLog(@"SelectedcycleCateg:%@",category);
            [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
            [_selectCategory_Click setTitle:category forState:UIControlStateNormal];
            AdminSchoolSMSViewController *adminSchoolSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMS"];
            
            [self.navigationController pushViewController:adminSchoolSMSViewController animated:NO];
            [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
        }
        else if([category isEqualToString:@"Teacher"]){
            NSLog(@"SelectedcycleCateg:%@",category);
             [_selectCategory_Click setTitle:category forState:UIControlStateNormal];
            
            AdminSchoolSMSTeacherViewController *adminSchoolSMSTeacherViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMSTeacher"];
            
            [self.navigationController pushViewController:adminSchoolSMSTeacherViewController animated:NO];
              [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
        }
        else if([category isEqualToString:@"Direct"]){
            NSLog(@"SelectedcycleCateg:%@",category);
             [_selectCategory_Click setTitle:category forState:UIControlStateNormal];
            
            AdminSchoolSMSDirectViewController *adminSchoolSMSDirectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMSDirect"];
            
            [self.navigationController pushViewController:adminSchoolSMSDirectViewController animated:NO];
            [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
    
}

-(void)checkButtonPressed:(id)sender
{
    
    BOOL checked;
    individualButtonClicked = YES;
    selectAll = NO;
    UIButton *checkBox=(UIButton*)sender;
    UIImage *btnCheckedImage = [UIImage imageNamed:@"smschecked_red_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    
    path = [NSIndexPath indexPathForRow:checkBox.tag inSection:0];
    clsIDSMS = [[AdminSchoolSMSData objectAtIndex:checkBox.tag] objectForKey:@"cls_ID"];
    
    if ([checkBox.currentImage isEqual:[UIImage imageNamed:@"smschecked_red_32x32.png"]]){
        NSLog(@"Checked ..");
        checked = YES;
        
    }
    else{
        NSLog(@"Unchecked ..");
        checked = NO;
        
    }
    
    if([pathArray containsObject:path] || checked == YES)
    {
        
        [pathArray removeObject:path];
        checkBox.selected=false;
        [checkBox setImage:btnUnCheckedImage forState:UIControlStateNormal];
        [self deleteSelectedCheckBoxTag:checkBox.tag];
        NSLog(@"unselected ..");
    }
    else if(![pathArray containsObject:path] || checked == NO)
    {
        [pathArray addObject:path];
        checkBox.selected=true;
        [self addSelectedCheckBoxTag:checkBox.tag];
        [checkBox setImage:btnCheckedImage forState:UIControlStateNormal];
        NSLog(@"selected..");
    }
    
}
-(void)addSelectedCheckBoxTag:(int)value
{
    int flag=0;
    
    for(int i=0;i<[arrayForTag count];i++)
    {
        if([[arrayForTag objectAtIndex:i] intValue]==value)
            flag=1;
    }
    if(flag==0)
        [arrayForTag addObject:[NSString stringWithFormat:@"%d",value]];
    NSLog(@"After addition  .." ,arrayForTag);
    [clsIDArraySMS addObject:clsIDSMS];
    clsIDSMS = [clsIDArraySMS componentsJoinedByString:@","];
    NSLog(@"CLS ID after add  %@",clsIDSMS);
    
}


-(void)deleteSelectedCheckBoxTag:(int)value
{
    
    for(int i=0;i<[arrayForTag count];i++)
    {
        if([[arrayForTag objectAtIndex:i] intValue]==value)
            [arrayForTag removeObjectAtIndex:i];
    }
    NSLog(@"After deletion  .." ,arrayForTag);
    [clsIDArraySMS removeObject:clsIDSMS];
    clsIDSMS = [clsIDArraySMS componentsJoinedByString:@","];
    NSLog(@"Cls ID after remove  %@",clsIDSMS);
}

// For take is selected or not from array -

-(BOOL)isSelectedCheckBox:(int)value
{
    for(int i=0;i<[arrayForTag count];i++)
    {
        if([[arrayForTag objectAtIndex:i] intValue]==value)
            return true;
    }
    return false;
}
- (IBAction)stdBtn:(id)sender {
    _std_click.selected = YES;
    searchKey = @"Std";
    UIImage *btnOnImage = [UIImage imageNamed:@"radio-on.png"];
    UIImage *btnOffImage = [UIImage imageNamed:@"radio-off.png"];
    [_std_click setImage:btnOnImage forState:UIControlStateNormal];
    [_section_Click setImage:btnOffImage forState:UIControlStateNormal];
    [_shift_click setImage:btnOffImage forState:UIControlStateNormal];
}
- (IBAction)sectionBtn:(id)sender {
    _section_Click.selected = YES;
    searchKey = @"Section";
    UIImage *btnOnImage = [UIImage imageNamed:@"radio-on.png"];
    UIImage *btnOffImage = [UIImage imageNamed:@"radio-off.png"];
    [_section_Click setImage:btnOnImage forState:UIControlStateNormal];
    [_std_click setImage:btnOffImage forState:UIControlStateNormal];
    [_shift_click setImage:btnOffImage forState:UIControlStateNormal];
}
- (IBAction)shiftBtn:(id)sender {
    _shift_click.selected = YES;
    searchKey = @"Shift";
    UIImage *btnOnImage = [UIImage imageNamed:@"radio-on.png"];
    UIImage *btnOffImage = [UIImage imageNamed:@"radio-off.png"];
    [_shift_click setImage:btnOnImage forState:UIControlStateNormal];
    [_std_click setImage:btnOffImage forState:UIControlStateNormal];
    [_section_Click setImage:btnOffImage forState:UIControlStateNormal];
}

- (IBAction)showSearchViewBtn:(id)sender {
    if(_SearchView.isHidden==YES){
        [_SearchView setHidden:NO];
        _topConstraintToAcademicYearFromLabel.constant=70;
    }
    else{
        [_SearchView setHidden:YES];
        _topConstraintToAcademicYearFromLabel.constant=0;
    }

}
- (IBAction)SearchValueBtn:(id)sender {
    
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];

    if([_enterSearchValueTextfield isFirstResponder]){
                [_enterSearchValueTextfield resignFirstResponder];
            }
            [self.view endEditing:YES];
            searchValue = _enterSearchValueTextfield.text;
            NSLog(@"Value: %@", searchValue);
            if(_shift_click.selected==NO && _section_Click.selected==NO && _std_click.selected ==NO){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Search Key" preferredStyle:UIAlertControllerStyleAlert];
        
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
        
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if([searchValue isEqualToString:@""]){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Search Key" preferredStyle:UIAlertControllerStyleAlert];
        
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
        
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if(_shift_click.selected==YES && [searchValue isEqualToString:@""]){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Search Key" preferredStyle:UIAlertControllerStyleAlert];
        
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
        
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if(_section_Click.selected==YES &&  [searchValue isEqualToString:@""]){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Search Key" preferredStyle:UIAlertControllerStyleAlert];
        
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
        
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if(_std_click.selected==YES &&  [searchValue isEqualToString:@""]){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Search Key" preferredStyle:UIAlertControllerStyleAlert];
        
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
        
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if(_shift_click.selected == YES &&  ![searchValue isEqualToString:@""]){
                ListSearch = YES;
                [arrayForTag removeAllObjects];
                checkboxAllClicked = NO;
                individualButtonClicked = NO;
                [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
                //  [studIDArraySMS removeAllObjects];
                [clsIDArraySMS removeAllObjects];
                //   studIDSMS = [studIDArraySMS componentsJoinedByString:@","];
                clsIDSMS = [clsIDArraySMS componentsJoinedByString:@","];
                //  NSLog(@"Stu id after all det: %@", studIDSMS);
                NSLog(@"Cls id after all det: %@", clsIDSMS);

                [self webserviceCall];
            }
            else if(_section_Click.selected == YES &&  ![searchValue isEqualToString:@""]){
                ListSearch = YES;
                [arrayForTag removeAllObjects];
                [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
                //  [studIDArraySMS removeAllObjects];
                [clsIDArraySMS removeAllObjects];
                checkboxAllClicked = NO;
                individualButtonClicked = NO;
                //   studIDSMS = [studIDArraySMS componentsJoinedByString:@","];
                clsIDSMS = [clsIDArraySMS componentsJoinedByString:@","];
                //  NSLog(@"Stu id after all det: %@", studIDSMS);
                NSLog(@"Cls id after all det: %@", clsIDSMS);

                [self webserviceCall];
            }
            else if(_std_click.selected == YES &&  ![searchValue isEqualToString:@""]){
                ListSearch = YES;
                [arrayForTag removeAllObjects];
                [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
                //  [studIDArraySMS removeAllObjects];
                checkboxAllClicked = NO;
                individualButtonClicked = NO;
                [clsIDArraySMS removeAllObjects];
                //   studIDSMS = [studIDArraySMS componentsJoinedByString:@","];
                clsIDSMS = [clsIDArraySMS componentsJoinedByString:@","];
                //  NSLog(@"Stu id after all det: %@", studIDSMS);
                NSLog(@"Cls id after all det: %@", clsIDSMS);

                [self webserviceCall];
            }
}
- (IBAction)closeBtn:(id)sender {
    _enterSearchValueTextfield.text = @"";
    searchValue = @"";
    closeBtnClick = YES;
    checkboxAllClicked = NO;
    individualButtonClicked = NO;

    [arrayForTag removeAllObjects];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    //  [studIDArraySMS removeAllObjects];
    [clsIDArraySMS removeAllObjects];
    //   studIDSMS = [studIDArraySMS componentsJoinedByString:@","];
    clsIDSMS = [clsIDArraySMS componentsJoinedByString:@","];
    //  NSLog(@"Stu id after all det: %@", studIDSMS);
    NSLog(@"Cls id after all det: %@", clsIDSMS);

    [self webserviceCall];
}
- (IBAction)CheckAllBtn:(id)sender {
    UIButton *checkBoxAll=(UIButton*)sender;
    checkboxAllClicked = YES;
    individualButtonClicked = NO;
    selectAll = YES;
    
    UIImage *btnCheckedImage = [UIImage imageNamed:@"smschecked_red_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    
    if(_checkAllClick.isSelected == YES){
        _checkAllClick.selected = NO;
        checkboxAllClicked = NO;
        [arrayForTag removeAllObjects];
        [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
      //  [studIDArraySMS removeAllObjects];
        [clsIDArraySMS removeAllObjects];
     //   studIDSMS = [studIDArraySMS componentsJoinedByString:@","];
        clsIDSMS = [clsIDArraySMS componentsJoinedByString:@","];
      //  NSLog(@"Stu id after all det: %@", studIDSMS);
        NSLog(@"Cls id after all det: %@", clsIDSMS);

        
        
        [_AdminSchoolSMSTableView reloadData];
    }
    else if(_checkAllClick.isSelected == NO){
        _checkAllClick.selected = YES;
        [_checkAllClick setImage:btnCheckedImage forState:UIControlStateNormal];
        [_AdminSchoolSMSTableView reloadData];
    }

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
@end
