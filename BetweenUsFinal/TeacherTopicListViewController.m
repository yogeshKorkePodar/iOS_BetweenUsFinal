//
//  TeacherTopicListViewController.m
//  BetweenUs
//
//  Created by podar on 18/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "TeacherTopicListViewController.h"
#import "ViewLogsViewController.h"
#import "TopicListTableViewCell.h"
#import "HVTableView.h"
#import "URL_Constant.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "TopicList.h"
#import "CycleTest.h"
#import "FZAccordionTableView.h"
#import "ExpandTableViewCell.h"
#import "ResourceViewController.h"
#import "TeacherResourceListViewController.h"

@interface TeacherTopicListViewController (){
    NSDictionary *topicdetailsdictionary,*newDatasetinfoTeacherTopicList,*cycletestdetailsdictionary;
    BOOL firstTime,cycletestClick,cycletestItemClick,collapse,resourceClick;
    UITableView *cycletesttableview;
    UIAlertView *alertcycletest;
   // TopicListTableViewCell *topiccell;
   // int *path;
    NSString *string;
    TopicListTableViewCell *cell;
}

@property (nonatomic, strong) TopicList *TopicListtems;
@property (nonatomic, strong) CycleTest *CycleTesttems;
@end

@implementation TeacherTopicListViewController
@synthesize HVTableViewDelegate,HVTableViewDataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _topConstraintToTopicNameView.constant = 0;
    [_showlogView setHidden:YES];
    selectedIndexPath = [[NSMutableArray alloc]init];
    expandedCells = [[NSMutableArray alloc]init];
    firstTime = YES;
    
  
    selectedIndex = -1;
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
    subjecListClsID = [[NSUserDefaults standardUserDefaults]stringForKey:@"class_Id_SubjectList"];
    selectedStd = [[NSUserDefaults standardUserDefaults]stringForKey:@"stdName_SubjectList"];
    selectedSubject = [[NSUserDefaults standardUserDefaults] objectForKey:@"subjectName_SubjectList"];
    stdname = [[selectedStd componentsSeparatedByString:@"-"] objectAtIndex:0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
      title=[NSString stringWithFormat: @"%@>>%@", stdname,selectedSubject];
      self.navigationItem.title = title;
    //self.topicTblView.HVTableViewDataSource = self;
    //self.topicTblView.HVTableViewDelegate = self;
    self.topicTblView.dataSource = self;
    self.topicTblView.delegate = self;
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
    if(firstTime == YES){
        NSString *urlString = app_url @"PodarApp.svc/CycleTestDropDown";
        
        //Pass The String to server
        newDatasetinfoTeacherTopicList= [NSDictionary dictionaryWithObjectsAndKeys:brd_name,@"brd_name",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherTopicList options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(cycletestClick == YES){
        NSString *urlString = app_url @"PodarApp.svc/CycleTestDropDown";
        
        //Pass The String to server
        newDatasetinfoTeacherTopicList= [NSDictionary dictionaryWithObjectsAndKeys:brd_name,@"brd_name",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherTopicList options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(cycletestItemClick == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetTeacherTopicList";
        
        //Pass The String to server
        newDatasetinfoTeacherTopicList= [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",brd_name,@"brd_name",subjecListClsID,@"cls_id",stdname,@"std_name",selectedSubject,@"pmg_subject",cycletest,@"cycletest",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherTopicList options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(resourceClick == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetTeacherResourceList";
        
        //Pass The String to server
        newDatasetinfoTeacherTopicList= [NSDictionary dictionaryWithObjectsAndKeys:crf_id,@"crf_id",usl_id,@"usl_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherTopicList options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    }


-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    if(cycletestItemClick == YES){
        cycletestItemClick = NO;
           MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherTopicList options:kNilOptions error:&err];
                
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
                    TopicListStatus = [parsedJsonArray valueForKey:@"Status"];
                    topictListArray = [receivedData valueForKey:@"TopicList"];
                    
                    NSLog(@"Status:%@",TopicListStatus);
                    if([TopicListStatus isEqualToString:@"1"]){
                        [self.topicTblView setHidden:NO];
                        for(int n = 0; n < [topictListArray  count]; n++){
                            _TopicListtems = [[TopicList alloc]init];
                            topicdetailsdictionary = [topictListArray objectAtIndex:n];
                        }
                        
                    }
                    else if([TopicListStatus isEqualToString:@"0"]){
                        [self.topicTblView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [self.topicTblView reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if(firstTime == YES){
        firstTime = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherTopicList options:kNilOptions error:&err];
                
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
                    cycleTestStatus = [parsedJsonArray valueForKey:@"Status"];
                    cycleTestArray = [receivedData valueForKey:@"CycleTest"];
                    
                    NSLog(@"Status:%@",cycleTestStatus);
                    if([cycleTestStatus isEqualToString:@"1"]){
                    //    [self.topicListTableView setHidden:NO];
                        for(int n = 0; n < [cycleTestArray  count]; n++){
                            _CycleTesttems = [[CycleTest alloc]init];
                            cycletestdetailsdictionary = [cycleTestArray objectAtIndex:n];
                            cycletest = [[cycleTestArray objectAtIndex:0] objectForKey:@"cyc_name"];
                            [_cycleTestClick setTitle:cycletest forState:UIControlStateNormal];
                            cycletestItemClick= YES;
                            [self webserviceCall];
                        }
                        
                    }
                    else if([cycleTestStatus isEqualToString:@"0"]){
                     
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                
                    [hud hideAnimated:YES];
                }
            });
        });

    }
    else if(cycletestClick == YES){
        cycletestClick = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherTopicList options:kNilOptions error:&err];
                
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
                    cycleTestStatus = [parsedJsonArray valueForKey:@"Status"];
                    cycleTestArray = [receivedData valueForKey:@"CycleTest"];
                    
                    NSLog(@"Status:%@",cycleTestStatus);
                    if([cycleTestStatus isEqualToString:@"1"]){
                        //    [self.topicListTableView setHidden:NO];
                        for(int n = 0; n < [cycleTestArray  count]; n++){
                            _CycleTesttems = [[CycleTest alloc]init];
                            cycletestdetailsdictionary = [cycleTestArray objectAtIndex:n];
                            //  cycletest = [[cycleTestArray objectAtIndex:0] objectForKey:@"cyc_name"];
                         //   cycletestItemClick= YES;
                           // [self webserviceCall];
                        }
                        
                    }
                    else if([cycleTestStatus isEqualToString:@"0"]){
                     
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [cycletesttableview reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });

    }
    else if (resourceClick == YES){
        resourceClick = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherTopicList options:kNilOptions error:&err];
                
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
                    resourceStatus = [parsedJsonArray valueForKey:@"Status"];
                  
                    NSLog(@"Status:%@",cycleTestStatus);
                    if([cycleTestStatus isEqualToString:@"1"]){
                                ResourceViewController *ResourceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Resource"];
                            //    ResourceViewController.msd_id = msd_id;
                                ResourceViewController.usl_id = usl_id;
                                ResourceViewController.clt_id = clt_id;
                                ResourceViewController.brd_Name = brd_name;
                                ResourceViewController.crf_id = crf_id;
                                [self.navigationController pushViewController:ResourceViewController animated:YES];
                                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                        
                        
                    }
                    else if([cycleTestStatus isEqualToString:@"0"]){
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [cycletesttableview reloadData];
                    [hud hideAnimated:YES];
                }
            });
        });

    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try {
        if(tableView == _topicTblView){
            return [topictListArray count];
        }
        else if(tableView == cycletesttableview){
            return [cycleTestArray count];
        }
    }  @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try{
    if(tableView == _topicTblView){
    static NSString *simpleTableIdentifier = @"Cell";
    
    cell = (TopicListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TopicListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
        cell.topicName.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestTopicName =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceTopicName:)];
   
        cell.topicName.tag = indexPath.row;
           [tapGestTopicName setNumberOfTapsRequired:1];
        [cell.topicName addGestureRecognizer:tapGestTopicName];
        tapGestTopicName.delegate = self;
        
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.plusButtonClick.userInteractionEnabled = YES;
   
        cell.plusButtonClick.tag = indexPath.row;
        [cell.plusButtonClick setTag:indexPath.row];
        

    topicName = [[topictListArray objectAtIndex:indexPath.row]objectForKey:@"crf_topicname"];
        cell.topicName.text = topicName;
        srNo = [[topictListArray objectAtIndex:indexPath.row] objectForKey:@"srNo"];
        cell.rollNo.text = srNo;
        logfilled = [[topictListArray objectAtIndex:indexPath.row] objectForKey:@"total_logs"];
         logfilled=[NSString stringWithFormat: @"%@-%@", @"Total Logs",logfilled];
    //      [cell.logsFilled setTitle:logfilled forState:UIControlStateNormal];
        totalLogsFilled = [[topictListArray objectAtIndex:indexPath.row] objectForKey:@"No_of_logs_filled"];
        if([totalLogsFilled isEqualToString:@"1"]){
            totalLogsFilled = @"Yes";
        }
        else{
            totalLogsFilled = @"No";
        }
        totalLogsFilled =[NSString stringWithFormat: @"%@-%@", @"Logs Filled",totalLogsFilled];
        
        [cell.logsFilled setTitle:totalLogsFilled forState:UIControlStateNormal];
        
        [cell.viewLogClick addTarget:self action:@selector(ViewLog:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.viewLogClick.tag = indexPath.row;
        [cell.viewLogClick setTag:indexPath.row];
        

        return cell;
    }
    else if(tableView == cycletesttableview){
        static NSString *CellIdentifier = @"Cell";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        // Set up the cell...
        cell.textLabel.text = [[cycleTestArray objectAtIndex:indexPath.row]objectForKey:@"cyc_name"];
        return cell;
        }
    }
    @catch (NSException *exception) {
    NSLog(@"Exception: %@", exception);
    }
}
- (void)screenTappedOnceTopicName:(UITapGestureRecognizer *)tapGesture {

    UILabel *label = (UILabel *)tapGesture.view;
    NSLog(@"Lable tag is ::%ld",(long)label.tag);
    int indexFromArray = tapGesture.view.tag;
   int row = label.tag;
    
    NSLog(@"rowofthecell %d", indexFromArray);
    path = [NSIndexPath indexPathForRow:label.tag inSection:0];
    NSLog(@"path %d", path);
    row = path.row;
    crf_id = [[topictListArray objectAtIndex:row] objectForKey:@"crf_id"];    TeacherResourceListViewController *teacherResourceListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherResource"]; teacherResourceListViewController.usl_id = usl_id;
        teacherResourceListViewController.clt_id = clt_id;
        teacherResourceListViewController.brd_Name = brd_name;
        teacherResourceListViewController.crf_id = crf_id;
        [self.navigationController pushViewController:teacherResourceListViewController animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        if(tableView==_topicTblView){
            if ([expandedCells containsObject:indexPath])
            {
                return 100; //It's not necessary a constant, though
            }
            else
            {
                return 50; //Again not necessary a constant
            }
            }
        else if(tableView == cycletesttableview){
            return 45;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _topicTblView){
    TopicListTableViewCell *cell = [_topicTblView cellForRowAtIndexPath:indexPath];
    for (id object in cell.superview.subviews) {
        if ([object isKindOfClass:[UITableViewCell class]]) {
            TopicListTableViewCell *cellNotSelected = (TopicListTableViewCell*)object;
           // [cellNotSelected.plusButtonClick setTitle:@"+" forState:UIControlStateNormal];
            
        }
//        else{
//            [cell.plusButtonClick setTitle:@"-" forState:UIControlStateNormal];
//        }
    }
     //[cell.plusButtonClick setTitle:@"-" forState:UIControlStateNormal];

        NSIndexPath *selectedindexPath = [self.topicTblView indexPathForCell:cell];
        
            NSLog(@"Selected indexpath: %@", selectedindexPath);
        
        
    if ([expandedCells containsObject:indexPath])
    {
        [expandedCells removeObject:indexPath];
        [cell.plusButtonClick setTitle:@"+" forState:UIControlStateNormal];

    }
    else
    {
        [expandedCells addObject:indexPath];
        [cell.plusButtonClick setTitle:@"-" forState:UIControlStateNormal];

    }
        
     //   [self updateTableView];
    }
   else if(tableView == cycletesttableview){
    //   [self.topicTblView beginUpdates];
        [alertcycletest dismissWithClickedButtonIndex:0 animated:YES];
        cycletestItemClick = YES;
        cycletest = [[cycleTestArray objectAtIndex:indexPath.row] objectForKey:@"cyc_name"];
         [_cycleTestClick setTitle:cycletest forState:UIControlStateNormal];
        [self webserviceCall];
    }

 }


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateTableView];
  //  [cell.plusButtonClick setTitle:@"-" forState:UIControlStateNormal];
    
}

