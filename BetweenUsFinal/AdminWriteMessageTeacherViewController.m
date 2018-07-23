//
//  AdminWriteMessageTeacherViewController.m
//  BetweenUs
//
//  Created by podar on 29/09/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "NavigationMenuButton.h"
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
#import "AdminSchoolSMSViewController.h"


@interface AdminWriteMessageTeacherViewController ()
{
    
    MBProgressHUD *hud;
    WYPopoverController *settingsPopoverController;
    AdminTeacherTableViewCell *cell;
    NSIndexPath *path;
    NSInteger *cellRow;
    UITapGestureRecognizer *tapGestRecog ;
    NSDictionary *newDatasetinfoAdminWriteMessages_academicYear,*newDatasetinfoAdminWriteMessages,*newDatasetinfoAdminLogout;
    BOOL loginClick,firstTime,academicYear,firstTimeStudentList,academicYearSelected,teacherListSearch,*closeBtnClick,checkAllButtonClicked,individualButtonClicked,selectAll;
    UIAlertView *alertcycle;
    UITableView *academicYearTaleView;
    UITapGestureRecognizer *tapGesture,*tapGestureTextfield;
    
}

@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (nonatomic, strong) MsgTeacherResult *MsgTeacherResultItems;
@end

@implementation AdminWriteMessageTeacherViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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
     self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];
    self.adminTeacherTableView.delegate = self;
    self.adminTeacherTableView.dataSource = self;
    [_teacherNameTextfiled setDelegate:self];
     [_closeBtnClick setHidden:YES];
    uslIdArray = [[NSMutableArray alloc]init];
    arrayForTag = [[NSMutableArray alloc]init];
    pathArray = [[NSMutableArray alloc]init];
    checkAllButtonClicked = NO;
    AdminWriteMessage = @"Teacher";
    
    [[NSUserDefaults standardUserDefaults] setObject:AdminWriteMessage forKey:@"AdminWriteMessage"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //Click Event
    UITapGestureRecognizer *tapGestAdminViewMessages =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceViewMessages)];
    [tapGestAdminViewMessages setNumberOfTapsRequired:1];
    [_viewMessageClick addGestureRecognizer:tapGestAdminViewMessages];
    tapGestAdminViewMessages.delegate = self;
    
    
    UITapGestureRecognizer *tapGestAdminSentMessages =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceASentMessages)];
    [tapGestAdminSentMessages setNumberOfTapsRequired:1];
    [_sentMessageClick addGestureRecognizer:tapGestAdminSentMessages];
    tapGestAdminSentMessages.delegate = self;
    
    tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminTeacherCloseButton)];
    [tapGesture setNumberOfTapsRequired:1];
    [_closeBtnView addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    
    tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminTeacherName)];
    [tapGesture setNumberOfTapsRequired:1];
    [_teacherNameTextfiled addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;

    
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

    [self checkInternetConnectivity];

}

