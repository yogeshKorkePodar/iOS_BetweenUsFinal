//
//  AbsentHistoryViewController.m
//  TestAutoLayout
//
//  Created by podar on 21/07/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "AbsentHistoryViewController.h"
#import "RestAPI.h"
#import "AttendHistory.h"
#import "AbsentHistoryTableViewCell2.h"
#import "MBProgressHUD.h"

@interface AbsentHistoryViewController ()

@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) AttendHistory *AttendHistory_Item;
@end

@implementation AbsentHistoryViewController
@synthesize msd_id,usl_id,brd_Name,schoolName,month,year;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    msd_id = msd_id;
    usl_id = usl_id;
    schoolName = schoolName;
    clt_id = clt_id;
    brd_Name = brd_Name;
    month = month;
    year = year;
    
    msd_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"msd_Id"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    
    schoolName = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"school_name"];
    
    brd_Name = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"brd_name"];
    
    _absentHistory.dataSource = self;
    _absentHistory.delegate = self;
    //_absentHistory.layer.borderWidth = 2.0;
    //_absentHistory.layer.borderColor = [UIColor blackColor].CGColor;
    [self httpPostRequest];
}
-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}

-(void) httpPostRequest{
    //Create the response and Error
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{

        NSError *err;
        NSString *str = app_url @"PodarApp.svc/AttendanceHistory";
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:str];
        
        //Pass The String to server
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:msd_id,@"msd_id",month,@"month",clt_id,@"clt_id",year,@"year",nil];
        NSLog(@"History Details is =%@", newDatasetInfo);
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&err];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:POST];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        //Apply the data to the body
        [request setHTTPBody:jsonData];
        
        self.restApi.delegate = self;
        [self.restApi httpRequest:request];
        NSURLResponse *response;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
        
        //This is for Response
        NSLog(@"got attendanceHistoryresponse==%@", resSrt);
            dispatch_async(dispatch_get_main_queue(), ^{
           
                [hud hideAnimated:YES];
              
            });
        });
    });
    
  }
-(void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender
{
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{

        NSError *error = nil;
        NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
        historyStatus = [parsedJsonArray valueForKey:@"Status"];
        NSLog(@"Status:%@",historyStatus);
        attendanceHistortArray = [receivedData objectForKey:@"AttendHistory"];
        if([historyStatus isEqualToString:@"1"]){
            
            
            for(int n = 0; n < [ attendanceHistortArray count]; n++)
            {
                _AttendHistory_Item= [[AttendHistory alloc]init];
                attendHostprydictonary = [attendanceHistortArray
                                               objectAtIndex:n];
                _AttendHistory_Item.atn_date = [attendHostprydictonary objectForKey:@"atn_date"];
                NSLog(@"date:%@",   _AttendHistory_Item.atn_date);
            }
          
            [_absentHistory reloadData];
                        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
            });
        }
        });
    });
    
  }


- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        
        return [attendanceHistortArray count];
    
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
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
        [cell.absentReason_textview setEditable:NO];
           absentReason = [[attendanceHistortArray objectAtIndex:indexPath.row] objectForKey:@"atn_Reason"];
            absentDate = [[attendanceHistortArray objectAtIndex:indexPath.row] objectForKey:@"atn_date"];
        
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
//        if(indexPath.row == 0){
//        cell.date_label.text = @"Date";
//        cell.absentReason_textview.text = @"Absent Reason";
//        }
        return cell;
    
    } @catch (NSException *exception) {
        
        NSLog(@"Exception: %@", exception);
    }
    
}



@end
