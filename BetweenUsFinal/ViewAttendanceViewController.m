//
//  ViewAttendanceViewController.m
//  BetweenUsFinal
//
//  Created by podar on 18/08/17.
//  Copyright © 2017 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "ViewAttendanceViewController.h"
#import "ViewMessageViewController.h"
#import "LoginViewController.h"
#import "StudentDashboardWithoutSibling.h"
#import "ViewMessageViewController.h"
#import "PaymentInfoViewController.h"
#import "ViewAttendanceViewController.h"
#import "StudentInformationViewController.h"
#import "ChangePassswordViewController.h"
#import "RestAPI.h"
#import "stundentListDetails.h"
#import "CCKFNavDrawer.h"
#import "DrawerView.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AnnouncementViewController.h"
#import "BehaviourViewController.h"
#import "AboutUsViewController.h"
#import "AttendanceTableViewCell.h"
#import "DateDropdownValueDetails.h"
#import "StudentProfileWithSiblingViewController.h"
#import "SiblingStudentViewController.h"
#import "StudentResourcesViewController.h"
#import "AbsentHistoryViewController.h"


static const CGFloat dia = 150.0f;

//static const CGRect kPieChartViewFrame = {{35.0f, 35.0f},{dia, dia}};
static const CGRect kPieChartViewFrame = {{10.0f,50.0f},{dia, dia}};
//static const CGRect kPieChartViewFrame  = {10.0f,20.0f,150.0f,50.0f};
static const CGRect kHoleSliderFrame = {{35.0f, 300.0f},{dia, 20.0}};
static const CGRect kSlicesSliderFrame = {{35.0f, 330.0f},{100.0f, 20.0}};

static const CGRect kHoleLabelFrame = {{0.0f, 300.0f},{35.0, 20.0}};
static const CGRect kValueLabelFrame = {{0.0f, 330.0f},{35.0, 20.0}};

static const NSInteger tHoleLabelTag = 7;
static const NSInteger tValueLabelTag = 77;

float startAngle = - M_PI_2;
float endAngle = 0.0f;
CGFloat theHalf;
CGFloat lineWidth;
AttendanceTableViewCell *cell;
int p;
int a;
int n;



@interface ViewAttendanceViewController ()
<
PieChartViewDelegate,
PieChartViewDataSource
>
{
    PieChartView *pieChartView;
    MBProgressHUD *hud;
    UISlider *holeSlider;
    UISlider *slicesSlider;
    UILabel *holeLabel;
    UILabel *valueLabel;
    NSDictionary *newDatasetInfo;
    BOOL isSection0Cell0Expanded,message,announcement,attendance,behaviour,loginClick,firstTime,firstWebcall,collapse,firstTimeFirstRow;
    UITapGestureRecognizer *tapGestRecog ;
    
    
    CGFloat radius;
    CGFloat centerX;
    CGFloat centerY;
    //  NSString *row;
    //prepare
    CGContextRef context;
}


@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) DateDropdownValueDetails *DateDropdownValueDetails;
@property (nonatomic, strong) DateDropdownValueDetails *DateDropdownItems;


@end

@implementation ViewAttendanceViewController
@synthesize msd_id,clt_id,usl_id,brd_Name,schoolName,HVTableViewDelegate,HVTableViewDataSource;

@synthesize delegate;
@synthesize datasource;

-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    if(item.tag==1)
    {
        NSLog(@"First tab selected");
        ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
        //        ViewMessageViewController.msd_id = msd_id;
        //        ViewMessageViewController.usl_id = usl_id;
        //        ViewMessageViewController.clt_id = clt_id;
        //        ViewMessageViewController.brdName = brd_Name;
        [self.navigationController pushViewController:ViewMessageViewController animated:NO];
        //        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        //
        
    }
    else if(item.tag==2)
        
    {
        NSLog(@"Second tab selected");
        
        AnnouncementViewController *AnnouncementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Announcement"];
        //        AnnouncementViewController.msd_id = msd_id;
        //        AnnouncementViewController.usl_id = usl_id;
        //        AnnouncementViewController.clt_id = clt_id;
        //        AnnouncementViewController.brd_name = brd_Name;
        [self.navigationController pushViewController:AnnouncementViewController animated:NO];
        //        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        
        
    }
    else if(item.tag==3)
        
    {
        NSLog(@"Third tab selected");
        ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
        //        AttendanceViewController.msd_id = msd_id;
        //        AttendanceViewController.usl_id = usl_id;
        //        AttendanceViewController.clt_id = clt_id;
        //        AttendanceViewController.brd_Name = brd_Name;
        [self.navigationController pushViewController:AttendanceViewController animated:NO];
        //        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        
        
    }
    else if(item.tag==4)
        
    {
        NSLog(@"Fourth tab selected");
        BehaviourViewController *BehaviourViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Behaviour"];
        //        BehaviourViewController.msd_id = msd_id;
        //        BehaviourViewController.usl_id = usl_id;
        //        BehaviourViewController.clt_id = clt_id;
        //        BehaviourViewController.brd_name = brd_Name;
        [self.navigationController pushViewController:BehaviourViewController animated:NO];
        //        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_attendanceTable collapseExpandedCells];
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    [_attendanceTable collapseExpandedCells];

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_attendanceTable collapseExpandedCells];

}
- (void)viewDidLoad {
    
    firstWebcall =YES;
    firstTimeFirstRow = YES;
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self checkInternetConnectivity];
    
    
    _my_tabBar.delegate = self;
    _my_tabBar.selectedItem = [_my_tabBar.items objectAtIndex:2];
    isStudentResourcePresent = @"";
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    // Do any additional setup after loading the view.
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"white-menu-icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 25)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    firstTime = YES;
    CGFloat theHalf = 95.0f;
    CGFloat lineWidth = theHalf;
    if ([self.delegate respondsToSelector:@selector(centerCircleRadius)])
    {
        lineWidth -= [self.delegate centerCircleRadius];
        NSAssert(lineWidth <= theHalf, @"wrong circle radius");
    }
    
    
    msd_id = msd_id;
    usl_id = usl_id;
    clt_id = clt_id;
    brd_Name = brd_Name;
    schoolName = schoolName;
    
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
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    brd_Name = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"brd_name"];
    DeviceType= @"IOS";
    
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
    
    
    radius = 40.0f;
    centerX = 50.0f;;
    centerY = 50.0f;
    context = UIGraphicsGetCurrentContext();
    
    NSLog(@"Brd name saved Attendance:%@",brd_Name);
    
    self.attendanceTable.expandOnlyOneCell = TRUE;
    self.attendanceTable.HVTableViewDataSource = self;
    self.attendanceTable.HVTableViewDelegate = self;
    self.attendanceTable.tableFooterView = [UIView new];
    
}

