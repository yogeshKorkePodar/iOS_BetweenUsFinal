//
//  TeacherPresentHistoryViewController.m
//  BetweenUs
//
//  Created by podar on 16/11/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherPresentHistoryViewController.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "AbsentHistoryTableViewCell2.h"
#import "URL_Constant.h"

@interface TeacherPresentHistoryViewController ()
{
    NSDictionary *newDatasetinfoTeacherAttendanceHistory;
}
@end

@implementation TeacherPresentHistoryViewController

@synthesize month;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"<<<< Inside TeacherPresentHistoryViewController >>>>");
    
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    
    selectedMsdID = [[NSUserDefaults standardUserDefaults]stringForKey:@"selectedMsdID"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    atn_valid = [[NSUserDefaults standardUserDefaults] stringForKey:@"atn_valid"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    brd_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];
    
    acy_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"acy_id"];
    
    Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
    month = month;
    DeviceType= @"IOS";
    self.TeacherPresentHistoryTableView.dataSource = self;
    self.TeacherPresentHistoryTableView.delegate = self;
    
    [self checkInternetConnectivity];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *urlString = app_url @"ViewStudAttendDetails";
    
    //Pass The String to server
    newDatasetinfoTeacherAttendanceHistory = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",selectedMsdID,@"msdID",month,@"tmonth",atn_valid,@"atn_valid",acy_id,@"Acy_year",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAttendanceHistory options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServer:urlString jsonString:jsonInputString];
}
-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err;
            NSData* responseData = nil;
            NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            responseData = [NSMutableData data] ;
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherAttendanceHistory options:kNilOptions error:&err];
            
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
            if(responseData != nil){
                NSDictionary  *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                AttendanceHistoryStatus = [parsedJsonArray valueForKey:@"Status"];
                attendanceHistoryArray = [receivedData objectForKey:@"ViewStudAttendRes"];
                
                if([AttendanceHistoryStatus isEqualToString:@"1"]){
                    
                }
                else if([AttendanceHistoryStatus isEqualToString:@"0"]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No Records Found" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                [hud hideAnimated:YES];
                [self.TeacherPresentHistoryTableView reloadData];
            }
        });
    });
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        
        return [attendanceHistoryArray count];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    @try {
        static NSString *simpleTableIdentifier = @"AbsentHistoryCell";
        
        AbsentHistoryTableViewCell2 *cell = (AbsentHistoryTableViewCell2 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AbsentHistoryTableViewCell2" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        absentReason = [[attendanceHistoryArray objectAtIndex:indexPath.row] objectForKey:@"atn_Reason"];
        absentDate = [[attendanceHistoryArray objectAtIndex:indexPath.row] objectForKey:@"atn_date"];
        
        dateitems = [absentDate componentsSeparatedByString:@" "];
        date = dateitems[0];
        
        
        NSLog(@"firstdate==%@", date);
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"MM/dd/yyyy";
        
        NSDate *yourDate = [dateFormat dateFromString:date];
        
        NSLog(@"your date%@",yourDate);
        dateFormat.dateFormat = @"dd-MMM-yyyy";
        NSLog(@"formated date%@",[dateFormat stringFromDate:yourDate]);
        formatedDate = [dateFormat stringFromDate:yourDate];
        cell.date_label.text = formatedDate;
        cell.absentReason_textview.text = absentReason;
        cell.seperator_line.hidden = YES;
        
        return cell;
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception: %@", exception);
    }
    
}


@end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


