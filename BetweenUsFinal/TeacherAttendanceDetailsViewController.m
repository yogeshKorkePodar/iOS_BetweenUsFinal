//
//  TeacherAttendanceDetailsViewController.m
//  BetweenUs
//
//  Created by podar on 16/11/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherAttendanceDetailsViewController.h"
#import "AcedmicYearResult.h"
#import "teacherAttendanceResult.h"
#import "DivisionResult.h"
#import "MonthResult.h"
#import "SectionList.h"
#import "MBProgressHUD.h"
#import "ShiftResult.h"
#import "StandardResult.h"
#import "RestAPI.h"
#import "AttendanceDetailsTableViewCell.h"
#import "TeacherPresentHistoryViewController.h"
#import "TeacherAttendanceHistoryViewController.h"
#import "URL_Constant.h"

@interface TeacherAttendanceDetailsViewController ()
{
    BOOL attendancefirstTime,loginClick,attendanceDetails,AcademicYearBtnClick;
    NSDictionary *newDatasetinfoTeacherAttendanceDropdown,*newDatasetinfoTeacherLogout,*academicyeardetailsdictionry,*monthdetailsdictionry,*divisiondetailsdictionry,*standarddetailsdictionry,*shiftdetailsdictionry,*sectiondetailsdictionry,*attendancedetailsdictionry,*newDatasetinfoTeacherAttendanceDeatils;
    UITableView *AcademicYeartable;
    UIAlertView *alertacademicYear;
    UITableViewCell *academicCell;
    NSDictionary *receivedData;
}
@property (nonatomic, strong) AcedmicYearResult *AcedmicYearResultItems;
@property (nonatomic, strong) MonthResult *MonthResultItems;
@property (nonatomic, strong) DivisionResult *DivisionResultItems;
@property (nonatomic, strong) SectionList *SectionListItems;
@property (nonatomic, strong) ShiftResult *ShiftResultItems;
@property (nonatomic, strong) StandardResult *StandardResultItems;
@property (nonatomic, strong) teacherAttendanceResult *teacherAttendanceResultItems;

@end

@implementation TeacherAttendanceDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    attendancefirstTime = YES;
    self.navigationItem.title = @"View Attendance";
    
    [super viewDidLoad];
    //Hide back button
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"Attendance";
   
    self.attendaneDetailsTableView.delegate = self;
    self.attendaneDetailsTableView.dataSource = self;
    
    UITapGestureRecognizer *tapGestTeacherAttendance =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceTeacherAttendanceDetails)];
    [tapGestTeacherAttendance setNumberOfTapsRequired:1];
    [_attendanceView addGestureRecognizer:tapGestTeacherAttendance];
    tapGestTeacherAttendance.delegate = self;
    
    //get values
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    
    class_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"class_Id_Attendance"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    brd_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];
    
    Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
    
    DeviceType= @"IOS";
    pageNo =@"1";
    pageSize=@"200";
    
    [self checkInternetConnectivity];
    

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


