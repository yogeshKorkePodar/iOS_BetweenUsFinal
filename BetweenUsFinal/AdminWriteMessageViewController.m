//
//  AdminWriteMessageViewController.m
//  BetweenUs
//
//  Created by podar on 22/09/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
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
//#import "AdminAnnouncementViewController.h"
#import "AcedmicYearResult.h"
#import "AdminDropResult.h"
//#import "AdminStudentListViewController.h"
#import "AdminWriteMessageTeacherViewController.h"
//#import "AdminSchoolSMSViewController.h"

@interface AdminWriteMessageViewController ()
{
    WriteMessageStudentTableViewCell *cell;
    MBProgressHUD *hud;
    WYPopoverController *settingsPopoverController;
    UITapGestureRecognizer *tapGestRecog ;
    NSDictionary *newDatasetinfoAdminWriteMessages_academicYear,*newDatasetinfoAdminWriteMessages,*newDatasetinfoAdminLogout;
    BOOL loginClick,firstTime,academicYear,firstTimeStudentList,academicYearSelected,studentListSearch,*closeBtnClick;
    UIAlertView *alertcycle;
     UITableView *academicYearTaleView;
    UITapGestureRecognizer *tapGesture,*tapGestureTextfield;

}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (nonatomic, strong) AcedmicYearResult *AcedemicYearItems;
@property (nonatomic, strong) AdminDropResult *AdminDropResultItems;
@end

@implementation AdminWriteMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Hide back button
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.title = @"Messages>>Write Messages";
    
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
    
     [_enetrSearchKey_textfield setDelegate:self];
    [_academic_yearClick setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_searchView setHidden:YES];
    [_closeClick setHidden:YES];
    [_teacherSearchView setHidden:YES];
    
    clsIdArray = [[NSMutableArray alloc] init];
    _topConstraintToAademicYearViewFromLableView.constant = 0;
    _tableViewtolabelView.constant = 0;
    AdminWriteMessage = @"Student";
    
    [[NSUserDefaults standardUserDefaults] setObject:AdminWriteMessage forKey:@"AdminWriteMessage"];
    
    //_tableviewTopConstraintToLabelView.constant = 0;
   [_teacherView setHidden:YES];
    _tableViewToTeacherSearchView.constant = 0;
//    _labelConstraintToAcademicYearSearch.constant = 0;
//   _tableConstarintToLabelView.constant = 0;
  //  [_teachernameView setHidden:YES];
  //  _topconstraintToButtonFromLabelView.constant = 43;
  //  [_teacherView removeFromSuperview];
    
    _shiftClick.selected = NO;
    _sectionClick.selected =NO;
    _std_click.selected = NO;
    
    searchKey =@"";
    searchValue = @"";
    firstTime = YES;
    check = @"1";
    pageSize = @"500";
    pageNo=@"1";
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    sentmessageClick = [[NSUserDefaults standardUserDefaults]stringForKey:@"SentMessageClick"];
    attachementClick = [[NSUserDefaults standardUserDefaults]stringForKey:@"AttachmentClick"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myString"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"btnTapped"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Array"];


    
    DeviceType= @"IOS";
    
    self.studentTableView.delegate = self;
    self.studentTableView.dataSource = self;
    
    //Click Event
    UITapGestureRecognizer *tapGestAdminViewMessages =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceViewMessages)];
    [tapGestAdminViewMessages setNumberOfTapsRequired:1];
    [_viewMessage_click addGestureRecognizer:tapGestAdminViewMessages];
    tapGestAdminViewMessages.delegate = self;
    
    //Write Message
    UITapGestureRecognizer *tapGestAdminSentMessages =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOncesentMessages)];
    [tapGestAdminSentMessages setNumberOfTapsRequired:1];
    [_sentMessage_click addGestureRecognizer:tapGestAdminSentMessages];
    tapGestAdminSentMessages.delegate = self;
    

    tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsernameCloseButton)];
    [tapGesture setNumberOfTapsRequired:1];
    [_closeBtnView addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    
    UITapGestureRecognizer *tapGestureTextfield =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
    [tapGestureTextfield setNumberOfTapsRequired:1];
    [_enetrSearchKey_textfield addGestureRecognizer:tapGestureTextfield];
    tapGestureTextfield.delegate = self;
    
    [self checkInternetConnectivity];
}

-(void)TextfieldAdminUsernameCloseButton{
     _enetrSearchKey_textfield.text = @"";
    searchValue = @"";
    closeBtnClick = YES;
    [self webserviceCall];
}

