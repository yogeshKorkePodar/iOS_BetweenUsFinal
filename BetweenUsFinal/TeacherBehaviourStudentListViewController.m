//
//  TeacherBehaviourStudentListViewController.m
//  BetweenUs
//
//  Created by podar on 18/11/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherBehaviourStudentListViewController.h"
#import "TeacherBehvaiourDetailsViewController.h"
#import "TeacherBehaviourStudentListTableViewCell.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "teacherBehaviourStudResult.h"
#import "URL_Constant.h"

@interface TeacherBehaviourStudentListViewController ()
{
    NSDictionary *newDatasetinfoTeacherLogout,*newDatasetinfoTeacherBehaviourStudentList,*behaviourstudResultdetailsdictionry;
    BOOL loginClick;
}

@property (nonatomic, strong) teacherBehaviourStudResult *teacherBehaviourStudResultItems;
@end

@implementation TeacherBehaviourStudentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Student List";
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    DeviceType= @"IOS";
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    class_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"class_Id_Behaviour"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    brd_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];
    
    Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
    
    self.teacherBehaviourStudentTableView.delegate = self;
    self.teacherBehaviourStudentTableView.dataSource = self;
    pageNo = @"1";
    pageSize  = @"200";
    if([device isEqualToString:@"ipad"]){
        [_rollNoLabel setFont: [_rollNoLabel.font fontWithSize: 16.0]];
        [_nameLabel setFont: [_nameLabel.font fontWithSize: 16.0]];
        [_actionLabel setFont: [_actionLabel.font fontWithSize: 16.0]];
    }
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
    else{
        NSString *urlString = app_url @"PodarApp.svc/TeacherBehaviourStudList";
    
        //Pass The String to server
        newDatasetinfoTeacherBehaviourStudentList = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",class_id,@"cls_id",pageSize,@"PageSize",pageNo,@"PageNo",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherBehaviourStudentList options:NSJSONWritingPrettyPrinted error:&error];
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
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherBehaviourStudentList options:kNilOptions error:&err];
                
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
                    teacherBehaviourStudentListArray = [receivedData valueForKey:@"teacherBehavioutStudResult"];
                    
                    NSLog(@"Status:%@",BehaviourStatus);
                    if([BehaviourStatus isEqualToString:@"1"]){
                        
                        for(int n = 0; n < [teacherBehaviourStudentListArray  count]; n++){
                            _teacherBehaviourStudResultItems = [[teacherBehaviourStudResult alloc]init];
                            behaviourstudResultdetailsdictionry = [teacherAcademicYearArray objectAtIndex:n];
                        }
                        
                    }
                    else if([BehaviourStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [self.teacherBehaviourStudentTableView reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [teacherBehaviourStudentListArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"TeacherBehaviourStudentListTableViewCell";
    
    TeacherBehaviourStudentListTableViewCell *cell = (TeacherBehaviourStudentListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TeacherBehaviourStudentListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    [cell.viewClick addTarget:self action:@selector(viewBehaviour:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.viewClick.tag = indexPath.row;
    // NSNumber *abc = [NSNumber numberWithInt:_cell.cellCheckBoxClick.tag];
    [cell.viewClick setTag:indexPath.row];
    
    cell.rollNoView.layer.cornerRadius = 5;
    cell.rollNoView.layer.masksToBounds = YES;
    cell.viewClick.layer.cornerRadius = 5;
    cell.viewClick.layer.masksToBounds = YES;
    rollNo = [[teacherBehaviourStudentListArray objectAtIndex:indexPath.row]objectForKey:@"Roll_No"];
    cell.rollNo.text = rollNo;
    NSLog(@"RollNo  %@",rollNo);
    studentName = [[teacherBehaviourStudentListArray objectAtIndex:indexPath.row] objectForKey:@"stu_display"];
    
    cell.studentname.text = studentName;
    if([device isEqualToString:@"ipad"]){
        [cell.rollNo setFont: [cell.rollNo.font fontWithSize: 16.0]];
        [cell.studentname setFont: [cell.studentname.font fontWithSize: 16.0]];
        [cell.viewClick setFont: [cell.viewClick.font fontWithSize: 16.0]];
    }
    
    return cell;
    
}

-(void)viewBehaviour:(id)sender
{
    
    BOOL checked;
    
    UIButton *viewbehaviour=(UIButton*)sender;
    
    selectedMsd_ID = [[teacherBehaviourStudentListArray objectAtIndex:viewbehaviour.tag] objectForKey:@"msd_id"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedMsd_ID forKey:@"msdID_Behaviour"];
    NSLog(@"Selectd smdid  %@",selectedMsd_ID);
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    TeacherBehvaiourDetailsViewController *teacherBehvaiourDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BehaviourDetails"];
    
    
    [self.navigationController pushViewController:teacherBehvaiourDetailsViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
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