- (void)updateTableView
{
    [self.topicTblView beginUpdates];
    [self.topicTblView endUpdates];
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
- (IBAction)cycleTestBtn:(id)sender {
       alertcycletest= [[UIAlertView alloc] initWithTitle:@"Academic Year"
                                                  message:nil
                                                 delegate:self
                                        cancelButtonTitle:@"Close"
                                        otherButtonTitles:(NSString *)nil];
    if(self.internetActive == YES){
        
        cycletestClick = YES;
        [self webserviceCall];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    cycletesttableview = [[UITableView alloc] init];
    cycletesttableview.delegate = self;
    cycletesttableview.dataSource = self;
    [alertcycletest setValue:cycletesttableview forKey:@"accessoryView"];
    [alertcycletest show];
}
- (IBAction)viewLogBtn:(id)sender {
    
}

-(void)ViewLog:(id)sender
{
    UIButton *viewLog=(UIButton*)sender;
   
    path = [NSIndexPath indexPathForRow:viewLog.tag inSection:0];
    crf_id = [[topictListArray objectAtIndex:viewLog.tag] objectForKey:@"crf_id"];
    selectedTopicName= [[topictListArray objectAtIndex:viewLog.tag] objectForKey:@"crf_topicname"];
  
    [[NSUserDefaults standardUserDefaults] setObject:crf_id forKey:@"crf_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:selectedTopicName forKey:@"selectedTopicName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ViewLogsViewController *viewLogsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewLog"];
    
    [self.navigationController pushViewController:viewLogsViewController animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

}

@end
