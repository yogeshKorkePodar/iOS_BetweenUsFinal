//
//  AdminStudentSMSStudentListViewController.m
//  BetweenUs
//
//  Created by podar on 13/10/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "AdminStudentSMSStudentListViewController.h"
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
#import "AdminAnnouncementViewController.h"
#import "AcedmicYearResult.h"
#import "AdminDropResult.h"
#import "AdminStudentListViewController.h"
#import "MsgStudentResult.h"
#import "AdminStudentListTableViewCell.h"
#import "AdminSendMessageViewController.h"
#import "AdminSchoolSMSViewController.h"
#import "SmsStudentResult.h"
#import "AdminStudentSMSViewController.h"
#import"AdminStudentSendSMSViewController.h"

@interface AdminStudentSMSStudentListViewController (){
    WYPopoverController *settingsPopoverController;
    UIButton *btn;
    NSIndexPath *path;
    NSInteger *cellRow;
    BOOL loginClick,firstTime,academicYear,firstTimeStudentList,academicYearSelected,studentListSearch,*closeBtnClick,checkboxClicked,checkboxAllClicked,individualButtonClicked,selectAll;
    NSDictionary *newDatasetinfoAdminLogout,*newDatasetinfoStudentSMSStudentList;
}

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (nonatomic, strong) SmsStudentResult *SmsStudentResultItems;
@property(nonatomic,strong)   AdminStudentListTableViewCell *cell;

@end

