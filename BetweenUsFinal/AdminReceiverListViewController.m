//
//  AdminReceiverListViewController.m
//  BetweenUs
//
//  Created by podar on 17/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "AdminReceiverListViewController.h"
#import "ViewMessageResult.h"
#import "ReceiverListTableViewCell.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "URL_Constant.h"

@interface AdminReceiverListViewController ()
{
UITapGestureRecognizer *tapGestRecog ;
NSDictionary *newDatasetinfoAdminReceiverList;
BOOL loginClick;
NSArray *nib;

}
@property (nonatomic, strong) ViewMessageResult *ViewMessageItems;
@property (nonatomic, strong) ViewMessageResult *ViewMessageDetails;
@property(nonatomic,strong)   ReceiverListTableViewCell *cell;
@end

@implementation AdminReceiverListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *tableView;
    _cell = (ReceiverListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    
    rol_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Roll_id"];
    
    pmg_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"pmg_Id"];
    
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    
    DeviceType= @"IOS";
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    
    self.navigationItem.title = @"Receiver List";

    self.ReceiverTableView.delegate = self;
    self.ReceiverTableView.dataSource = self;
    [self checkInternetConnectivity];

}

-(void)checkInternetConnectivity{
    // MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatusViewMessage:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    // [hud hideAnimated:YES];
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
    
    NSString *urlString = app_url @"AdminSentMsgReciverList";
    
    //Pass The String to server
    newDatasetinfoAdminReceiverList = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",pmg_Id,@"pmg_id",rol_id,@"rol_id",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminReceiverList options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServer:urlString jsonString:jsonInputString];
}

-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    
    MBProgressHUD   *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err;
            NSData* responseData = nil;
            NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            responseData = [NSMutableData data] ;
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminReceiverList options:kNilOptions error:&err];
            
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
            NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
            
            ReceiverListStatus = [parsedJsonArray valueForKey:@"Status"];
            ViewReceiverTableData = [receivedData objectForKey:@"MsgReciverResult"];
            if([ReceiverListStatus isEqualToString:@"1"]){
                
                
            }
            [_ReceiverTableView reloadData];
            
            [hud hideAnimated:YES];
            
        });
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        
        return [ViewReceiverTableData count];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        // static NSString *simpleTableIdentifier = @"MessageTableViewCell";
        
        _cell = (ReceiverListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (_cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReceiverListTableViewCell" owner:self options:nil];
            _cell = [nib objectAtIndex:0];
            
        }
        
        receiverName = [[ViewReceiverTableData objectAtIndex:indexPath.row] objectForKey:@"Name"];
        Receiver_shift = [[ViewReceiverTableData objectAtIndex:indexPath.row] objectForKey:@"sft_name"];
        receiverSrNo = [[ViewReceiverTableData objectAtIndex:indexPath.row] objectForKey:@"SrNo"];
        receiver_Std = [[ViewReceiverTableData objectAtIndex:indexPath.row] objectForKey:@"std_Name"];
        receiver_divName = [[ViewReceiverTableData objectAtIndex:indexPath.row] objectForKey:@"div_name"];
        
        _cell.receiverName_label.text = receiverName;
        _cell.SrNo_label.text = receiverSrNo;
        
        if([Receiver_shift isEqualToString:@""] ||([receiver_Std isEqualToString:@""]) || ([receiver_divName isEqualToString:@""])){
            
            _cell.std_constraint.constant = 0;
            _class_label_constraint.constant = 0;
            [_class_label setText:@""];
          /*   [_cell.receiverStd_label setHidden:NO];
            [_cell.receiverStd_label removeFromSuperview];
            [_cell.cellView addSubview:_cell.receiverName_label];
            [_top_std_label setHidden:YES];
            [_top_std_label removeFromSuperview];
            [_topView addSubview:_top_name_label];
            _cell.receiverStd_label.backgroundColor =  [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];

           if([device isEqualToString:@"iphone"]){
                [_cell.receiverName_label addConstraint:[NSLayoutConstraint constraintWithItem:_cell.receiverName_label attribute:NSLayoutAttributeWidth
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:nil
                                                                                     attribute: NSLayoutAttributeNotAnAttribute
                                                                                    multiplier:1
                                                                                      constant:300]];
                [ _top_name_label  addConstraint:[NSLayoutConstraint constraintWithItem:_top_name_label attribute:NSLayoutAttributeWidth
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute: NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1
                                                                               constant:300]];
            }
            else if([device isEqualToString:@"ipad"]){
                [_cell.receiverName_label addConstraint:[NSLayoutConstraint constraintWithItem:_cell.receiverName_label attribute:NSLayoutAttributeWidth
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:nil
                                                                                     attribute: NSLayoutAttributeNotAnAttribute
                                                                                    multiplier:1
                                                                                      constant:800]];
                [ _top_name_label  addConstraint:[NSLayoutConstraint constraintWithItem:_top_name_label attribute:NSLayoutAttributeWidth
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute: NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1
                                                                               constant:800]];
                
            } */
        }
        else{
            
            _cell.receiverStd_label.text = [NSString stringWithFormat: @"%@ - %@ -%@ ", Receiver_shift,receiver_Std,receiver_divName];
            
        }
        
        if (indexPath.row % 2 == 0) {
            _cell.receiverStd_label.backgroundColor =  [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
            _cell.receiverName_label.backgroundColor =  [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
            _cell.SrNo_label.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
        }
        else
        {
            _cell.receiverStd_label.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
            _cell.receiverName_label.backgroundColor =[UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
            _cell.SrNo_label.backgroundColor =[UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
        }
        
        return _cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
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
