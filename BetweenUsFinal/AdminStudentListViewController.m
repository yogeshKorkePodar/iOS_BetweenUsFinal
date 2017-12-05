//
//  AdminStudentListViewController.m
//  BetweenUs
//
//  Created by podar on 23/09/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "AdminStudentListViewController.h"
#import "AdminWriteMessageViewController.h"
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
#import "AdminStudentListViewController.h"
#import "MsgStudentResult.h"
#import "AdminStudentListTableViewCell.h"
#import "AdminSendMessageViewController.h"
//#import "AdminSchoolSMSViewController.h"

@interface AdminStudentListViewController ()
{
    MBProgressHUD *hud;
    UIButton *btn;
    NSIndexPath *path;
    NSInteger *cellRow;
    WYPopoverController *settingsPopoverController;
    UITapGestureRecognizer *tapGestRecog ;
    NSDictionary *newDatasetinfoAdminWriteMessages_academicYear,*newDatasetinfoAdminWriteMessages,*newDatasetinfoAdminLogout;
    BOOL loginClick,firstTime,academicYear,firstTimeStudentList,academicYearSelected,studentListSearch,*closeBtnClick,checkboxClicked,checkboxAllClicked,individualButtonClicked,searchList,closebtnclick,selectAll;
    UITapGestureRecognizer *tapGesture,*tapGestureTextfield;

}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (nonatomic, strong) MsgStudentResult *MsgStudentResultItems;
@property(nonatomic,strong)   AdminStudentListTableViewCell *cell;

@end