@implementation AdminStudentSMSStudentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    firstTime = YES;
    checkboxAllClicked = NO;
    checkboxClicked = NO;
    pageSize = @"200";
    pageIndex =@"1";
    student_name = @"";
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    cls_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"StudentSMScls_ID"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    DeviceType= @"IOS";
    std = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedStdStudentSMS"];
    shift = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectedShiftNameStudentSMS"];
    section = [[NSUserDefaults standardUserDefaults] stringForKey:@"SelectedSectionNameStudentSMS"];
    selectAllClicked = [[NSUserDefaults standardUserDefaults]stringForKey:@"SelectAll"];
    
    self.StudentSMSStudentList.delegate = self;
    self.StudentSMSStudentList.dataSource = self;
    _enterStudentName.delegate = self;
    stuIdArray = [[NSMutableArray alloc] init];
    pathArray = [[NSMutableArray alloc] init];
    clsIdArray = [[NSMutableArray alloc]init];
    mystringArray = [[NSMutableArray alloc]init];
    buttonTagsTapped = [[NSMutableArray alloc] init];
    newMyStringArray = [[NSMutableArray alloc] init];
    arrayForTag =  [[NSMutableArray alloc]init];
    [_closeView setHidden:YES];
    [_closeImage setHidden:YES];
    _enterStudentName.delegate = self;

    
    if([selectAllClicked isEqualToString:@"1"]){
        self.navigationItem.title = @"Student List";
    }
    else if ([selectAllClicked isEqualToString:@"0"]){
        self.navigationItem.title = [NSString stringWithFormat:@"%@>>%@>>%@",std,shift,section];
    }
    
    [self checkInternetConnectivity];
    UITapGestureRecognizer *tapGestCloseView =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceCloseView)];
    [tapGestCloseView setNumberOfTapsRequired:1];
    [_closeView addGestureRecognizer:tapGestCloseView];
    tapGestCloseView.delegate = self;
    
    UITapGestureRecognizer *tapGestCloseImage =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceCloseView)];
    [tapGestCloseImage setNumberOfTapsRequired:1];
    [_closeImage addGestureRecognizer:tapGestCloseImage];
    tapGestCloseImage.delegate = self;

    UITapGestureRecognizer *tapGestTextfield =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
    [tapGestTextfield setNumberOfTapsRequired:1];
    [_enterStudentName addGestureRecognizer:tapGestTextfield];
    tapGestTextfield.delegate = self;


}
-(void)TextfieldAdminUsername{
    [_closeView setHidden:NO];
    [_closeImage setHidden:NO];
    
}- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"went here ...");
    
    //  if([touch.view isKindOfClass:[UITextField class]]){
    if(touch.view==_enterStudentName){
        [_closeImage setHidden:NO];
        [_closeView setHidden:NO];
        //   tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
        [self TextfieldAdminUsername];
        
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
    closeBtnClick = YES;
    _enterStudentName.text = @"";
    [_closeView setHidden:YES];
    [_closeImage setHidden:YES];
    student_name = @"";
    [arrayForTag removeAllObjects];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    [stuIdArray removeAllObjects];
    [clsIdArray removeAllObjects];
    individualButtonClicked = NO;
    checkboxAllClicked = NO;
    stu_id = [stuIdArray componentsJoinedByString:@","];
    classID = [clsIdArray componentsJoinedByString:@","];
    NSLog(@"Stu id after all det: %@", stu_id);
    NSLog(@"cls id after all det: %@", classID);

    [self webserviceCall];
}
-(void)handleDrawer{
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
        NSString *urlString = app_url @"PodarApp.svc/GetTeacherSMSStudentList";
        
        //Pass The String to server
        newDatasetinfoStudentSMSStudentList = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",cls_id,@"cls_id",student_name,@"studentName",pageIndex,@"PageNo",pageSize,@"PageSize",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoStudentSMSStudentList options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else if(studentListSearch==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetTeacherSMSStudentList";
        
        //Pass The String to server
        newDatasetinfoStudentSMSStudentList = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",cls_id,@"cls_id",student_name,@"studentName",pageIndex,@"PageNo",pageSize,@"PageSize",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoStudentSMSStudentList options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(closeBtnClick == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetTeacherSMSStudentList";
        
        //Pass The String to server
        newDatasetinfoStudentSMSStudentList = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",cls_id,@"cls_id",student_name,@"studentName",pageIndex,@"PageNo",pageSize,@"PageSize",nil];
         NSLog(@"params==%@", newDatasetinfoStudentSMSStudentList);
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoStudentSMSStudentList options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];

    }
    else if(loginClick==YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *urlString = app_url @"PodarApp.svc/LogOut";
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
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoStudentSMSStudentList options:kNilOptions error:&err];
                
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
                    
                    AdminStudentSMSListStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminStudentSMSListData = [receivedData objectForKey:@"SmsStudentResult"];
                    if([AdminStudentSMSListStatus isEqualToString:@"1"]){
                        _SmsStudentResultItems = [[SmsStudentResult alloc]init];
                        
                    }
                    else if([AdminStudentSMSListStatus isEqualToString:@"0"]){
                        selectAll = NO;
                        [stuIdArray removeAllObjects];
                        [clsIdArray removeAllObjects];
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_StudentSMSStudentList reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if(studentListSearch == YES){
        studentListSearch = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoStudentSMSStudentList options:kNilOptions error:&err];
                
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
                    
                    AdminStudentSMSListStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminStudentSMSListData = [receivedData objectForKey:@"SmsStudentResult"];
                    if([AdminStudentSMSListStatus isEqualToString:@"1"]){
                        _SmsStudentResultItems = [[SmsStudentResult alloc]init];
                        
                    }
                    else if([AdminStudentSMSListStatus isEqualToString:@"0"]){
                        selectAll = NO;
                        [stuIdArray removeAllObjects];
                        [clsIdArray removeAllObjects];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_StudentSMSStudentList reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if(closeBtnClick == YES){
        closeBtnClick = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoStudentSMSStudentList options:kNilOptions error:&err];
                
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
                    
                    AdminStudentSMSListStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminStudentSMSListData = [receivedData objectForKey:@"SmsStudentResult"];
                    if([AdminStudentSMSListStatus isEqualToString:@"1"]){
                        _SmsStudentResultItems = [[SmsStudentResult alloc]init];
                        
                    }
                    else if([AdminStudentSMSListStatus isEqualToString:@"0"]){
                        selectAll = NO;
                        [stuIdArray removeAllObjects];
                        [clsIdArray removeAllObjects];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_StudentSMSStudentList reloadData];
                    
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
        if(tableView == _StudentSMSStudentList){
            return [AdminStudentSMSListData count];
        }
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
        static NSString *simpleTableIdentifier = @"AdminStudentListTableViewCell";
        
        _cell = (AdminStudentListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (_cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminStudentListTableViewCell" owner:self options:nil];
            _cell = [nib objectAtIndex:0];
        }
        UIImage *btnCheckedImage = [UIImage imageNamed:@"smschecked_red_32x32.png"];
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
                        stu_id = [[AdminStudentSMSListData objectAtIndex:cellRow] objectForKey:@"stu_ID"];
                        classID = [[AdminStudentSMSListData objectAtIndex:cellRow] objectForKey:@"cls_ID"];
                        [stuIdArray addObject:stu_id];
                        [clsIdArray addObject:classID];
                        NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:stuIdArray];
                        stuIdArray = [[NSMutableArray alloc] initWithArray:[mySet array]];
                        NSOrderedSet *mySetClassID = [[NSOrderedSet alloc] initWithArray:clsIdArray];
                        clsIdArray = [[NSMutableArray alloc] initWithArray:[mySetClassID array]];
                        classID = [clsIdArray componentsJoinedByString:@","];
                        stu_id = [stuIdArray componentsJoinedByString:@","];
                        NSLog(@"Stu id after all selection: %@", stu_id);
                        NSLog(@"cls id after all selection: %@", classID);
                        
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
        _cell.studentNamelabel.text = [[AdminStudentSMSListData objectAtIndex:indexPath.row] objectForKey:@"Student_Name"];
        _cell.rollNoLabel.text = [[AdminStudentSMSListData objectAtIndex:indexPath.row] objectForKey:@"Roll_No"];

        if (indexPath.row % 2 == 0) {
            _cell.studentNamelabel.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:229.0/255.0f blue:222/255.0f alpha:1.0];
            _cell.rolNoBgView.backgroundColor =[UIColor colorWithRed:255.0/255.0f green:229.0/255.0f blue:222/255.0f alpha:1.0];
            _cell.cellCheckBoxClick.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:229.0/255.0f blue:222/255.0f alpha:1.0];
            _cell.rollNoView.backgroundColor = [UIColor colorWithRed:108.0/255.0f green:6.0/255.0f blue:7/255.0f alpha:1.0];

            
        }
        else
        {
            _cell.studentNamelabel.backgroundColor = [UIColor colorWithRed:244.0/255.0f green:202.0/255.0f blue:190/255.0f alpha:1.0];
            _cell.rolNoBgView.backgroundColor = [UIColor colorWithRed:244.0/255.0f green:202.0/255.0f blue:190/255.0f alpha:1.0];
            _cell.cellCheckBoxClick.backgroundColor = [UIColor colorWithRed:244.0/255.0f green:202.0/255.0f blue:190/255.0f alpha:1.0];
               _cell.rollNoView.backgroundColor = [UIColor colorWithRed:108.0/255.0f green:6.0/255.0f blue:7/255.0f alpha:1.0];
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
    UIImage *btnCheckedImage = [UIImage imageNamed:@"smschecked_red_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    
    path = [NSIndexPath indexPathForRow:checkBox.tag inSection:0];
    stu_id = [[AdminStudentSMSListData objectAtIndex:checkBox.tag] objectForKey:@"stu_ID"];
    classID = [[AdminStudentSMSListData objectAtIndex:checkBox.tag] objectForKey:@"cls_ID"];
    
    if ([checkBox.currentImage isEqual:[UIImage imageNamed:@"smschecked_red_32x32.png"]]){
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
    [clsIdArray addObject:classID];
    stu_id = [stuIdArray componentsJoinedByString:@","];
    classID = [clsIdArray componentsJoinedByString:@","];
    NSLog(@"Stu ID after add  %@",stu_id);
    NSLog(@"Cls ID after add  %@",classID);

    
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
    [clsIdArray removeObject:classID];
    classID = [clsIdArray componentsJoinedByString:@","];
    NSLog(@"Stu ID after remove  %@",stu_id);
    NSLog(@"Cls ID after remove  %@",classID);

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

-(void)screenTappedOnceStudentSMS{
    AdminStudentSMSViewController *adminStudentSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminStudentSMS"];
    [self.navigationController pushViewController:adminStudentSMSViewController animated:YES];
}
-(void)screenTappedOnceSchoolSMS{
    //sms
    AdminSchoolSMSViewController *adminSchoolSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMS"];
    
    [self.navigationController pushViewController:adminSchoolSMSViewController animated:YES];
}

- (IBAction)searchStudentBtn:(id)sender {
    
    studentListSearch =  YES;
    student_name = _enterStudentName.text;
    [arrayForTag removeAllObjects];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    [stuIdArray removeAllObjects];
    [clsIdArray removeAllObjects];
    individualButtonClicked = NO;
    checkboxAllClicked = NO;
    stu_id = [stuIdArray componentsJoinedByString:@","];
    classID = [clsIdArray componentsJoinedByString:@","];
    NSLog(@"Stu id after all det: %@", stu_id);
    NSLog(@"cls id after all det: %@", classID);
    [self webserviceCall];
}

- (IBAction)sendMessageBtn:(id)sender {
    if(checkboxAllClicked ==NO && individualButtonClicked == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(selectAll == NO && stuIdArray.count ==0 && clsIdArray.count == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        stu_id = [stuIdArray componentsJoinedByString:@","];
        classID = [clsIdArray componentsJoinedByString:@","];
        NSLog(@"all stu id  %@",stu_id);
        NSLog(@"all cls id  %@",classID);
        
        [[NSUserDefaults standardUserDefaults] setObject:stu_id forKey:@"SelectedStudentStuID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:classID forKey:@"SelectedStudentCassID"];
        [[NSUserDefaults standardUserDefaults] synchronize];


        AdminStudentSendSMSViewController *adminStudentSendSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminStudentSendSMS"];
        
        [self.navigationController pushViewController:adminStudentSendSMSViewController animated:YES];
    }
}

- (IBAction)checkAllBtn:(id)sender {
    UIButton *checkBoxAll=(UIButton*)sender;
    checkboxAllClicked = YES;
    selectAll = YES;
    individualButtonClicked = NO;
    
    UIImage *btnCheckedImage = [UIImage imageNamed:@"smschecked_red_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    
    if(_checkAllClick.isSelected == YES){
        _checkAllClick.selected = NO;
        checkboxAllClicked = NO;
        [arrayForTag removeAllObjects];
        [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
        [stuIdArray removeAllObjects];
        [clsIdArray removeAllObjects];
        stu_id = [stuIdArray componentsJoinedByString:@","];
        classID = [clsIdArray componentsJoinedByString:@","];
        NSLog(@"Stu id after all det: %@", stu_id);
        NSLog(@"cls id after all det: %@", classID);
        [_StudentSMSStudentList reloadData];
    }
    else if(_checkAllClick.isSelected == NO){
        _checkAllClick.selected = YES;
        [_checkAllClick setImage:btnCheckedImage forState:UIControlStateNormal];
        [_StudentSMSStudentList reloadData];
    }
    

}
@end