-(void) httpPostRequest{
    //Create the response and Error
    if(firstTime ==YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        firstWebcall = NO;
        firstTime = NO;
              NSString *urlString =app_url @"PodarApp.svc/GetDateDropdownValue";
        newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",msd_id,@"msd_id",brd_Name,@"brd_name",nil];
        NSLog(@"the data Details is =%@", newDatasetInfo);
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        dispatch_async(dispatch_get_main_queue(), ^{
            //                    //  [urlData writeToFile:filePathnew atomically:YES];
            [hud hideAnimated:YES];
            // NSLog(@"File Saved !");
        });
        
    }
    else if(loginClick == YES){
        //   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        loginClick = NO;
        NSError *err;
        NSString *str =app_url @"PodarApp.svc/LogOut";
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:str];
        
        //Pass The String to server
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
        NSLog(@"the data Details is =%@", newDatasetInfo);
        
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
        NSLog(@"got logout==%@", resSrt);
        
        // [hud hideAnimated:YES];
    }
    
}
-(void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender
{
    
}

-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    @try{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&err];
                //   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                [request setHTTPMethod:POST];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                
                //Apply the data to the body
                [request setHTTPBody:jsonData];
                
                // self.restApi.delegate = self;
                //  [self.restApi httpRequest:request];
                NSURLResponse *response;
                
                responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
                
                //This is for Response
                NSLog(@"got got response==%@", resSrt);
                
                
                NSError *error = nil;
                NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
                //   NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:
                                            (NSJSONReadingMutableContainers) error:&error];
                attendanceStatus = [parsedJsonArray valueForKey:@"Status"];
                attendancedetails = [receivedData objectForKey:@"DateDropdownValueDetails"];
                if([attendanceStatus isEqualToString:@"1"]){
                    for(int n = 0; n < [attendancedetails count]; n++)
                    {
                        _DateDropdownItems = [[DateDropdownValueDetails alloc]init];
                        attendancedetailsdictionry = [attendancedetails objectAtIndex:n];
                        _DateDropdownItems.MonthsName =[attendancedetailsdictionry objectForKey:@"MonthsName"];
                        NSLog(@"TelNo:%@",_DateDropdownItems.MonthsName);
                    }
                    
                }
                // [_attendanceTableData reloadData];
                [_attendanceTable reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    
                });
                
            });
        });
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

-(void)checkInternetConnectivity{
    //   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    // [hud hideAnimated:YES];
    
}
-(void) checkNetworkStatus:(NSNotification *)notice
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
        if(firstWebcall == YES){
            firstWebcall = NO;
            [self httpPostRequest];
        }
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}


- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView expandCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
   // selectedIndexPath = indexPath;
   // tempSelectedIndexPath = selectedIndexPath;
   // row = @"";
}

