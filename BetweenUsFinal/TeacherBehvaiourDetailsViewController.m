//
//  TeacherBehvaiourDetailsViewController.m
//  BetweenUs
//
//  Created by podar on 17/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "TeacherBehvaiourDetailsViewController.h"
#import "MBProgressHUD.h"
#import "teacherStudBehaviourResult.h"
#import "RestAPI.h"
#import "ViewBehaviourTableViewCell.h"
#import "URL_Constant.h"

@interface TeacherBehvaiourDetailsViewController (){
    NSDictionary *newDatasetinfoTeacherBehaviourDetails,*newDatasetinfoTeacherLogout,*behaviourdetailsdictionry;
    BOOL loginClick;
    ViewBehaviourTableViewCell *cell;
}
@property (nonatomic, strong) teacherStudBehaviourResult *tteacherStudBehaviourResultItems;


@end

@implementation TeacherBehvaiourDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"View Behaviour";
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    DeviceType= @"IOS";
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    selectedMsdId = [[NSUserDefaults standardUserDefaults] stringForKey:@"msdID_Behaviour"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    brd_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];
    
    Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
    
    self.behaviourDetailsTableView.delegate = self;
    self.behaviourDetailsTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;

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
        NSString *urlString = app_url @"PodarApp.svc/TeacherStudBehaviourDtls";
        
        //Pass The String to server
        newDatasetinfoTeacherBehaviourDetails= [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",selectedMsdId,@"msdID",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherBehaviourDetails options:NSJSONWritingPrettyPrinted error:&error];
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
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherBehaviourDetails options:kNilOptions error:&err];
                
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
                    BehaviourDetailsStatus = [parsedJsonArray valueForKey:@"Status"];
                    teacherBehaviourDetailsArray = [receivedData valueForKey:@"teacherStudBehaviourResult"];
                    
                    NSLog(@"Status:%@",BehaviourDetailsStatus);
                    if([BehaviourDetailsStatus isEqualToString:@"1"]){
                          [self.behaviourDetailsTableView setHidden:NO];
                        for(int n = 0; n < [teacherBehaviourDetailsArray  count]; n++){
                            _tteacherStudBehaviourResultItems = [[teacherStudBehaviourResult alloc]init];
                            behaviourdetailsdictionry = [teacherBehaviourDetailsArray objectAtIndex:n];
                        }
                        
                    }
                    else if([BehaviourDetailsStatus isEqualToString:@"0"]){
                        [self.behaviourDetailsTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [self.behaviourDetailsTableView reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [teacherBehaviourDetailsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"ViewBehaviourTableViewCell";
    
    cell = (ViewBehaviourTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ViewBehaviourTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    behaviour = [[teacherBehaviourDetailsArray objectAtIndex:indexPath.row]objectForKey:@"bhr_name"];
    cell.behaviourLabel.text = behaviour;
    date = [[teacherBehaviourDetailsArray objectAtIndex:indexPath.row] objectForKey:@"sbh_date1"];
    behaviourType = [[teacherBehaviourDetailsArray objectAtIndex:indexPath.row]objectForKey:@"bhr_type"];
    if([behaviourType isEqualToString:@"0"]){
        cell.behaviourImg.image=[UIImage imageNamed:@"thumbsup"];
    }
    else {
         cell.behaviourImg.image=[UIImage imageNamed:@"thumbsdown"];
    }
    
    cell.date.text = date;
    if([device isEqualToString:@"ipad"]){
        [cell.date setFont: [cell.date.font fontWithSize: 16.0]];
        [cell.behaviourLabel setFont: [cell.behaviourLabel.font fontWithSize: 16.0]];
     
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
            
            return 80;
        }else if([device isEqualToString:@"iphone"]){
            return 70;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}


@end