-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)screenTappedOnceViewMessages{
    AdminViewMessageViewController *adminViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewMessage"];
    
    [self.navigationController pushViewController:adminViewMessageViewController animated:YES];
}
-(void)screenTappedOnceASentMessages{
    AdminSentMessagesViewController *adminSentMessagesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSentMessage"];
    [self.navigationController pushViewController:adminSentMessagesViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

-(void)TextfieldAdminTeacherCloseButton{
    _teacherNameTextfiled.text = @"";
    studentName = @"";
    closeBtnClick = YES;
    individualButtonClicked = NO;
    checkAllButtonClicked = NO;
    [_closeBtnClick setHidden:NO];

    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    [arrayForTag removeAllObjects];
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    [uslIdArray removeAllObjects];
    usl_id = [uslIdArray componentsJoinedByString:@","];
    NSLog(@"usl id after all det: %@", usl_id);
    
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];

    [self webserviceCall];
}

-(void)TextfieldAdminTeacherName{
    [_closeBtnClick setHidden:NO];

}


-(void)handleDrawer{
    [self.rootNav drawerToggle];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"went here ...");
    
    if([touch.view isKindOfClass:[UITextField class]]){
        if(touch.view==_teacherNameTextfiled){
            [_closeBtnClick setHidden:NO];
            
            [self TextfieldAdminTeacherName];
        }
    }
    else if ([touch.view isKindOfClass:[UIView class]]){
        if(touch.view == _closeBtnView){
            //  tapGestureTextfield = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsernameCloseButton)];
            [self TextfieldAdminTeacherCloseButton];
        }
        return YES;
    }
    
    return NO; // handle the touch
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
        NSString *urlString = app_url @"GetMessageTeacherList";
        
        
        
        //Pass The String to server
        newDatasetinfoAdminWriteMessages_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",pageNo,@"PageNo",pageSize,@"PageSize",studentName,@"studentName",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages_academicYear options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else if(closeBtnClick==YES){
        NSString *urlString = app_url @"GetMessageTeacherList";
        [_closeBtnClick setHidden:YES];
        usl_id = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"usl_id"];
        //Pass The String to server
        newDatasetinfoAdminWriteMessages_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",pageNo,@"PageNo",pageSize,@"PageSize",studentName,@"studentName",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages_academicYear options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];

    }
    else if(teacherListSearch ==YES){
        NSString *urlString = app_url @"GetMessageTeacherList";
        
        usl_id = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"usl_id"];

        //Pass The String to server
        newDatasetinfoAdminWriteMessages_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",pageNo,@"PageNo",pageSize,@"PageSize",studentName,@"studentName",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages_academicYear options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];

    }
    else if(loginClick==YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *urlString = app_url @"LogOut";
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
                    
                    TeacherListStatus = [parsedJsonArray valueForKey:@"Status"];
                    TeacherTableData = [receivedData objectForKey:@"MsgTeacherResult"];
                    if([TeacherListStatus isEqualToString:@"1"]){
                        _MsgTeacherResultItems = [[MsgTeacherResult alloc]init];
                        TeacherDetails = [TeacherTableData objectAtIndex:0];
                        }
                    else if([TeacherListStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                     [_adminTeacherTableView reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if(closeBtnClick == YES){
        closeBtnClick = NO;
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
                    
                    TeacherListStatus = [parsedJsonArray valueForKey:@"Status"];
                    TeacherTableData = [receivedData objectForKey:@"MsgTeacherResult"];
                    if([TeacherListStatus isEqualToString:@"1"]){
                        _MsgTeacherResultItems = [[MsgTeacherResult alloc]init];
                        TeacherDetails = [TeacherTableData objectAtIndex:0];
                    }
                    else if([TeacherListStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }

                    [_adminTeacherTableView reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });

        
    }
    else if(teacherListSearch == YES){
        teacherListSearch = NO;
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
                    
                    TeacherListStatus = [parsedJsonArray valueForKey:@"Status"];
                    TeacherTableData = [receivedData objectForKey:@"MsgTeacherResult"];
                    if([TeacherListStatus isEqualToString:@"1"]){
                        _MsgTeacherResultItems = [[MsgTeacherResult alloc]init];
                        TeacherDetails = [TeacherTableData objectAtIndex:0];
                    }
                    else if([TeacherListStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }

                    [_adminTeacherTableView reloadData];
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
        return [TeacherTableData count];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        
            static NSString *simpleTableIdentifier = @"AdminTeacherTableViewCell";
            
            cell = (AdminTeacherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        UIImage *btnCheckedImage = [UIImage imageNamed:@"blue_messagechecked_32x32.png"];
        UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];

            
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminTeacherTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
    
        [cell.checkbox_click addTarget:self action:@selector(TeachercheckButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.checkbox_click.tag = indexPath.row;
        
        if(![self isSelectedCheckBox:cell.checkbox_click.tag] && checkAllButtonClicked==NO)
        {
            [cell.checkbox_click setImage:btnUnCheckedImage forState:UIControlStateNormal];
        }
        else if([self isSelectedCheckBox:cell.checkbox_click.tag] && checkAllButtonClicked==NO){
            [cell.checkbox_click setImage:btnCheckedImage forState:UIControlStateNormal];
        }
        
        
        if(![self isSelectedCheckBox:cell.checkbox_click.tag] && checkAllButtonClicked == YES)
        {
            [cell.checkbox_click setImage:btnUnCheckedImage forState:UIControlStateNormal];
        }
        else if([self isSelectedCheckBox:cell.checkbox_click.tag] && checkAllButtonClicked == YES ){
            [cell.checkbox_click setImage:btnCheckedImage forState:UIControlStateNormal];
            
        }

        
        
        
        if(checkAllButtonClicked == YES && individualButtonClicked == NO){
        if(_checkAllClick.selected ==YES){
            NSInteger nSections = [tableView numberOfSections];
            for (int j=0; j<nSections; j++) {
                NSInteger nRows = [tableView numberOfRowsInSection:j];
                for (int i=0; i<nRows; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:j];
                    cellRow= indexPath.row;
                    
                    NSString *inStr = [NSString stringWithFormat: @"%ld", cellRow];
                    NSLog(@"Index: %@", inStr);
                    [arrayForTag addObject:inStr];
                    usl_id = [[TeacherTableData objectAtIndex:cellRow] objectForKey:@"usl_Id"];
                    [uslIdArray addObject:usl_id];
                    NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:uslIdArray];
                    uslIdArray = [[NSMutableArray alloc] initWithArray:[mySet array]];
                    usl_id = [uslIdArray componentsJoinedByString:@","];
                    NSLog(@"usl id after all selection: %@", usl_id);
                    
                }
            }

            cell.checkbox_click.selected = YES;
            [cell.checkbox_click setTag:indexPath.row];
            [cell.checkbox_click setImage:btnCheckedImage forState:UIControlStateNormal];

        }
        else if(_checkAllClick.selected == NO){
            cell.checkbox_click.selected = YES;
            [cell.checkbox_click setTag:indexPath.row];
            [cell.checkbox_click setImage:btnUnCheckedImage forState:UIControlStateNormal];
        }
        }
        
        
        
        
        
       cell.teacherName_label.text = [[TeacherTableData objectAtIndex:indexPath.row] objectForKey:@"StaffName"];
            
        
            
            if (indexPath.row % 2 == 0) {
                cell.teacherName_label.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
                cell.checkbox_click.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
            }
            else
            {
                cell.teacherName_label.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
                cell.checkbox_click.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
            }
            
            return cell;
            
    
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}



-(void)TeachercheckButtonPressed:(id)sender
{
    
    BOOL checked;
    individualButtonClicked = YES;
    selectAll = NO;
    UIButton *checkBox=(UIButton*)sender;
    UIImage *btnCheckedImage = [UIImage imageNamed:@"blue_messagechecked_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    
    path = [NSIndexPath indexPathForRow:checkBox.tag inSection:0];
    usl_id = [[TeacherTableData objectAtIndex:checkBox.tag] objectForKey:@"usl_Id"];
    
    if ([checkBox.currentImage isEqual:[UIImage imageNamed:@"blue_messagechecked_32x32.png"]]){
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
    [uslIdArray addObject:usl_id];
    usl_id = [uslIdArray componentsJoinedByString:@","];
    NSLog(@"Usl ID after add  %@",usl_id);
    
}


-(void)deleteSelectedCheckBoxTag:(int)value
{
    
    for(int i=0;i<[arrayForTag count];i++)
    {
        if([[arrayForTag objectAtIndex:i] intValue]==value)
            [arrayForTag removeObjectAtIndex:i];
    }
    NSLog(@"After deletion  .." ,arrayForTag);
    [uslIdArray removeObject:usl_id];
    usl_id = [uslIdArray componentsJoinedByString:@","];
    NSLog(@"Usl ID after remove  %@",usl_id);
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





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    cls_id  = [[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"cls_ID"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myString"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"btnTapped"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Array"];
        
        [[NSUserDefaults standardUserDefaults] setObject:cls_id forKey:@"cls_ID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (IBAction)closeBtn:(id)sender {
    [self TextfieldAdminTeacherCloseButton];
}

- (IBAction)TeacherBtn:(id)sender {
}

- (IBAction)StudentBtn:(id)sender {
    AdminWriteMessageViewController *adminWriteMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminWriteMessage"];
    
    [self.navigationController pushViewController:adminWriteMessageViewController animated:NO];
}
- (IBAction)searchTeacherBtn:(id)sender {
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];

    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    teacherListSearch = YES;
    if([_teacherNameTextfiled isFirstResponder]){
        [_teacherNameTextfiled resignFirstResponder];
    }
    [self.view endEditing:YES];
    
    studentName = _teacherNameTextfiled.text;
    individualButtonClicked = NO;
    checkAllButtonClicked = NO;
    [arrayForTag removeAllObjects];
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    [uslIdArray removeAllObjects];
    usl_id = [uslIdArray componentsJoinedByString:@","];
    NSLog(@"usl id after all det: %@", usl_id);
    
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    [self webserviceCall];
}

- (IBAction)sendMessageTeacher:(id)sender {
    if(checkAllButtonClicked ==NO && individualButtonClicked == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Teacher" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(selectAll == NO && uslIdArray.count == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Teacher" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];

    }
    else{
    usl_id = [uslIdArray componentsJoinedByString:@","];
    NSLog(@"Usl id: %@", usl_id);

    [[NSUserDefaults standardUserDefaults] setObject:usl_id forKey:@"UslIDMessage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  
    AdminSendMessageViewController *adminSendMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSendMessage"];
    
    [self.navigationController pushViewController:adminSendMessageViewController animated:YES];
        
    }
}
- (IBAction)checkAllBtn:(id)sender {
    UIButton *checkBoxAll=(UIButton*)sender;
    checkAllButtonClicked = YES;
    individualButtonClicked = NO;
    selectAll = YES;
    UIImage *btnCheckedImage = [UIImage imageNamed:@"blue_messagechecked_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    
    if(_checkAllClick.selected == YES){
        _checkAllClick.selected = NO;
        checkAllButtonClicked = NO;
        [arrayForTag removeAllObjects];
        [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
        [uslIdArray removeAllObjects];
        usl_id = [uslIdArray componentsJoinedByString:@","];
        NSLog(@"usl id after all det: %@", usl_id);

        [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
        [_adminTeacherTableView reloadData];
    }
    else if(_checkAllClick.selected == NO){
        _checkAllClick.selected = YES;
          [_checkAllClick setImage:btnCheckedImage forState:UIControlStateNormal];
        [_adminTeacherTableView reloadData];
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