//perform your collapse stuff (may include animation) for cell here. It will be called when the user touches an expanded cell so it gets collapsed or the table is in the expandOnlyOneCell satate and the user touches another item, So the last expanded item has to collapse
-(void)tableView:(UITableView *)tableView collapseCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    
    //if(collapse ==YES){
        
        static NSString *simpleTableIdentifier = @"Cell";
        selectedIndexPath = indexPath;
        AttendanceTableViewCell *cell1 = (AttendanceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        [cell1.absent_textfield setHidden:YES];
        [cell1.presentLabel setHidden:YES];
        [cell1.absentlabel setHidden:YES];
        [cell1.present_textfield setHidden:YES];
        [cell1.notMarkedLabel setHidden:YES];
        [cell1.notMarked_textfield setHidden:YES];
        [cell1.click_absentHistory setHidden:YES];
        
   // }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        return [attendancedetails count];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded
{
    if (isexpanded){
        if(indexPath.row==0){
            return 50;
        }
        
        return 180;
    }
    else if(!isexpanded){
        if(indexPath.row == 0)
            return  180;
        else{
            return 50;
        }
    }
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded{
    static NSString *simpleTableIdentifier = @"Cell";
    
    NSLog(@"$$$ Selected indexPath %ld", (long)indexPath.row);

    
    AttendanceTableViewCell *cell = (AttendanceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttendanceTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (!isExpanded) //prepare the cell as if it was collapsed! (without any animation!)
    {
        
        if((indexPath.row)==0){
            
            NSString *Title= [[attendancedetails objectAtIndex:0] objectForKey:@"MonthYear"];
            cell.monthName.text = Title;
            selectedIndexPath = 0;
            row= @"0";
            NSLog(@"&&&&&& row %@", row);
            cell.click_absentHistory.tag = 0;
            [cell.click_absentHistory addTarget:self action:@selector(absentHistorySelector:) forControlEvents:UIControlEventTouchUpInside];
            [cell.click_absentHistory setTag:indexPath.row];
            year = [[attendancedetails objectAtIndex:cell.click_absentHistory.tag]objectForKey:@"years"];
            month = [[attendancedetails objectAtIndex:cell.click_absentHistory.tag]objectForKey:@"monthid"];
            NSLog(@"<<<< selected month %@", month);
            
            pieChartView = [[PieChartView alloc] initWithFrame:kPieChartViewFrame];
            pieChartView.delegate = self;
            pieChartView.datasource = self;
            [self.view addSubview:pieChartView];
            
            //[pieChartView release];
            
            holeLabel = [self labelWithFrame:kHoleLabelFrame];
            [self.view addSubview:holeLabel];
            
            valueLabel = [self labelWithFrame:kValueLabelFrame];
            [self.view addSubview:valueLabel];
            
            holeSlider = [[UISlider alloc] initWithFrame:kHoleSliderFrame];
            holeSlider.tag = tHoleLabelTag;
            holeSlider.maximumValue = 180/2 - 1;
            int max = holeSlider.maximumValue;
            holeSlider.value = arc4random() % max;
            [self.view addSubview:holeSlider];
            [holeSlider setHidden:YES];
            // [holeSlider release];
            
            slicesSlider = [[UISlider alloc] initWithFrame:kSlicesSliderFrame];
            slicesSlider.tag = tValueLabelTag;
            [slicesSlider addTarget:self action:@selector(didChangeValueForSlider:)
                   forControlEvents:UIControlEventValueChanged];
            
            slicesSlider.value = 3;
            [self.view addSubview:slicesSlider];
            [slicesSlider setHidden:YES];
            [cell addSubview:pieChartView];
            
            present = [[attendancedetails objectAtIndex:0] objectForKey:@"AttnPercent"];
            absent = [[attendancedetails objectAtIndex:0] objectForKey:@"Abper"];
            int p= [ present integerValue];
            int a = [absent integerValue];
            
            
            // cell.click_absentHistory.tag = indexPath.row;
            
            if([present isEqualToString:@"100"]){
                
                n = 0;
                [[NSUserDefaults standardUserDefaults] setInteger:p forKey:@"PresentFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:a forKey:@"AbsentFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:n forKey:@"Not MarkedFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                cell.presentLabel.text = [NSString stringWithFormat: @"%@ %@",present, @" % Present"];
                cell.absentlabel.text =[NSString stringWithFormat: @"%@ %@",@"0", @"% Absent"];
                [cell.presentLabel setHidden:NO];
                [cell.present_textfield setHidden:NO];
                [cell.absentlabel setHidden:NO];
                [cell.absent_textfield setHidden:NO];
                [cell.notMarkedLabel setHidden:YES];
                [cell.notMarked_textfield setHidden:YES];
                [cell.click_absentHistory setHidden:YES];
                
            }
            else if(([present isEqualToString:@""])&& ([absent isEqualToString:@"0"])){
                cell.notMarkedLabel.text = @"Not Marked";
                slicesSlider.value = 1;
                n=100;
                [[NSUserDefaults standardUserDefaults] setInteger:p forKey:@"PresentFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:a forKey:@"AbsentFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:n forKey:@"Not MarkedFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [cell.notMarkedLabel setHidden:NO];
                [cell.notMarked_textfield setHidden:NO];
                [cell.presentLabel setHidden:YES];
                [cell.present_textfield setHidden:YES];
                [cell.absentlabel setHidden:YES];
                [cell.absent_textfield setHidden:YES];
                [cell.click_absentHistory setHidden:YES];
                
            }
            else if(([present isEqualToString:@""]) && (![absent isEqualToString:@"0"])){
                present = [[attendancedetails objectAtIndex:0] objectForKey:@"AttnPercent"];
                absent = [[attendancedetails objectAtIndex:0] objectForKey:@"Abper"];
                cell.presentLabel.text = [NSString stringWithFormat: @"%@ %@",@"0", @"% Present"];
                cell.absentlabel.text =[NSString stringWithFormat: @"%@ %@",absent, @"% Absent"];
                int p= [ present integerValue];
                int a = [absent integerValue];
                int n = 100-(p+a);
                
                [[NSUserDefaults standardUserDefaults] setInteger:p forKey:@"PresentFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:a forKey:@"AbsentFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:n forKey:@"Not MarkedFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                notmarked = [@(n) stringValue];
                cell.notMarkedLabel.text =[NSString stringWithFormat: @"%@ %@",notmarked, @"% Not Marked"];
                
                [cell.notMarkedLabel setHidden:NO];
                [cell.notMarked_textfield setHidden:NO];
                [cell.click_absentHistory setHidden:NO];
                [cell.absent_textfield setHidden:NO];
                [cell.absentlabel setHidden:NO];
                [cell.present_textfield setHidden:NO];
                [cell.presentLabel setHidden:NO];
            }
            
            else if(p <100){
                present = [[attendancedetails objectAtIndex:0] objectForKey:@"AttnPercent"];
                absent = [[attendancedetails objectAtIndex:0] objectForKey:@"Abper"];
                cell.presentLabel.text = [NSString stringWithFormat: @"%@ %@",present, @"% Present"];
                cell.absentlabel.text =[NSString stringWithFormat: @"%@ %@",absent, @"% Absent"];
                p= [ present integerValue];
                a = [absent integerValue];
                n = 100-(p+a);
                [[NSUserDefaults standardUserDefaults] setInteger:p forKey:@"PresentFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:a forKey:@"AbsentFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:n forKey:@"Not MarkedFirstRow"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                notmarked = [@(n) stringValue];
                cell.notMarkedLabel.text =[NSString stringWithFormat: @"%@ %@",notmarked, @"% Not Marked"];
                
                [cell.notMarkedLabel setHidden:NO];
                [cell.notMarked_textfield setHidden:NO];
                [cell.click_absentHistory setHidden:NO];
                [cell.absent_textfield setHidden:NO];
                [cell.absentlabel setHidden:NO];
                [cell.present_textfield setHidden:NO];
                [cell.presentLabel setHidden:NO];
                
            }
            
            
            if([absent isEqualToString:@"0"]){
                [cell.click_absentHistory setHidden:YES];
            }
            
        }
        
        
        else{
           [_attendanceTable collapseCellAtIndexPath:0];
            row=@"0";
            NSString *Title= [[attendancedetails objectAtIndex:indexPath.row] objectForKey:@"MonthYear"];
            cell.monthName.text = Title;
            selectedIndexPath = indexPath;
            
            cell.click_absentHistory.tag = indexPath.row;
            [cell.click_absentHistory addTarget:self action:@selector(absentHistorySelector:) forControlEvents:UIControlEventTouchUpInside];
            [cell.click_absentHistory setTag:indexPath.row];
            year = [[attendancedetails objectAtIndex:cell.click_absentHistory.tag]objectForKey:@"years"];
            month = [[attendancedetails objectAtIndex:cell.click_absentHistory.tag]objectForKey:@"monthid"];
            NSLog(@"++++++ selected month %@", month);
            
            pieChartView = [[PieChartView alloc] initWithFrame:kPieChartViewFrame];
            pieChartView.delegate = self;
            pieChartView.datasource = self;
            [self.view addSubview:pieChartView];
            
            //[pieChartView release];
            
            holeLabel = [self labelWithFrame:kHoleLabelFrame];
            [self.view addSubview:holeLabel];
            
            valueLabel = [self labelWithFrame:kValueLabelFrame];
            [self.view addSubview:valueLabel];
            
            holeSlider = [[UISlider alloc] initWithFrame:kHoleSliderFrame];
            holeSlider.tag = tHoleLabelTag;
            holeSlider.maximumValue = 180/2 - 1;
            int max = holeSlider.maximumValue;
            holeSlider.value = arc4random() % max;
            [self.view addSubview:holeSlider];
            [holeSlider setHidden:YES];
            // [holeSlider release];
            
            slicesSlider = [[UISlider alloc] initWithFrame:kSlicesSliderFrame];
            slicesSlider.tag = tValueLabelTag;
            [slicesSlider addTarget:self action:@selector(didChangeValueForSlider:)
                   forControlEvents:UIControlEventValueChanged];
            
            slicesSlider.value = 3;
            [self.view addSubview:slicesSlider];
            [slicesSlider setHidden:YES];
            [cell addSubview:pieChartView];
            
            present = [[attendancedetails objectAtIndex:indexPath.row] objectForKey:@"AttnPercent"];
            absent = [[attendancedetails objectAtIndex:indexPath.row] objectForKey:@"Abper"];
            int p= [ present integerValue];
            int a = [absent integerValue];
            
            
            // cell.click_absentHistory.tag = indexPath.row;
            
            if([present isEqualToString:@"100"]){
                
                n = 0;
                [[NSUserDefaults standardUserDefaults] setInteger:p forKey:@"Present"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:a forKey:@"Absent"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:n forKey:@"Not Marked"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                cell.presentLabel.text = [NSString stringWithFormat: @"%@ %@",present, @" % Present"];
                cell.absentlabel.text =[NSString stringWithFormat: @"%@ %@",@"0", @"% Absent"];
                [cell.presentLabel setHidden:NO];
                [cell.present_textfield setHidden:NO];
                [cell.absentlabel setHidden:NO];
                [cell.absent_textfield setHidden:NO];
                [cell.notMarkedLabel setHidden:YES];
                [cell.notMarked_textfield setHidden:YES];
                [cell.click_absentHistory setHidden:YES];
            }
            else if(([present isEqualToString:@""])&& ([absent isEqualToString:@"0"])){
                cell.notMarkedLabel.text = @"Not Marked";
                slicesSlider.value = 1;
                n=100-(p+a);
                [[NSUserDefaults standardUserDefaults] setInteger:p forKey:@"Present"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:a forKey:@"Absent"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:n forKey:@"Not Marked"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [cell.notMarkedLabel setHidden:NO];
                [cell.notMarked_textfield setHidden:NO];
                [cell.presentLabel setHidden:YES];
                [cell.present_textfield setHidden:YES];
                [cell.absentlabel setHidden:YES];
                [cell.absent_textfield setHidden:YES];
                [cell.click_absentHistory setHidden:YES];
                
            }
            else if(([present isEqualToString:@""]) && (![absent isEqualToString:@"0"])){
                present = [[attendancedetails objectAtIndex:indexPath.row] objectForKey:@"AttnPercent"];
                absent = [[attendancedetails objectAtIndex:indexPath.row] objectForKey:@"Abper"];
                cell.presentLabel.text = [NSString stringWithFormat: @"%@ %@",@"0", @"% Present"];
                cell.absentlabel.text =[NSString stringWithFormat: @"%@ %@",absent, @"% Absent"];
                int p= [ present integerValue];
                int a = [absent integerValue];
                int n = 100-(p+a);
                
                [[NSUserDefaults standardUserDefaults] setInteger:p forKey:@"Present"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:a forKey:@"Absent"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:n forKey:@"Not Marked"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                notmarked = [@(n) stringValue];
                cell.notMarkedLabel.text =[NSString stringWithFormat: @"%@ %@",notmarked, @"% Not Marked"];
                
                [cell.notMarkedLabel setHidden:NO];
                [cell.notMarked_textfield setHidden:NO];
                [cell.click_absentHistory setHidden:NO];
                [cell.absent_textfield setHidden:NO];
                [cell.absentlabel setHidden:NO];
                [cell.present_textfield setHidden:NO];
                [cell.presentLabel setHidden:NO];
            }
            
            else if(p <100){
                present = [[attendancedetails objectAtIndex:indexPath.row] objectForKey:@"AttnPercent"];
                absent = [[attendancedetails objectAtIndex:indexPath.row] objectForKey:@"Abper"];
                cell.presentLabel.text = [NSString stringWithFormat: @"%@ %@",present, @"% Present"];
                cell.absentlabel.text =[NSString stringWithFormat: @"%@ %@",absent, @"% Absent"];
                p= [ present integerValue];
                a = [absent integerValue];
                n = 100-(p+a);
                [[NSUserDefaults standardUserDefaults] setInteger:p forKey:@"Present"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:a forKey:@"Absent"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setInteger:n forKey:@"Not Marked"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                notmarked = [@(n) stringValue];
                cell.notMarkedLabel.text =[NSString stringWithFormat: @"%@ %@",notmarked, @"% Not Marked"];
                
                [cell.notMarkedLabel setHidden:NO];
                [cell.notMarked_textfield setHidden:NO];
                [cell.click_absentHistory setHidden:NO];
                [cell.absent_textfield setHidden:NO];
                [cell.absentlabel setHidden:NO];
                [cell.present_textfield setHidden:NO];
                [cell.presentLabel setHidden:NO];
                

                
            }
            
            
            if([absent isEqualToString:@"0"]){
                [cell.click_absentHistory setHidden:YES];
            }
            

        }
    }
    
    else ///prepare the cell as if it was expanded! (without any animation!)
    {

        row=@"";
    }
    
    return cell;
    
}

//-(void) absentHistorySelector{

-(void)absentHistorySelector:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    int row = btn.tag;
    month = [[attendancedetails objectAtIndex:row] objectForKey:@"monthid"];
    year = [[attendancedetails objectAtIndex:row]objectForKey:@"years"];
    NSLog(@"month: %@", month);
    
    AbsentHistoryViewController *AbsentHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AbsentHistory"];
    
    AbsentHistoryViewController.msd_id = msd_id;
    AbsentHistoryViewController.usl_id = usl_id;
    AbsentHistoryViewController.clt_id = clt_id;
    AbsentHistoryViewController.brd_Name = brd_Name;
    AbsentHistoryViewController.month = month;
    AbsentHistoryViewController.year = year;
    
    NSLog(@"History button clicked: %@", @"History button clicked:");
    
    [self.navigationController pushViewController:AbsentHistoryViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.click_absentHistory.tag = indexPath.row;
    year = [[attendancedetails objectAtIndex:cell.click_absentHistory.tag]objectForKey:@"years"];
    month = [[attendancedetails objectAtIndex:cell.click_absentHistory.tag]objectForKey:@"monthid"];
    
    [cell.click_absentHistory addTarget:self action:@selector(absentHistorySelector) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSLog(@"------selected month %@", month);
    
    NSLog(@"Row Selected %@", @"Row Selected");
    
}


- (UILabel*)labelWithFrame:(CGRect)frame
{
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:frame];
    resultLabel.backgroundColor = [UIColor clearColor];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.textColor = [UIColor blackColor];
    resultLabel.font = [UIFont systemFontOfSize:15.0f];
    resultLabel.shadowOffset = (CGSize){2,1};
    resultLabel.shadowColor = [UIColor lightGrayColor];
    return resultLabel;
}


-(void)didChangeValueForSlider:(UISlider*)slider
{
    if (slider.tag == tValueLabelTag) valueLabel.text = [NSString stringWithFormat:@"%.0f",slider.value];
    if (slider.tag == tHoleLabelTag) holeLabel.text = [NSString stringWithFormat:@"%.0f",slider.value];
    [pieChartView reloadData];
}

#pragma mark -    PieChartViewDelegate
-(CGFloat)centerCircleRadius
{
    return 160/2 - 1;
}
#pragma mark - PieChartViewDataSource
-(int)numberOfSlicesInPieChartView:(PieChartView *)pieChartView
{
    return 3;
}
-(UIColor *)pieChartView:(PieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index
{
    // return GetRandomUIColor();
    
    @try {
        if(index == 0){
            
            UIColor * color = [UIColor redColor] ;
            
            return color;
            //  return  GetRandomUIColor();
        }
        else if(index ==1){
            UIColor * color = [UIColor orangeColor];
            return color;
        }
        else if(index == 2){
            UIColor * color = [UIColor yellowColor];
            return color;
            //  [self pieChartView:(PieChartView *)pieChartView  valueForSliceAtIndex:(NSUInteger)index];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
        
    }
}

-(double)pieChartView:(PieChartView *)pieChartView valueForSliceAtIndex:(NSUInteger)index
{
    if([row isEqualToString:@"0"]){
        //  row = @"";
        p = [[NSUserDefaults standardUserDefaults]
             integerForKey:@"PresentFirstRow"];
        n = [[NSUserDefaults standardUserDefaults]
             integerForKey:@"Not MarkedFirstRow"];
        a = [[NSUserDefaults standardUserDefaults]
             integerForKey:@"AbsentFirstRow"];
        
        values = [[NSMutableArray alloc] init];
        
        [values addObject:[NSNumber numberWithInt:p]];
        [values addObject:[NSNumber numberWithInt:a]];
        [values addObject:[NSNumber numberWithInt:n]];
        
        return [[values objectAtIndex:index] floatValue];
    }
    
    
    else    if([row isEqualToString:@""]){
        p = [[NSUserDefaults standardUserDefaults]
             integerForKey:@"Present"];
        n = [[NSUserDefaults standardUserDefaults]
             integerForKey:@"Not Marked"];
        a = [[NSUserDefaults standardUserDefaults]
             integerForKey:@"Absent"];
        
        values = [[NSMutableArray alloc] init];
        
        [values addObject:[NSNumber numberWithInt:p]];
        [values addObject:[NSNumber numberWithInt:a]];
        [values addObject:[NSNumber numberWithInt:n]];
    }
    return [[values objectAtIndex:index] floatValue];
    
}


-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
    
    LoginArrayCount = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"LoginUserCount"];
    if (![LoginArrayCount isEqualToString:@"1"]) {
        // SiblingProfile
        if([isStudentResourcePresent isEqualToString:@"0"]){
            if(selectionIndex == 0){
                
                StudentProfileWithSiblingViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SiblingProfile"];
                secondViewController.msd_id = msd_id;
                secondViewController.usl_id = usl_id;
                secondViewController.clt_id = clt_id;
                [self.navigationController pushViewController:secondViewController animated:YES];
                
            }
            else if(selectionIndex ==1){
                SiblingStudentViewController *SiblingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Sibling"];
                SiblingViewController.msd_id = msd_id;
                SiblingViewController.usl_id = usl_id;
                SiblingViewController.clt_id = clt_id;
                //yocomment
                SiblingViewController.schoolName = schoolName;
                [self.navigationController pushViewController:SiblingViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
            }
            else if(selectionIndex == 2){
                ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
                ViewMessageViewController.msd_id = msd_id;
                ViewMessageViewController.usl_id = usl_id;
                ViewMessageViewController.clt_id = clt_id;
                //yocomment
                //ViewMessageViewController.brdName = brdName;
                //        NSLog(@"msdid", msd_id);
                [self.navigationController pushViewController:ViewMessageViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 3){
                PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
                PaymentInfoViewController.msd_id = msd_id;
                PaymentInfoViewController.clt_id = clt_id;
                [self.navigationController pushViewController:PaymentInfoViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 4){
                StudentResourcesViewController *StudentResourceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentResource"];
                //                StudentResourceViewController.msd_id = msd_id;
                //                StudentResourceViewController.usl_id = usl_id;
                //                StudentResourceViewController.clt_id = clt_id;
                //                StudentResourceViewController.brdName = brdName;
                
                [self.navigationController pushViewController:StudentResourceViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 5){
                ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
                AttendanceViewController.msd_id = msd_id;
                AttendanceViewController.usl_id = usl_id;
                AttendanceViewController.clt_id = clt_id;
                //yocomment
                //  AttendanceViewController.brd_Name = brdName;
                [self.navigationController pushViewController:AttendanceViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 6){
                StudentInformationViewController *StudentInformationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformation"];
                StudentInformationViewController.msd_id = msd_id;
                //        secondViewController.usl_id = usl_id;
                //        secondViewController.clt_id = clt_id;
                //        secondViewController.name = name;
                //        secondViewController.school_name = school_name;
                //        secondViewController.teacherAnnouncementCount = teacher_announcementCount;
                [self.navigationController pushViewController:StudentInformationViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
            }
            
            else if(selectionIndex == 7){
                ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
                ChangePasswordViewController.msd_id = msd_id;
                ChangePasswordViewController.clt_id = clt_id;
                ChangePasswordViewController.usl_id = usl_id;
                //yocomment
                // ChangePasswordViewController.brd_Name = brdName;
                [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
                
            }
            else if(selectionIndex == 8){
                loginClick = YES;
                //yocomment
                //ViewMessageStatus =@"1";
                [self httpPostRequest];
                
                LoginViewController *LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
                [self.navigationController pushViewController:LoginViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 9){
                
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
                
                //            AboutUsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //            controller.view.frame=CGRectMake(50,250,300,230);
                //            controller.msd_id = msd_id;
                //            controller.usl_id = usl_id;
                //            controller.brd_Name = brdName;
                //            controller.clt_id = clt_id;
                //            controller.schoolName = school_name;
                //
                //            [self.view addSubview:controller.view];
                //            //[controller.view.center ]
                //            controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
                //                                                 self.view.frame.size.height / 2);
                //            AboutUsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //            //   controller.view.frame=CGRectMake(50,250,300,230);
                //            controller.msd_id = msd_id;
                //            controller.usl_id = usl_id;
                //            controller.brd_Name = brdName;
                //            controller.clt_id = clt_id;
                //
                //            //      [self.view addSubview:controller.view];
                //            //[controller.view.center ]
                //            //  controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
                //            //                                         self.view.frame.size.height / 2);
                //
                //            [self.navigationController pushViewController:controller animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
                //yocomment
                //                if (settingsPopoverController == nil)
                //                {
                //                    AboutUsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //                    settingsViewController.preferredContentSize = CGSizeMake(320, 300);
                //
                //                    settingsViewController.title = @"AboutUs";
                //
                //                    // [settingsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)]];
                //
                //                    //     [settingsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
                //
                //                    settingsViewController.modalInPopover = NO;
                //
                //                    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
                //
                //                    settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
                //                    settingsPopoverController.delegate = self;
                //                    //  settingsPopoverController.passthroughViews = @[btn];
                //                    settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
                //                    settingsPopoverController.wantsDefaultContentAppearance = NO;
                //
                //
                //                    [settingsPopoverController presentPopoverAsDialogAnimated:YES
                //                                                                      options:WYPopoverAnimationOptionFadeWithScale];
                //
                //
                //
                //                }
                //yocomment
                
            }
        }
        else if([isStudentResourcePresent isEqualToString:@""]){
            if(selectionIndex == 0){
                
                StudentProfileWithSiblingViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SiblingProfile"];
                secondViewController.msd_id = msd_id;
                secondViewController.usl_id = usl_id;
                secondViewController.clt_id = clt_id;
                [self.navigationController pushViewController:secondViewController animated:YES];
                
            }
            else if(selectionIndex ==1){
                SiblingStudentViewController *SiblingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Sibling"];
                SiblingViewController.msd_id = msd_id;
                SiblingViewController.usl_id = usl_id;
                SiblingViewController.clt_id = clt_id;
                //yocomment
                //  SiblingViewController.schoolName = school_name;
                [self.navigationController pushViewController:SiblingViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
            }
            else if(selectionIndex == 2){
                ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
                ViewMessageViewController.msd_id = msd_id;
                ViewMessageViewController.usl_id = usl_id;
                ViewMessageViewController.clt_id = clt_id;
                //yocomment
                // ViewMessageViewController.brdName = brdName;
                //        NSLog(@"msdid", msd_id);
                [self.navigationController pushViewController:ViewMessageViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 3){
                PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
                PaymentInfoViewController.msd_id = msd_id;
                PaymentInfoViewController.clt_id = clt_id;
                [self.navigationController pushViewController:PaymentInfoViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 4){
                ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
                AttendanceViewController.msd_id = msd_id;
                AttendanceViewController.usl_id = usl_id;
                AttendanceViewController.clt_id = clt_id;
                //yocomment
                //AttendanceViewController.brd_Name = brdName;
                [self.navigationController pushViewController:AttendanceViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 5){
                StudentInformationViewController *StudentInformationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformation"];
                StudentInformationViewController.msd_id = msd_id;
                //        secondViewController.usl_id = usl_id;
                //        secondViewController.clt_id = clt_id;
                //        secondViewController.name = name;
                //        secondViewController.school_name = school_name;
                //        secondViewController.teacherAnnouncementCount = teacher_announcementCount;
                [self.navigationController pushViewController:StudentInformationViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
            }
            else if(selectionIndex == 6){
                ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
                ChangePasswordViewController.msd_id = msd_id;
                ChangePasswordViewController.clt_id = clt_id;
                ChangePasswordViewController.usl_id = usl_id;
                //yocomment
                // ChangePasswordViewController.brd_Name = brdName;
                [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
                
            }
            else if(selectionIndex == 7){
                loginClick = YES;
                //yocomment
                // ViewMessageStatus =@"1";
                
                [self httpPostRequest];
                
                LoginViewController *LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
                [self.navigationController pushViewController:LoginViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 8){
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
                
                //            AboutUsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //            controller.view.frame=CGRectMake(50,250,300,230);
                //            controller.msd_id = msd_id;
                //            controller.usl_id = usl_id;
                //            controller.brd_Name = brdName;
                //            controller.clt_id = clt_id;
                //            controller.schoolName = school_name;
                //
                //            [self.view addSubview:controller.view];
                //            //[controller.view.center ]
                //            controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
                //                                                 self.view.frame.size.height / 2);
                //                AboutUsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //                //   controller.view.frame=CGRectMake(50,250,300,230);
                //                controller.msd_id = msd_id;
                //                controller.usl_id = usl_id;
                //                controller.brd_Name = brdName;
                //                controller.clt_id = clt_id;
                //
                //                //      [self.view addSubview:controller.view];
                //                //[controller.view.center ]
                //                //  controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
                //                //                                         self.view.frame.size.height / 2);
                //
                //                [self.navigationController pushViewController:controller animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                //yocomment
                //                if (settingsPopoverController == nil)
                //                {
                //                    AboutUsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //                    settingsViewController.preferredContentSize = CGSizeMake(320, 300);
                //
                //                    settingsViewController.title = @"AboutUs";
                //
                //                    // [settingsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)]];
                //
                //                    //     [settingsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
                //
                //                    settingsViewController.modalInPopover = NO;
                //
                //                    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
                //
                //                    settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
                //                    settingsPopoverController.delegate = self;
                //                    //  settingsPopoverController.passthroughViews = @[btn];
                //                    settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
                //                    settingsPopoverController.wantsDefaultContentAppearance = NO;
                //
                //
                //                    [settingsPopoverController presentPopoverAsDialogAnimated:YES
                //                                                                      options:WYPopoverAnimationOptionFadeWithScale];
                //
                //
                //
                //                }
                //yocomment
                
            }
            
            
        }
    }
    else if([LoginArrayCount isEqualToString:@"1"]){
        NSLog(@"LoginArrayCount %@", LoginArrayCount);
        NSLog(@"Without sibling");
        if([isStudentResourcePresent isEqualToString:@"0"]) {
            NSLog(@"isStudentResourcePresent %@", isStudentResourcePresent );
            NSLog(@"With student resources");
            if(selectionIndex == 0){
                
                StudentDashboardWithoutSibling *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentDashboardWithoutSibling"];
                //            secondViewController.msd_id = msd_id;
                //            secondViewController.usl_id = usl_id;
                //            secondViewController.clt_id = clt_id;
                //            secondViewController.name = name;
                //            secondViewController.school_name = school_name;
                //            secondViewController.teacherAnnouncementCount = teacherAnnouncementCount;
                [self.navigationController pushViewController:secondViewController animated:YES];
            }
            else if(selectionIndex == 1){
                ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
                //            ViewMessageViewController.msd_id = msd_id;
                //            ViewMessageViewController.usl_id = usl_id;
                //            ViewMessageViewController.clt_id = clt_id;
                //            ViewMessageViewController.brdName = brd_name;
                //            ViewMessageViewController.stdName = _std;
                //            NSLog(@"msdid", msd_id);
                [self.navigationController pushViewController:ViewMessageViewController animated:YES];
                //            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 2){
                PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
                //            PaymentInfoViewController.msd_id = msd_id;
                //            PaymentInfoViewController.clt_id = clt_id;
                [self.navigationController pushViewController:PaymentInfoViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 3){
                StudentResourcesViewController *StudentResourceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentResource"];
                //            StudentResourceViewController.msd_id = msd_id;
                //            StudentResourceViewController.usl_id = usl_id;
                //            StudentResourceViewController.clt_id = clt_id;
                //            StudentResourceViewController.brdName = brd_name;
                //            StudentResourceViewController.stdName = _std;
                [self.navigationController pushViewController:StudentResourceViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            
            else if(selectionIndex == 4){
                ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
                //            AttendanceViewController.msd_id = msd_id;
                //            AttendanceViewController.usl_id = usl_id;
                //            AttendanceViewController.clt_id = clt_id;
                //            AttendanceViewController.brd_Name = brd_name;
                [self.navigationController pushViewController:AttendanceViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 5){
                StudentInformationViewController *StudentInformationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformation"];
                //StudentInformationViewController.msd_id = msd_id;
                //        secondViewController.usl_id = usl_id;
                //        secondViewController.clt_id = clt_id;
                //        secondViewController.name = name;
                //        secondViewController.school_name = school_name;
                //        secondViewController.teacherAnnouncementCount = teacher_announcementCount;
                [self.navigationController pushViewController:StudentInformationViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
            }
            else if(selectionIndex == 6){
                ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
                //            ChangePasswordViewController.msd_id = msd_id;
                //            ChangePasswordViewController.clt_id = clt_id;
                //            ChangePasswordViewController.usl_id = usl_id;
                //            ChangePasswordViewController.brd_Name = brd_name;
                [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
                
            }
            else if(selectionIndex == 7){
                loginClick = YES;
                _Status = @"0";
                [self httpPostRequest];
                LoginViewController *LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
                [self.navigationController pushViewController:LoginViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 8){
                
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
                
                //       controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //     //   controller = [[AboutUsViewController alloc] init];
                //   //     controller.view.frame=CGRectMake(50,250,300,230);
                //        controller.msd_id = msd_id;
                //        controller.usl_id = usl_id;
                //        controller.brd_Name = brd_name;
                //        controller.clt_id = clt_id;
                //        controller.schoolName = school_name;
                //
                //     //   [self.view addSubview:controller.view];
                //        //[controller.view.center ]
                //      //  controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
                //                                 //        self.view.frame.size.height / 2);
                //
                //   //     [_closeClick addTarget:self action:@selector(dismissPopup:) forControlEvents:UIControlEventTouchUpInside];
                //      //  [controller.closeClick addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
                //        [self.navigationController pushViewController:controller animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                //
                
                //            if (settingsPopoverController == nil)
                {
                    //                AboutUsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                    //                settingsViewController.preferredContentSize = CGSizeMake(320, 300);
                    //
                    //                settingsViewController.title = @"AboutUs";
                    //
                    //                // [settingsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)]];
                    //
                    //                //     [settingsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
                    //
                    //                settingsViewController.modalInPopover = NO;
                    //
                    //                UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
                    //
                    //                settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
                    //                settingsPopoverController.delegate = self;
                    //                //  settingsPopoverController.passthroughViews = @[btn];
                    //                settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
                    //                settingsPopoverController.wantsDefaultContentAppearance = NO;
                    //
                    //
                    //                [settingsPopoverController presentPopoverAsDialogAnimated:YES
                    //                                                                  options:WYPopoverAnimationOptionFadeWithScale];
                }
                
            }
        }
        else{
            NSLog(@"Without student resources");
            if(selectionIndex == 0){
                
                StudentDashboardWithoutSibling *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentDashboardWithoutSibling"];
                //            secondViewController.msd_id = msd_id;
                //            secondViewController.usl_id = usl_id;
                //            secondViewController.clt_id = clt_id;
                //            secondViewController.name = name;
                //            secondViewController.school_name = school_name;
                //            secondViewController.teacherAnnouncementCount = teacherAnnouncementCount;
                [self.navigationController pushViewController:secondViewController animated:YES];
            }
            else if(selectionIndex == 1){
                ViewMessageViewController *ViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
                //            ViewMessageViewController.msd_id = msd_id;
                //            ViewMessageViewController.usl_id = usl_id;
                //            ViewMessageViewController.clt_id = clt_id;
                //            ViewMessageViewController.brdName = brd_name;
                //            ViewMessageViewController.stdName = _std;
                //            NSLog(@"msdid", msd_id);
                [self.navigationController pushViewController :ViewMessageViewController animated:YES];
                //            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
                //            ViewMessageViewController *navigationTabController = [self.storyboard instantiateViewControllerWithIdentifier:@"tab_controller"];
                //
                //            [ self presentModalViewController:navigationTabController animated:YES];
                
            }
            else if(selectionIndex == 2){
                PaymentInfoViewController *PaymentInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentInformation"];
                //            PaymentInfoViewController.msd_id = msd_id;
                //            PaymentInfoViewController.clt_id = clt_id;
                [self.navigationController pushViewController:PaymentInfoViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 3){
                ViewAttendanceViewController *AttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Attendance"];
                //            AttendanceViewController.msd_id = msd_id;
                //            AttendanceViewController.usl_id = usl_id;
                //            AttendanceViewController.clt_id = clt_id;
                //            AttendanceViewController.brd_Name = brd_name;
                [self.navigationController pushViewController:AttendanceViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 4){
                StudentInformationViewController *StudentInformationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformation"];
                //            StudentInformationViewController.msd_id = msd_id;
                //        secondViewController.usl_id = usl_id;
                //        secondViewController.clt_id = clt_id;
                //        secondViewController.name = name;
                //        secondViewController.school_name = school_name;
                //        secondViewController.teacherAnnouncementCount = teacher_announcementCount;
                [self.navigationController pushViewController:StudentInformationViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 5){
                ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
                //            ChangePasswordViewController.msd_id = msd_id;
                //            ChangePasswordViewController.clt_id = clt_id;
                //            ChangePasswordViewController.usl_id = usl_id;
                //            ChangePasswordViewController.brd_Name = brd_name;
                [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
                
            }
            else if(selectionIndex == 6){
                loginClick = YES;
                _Status = @"0";
                [self httpPostRequest];
                LoginViewController *LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
                [self.navigationController pushViewController:LoginViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            }
            else if(selectionIndex == 7){
                
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
                
                
                //            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //            //   controller = [[AboutUsViewController alloc] init];
                //            //     controller.view.frame=CGRectMake(50,250,300,230);
                //            controller.msd_id = msd_id;
                //            controller.usl_id = usl_id;
                //            controller.brd_Name = brd_name;
                //            controller.clt_id = clt_id;
                //            controller.schoolName = school_name;
                //
                //            //   [self.view addSubview:controller.view];
                //            //[controller.view.center ]
                //            //  controller.view.center = CGPointMake(self.view.frame.size.width  / 2,
                //            //        self.view.frame.size.height / 2);
                //
                //            //     [_closeClick addTarget:self action:@selector(dismissPopup:) forControlEvents:UIControlEventTouchUpInside];
                //            //  [controller.closeClick addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
                //            [self.navigationController pushViewController:controller animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                //
                //if (settingsPopoverController == nil)
                //            {
                //                AboutUsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
                //                settingsViewController.preferredContentSize = CGSizeMake(320, 300);
                //
                //                settingsViewController.title = @"AboutUs";
                //
                //                // [settingsViewController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)]];
                //
                //                //     [settingsViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
                //
                //                settingsViewController.modalInPopover = NO;
                //
                //                UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
                //
                //                settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
                //                settingsPopoverController.delegate = self;
                //                //  settingsPopoverController.passthroughViews = @[btn];
                //                settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
                //                settingsPopoverController.wantsDefaultContentAppearance = NO;
                //
                //
                //                [settingsPopoverController presentPopoverAsDialogAnimated:YES
                //                                                                  options:WYPopoverAnimationOptionFadeWithScale];
                //
                //
                //            }
            }
            
            
        }
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