-(void)TextfieldAdminUsername{
    [_closeClick setHidden:NO];

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"went here ...");
    
    if([touch.view isKindOfClass:[UITextField class]]){
        if(touch.view==_enetrSearchKey_textfield){
        [_closeClick setHidden:NO];
     //   tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
            [self TextfieldAdminUsername];
        }
    }
    else if ([touch.view isKindOfClass:[UIView class]]){
        if(touch.view == _closeBtnView){
          //  tapGestureTextfield = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsernameCloseButton)];
            [self TextfieldAdminUsernameCloseButton];
        }
        return YES;
    }
    
    return NO; // handle the touch
}




-(void)screenTappedOnceViewMessages{
    AdminViewMessageViewController *adminViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewMessage"];
    
    [self.navigationController pushViewController:adminViewMessageViewController animated:YES];
}
-(void)screenTappedOncesentMessages{
    AdminSentMessagesViewController *adminSentMessagesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSentMessage"];
    [self.navigationController pushViewController:adminSentMessagesViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

}
-(void)handleDrawer{
    [self.rootNav drawerToggle];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    newDatasetinfoAdminWriteMessages_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages_academicYear options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServer:urlString jsonString:jsonInputString];
    
    }
    else if(academicYear==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminAcedmicYearList";
        
        //Pass The String to server
        newDatasetinfoAdminWriteMessages_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages_academicYear options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(firstTimeStudentList==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminWriteMessages = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(academicYearSelected == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminWriteMessages = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(studentListSearch==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminWriteMessages = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(closeBtnClick==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminWriteMessages = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages options:NSJSONWritingPrettyPrinted error:&error];
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
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages_academicYear options:kNilOptions error:&err];
            
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
                    firstTimeStudentList = YES;
                    selectedAcademicYearId =[academicYearDetails objectForKey:@"acy_id"];
                    currentacademicYear = [academicYearDetails objectForKey:@"acy_Year"];
                    
                     [_academic_yearClick setTitle:currentacademicYear forState:UIControlStateNormal];
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
    else if(firstTimeStudentList == YES){
        firstTimeStudentList = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages options:kNilOptions error:&err];
                
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
                    
                    StudentListStatus = [parsedJsonArray valueForKey:@"Status"];
                    StudentTableData = [receivedData objectForKey:@"AdminDropResult"];
                    if([StudentListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([StudentListStatus isEqualToString:@"0"]){
                        [_studentTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_studentTableView reloadData];
                    
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
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages options:kNilOptions error:&err];
                
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
                    
                    StudentListStatus = [parsedJsonArray valueForKey:@"Status"];
                    StudentTableData = [receivedData objectForKey:@"AdminDropResult"];
                    if([StudentListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([StudentListStatus isEqualToString:@"0"]){
                        [_studentTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }

                    [_studentTableView reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });

    }
    else if(studentListSearch == YES){
        studentListSearch = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages options:kNilOptions error:&err];
                
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
                    
                    StudentListStatus = [parsedJsonArray valueForKey:@"Status"];
                    StudentTableData = [receivedData objectForKey:@"AdminDropResult"];
                    if([StudentListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([StudentListStatus isEqualToString:@"0"]){
                     //   [_studentTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [_studentTableView reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
        

    }
    else if(closeBtnClick == YES){
        closeBtnClick = NO;
        [_closeClick setHidden:YES];
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages options:kNilOptions error:&err];
                
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
                    
                    StudentListStatus = [parsedJsonArray valueForKey:@"Status"];
                    StudentTableData = [receivedData objectForKey:@"AdminDropResult"];
                    if([StudentListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([StudentListStatus isEqualToString:@"0"]){
                        [_studentTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_studentTableView reloadData];
                    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        if(tableView == academicYearTaleView){
        return [AcademicYearTableData count];
        }
        else if(tableView == _studentTableView){
            return [StudentTableData count];
        }
        
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
        // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SiblingTableViewCell" owner:self options:nil];
        // cell = [nib objectAtIndex:0];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
      
            
            [cell.textLabel setFont: [cell.textLabel.font fontWithSize: 14]];
            acy_year= [[AcademicYearTableData objectAtIndex:indexPath.row] objectForKey:@"acy_Year"];
            cell.textLabel.text = acy_year;
        }
            return cell;
    }
      else if(tableView == _studentTableView){
          
          static NSString *simpleTableIdentifier = @"WriteMessageStudentTableViewCell";
          
          WriteMessageStudentTableViewCell *cell = (WriteMessageStudentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
          
          
          if (cell == nil)
          {
              NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WriteMessageStudentTableViewCell" owner:self options:nil];
              cell = [nib objectAtIndex:0];
          }
          
          if (cell == nil)
          {
              cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
          }
        
          cell.shift_label.text = [[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"sft_name"];
          cell.section_label.text = [[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"sec_Name"];
          
          std_name =[[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"std_Name"];
          div_name = [[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"div_name"];
          cell.std_label.text = [NSString stringWithFormat:@"%@-%@",std_name,div_name];
         // cell.std_label.text = [[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"std_Name"];
          
          if (indexPath.row % 2 == 0) {
              cell.shift_label.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
              cell.section_label.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
              cell.std_label.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];

          }
          else
          {
              cell.shift_label.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
               cell.section_label.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
               cell.std_label.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
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
    
    if(tableView == _studentTableView){
        return 35;
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
        [_academic_yearClick setTitle:selectedAcademicYear forState:UIControlStateNormal];
        academicYearSelected = YES;
         [self webserviceCall];
        NSLog(@"SelectedcycleTEST:%@",selectedAcademicYear);
    }
    else if(tableView == _studentTableView){
        clickedAll = @"false";
        
        [[NSUserDefaults standardUserDefaults] setObject:clickedAll forKey:@"ClickedAll"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        cls_id  = [[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"cls_ID"];
       selectedShiftname= [[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"sft_name"];
        selected_sectionName= [[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"sec_Name"];
        
        std_name =[[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"std_Name"];
        div_name = [[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"div_name"];
        selected_std= [NSString stringWithFormat:@"%@-%@",std_name,div_name];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myString"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"btnTapped"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Array"];

        [[NSUserDefaults standardUserDefaults] setObject:cls_id forKey:@"cls_ID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:selected_std forKey:@"SelectedStd"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:selected_sectionName forKey:@"SelectedSectionName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:selectedShiftname forKey:@"SelectedShiftName"];
        [[NSUserDefaults standardUserDefaults] synchronize];

       //yocomment
        /*
        AdminStudentListViewController *adminStudentListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminStudentList"];
        
        [self.navigationController pushViewController:adminStudentListViewController animated:YES];
         */
    }

}





- (IBAction)Student_btn:(id)sender {
//    [_academicYearView setHidden:NO];
//   // [_searchView setHidden:NO];
//   [_labelView setHidden:NO];
    
    _tableViewToTeacherSearchView.constant = 0;
    [_studentTableView setHidden:NO];
//    [_enteracademicYearView setHidden:NO];
//    [_teacherSearchView setHidden:YES];
// //   _labelConstraintToAcademicYearSearch.constant = 0;
//    [_teachernameView setHidden:YES];
    [_studentView setHidden:NO];
    [_teacherView setHidden:YES];
    //_tableviewTopConstraintToLabelView.constant = 0;
    _tableViewtolabelView.constant = 0;
//    [_teacherView removeFromSuperview];
    
  //  _topConstraintToAademicYearViewFromLableView.constant = 0;
    _tableViewtolabelView.constant = 0;
    
 //   [_teacherView setHidden:YES];
   _tableViewToTeacherSearchView.constant = -40;

}
- (IBAction)Teacher_btn:(id)sender {
//    [_studentView setHidden:YES];
//    
//    _tableViewToTeacherSearchView.constant = 35;
//    [self.view addSubview:_teacherView];
//    [_teacherView setHidden:NO];
    
    
    
 //   [_studentTableView setHidden:NO];
  //  _topConstraintToAademicYearViewFromLableView.constant = 80;
    //_topconstraintToButtonFromLabelView.constant = 80;
    
//    [_academicYearView setHidden:YES];
//    [_searchView setHidden:YES];
//    [_labelView setHidden:YES];
  //  [_studentTableView setHidden:YES];
//    [_enteracademicYearView setHidden:YES];
//    [_teacherSearchView setHidden:NO];
//    [_teachernameView setHidden:NO];
 //   _teacherViewTopToButtons.constant = 38;
  //  _teacherSearchViewTopConstraint.constant = 3;

//    _fromTeacherViewToStudentView.constant =-137;
    
    //yocomment
    AdminWriteMessageTeacherViewController *adminWriteMessageTeacherViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminWriteMessageTeacher"];
    
    [self.navigationController pushViewController:adminWriteMessageTeacherViewController animated:NO];
    
    
}
- (IBAction)All_btn:(id)sender {
    
   clickedAll = @"true";
    for(int n = 0; n < [StudentTableData  count]; n++)
    {
        _AdminDropResultItems= [[AdminDropResult alloc]init];
        studentDetails = [StudentTableData
                              objectAtIndex:n];
        _AdminDropResultItems.cls_ID = [studentDetails objectForKey:@"cls_ID"];
        cls_id = _AdminDropResultItems.cls_ID;
        [clsIdArray addObject:cls_id];
        cls_id = [clsIdArray componentsJoinedByString:@","];
            NSLog(@"Cls id: %@", cls_id);
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:cls_id forKey:@"cls_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:clickedAll forKey:@"ClickedAll"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   /* AdminStudentListViewController *adminStudentListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminStudentList"];
    
    [self.navigationController pushViewController:adminStudentListViewController animated:YES];
    */
}
- (IBAction)academicYear_btn:(id)sender {
    alertcycle = [[UIAlertView alloc] initWithTitle:@"Academic Year"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:(NSString *)nil];
    if(self.internetActiveViewMessage == YES){

        academicYear = YES;
        [self webserviceCall];
    }
    else if(self.internetActiveViewMessage == NO){
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
- (IBAction)searchButton:(id)sender {
    if(_searchView.isHidden==YES){
    [_searchView setHidden:NO];
    _topConstraintToAademicYearViewFromLableView.constant=70;
    }
    else{
        [_searchView setHidden:YES];
        _topConstraintToAademicYearViewFromLableView.constant=0;
    }
}

- (IBAction)std_Btn:(id)sender {
    _std_click.selected = YES;
    searchKey = @"Std";
    UIImage *btnOnImage = [UIImage imageNamed:@"radio-on.png"];
    UIImage *btnOffImage = [UIImage imageNamed:@"radio-off.png"];
    [_std_click setImage:btnOnImage forState:UIControlStateNormal];
    [_sectionClick setImage:btnOffImage forState:UIControlStateNormal];
    [_shiftClick setImage:btnOffImage forState:UIControlStateNormal];
}

- (IBAction)section_Btn:(id)sender {
    _sectionClick.selected = YES;
    searchKey = @"Section";
    UIImage *btnOnImage = [UIImage imageNamed:@"radio-on.png"];
    UIImage *btnOffImage = [UIImage imageNamed:@"radio-off.png"];
    [_sectionClick setImage:btnOnImage forState:UIControlStateNormal];
    [_std_click setImage:btnOffImage forState:UIControlStateNormal];
    [_shiftClick setImage:btnOffImage forState:UIControlStateNormal];
}


- (IBAction)searchBtnAccordingToValue:(id)sender {
    if([_enetrSearchKey_textfield isFirstResponder]){
        [_enetrSearchKey_textfield resignFirstResponder];
    }
    [self.view endEditing:YES];
    searchValue = _enetrSearchKey_textfield.text;
    NSLog(@"Value: %@", searchValue);
    if(_shiftClick.selected==NO && _sectionClick.selected==NO && _std_click.selected ==NO){
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
    else if(_shiftClick.selected==YES && [searchValue isEqualToString:@""]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Search Key" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(_sectionClick.selected==YES &&  [searchValue isEqualToString:@""]){
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
    else if(_shiftClick.selected == YES &&  ![searchValue isEqualToString:@""]){
        studentListSearch = YES;
        [self webserviceCall];
    }
    else if(_sectionClick.selected == YES &&  ![searchValue isEqualToString:@""]){
        studentListSearch = YES;
        [self webserviceCall];
    }
    else if(_std_click.selected == YES &&  ![searchValue isEqualToString:@""]){
        studentListSearch = YES;
        [self webserviceCall];
    }
}
- (IBAction)shiftBtn:(id)sender {
    _shiftClick.selected = YES;
    searchKey = @"Shift";
    UIImage *btnOnImage = [UIImage imageNamed:@"radio-on.png"];
    UIImage *btnOffImage = [UIImage imageNamed:@"radio-off.png"];
    [_shiftClick setImage:btnOnImage forState:UIControlStateNormal];
    [_std_click setImage:btnOffImage forState:UIControlStateNormal];
    [_sectionClick setImage:btnOffImage forState:UIControlStateNormal];
}

- (IBAction)closeBtn:(id)sender {
    closeBtnClick = YES;
    _enetrSearchKey_textfield.text = @"";
    searchValue = @"";
    [self webserviceCall];
}
- (IBAction)sentMessageTeacherBtn:(id)sender {
}

- (IBAction)searchTeacherBtn:(id)sender {
}
@end