- (IBAction)academicYearBtn:(id)sender {
    
    alertacademicYear= [[UIAlertView alloc] initWithTitle:@"Academic Year"
                                                  message:nil
                                                 delegate:self
                                        cancelButtonTitle:@"Close"
                                        otherButtonTitles:(NSString *)nil];
    if(self.internetActive == YES){
        
        AcademicYearBtnClick = YES;
        [self webserviceCall];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    AcademicYeartable = [[UITableView alloc] init];
    AcademicYeartable.delegate = self;
    AcademicYeartable.dataSource = self;
    [alertacademicYear setValue:AcademicYeartable forKey:@"accessoryView"];
    [alertacademicYear show];
}

-(void)webserviceCall{
    if(attendancefirstTime == YES){
        
        NSString *urlString = app_url @"PodarApp.svc/GetTeacherAttendanceDropDtls";
        
        //Pass The String to server
        newDatasetinfoTeacherAttendanceDropdown = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",brd_name,@"brd_name",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAttendanceDropdown options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(attendanceDetails == YES){
        NSString *urlString = app_url @"PodarApp.svc/TeacherAttendance";
        
        //Pass The String to server
        newDatasetinfoTeacherAttendanceDeatils = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",month_id,@"tmonth",class_id,@"cls_id",pageSize,@"PageSize",pageNo,@"PageNo",usl_id,@"usl_id",acy_id,@"Acy_year",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAttendanceDeatils options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else if(AcademicYearBtnClick == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetTeacherAttendanceDropDtls";
        
        //Pass The String to server
        newDatasetinfoTeacherAttendanceDropdown = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",brd_name,@"brd_name",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAttendanceDropdown options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else if(loginClick==YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *urlString =app_url @"PodarApp.svc/LogOut";
        
        //Pass The String to server
        newDatasetinfoTeacherLogout= [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherLogout options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
        
    }
}
-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    
    if(loginClick == YES){
        loginClick = NO;
        loginClick = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES ];
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
    else if(attendancefirstTime == YES){
        attendancefirstTime = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAttendanceDropdown options:kNilOptions error:&err];
                
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
                    AttendanceStatus = [parsedJsonArray valueForKey:@"Status"];
                    teacherAcademicYearArray = [receivedData valueForKey:@"AcedmicYearResult"];
                    teacherShiftListArray = [receivedData valueForKey:@"ShiftResult"];
                    tecaherMonthListArray = [receivedData valueForKey:@"MonthResult"];
                    teacherSectionListarray = [receivedData valueForKey:@"SectionList"];
                    teacherStandardListArray = [receivedData valueForKey:@"StandardResult"];
                    teacherDivisionListArray = [receivedData valueForKey:@"DivisionResult"];
                    NSLog(@"Status:%@",AttendanceStatus);
                    if([AttendanceStatus isEqualToString:@"1"]){
                        
                        for(int n = 0; n < [teacherAcademicYearArray  count]; n++){
                            _AcedmicYearResultItems = [[AcedmicYearResult alloc]init];
                            academicyeardetailsdictionry = [teacherAcademicYearArray objectAtIndex:n];
                        }
                        for(int m = 0; m < [tecaherMonthListArray  count]; m++){
                            _MonthResultItems = [[MonthResult alloc]init];
                            monthdetailsdictionry = [tecaherMonthListArray objectAtIndex:m];
                            month_id = [[tecaherMonthListArray objectAtIndex:0] objectForKey:@"monthid"];
                            acy_id = [[teacherAcademicYearArray objectAtIndex:0]objectForKey:@"acy_id"];
                            monthname = [[tecaherMonthListArray objectAtIndex:0]objectForKey:@"monthyear"];
                            [_academicYearClick setTitle:monthname forState:UIControlStateNormal];
                            attendanceDetails = YES;
                            [self webserviceCall];
                        }
                        for(int d = 0; d < [teacherDivisionListArray  count]; d++){
                            _DivisionResultItems = [[DivisionResult alloc]init];
                            divisiondetailsdictionry = [teacherDivisionListArray objectAtIndex:d];
                        }
                        for(int s = 0; s < [teacherStandardListArray  count]; s++){
                            _StandardResultItems = [[StandardResult alloc]init];
                            standarddetailsdictionry = [teacherStandardListArray objectAtIndex:s];
                            
                        }
                        for(int t = 0; t< [teacherShiftListArray  count]; t++){
                            _ShiftResultItems = [[ShiftResult alloc]init];
                            shiftdetailsdictionry = [teacherShiftListArray objectAtIndex:t];
                        }
                        for(int c = 0; c< [teacherSectionListarray  count]; c++){
                            _SectionListItems = [[SectionList alloc]init];
                            sectiondetailsdictionry = [teacherSectionListarray objectAtIndex:c];
                        }
                        
                    }
                    else if([AttendanceStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [self.attendaneDetailsTableView reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if(attendanceDetails == YES){
        attendanceDetails = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
      
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAttendanceDeatils options:kNilOptions error:&err];
                
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
                    AttendanceStatusDeatils = [parsedJsonArray valueForKey:@"Status"];
                    
                    teacherAttendanceDetailsArray = [receivedData objectForKey:@"teacherAttendaceResult"];
                    
                    NSLog(@"Status:%@",AttendanceStatus);
                    if([AttendanceStatusDeatils isEqualToString:@"1"]){
                        [self.attendaneDetailsTableView setHidden:NO];
                        for(int n = 0; n < [teacherAttendanceDetailsArray  count]; n++)
                        {
                            _teacherAttendanceResultItems = [[teacherAttendanceResult alloc]init];
                            attendancedetailsdictionry = [teacherAttendanceDetailsArray objectAtIndex:n];
                        }
                    }
                    else if([AttendanceStatusDeatils isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [self.attendaneDetailsTableView reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });
        
    }
    else if(AcademicYearBtnClick == YES){
        AcademicYearBtnClick = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAttendanceDropdown options:kNilOptions error:&err];
                
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
                    receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                    AttendanceStatus = [parsedJsonArray valueForKey:@"Status"];
                    teacherAcademicYearArray = [receivedData valueForKey:@"AcedmicYearResult"];
                    teacherShiftListArray = [receivedData valueForKey:@"ShiftResult"];
                    tecaherMonthListArray = [receivedData valueForKey:@"MonthResult"];
                    teacherSectionListarray = [receivedData valueForKey:@"SectionList"];
                    teacherStandardListArray = [receivedData valueForKey:@"StandardResult"];
                    teacherDivisionListArray = [receivedData valueForKey:@"DivisionResult"];
                    NSLog(@"Status:%@",AttendanceStatus);
                    if([AttendanceStatus isEqualToString:@"1"]){
                        
                        for(int n = 0; n < [teacherAcademicYearArray  count]; n++){
                            _AcedmicYearResultItems = [[AcedmicYearResult alloc]init];
                            academicyeardetailsdictionry = [teacherAcademicYearArray objectAtIndex:n];
                        }
                        for(int m = 0; m < [tecaherMonthListArray  count]; m++){
                            _MonthResultItems = [[MonthResult alloc]init];
                            monthdetailsdictionry = [tecaherMonthListArray objectAtIndex:m];
                            month_id = [[tecaherMonthListArray objectAtIndex:m] objectForKey:@"monthid"];
                            monthname = [[tecaherMonthListArray objectAtIndex:m]objectForKey:@"monthyear"];
                            NSLog(@"Month btn:%@",monthname);
                            // [_academicYearClick setTitle:monthname forState:UIControlStateNormal];
                        }
                        for(int d = 0; d < [teacherDivisionListArray  count]; d++){
                            _DivisionResultItems = [[DivisionResult alloc]init];
                            divisiondetailsdictionry = [teacherDivisionListArray objectAtIndex:d];
                        }
                        for(int s = 0; s < [teacherStandardListArray  count]; s++){
                            _StandardResultItems = [[StandardResult alloc]init];
                            standarddetailsdictionry = [teacherStandardListArray objectAtIndex:s];
                            
                        }
                        for(int t = 0; t< [teacherShiftListArray  count]; t++){
                            _ShiftResultItems = [[ShiftResult alloc]init];
                            shiftdetailsdictionry = [teacherShiftListArray objectAtIndex:t];
                        }
                        for(int c = 0; c< [teacherSectionListarray  count]; c++){
                            _SectionListItems = [[SectionList alloc]init];
                            sectiondetailsdictionry = [teacherSectionListarray objectAtIndex:c];
                        }
                        
                    }
                    else if([AttendanceStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [AcademicYeartable reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        if(tableView == _attendaneDetailsTableView)
        {
            return [teacherAttendanceDetailsArray count];
        }
        else if(tableView == AcademicYeartable){
            return [tecaherMonthListArray count];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if(tableView == _attendaneDetailsTableView){
            static NSString *simpleTableIdentifier = @"AttendanceDetailsTableViewCell";
            
            AttendanceDetailsTableViewCell *cell = (AttendanceDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttendanceDetailsTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
            }
            
            cell.presentBtnValue.tag = indexPath.row;
            
            [cell.presentBtnValue addTarget:self action:@selector(presentData:) forControlEvents:UIControlEventTouchUpInside];
            [cell.presentBtnValue setTag:indexPath.row];
            
            cell.absentBtnValue.tag = indexPath.row;
            
            [cell.absentBtnValue addTarget:self action:@selector(absentData:) forControlEvents:UIControlEventTouchUpInside];
            [cell.absentBtnValue setTag:indexPath.row];
            
            cell.rollNoView.layer.cornerRadius = 5;
            cell.rollNoView.layer.masksToBounds = YES;
            cell.totalCountView.layer.cornerRadius = 5;
            cell.totalCountView.layer.masksToBounds = YES;
            cell.absentView.layer.cornerRadius = 5;
            cell.absentView.layer.masksToBounds = YES;
            rollNo = [[teacherAttendanceDetailsArray objectAtIndex:indexPath.row]objectForKey:@"Roll_No"];
            cell.rollNo_label.text = rollNo;
            NSLog(@"RollNo%@",rollNo);
            Name = [[teacherAttendanceDetailsArray objectAtIndex:indexPath.row] objectForKey:@"student_Name"];
            cell.name_label.text = Name;
            NSLog(@"Name%@",Name);
            Total = [[teacherAttendanceDetailsArray objectAtIndex:indexPath.row]objectForKey:@"total"];
            totalP = [[teacherAttendanceDetailsArray objectAtIndex:indexPath.row]objectForKey:@"totalp"];
            
            // To underline text in UILable
            NSMutableAttributedString *textabsent = [[NSMutableAttributedString alloc] initWithString:Total];
            [textabsent addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, textabsent.length)];
            cell.absent_attendanceLabel.attributedText = textabsent;
            if([Total isEqualToString:@"0"]){
                [cell.absentBtnValue setTitle:@"" forState:UIControlStateNormal];
            }
            else{
                [cell.absentBtnValue setTitle:Total forState:UIControlStateNormal];
            }
            // To underline text in UILable
            // NSMutableAttributedString *textpresent = [[NSMutableAttributedString alloc] initWithString:totalP];
            // [textpresent addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, textpresent.length)];
            //   cell.attendance_countLabel.attributedText = textpresent;
            if([totalP isEqualToString:@"0"]){
                [cell.presentBtnValue setTitle:@"" forState:UIControlStateNormal];
            }
            else{
                [cell.presentBtnValue setTitle:totalP forState:UIControlStateNormal];
            }
            if([device isEqualToString:@"ipad"]){
                [cell.rollNo_label setFont: [cell.rollNo_label.font fontWithSize: 16.0]];
                [cell.name_label setFont: [cell.name_label.font fontWithSize: 16.0]];
                [cell.attendance_countLabel setFont: [cell.attendance_countLabel.font fontWithSize: 16.0]];
                //[cell.absent_attendanceLabel setFont: [cell.absent_attendanceLabel.font fontWithSize: 16.0]];
                cell.absentBtnValue.titleLabel.font = [UIFont systemFontOfSize:16.0];
                cell.presentBtnValue.titleLabel.font = [UIFont systemFontOfSize:16.0];
            }
            
            return cell;
        }
        else if(tableView == AcademicYeartable){
            static NSString *CellIdentifier = @"Cell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            // Set up the cell...
            cell.textLabel.text = [[tecaherMonthListArray objectAtIndex:indexPath.row]objectForKey:@"monthyear"];
            return cell;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == AcademicYeartable){
        [alertacademicYear dismissWithClickedButtonIndex:0 animated:YES];
        monthname = [[tecaherMonthListArray objectAtIndex:indexPath.row]objectForKey:@"monthyear"];
        month_id = [[tecaherMonthListArray objectAtIndex:indexPath.row]objectForKey:@"monthid"];
        attendanceDetails = YES;
        [_academicYearClick setTitle:monthname forState:UIControlStateNormal];
        [self webserviceCall];
    }
    else if(tableView == _attendaneDetailsTableView){
        //        Total = [[teacherAttendanceDetailsArray objectAtIndex:indexPath.row]objectForKey:@"total"];
        //        if(![Total isEqualToString:@""]){
        //        selectedMsdID =  [[teacherAttendanceDetailsArray objectAtIndex:indexPath.row] objectForKey:@"msd_id"];
        //
        //        [[NSUserDefaults standardUserDefaults] setObject:selectedMsdID forKey:@"selectedMsdID"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //        TeacherAttendanceHistoryViewController *teacherAttendanceHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAbsentHistory"];
        //
        //        NSLog(@"selected msdid %@",selectedMsdID);
        //        teacherAttendanceHistoryViewController.month = month_id;
        //        [self.navigationController pushViewController:teacherAttendanceHistoryViewController animated:YES];
        //        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        //        }
        //        else if([Total isEqualToString:@""]){
        //            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"There is no attendance available" preferredStyle:UIAlertControllerStyleAlert];
        //
        //            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        //            [alertController addAction:ok];
        //
        //            [self presentViewController:alertController animated:YES completion:nil];
        //        }
    }
    
}
-(void)absentData:(id)sender{
    //Unable to access sender.tag property }
    UIButton *btn = (UIButton*)sender;
    int row = btn.tag;
    //   atnValid = [[teacherAttendanceDetailsArray objectAtIndex:row] objectForKey:@"atn_valid"];
    NSLog(@"Atn Valid: %@", atnValid);
    Total = [[teacherAttendanceDetailsArray objectAtIndex:row]objectForKey:@"total"];
    if(![Total isEqualToString:@""]){
        selectedMsdID =  [[teacherAttendanceDetailsArray objectAtIndex:row] objectForKey:@"msd_id"];
        //  atnValid = [[teacherAttendanceDetailsArray objectAtIndex:row]objectForKey:@"atn_valid"];
        atnValid = @"0";
        [[NSUserDefaults standardUserDefaults] setObject:selectedMsdID forKey:@"selectedMsdID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:atnValid forKey:@"atn_valid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        TeacherAttendanceHistoryViewController *teacherAttendanceHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAbsentHistory"];
        
        NSLog(@"selected msdid %@",selectedMsdID);
        teacherAttendanceHistoryViewController.month = month_id;
        [self.navigationController pushViewController:teacherAttendanceHistoryViewController animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    else if([Total isEqualToString:@""]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"There is no attendance available" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

-(void)presentData:(id)sender{
    //Unable to access sender.tag property }
    UIButton *btn = (UIButton*)sender;
    int row = btn.tag;
    //    atnValid = [[teacherAttendanceDetailsArray objectAtIndex:row] objectForKey:@"atn_valid"];
    NSLog(@"Atn Valid: %@", atnValid);
    Total = [[teacherAttendanceDetailsArray objectAtIndex:row]objectForKey:@"total"];
    if(![Total isEqualToString:@""]){
        selectedMsdID =  [[teacherAttendanceDetailsArray objectAtIndex:row] objectForKey:@"msd_id"];
        // atnValid = [[teacherAttendanceDetailsArray objectAtIndex:row]objectForKey:@"atn_valid"];
        atnValid = @"1";
        
        [[NSUserDefaults standardUserDefaults] setObject:atnValid forKey:@"atn_valid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:acy_id forKey:@"acy_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:selectedMsdID forKey:@"selectedMsdID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        TeacherPresentHistoryViewController *TeacherPresentHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherPresentHistory"];
        
        NSLog(@"selected msdid %@",selectedMsdID);
        TeacherPresentHistoryViewController.month = month_id;
        [self.navigationController pushViewController:TeacherPresentHistoryViewController animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    else if([Total isEqualToString:@""]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"There is no attendance available" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
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
