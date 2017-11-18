//
//  TeacherWriteMessageViewController.m
//  BetweenUs
//
//  Created by podar on 24/10/17.
//  Copyright © 2017 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "TeacherWriteMessageViewController.h"
#import "NavigationMenuButton.h"
#import "MBProgressHUD.h"
#import "AcedmicYearResult.h"
#import "MonthResult.h"
#import "DivisionResult.h"
#import "SectionList.h"
#import "ShiftResult.h"
#import "StandardResult.h"
#import "RestAPI.h"
#import "TeacherAttendanceTableViewCell.h"
#import "TeacherWriteMessageStudentListViewController.h"
@interface TeacherWriteMessageViewController (){
BOOL loginClick;
NSDictionary *newDatasetinfoTeacherWriteMessageDropdown,*newDatasetinfoTeacherLogout,*academicyeardetailsdictionry,*monthdetailsdictionry,*divisiondetailsdictionry,*standarddetailsdictionry,*shiftdetailsdictionry,*sectiondetailsdictionry;
}
@property (nonatomic, strong) AcedmicYearResult *AcedmicYearResultItems;
@property (nonatomic, strong) MonthResult *MonthResultItems;
@property (nonatomic, strong) DivisionResult *DivisionResultItems;
@property (nonatomic, strong) SectionList *SectionListItems;
@property (nonatomic, strong) ShiftResult *ShiftResultItems;
@property (nonatomic, strong) StandardResult *StandardResultItems;
@end

@implementation TeacherWriteMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    
    self.TeacherWriteMEssageDropDown.delegate = self;
    self.TeacherWriteMEssageDropDown.dataSource = self;
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
-(void) webserviceCall{
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
    else{
        NSString *urlString = app_url @"PodarApp.svc/GetTeacherSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoTeacherWriteMessageDropdown = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherWriteMessageDropdown options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    
}
-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    
    if(loginClick == YES){
        loginClick = NO;
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
    else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherWriteMessageDropdown options:kNilOptions error:&err];
                
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
                    BehaviourStatus = [parsedJsonArray valueForKey:@"Status"];
                    teacherAcademicYearArray = [receivedData valueForKey:@"AcedmicYearResult"];
                    teacherShiftListArray = [receivedData valueForKey:@"ShiftResult"];
                    tecaherMonthListArray = [receivedData valueForKey:@"MonthResult"];
                    teacherSectionListarray = [receivedData valueForKey:@"SectionList"];
                    teacherStandardListArray = [receivedData valueForKey:@"StandardResult"];
                    teacherDivisionListArray = [receivedData valueForKey:@"DivisionResult"];
                    NSLog(@"Status:%@",BehaviourStatus);
                    if([BehaviourStatus isEqualToString:@"1"]){
                        
                        for(int n = 0; n < [teacherAcademicYearArray  count]; n++){
                            _AcedmicYearResultItems = [[AcedmicYearResult alloc]init];
                            academicyeardetailsdictionry = [teacherAcademicYearArray objectAtIndex:n];
                        }
                        for(int m = 0; m < [tecaherMonthListArray  count]; m++){
                            _MonthResultItems = [[MonthResult alloc]init];
                            monthdetailsdictionry = [tecaherMonthListArray objectAtIndex:m];
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
                    else if([BehaviourStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [self.TeacherWriteMEssageDropDown reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    
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
    cell.sectionLabel.backgroundColor = [UIColor colorWithRed:78.0/255.0f green:163/255.0f blue:206/255.0f alpha:1.0];
    cell.shiftlabel.backgroundColor = [UIColor colorWithRed:78.0/255.0f green:163/255.0f blue:206/255.0f alpha:1.0];
    cell.std_div_label.backgroundColor =[UIColor colorWithRed:78.0/255.0f green:163/255.0f blue:206/255.0f alpha:1.0];
    cell.wholeview.backgroundColor = [UIColor colorWithRed:78.0/255.0f green:163/255.0f blue:206/255.0f alpha:1.0];
    cell.teacherbtnBg.backgroundColor = [UIColor colorWithRed:18.0/255.0f green:130.0/255.0f blue:185/255.0f alpha:1.0];
    cell.nextBtnBg.backgroundColor = [UIColor colorWithRed:18.0/255.0f green:130.0/255.0f blue:185/255.0f alpha:1.0];
    sectionName = [[teacherSectionListarray objectAtIndex:indexPath.row]objectForKey:@"sec_Name"];
    cell.sectionLabel.text = sectionName;
    NSLog(@"Section name  %@",sectionName);
    SfiName = [[teacherShiftListArray objectAtIndex:indexPath.row] objectForKey:@"sft_name"];
    divName = [[teacherDivisionListArray objectAtIndex:indexPath.row]objectForKey:@"div_name"];
    stdName = [[teacherStandardListArray objectAtIndex:indexPath.row]objectForKey:@"std_Name"];
    teachershiftstdDiv=[NSString stringWithFormat: @"%@-%@", stdName,divName];
    cell.shiftlabel.text = SfiName;
    cell.std_div_label.text = teachershiftstdDiv;
    if([device isEqualToString:@"ipad"]){
        [cell.sectionLabel setFont: [cell.sectionLabel.font fontWithSize: 16.0]];
        [cell.shiftlabel setFont: [cell.shiftlabel.font fontWithSize: 16.0]];
        [cell.std_div_label setFont: [cell.std_div_label.font fontWithSize: 16.0]];
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([device isEqualToString:@"ipad"]){
        return  60;
    }
    else{
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [teacherSectionListarray count];
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TeacherWriteMessageStudentListViewController *teacherWriteMessageStudentListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherStudentList"];
    class_id = [[teacherStandardListArray objectAtIndex:indexPath.row]objectForKey:@"class_id"];
    [[NSUserDefaults standardUserDefaults] setObject:class_id forKey:@"class_Id_TeacherWriteMsg"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController pushViewController:teacherWriteMessageStudentListViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
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