@implementation AdminStudentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    firstTime = YES;
    checkboxAllClicked = NO;
    checkboxClicked = NO;
    pageSize = @"200";
    pageIndex =@"1";
    student_name = @"";
    AdminWriteMessage = @"Student";
    [_closebuttonClick setHidden:YES];
    [[NSUserDefaults standardUserDefaults] setObject:AdminWriteMessage forKey:@"AdminWriteMessage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    cls_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"cls_ID"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    DeviceType= @"IOS";
    clickedAll = [[NSUserDefaults standardUserDefaults]stringForKey:@"ClickedAll"];
    std = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedStd"];
    shift = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedShiftName"];
    section = [[NSUserDefaults standardUserDefaults] stringForKey:@"SelectedSectionName"];
    if([clickedAll isEqualToString:@"true"]){
           self.navigationItem.title = @"Student List";
    
    }
    else if([clickedAll isEqualToString:@"false"]){
           self.navigationItem.title = [NSString stringWithFormat:@"%@>>%@>>%@",std,shift,section];
    }
 

    
//    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:14.0],UITextAttributeFont, nil];
//    
//    self.navigationController.navigationBar.titleTextAttributes = size;
//         self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    self.studentListTableView.delegate = self;
    self.studentListTableView.dataSource = self;
    _studentNameTextfield.delegate = self;
    stuIdArray = [[NSMutableArray alloc] init];
    pathArray = [[NSMutableArray alloc] init];
    mystringArray = [[NSMutableArray alloc]init];
    buttonTagsTapped = [[NSMutableArray alloc] init];
    newMyStringArray = [[NSMutableArray alloc] init];
    arrayForTag =  [[NSMutableArray alloc]init];
 //  [self.studentListTableView setEditing:YES animated:YES];
    
    //Click Event
    UITapGestureRecognizer *tapGestAdmindropDownView =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOncedropDownView)];
    [tapGestAdmindropDownView setNumberOfTapsRequired:1];
    [_dropDownView addGestureRecognizer:tapGestAdmindropDownView];
    tapGestAdmindropDownView.delegate = self;
    
    //Click Event
    UITapGestureRecognizer *tapGestAdminSendMessage =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceSendMessage)];
    [tapGestAdminSendMessage setNumberOfTapsRequired:1];
    [_sendMessageClick addGestureRecognizer:tapGestAdminSendMessage];
    tapGestAdminSendMessage.delegate = self;
    
    UITapGestureRecognizer *tapGestTextfield =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
    [tapGestTextfield setNumberOfTapsRequired:1];
    [_studentNameTextfield addGestureRecognizer:tapGestTextfield];
    tapGestTextfield.delegate = self;
    
    UITapGestureRecognizer *tapGestCloseView =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
    [tapGestCloseView setNumberOfTapsRequired:1];
    [_closeView addGestureRecognizer:tapGestCloseView];
    tapGestCloseView.delegate = self;
    
    UITapGestureRecognizer *tapGestCloseImg=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
    [tapGestCloseImg setNumberOfTapsRequired:1];
    [_closebuttonClick addGestureRecognizer:tapGestCloseImg];
    tapGestCloseImg.delegate = self;

    
    [self checkInternetConnectivity];
}
-(void)TextfieldAdminUsername{
    [_closeView setHidden:NO];
    [_closebuttonClick setHidden:NO];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"went here ...");
    
    //  if([touch.view isKindOfClass:[UITextField class]]){
    if(touch.view==_studentNameTextfield){
        [_closebuttonClick setHidden:NO];
        [_closeView setHidden:NO];
        //   tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
        [self TextfieldAdminUsername];
        
    }
    else if(touch.view == _closeView){
        
        [self screenTappedOnceCloseView];
    }
    else if(touch.view == _closebuttonClick){
          [self screenTappedOnceCloseView];
    }
    else if(touch.view == _sendMessageClick){
        [self sendMessage];
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
-(void)screenTappedOnceCloseView{
    closebtnclick = YES;
    _studentNameTextfield.text = @"";
    individualButtonClicked = NO;
    checkboxAllClicked = NO;

    [_closeView setHidden:YES];
    [_closebuttonClick setHidden:YES];
    student_name= @"";
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    [arrayForTag removeAllObjects];
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    [stuIdArray removeAllObjects];
    stu_id = [stuIdArray componentsJoinedByString:@","];
    NSLog(@"Stu id after all det: %@", stu_id);
    
    [self webserviceCall];
}


-(void)screenTappedOnceSendMessage{
    if(checkboxAllClicked ==NO && individualButtonClicked == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(selectAll == NO && stuIdArray.count == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }    else{
        stu_id = [stuIdArray componentsJoinedByString:@","];
        
        NSLog(@"all stu id  %@",stu_id);
        
        AdminSendMessageViewController *adminSendMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSendMessage"];
        adminSendMessageViewController.stu_id = stu_id;
        
        [self.navigationController pushViewController:adminSendMessageViewController animated:YES];
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
        NSString *urlString = app_url @"PodarApp.svc/GetMessageStudentList";
        
        //Pass The String to server
        newDatasetinfoAdminWriteMessages_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",cls_id,@"cls_id",student_name,@"studentName",pageIndex,@"PageNo",pageSize,@"PageSize",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages_academicYear options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else if(searchList == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetMessageStudentList";
        
        //Pass The String to server
        newDatasetinfoAdminWriteMessages_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",cls_id,@"cls_id",student_name,@"studentName",pageIndex,@"PageNo",pageSize,@"PageSize",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages_academicYear options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(closebtnclick == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetMessageStudentList";
        
        //Pass The String to server
        newDatasetinfoAdminWriteMessages_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",cls_id,@"cls_id",student_name,@"studentName",pageIndex,@"PageNo",pageSize,@"PageSize",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminWriteMessages_academicYear options:NSJSONWritingPrettyPrinted error:&error];
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
                    
                    AdminStudentListStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminStudentListData = [receivedData objectForKey:@"MsgStudentResult"];
                    if([AdminStudentListStatus isEqualToString:@"1"]){
                        _MsgStudentResultItems = [[MsgStudentResult alloc]init];
                        
                    }
                    else if([AdminStudentListStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_studentListTableView reloadData];

                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if(searchList == YES){
        searchList = NO;
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
                    
                    AdminStudentListStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminStudentListData = [receivedData objectForKey:@"MsgStudentResult"];
                    if([AdminStudentListStatus isEqualToString:@"1"]){
                        _MsgStudentResultItems = [[MsgStudentResult alloc]init];
                        
                    }
                    else if([AdminStudentListStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_studentListTableView reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if(closebtnclick == YES){
        closebtnclick = NO;
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
                    
                    AdminStudentListStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminStudentListData = [receivedData objectForKey:@"MsgStudentResult"];
                    if([AdminStudentListStatus isEqualToString:@"1"]){
                        _MsgStudentResultItems = [[MsgStudentResult alloc]init];
                        
                    }
                    else if([AdminStudentListStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_studentListTableView reloadData];
                    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        if(tableView == _studentListTableView){
            return [AdminStudentListData count];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    @try {
         static NSString *simpleTableIdentifier = @"AdminStudentListTableViewCell";
        
        _cell = (AdminStudentListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (_cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminStudentListTableViewCell" owner:self options:nil];
            _cell = [nib objectAtIndex:0];
        }
        UIImage *btnCheckedImage = [UIImage imageNamed:@"blue_messagechecked_32x32.png"];
        UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
        [_cell.cellCheckBoxClick addTarget:self action:@selector(checkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _cell.cellCheckBoxClick.tag = indexPath.row;
        NSNumber *abc = [NSNumber numberWithInt:_cell.cellCheckBoxClick.tag];
        [_cell.cellCheckBoxClick setTag:indexPath.row];

        int rows = [tableView numberOfRowsInSection:indexPath.section];
        
        if(![self isSelectedCheckBox:_cell.cellCheckBoxClick.tag] && checkboxAllClicked==NO)
        {
           [_cell.cellCheckBoxClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
        }
        else if([self isSelectedCheckBox:_cell.cellCheckBoxClick.tag] && checkboxAllClicked==NO){
          [_cell.cellCheckBoxClick setImage:btnCheckedImage forState:UIControlStateNormal];
        }
        
        
        if(![self isSelectedCheckBox:_cell.cellCheckBoxClick.tag] && checkboxAllClicked == YES)
        {
               [_cell.cellCheckBoxClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
        }
        else if([self isSelectedCheckBox:_cell.cellCheckBoxClick.tag] && checkboxAllClicked == YES ){
            [_cell.cellCheckBoxClick setImage:btnCheckedImage forState:UIControlStateNormal];

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
                    stu_id = [[AdminStudentListData objectAtIndex:cellRow] objectForKey:@"stu_ID"];
                    [stuIdArray addObject:stu_id];
                    NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:stuIdArray];
                    stuIdArray = [[NSMutableArray alloc] initWithArray:[mySet array]];
                    stu_id = [stuIdArray componentsJoinedByString:@","];
                    NSLog(@"Stu id after all selection: %@", stu_id);
                    
                }
            }
        
            _cell.cellCheckBoxClick.selected = YES;
            [_cell.cellCheckBoxClick setTag:indexPath.row];
            [_cell.cellCheckBoxClick setImage:btnCheckedImage forState:UIControlStateNormal];
           
            
        }
        else if(_checkAllClick.selected == NO){
            _cell.cellCheckBoxClick.selected = YES;
            [_cell.cellCheckBoxClick setTag:indexPath.row];
            [_cell.cellCheckBoxClick setImage:btnUnCheckedImage forState:UIControlStateNormal];

        }
        }
        
        //Alternate color to cell
        _cell.rollNoView.layer.cornerRadius = 5;
                _cell.rollNoView.layer.masksToBounds = YES;
                _cell.studentNamelabel.text = [[AdminStudentListData objectAtIndex:indexPath.row] objectForKey:@"Student_Name"];
                    _cell.rollNoLabel.text = [[AdminStudentListData objectAtIndex:indexPath.row] objectForKey:@"Roll_No"];
                          if (indexPath.row % 2 == 0) {
                            _cell.studentNamelabel.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
                            _cell.rolNoBgView.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
                            _cell.cellCheckBoxClick.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
            
                        }
                        else
                        {
                            _cell.studentNamelabel.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
                            _cell.rolNoBgView.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
                           _cell.cellCheckBoxClick.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
                        }

        
               return _cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}


-(void)checkButtonPressed:(id)sender
{
   
    BOOL checked;
    individualButtonClicked = YES;
    selectAll = NO;
    UIButton *checkBox=(UIButton*)sender;
    UIImage *btnCheckedImage = [UIImage imageNamed:@"blue_messagechecked_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    
    path = [NSIndexPath indexPathForRow:checkBox.tag inSection:0];
    stu_id = [[AdminStudentListData objectAtIndex:checkBox.tag] objectForKey:@"stu_ID"];
   
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
    [stuIdArray addObject:stu_id];
    stu_id = [stuIdArray componentsJoinedByString:@","];
    NSLog(@"Stu ID after add  %@",stu_id);

}


-(void)deleteSelectedCheckBoxTag:(int)value
{
    
    for(int i=0;i<[arrayForTag count];i++)
    {
        if([[arrayForTag objectAtIndex:i] intValue]==value)
            [arrayForTag removeObjectAtIndex:i];
    }
    NSLog(@"After deletion  .." ,arrayForTag);
    [stuIdArray removeObject:stu_id];
    stu_id = [stuIdArray componentsJoinedByString:@","];
    NSLog(@"Stu ID after remove  %@",stu_id);
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (IBAction)searchStudentBtn:(id)sender {
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    if([_studentNameTextfield isFirstResponder]){
        [_studentNameTextfield resignFirstResponder];
    }
    [self.view endEditing:YES];
    searchList = YES;
    student_name = _studentNameTextfield.text;
    individualButtonClicked = NO;
    checkboxAllClicked = NO;
    [arrayForTag removeAllObjects];
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    [stuIdArray removeAllObjects];
    stu_id = [stuIdArray componentsJoinedByString:@","];
    NSLog(@"Stu id after all det: %@", stu_id);
    [self webserviceCall];
    
    
}
-(void)sendMessage{
    if(checkboxAllClicked ==NO && individualButtonClicked == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(selectAll == NO && stuIdArray.count == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else{
        stu_id = [stuIdArray componentsJoinedByString:@","];
        
        NSLog(@"all stu id  %@",stu_id);
        
        AdminSendMessageViewController *adminSendMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSendMessage"];
        adminSendMessageViewController.stu_id = stu_id;
        
        [self.navigationController pushViewController:adminSendMessageViewController animated:YES];
    }

}
- (IBAction)sendMessageBtn:(id)sender {
    
    if(checkboxAllClicked ==NO && individualButtonClicked == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(selectAll == NO && stuIdArray.count == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];

    }
    else{
        stu_id = [stuIdArray componentsJoinedByString:@","];
        
        NSLog(@"all stu id  %@",stu_id);
        
        AdminSendMessageViewController *adminSendMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSendMessage"];
        adminSendMessageViewController.stu_id = stu_id;

        [self.navigationController pushViewController:adminSendMessageViewController animated:YES];
    }

}
- (IBAction)checkAllBtn:(id)sender {
    UIButton *checkBoxAll=(UIButton*)sender;
    checkboxAllClicked = YES;
    individualButtonClicked = NO;
    selectAll = YES;
    UIImage *btnCheckedImage = [UIImage imageNamed:@"blue_messagechecked_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    
    if(_checkAllClick.isSelected == YES){
        _checkAllClick.selected = NO;
         checkboxAllClicked = NO;
        [arrayForTag removeAllObjects];
          [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
        [stuIdArray removeAllObjects];
        stu_id = [stuIdArray componentsJoinedByString:@","];
        NSLog(@"Stu id after all det: %@", stu_id);
        

           [_studentListTableView reloadData];
    }
    else if(_checkAllClick.isSelected == NO){
        _checkAllClick.selected = YES;
        [_checkAllClick setImage:btnCheckedImage forState:UIControlStateNormal];
        [_studentListTableView reloadData];
    }

}
@end
