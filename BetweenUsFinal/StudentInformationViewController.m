//
//  StudentInformationViewController.m
//  BetweenUsFinal
//
//  Created by podar on 18/08/17.
//  Copyright © 2017 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "StudentInformationViewController.h"
#import "PaymentInfoViewController.h"
#import "ViewMessageViewController.h"
#import "LoginViewController.h"
#import "StudentDashboardWithoutSibling.h"
#import "ViewMessageViewController.h"
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
#import "ParentInfoStudent.h"
#import "ParentInfoState.h"
#import "ParentInfocity.h"
#import "ParentInfoCountyList.h"
#import "StudentProfileWithSiblingViewController.h"
#import "SiblingStudentViewController.h"
#import "StudentResourcesViewController.h"

@interface StudentInformationViewController (){
    Boolean save,cancel,edit,stateboolean,cityboolean,countryboolean,firstTime;
    NSString *regEmailId,*mobilNo,*bldgAddress,*streetAddress,*locationArea,*state,*city,*country,*pincode,*telephoneNo;
    BOOL countrytableStatus,citytableStatus,statetableStatus,loginClick,firstWebcall;
    
}
@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) ParentInfoStudent *ParentInfoStudent;
@property (nonatomic, strong) ParentInfoState *ParentInfoState;
@property (nonatomic, strong) ParentInfocity *ParentInfocity;
@property (nonatomic, strong) ParentInfoCountyList *ParentInfoCountryList;

@property (nonatomic, strong) ParentInfoStudent *item;
@property (nonatomic, strong) ParentInfoState *Stateitem;
@property (nonatomic, strong) ParentInfocity *Cityitem;
@property (nonatomic, strong) ParentInfoCountyList *Countryitem;


@end

@implementation StudentInformationViewController

@synthesize  textfield_pinCode,textfield_mobileNo,textfield_streetName,textfield_telephoneNo,textfield_locationArea,textfield_buildingAddress,textfield_registeredEmailId,click_city,click_edit,click_save,click_state,click_cancel,click_country,msd_id,usl_id,clt_id,school_name,Status,state_tableData,Statename,StateId,CityId,CountryId,SelectedCityId,SelectedStateId,SelectedCountryId,city_tableData,country_tableData,Countryname,Cityname,brdName;

-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}
- (void)viewDidLoad {
    
    firstWebcall = YES;
    [self checkInternetConnectivity];
    
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
    
    msd_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"msd_Id"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    
    
    msd_id = msd_id;
    usl_id = usl_id;
    clt_id = clt_id;
    brdName = brdName;
    firstTime = YES;
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    DeviceType= @"IOS";
    NSLog(@"Device Token:%@",DeviceToken);
    NSLog(@"MSD Id StudentInfo:%@",msd_id);
    [textfield_telephoneNo resignFirstResponder];
    [click_cancel setHidden:YES];
    [click_save setHidden:YES];
    [self httpGetRequest];
    [self httpPostRequest];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [textfield_pinCode setEnabled:NO];
    [textfield_locationArea setEnabled:NO];
    [textfield_streetName setEnabled:NO];
    [textfield_mobileNo setEnabled:NO];
    [textfield_buildingAddress setEnabled:NO];
    [textfield_registeredEmailId setEnabled:NO];
    [textfield_telephoneNo setEnabled:NO];
    [click_state setEnabled:NO];
    [click_city setEnabled:NO];
    [click_country setEnabled:NO];
    [textfield_registeredEmailId setDelegate:self];
    [textfield_mobileNo setDelegate:self];
    [textfield_buildingAddress setDelegate:self];
    [textfield_streetName setDelegate:self];
    [textfield_locationArea setDelegate:self];
    [textfield_pinCode setDelegate:self];
    [textfield_telephoneNo setDelegate:self];
    [state_tableData setHidden:YES];
    [city_tableData setHidden:YES];
    [country_tableData setHidden:YES];
    self.state_tableData.delegate = self;
    self.state_tableData.dataSource = self;
    self.city_tableData.dataSource = self;
    self.country_tableData.dataSource = self;
    self.city_tableData.delegate = self;
    self.country_tableData.delegate = self;
    BOOL abc = country_tableData.hidden;
    //  textfield_telephoneNo.keyboardType = UIKeyboardTypeNumberPad;
    //  textfield_mobileNo.keyboardType = UIKeyboardTypeNumberPad;
    //SetBackground Color
    
    textfield_registeredEmailId.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_mobileNo.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_buildingAddress.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_streetName.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_locationArea.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_pinCode.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    click_state.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    click_city.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    click_country.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_telephoneNo.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    
    //Set Border to button
    [self.click_state.layer setBorderWidth:1.0];
    [self.click_state.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.click_country.layer setBorderWidth:1.0];
    [self.click_country.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.click_city.layer setBorderWidth:1.0];
    [self.click_city.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string
{
    if(textField == textfield_telephoneNo){
        if (textField.text.length >= 12 && range.length == 0)
            
            return NO;
    }
    else if(textField == textfield_mobileNo){
        if (textField.text.length >= 10 && range.length == 0)
            
            return NO;
    }
    return YES;
}


-(void)checkInternetConnectivity{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    
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
            firstWebcall == NO;
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



-(void) httpGetRequest{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString *str = app_url @"GetParentInfoDropDown";
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:GET];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];
    [hud hideAnimated:YES];
}
-(void) httpPostRequest{
    @try {
        
        if(save == YES){
            save = NO;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *err;
                    NSString *str = app_url @"UpdateParentStudentInfo";
                    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:str];
                    
                    //Pass The String to server
                    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:msd_id,@"msd_Id",regEmailId,@"stu_email",mobilNo,@"stu_mobile",bldgAddress,@"flat",streetAddress,@"Street",locationArea,@"Area",pincode,@"pinNo",StateId,@"Ste_ID",CityId,@"cit_ID",@"1",@"cnt_id",telephoneNo,@"TelNo", nil];
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
                    NSLog(@"got response==%@", resSrt);
                    
                    
                    // [self httpPostRequest];
                    
                    // NSError *err;
                    NSString *str1 = app_url @"GetParentStudentInfo";
                    str1 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url1 = [NSURL URLWithString:str1];
                    
                    //Pass The String to server
                    NSDictionary *newDatasetInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:msd_id,@"msd_Id", nil];
                    NSLog(@"the data Details is =%@", newDatasetInfo1);
                    
                    //convert object to data
                    NSData* jsonData1 = [NSJSONSerialization dataWithJSONObject:newDatasetInfo1 options:kNilOptions error:&err];
                    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url1];
                    [request1 setHTTPMethod:POST];
                    [request1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    [request1 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    
                    //Apply the data to the body
                    [request1 setHTTPBody:jsonData1];
                    
                    self.restApi.delegate = self;
                    [self.restApi httpRequest:request1];
                    NSURLResponse *response1;
                    
                    NSData *responseData1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:&response1 error:&err];
                    NSString *resSrt1 = [[NSString alloc]initWithData:responseData1 encoding:NSASCIIStringEncoding];
                    
                    //This is for Response
                    NSLog(@"got responsenew==%@", resSrt1);
                    
                    [hud hideAnimated:YES];
                    NSError *error = nil;
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingAllowFragments error:&error];
                    //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
                    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:responseData1 options:kNilOptions error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData1 options:(NSJSONReadingMutableContainers) error:&error];
                    Status = [parsedJsonArray valueForKey:@"Status"];
                    
                    NSLog(@"Statusnew:%@",Status);
                    
                    NSArray* parentInfoStudent = [receivedData objectForKey:@"ParentInfoStudent"];
                    //
                    NSLog(@"Sizenew:%lu",(unsigned long)[parentInfoStudent count]);
                    if([Status isEqualToString:@"1"]){
                        for(int n = 0; n < [parentInfoStudent count]; n++)
                        {
                            _item = [[ParentInfoStudent alloc]init];
                            NSDictionary* parentinfodetails = [parentInfoStudent objectAtIndex:n];
                            _item.eml_mailID = [parentinfodetails objectForKey:@"eml_mailID"];
                            _item.con_MNo =[parentinfodetails objectForKey:@"con_MNo"];
                            _item.adr_Building = [parentinfodetails objectForKey:@"adr_Building"];
                            _item.adr_Street = [parentinfodetails objectForKey:@"adr_Street"];
                            _item.adr_Area = [parentinfodetails objectForKey:@"adr_Area"];
                            _item.adr_pincode = [parentinfodetails objectForKey:@"adr_pincode"];
                            _item.Ste_Name = [parentinfodetails objectForKey:@"Ste_Name"];
                            _item.cit_Name = [parentinfodetails objectForKey:@"cit_Name"];
                            _item.cnt_Name = [parentinfodetails objectForKey:@"cnt_Name"];
                            _item.con_No = [parentinfodetails objectForKey:@"con_No"];
                            NSLog(@"TelNonew:%@",_item.con_No);
                        }
                        [self setData];
                        [hud hideAnimated:YES];
                        
                    }
                });
            });
        }
        else if(stateboolean == YES){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *err;
                    NSString *str = app_url @"GetParentInfoStateList";
                    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:str];
                    
                    //Pass The String to server
                    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"cnt_id",nil];
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
                    NSLog(@"got response==%@", resSrt);
                    
                    [hud hideAnimated:YES];
                });
            });
            
        }
        else if(cityboolean == YES){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *err;
                    NSString *str = app_url @"GetParentInfoCityList";
                    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:str];
                    
                    //Pass The String to server
                    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:StateId,@"Ste_ID",nil];
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
                    NSLog(@"got response==%@", resSrt);
                    [hud hideAnimated:YES];
                });
            });
        }
        else if(loginClick == YES){
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            loginClick = NO;
            NSError *err;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            NSString *str = app_url @"LogOut";
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
            [hud hideAnimated:YES];
            
        }
        else{
            @try{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                NSError *err;
                NSString *str = app_url @"GetParentStudentInfo";
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:str];
                
                //Pass The String to server
                NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:msd_id,@"msd_Id", nil];
                NSLog(@"<<<<<<<<<<< the data Details is =%@", newDatasetInfo);
                
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
                NSLog(@"<<<<<<<< got response==%@", resSrt);
                
                NSError *error = nil;
                NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                
                NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:
                                            (NSJSONReadingMutableContainers) error:&error];
                Status = [parsedJsonArray valueForKey:@"Status"];
                
                NSLog(@"<<<<<<< Statusfirst:%@",Status);
                
                NSArray* parentInfoStudent = [receivedData objectForKey:@"ParentInfoStudent"];
                
                if([Status isEqualToString:@"1"]){
                    for(int n = 0; n < [parentInfoStudent count]; n++)
                    {
                        _item = [[ParentInfoStudent alloc]init];
                        parentinfodetails = [parentInfoStudent objectAtIndex:n];
                        _item.eml_mailID = [parentinfodetails objectForKey:@"eml_mailID"];
                        _item.con_MNo =[parentinfodetails objectForKey:@"con_MNo"];
                        _item.adr_Building = [parentinfodetails objectForKey:@"adr_Building"];
                        _item.adr_Street = [parentinfodetails objectForKey:@"adr_Street"];
                        _item.adr_Area = [parentinfodetails objectForKey:@"adr_Area"];
                        _item.adr_pincode = [parentinfodetails objectForKey:@"adr_pincode"];
                        _item.Ste_Name = [parentinfodetails objectForKey:@"Ste_Name"];
                        _item.cit_Name = [parentinfodetails objectForKey:@"cit_Name"];
                        _item.cnt_Name = [parentinfodetails objectForKey:@"cnt_Name"];
                        _item.con_No = [parentinfodetails objectForKey:@"con_No"];
                        NSLog(@"TelNo:%@",_item.con_No);
                    }
                }
                [self setData];
                
                [hud hideAnimated:YES];
            }
            @catch (NSException *exception) {
                NSLog(@"<<<<<<<< Exception: %@", exception);
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"<<<<<<<<<<< Exception: %@", exception);
    }
}

-(void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender
{
    @try{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if(stateboolean == YES){
                    NSError *error = nil;
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                                (NSJSONReadingMutableContainers) error:&error];
                    Status = [parsedJsonArray valueForKey:@"Status"];
                    
                    NSLog(@"Status:%@",Status);
                    stateboolean = NO;
                    stateTableData = [receivedData objectForKey:@"ParentInfoState"];
                    NSLog(@"Size:%lu",(unsigned long)[stateTableData count]);
                    if([Status isEqualToString:@"1"]){
                        for(int n = 0; n < [stateTableData count]; n++)
                        {
                            _Stateitem = [[ParentInfoState alloc]init];
                            NSDictionary* parentStatedetails = [stateTableData objectAtIndex:n];
                            _Stateitem.Ste_Name = [parentStatedetails objectForKey:@"Ste_Name"];
                            _Stateitem.Ste_ID =[parentStatedetails objectForKey:@"Ste_ID"];
                            NSLog(@"StateName:%@",_Stateitem.Ste_Name);
                        }
                    }
                    [self.state_tableData reloadData];
                    
                    
                }
                else if(cityboolean == YES){
                    NSError *error = nil;
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    
                    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                                (NSJSONReadingMutableContainers) error:&error];
                    Status = [parsedJsonArray valueForKey:@"Status"];
                    
                    NSLog(@"Status:%@",Status);
                    cityboolean = NO;
                    cityTableData = [receivedData objectForKey:@"ParentInfocity"];
                    NSLog(@"Size:%lu",(unsigned long)[stateTableData count]);
                    if([Status isEqualToString:@"1"]){
                        for(int n = 0; n < [cityTableData count]; n++)
                        {
                            _Cityitem = [[ParentInfocity alloc]init];
                            NSDictionary* parentCitydetails = [cityTableData objectAtIndex:n];
                            _Cityitem.cit_Name = [parentCitydetails objectForKey:@"cit_Name"];
                            _Cityitem.cit_ID =[parentCitydetails objectForKey:@"cit_ID"];
                            NSLog(@"CityName:%@",_Cityitem.cit_Name);
                        }
                    }
                    [self.city_tableData reloadData];
                    
                }
                else if(countryboolean == YES){
                    NSError *error = nil;
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                                (NSJSONReadingMutableContainers) error:&error];
                    Status = [parsedJsonArray valueForKey:@"Status"];
                    
                    NSLog(@"Status:%@",Status);
                    countryboolean = NO;
                    countryTableData = [receivedData objectForKey:@"ParentInfoCountyList"];
                    NSLog(@"Size:%lu",(unsigned long)[countryTableData count]);
                    if([Status isEqualToString:@"1"]){
                        for(int n = 0; n < [countryTableData count]; n++)
                        {
                            _Countryitem = [[ParentInfoCountyList alloc]init];
                            NSDictionary* parentCitydetails = [countryTableData objectAtIndex:n];
                            _Countryitem.cnt_Name = [parentCitydetails objectForKey:@"cnt_Name"];
                            _Countryitem.cnt_ID =[parentCitydetails objectForKey:@"cnt_ID"];
                            NSLog(@"CountryName:%@",_Countryitem.cnt_Name);
                        }
                    }
                    [self.country_tableData reloadData];
                }
                else{
                    NSError *error = nil;
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    
                    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                                (NSJSONReadingMutableContainers) error:&error];
                    Status = [parsedJsonArray valueForKey:@"Status"];
                    
                    NSLog(@"Statusfirst:%@",Status);
                    
                    NSArray* parentInfoStudent = [receivedData objectForKey:@"ParentInfoStudent"];
                    
                    if([Status isEqualToString:@"1"]){
                        for(int n = 0; n < [parentInfoStudent count]; n++)
                        {
                            _item = [[ParentInfoStudent alloc]init];
                            parentinfodetails = [parentInfoStudent objectAtIndex:n];
                            _item.eml_mailID = [parentinfodetails objectForKey:@"eml_mailID"];
                            _item.con_MNo =[parentinfodetails objectForKey:@"con_MNo"];
                            _item.adr_Building = [parentinfodetails objectForKey:@"adr_Building"];
                            _item.adr_Street = [parentinfodetails objectForKey:@"adr_Street"];
                            _item.adr_Area = [parentinfodetails objectForKey:@"adr_Area"];
                            _item.adr_pincode = [parentinfodetails objectForKey:@"adr_pincode"];
                            _item.Ste_Name = [parentinfodetails objectForKey:@"Ste_Name"];
                            _item.cit_Name = [parentinfodetails objectForKey:@"cit_Name"];
                            _item.cnt_Name = [parentinfodetails objectForKey:@"cnt_Name"];
                            _item.con_No = [parentinfodetails objectForKey:@"con_No"];
                            NSLog(@"TelNo:%@",_item.con_No);
                        }
                        [self setData];
                        
                        if(save==YES){
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sucess" message:@"Information Updated Successfully" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:ok];
                            
                            [self presentViewController:alertController animated:YES completion:nil];
                        }
                        
                    }
                }
                [hud hideAnimated:YES];
            });
        });
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}
-(void) setData{
    
    textfield_registeredEmailId.text = _item.eml_mailID;
    textfield_mobileNo.text = _item.con_MNo;
    textfield_buildingAddress.text = _item.adr_Building;
    textfield_streetName.text = _item.adr_Street;
    textfield_locationArea.text = _item.adr_Area;
    textfield_pinCode.text = _item.adr_pincode;
    textfield_telephoneNo.text = _item.con_No;
    [click_state setTitle:_item.Ste_Name forState:UIControlStateNormal];
    [click_city setTitle:_item.cit_Name forState:UIControlStateNormal];
    [click_country setTitle:_item.cnt_Name forState:UIControlStateNormal];
    NSLog(@"TelNo tExt:%@",textfield_telephoneNo.text);
    
    
}
-(void) passDataOnSame{
    StudentInformationViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformation"];
    secondViewController.msd_id = msd_id;
    secondViewController.usl_id = usl_id;
    secondViewController.clt_id = clt_id;
    [self.navigationController pushViewController:secondViewController animated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        if(tableView==state_tableData){
            return [stateTableData count];
        }
        else if(tableView == city_tableData){
            return [cityTableData count];
        }
        else{
            return [countryTableData count];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SiblingTableViewCell" owner:self options:nil];
        // cell = [nib objectAtIndex:0];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if(tableView==country_tableData){
        Countryname = [[countryTableData objectAtIndex:indexPath.row] objectForKey:@"cnt_Name"];
        CountryId  = [[countryTableData objectAtIndex:indexPath.row] objectForKey:@"cnt_ID"];
        cell.textLabel.text = [[countryTableData objectAtIndex:indexPath.row] objectForKey:@"cnt_Name"];
    }
    else if(tableView == state_tableData){
        Statename = [[stateTableData objectAtIndex:indexPath.row] objectForKey:@"Ste_Name"];
        StateId = [[stateTableData objectAtIndex:indexPath.row] objectForKey:@"Ste_ID"];
        cell.textLabel.text = [[stateTableData objectAtIndex:indexPath.row] objectForKey:@"Ste_Name"];
    }
    else if(tableView == city_tableData){
        Cityname = [[cityTableData objectAtIndex:indexPath.row] objectForKey:@"cit_Name"];
        CityId = [[cityTableData objectAtIndex:indexPath.row] objectForKey:@"cit_ID"];
        cell.textLabel.text = [[cityTableData objectAtIndex:indexPath.row] objectForKey:@"cit_Name"];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == state_tableData){
        Statename = [[stateTableData objectAtIndex:indexPath.row] objectForKey:@"Ste_Name"];
        SelectedStateId  = [[stateTableData objectAtIndex:indexPath.row] objectForKey:@"Ste_ID"];
        [click_state setTitle:Statename forState:UIControlStateNormal];
        [state_tableData setHidden:YES];
        state = click_state.currentTitle;
        StateId = SelectedStateId;
        NSLog(@"StateTitle:%@",state);
        NSLog(@"SelectedStateID:%@",StateId);
    }
    else if(tableView == country_tableData){
        
        Countryname = [[countryTableData objectAtIndex:indexPath.row] objectForKey:@"cnt_Name"];
        SelectedCountryId  = [[countryTableData objectAtIndex:indexPath.row] objectForKey:@"cnt_ID"];
        [click_country setTitle:Countryname forState:UIControlStateNormal];
        [country_tableData setHidden:YES];
        country =  click_country.currentTitle;
        CountryId = SelectedCountryId;
        NSLog(@"CountryTitle:%@",country);
        NSLog(@"SelectedCountryID:%@",CountryId);
    }
    else if(tableView == city_tableData){
        Cityname = [[cityTableData objectAtIndex:indexPath.row] objectForKey:@"cit_Name"];
        SelectedCityId = [[cityTableData objectAtIndex:indexPath.row] objectForKey:@"cit_ID"];
        [click_city setTitle:Cityname forState:UIControlStateNormal];
        [city_tableData setHidden:YES];
        city = click_city.currentTitle;
        CityId = SelectedCityId;
        NSLog(@"CityTitle:%@",city);
        NSLog(@"SelectedCityID:%@",CityId);
    }
    
}

- (IBAction)btn_city:(id)sender {
    if(self.internetActive == YES){
        cityboolean = YES;
        firstTime = NO;
        [city_tableData setHidden:NO];
        [state_tableData setHidden:YES];
        [country_tableData setHidden:YES];
        citytableStatus = city_tableData.hidden;
        [self httpPostRequest];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}
- (IBAction)btn_country:(id)sender {
    if(self.internetActive == YES){
        countryboolean = YES; firstTime = NO;
        [country_tableData setHidden:NO];
        [state_tableData setHidden:YES];
        [city_tableData setHidden:YES];
        countrytableStatus = country_tableData.hidden;
        [self httpGetRequest];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}
- (IBAction)btn_edit:(id)sender {
    edit = YES;
    
    
    [click_edit setHidden:YES];
    [click_cancel setHidden:NO];
    [click_save setHidden: NO];
    _topConstraintSave.constant = 33;
    _topConstraintCancel.constant = 33;
    
    [textfield_pinCode setEnabled:YES];
    [textfield_locationArea setEnabled:YES];
    [textfield_streetName setEnabled:YES];
    [textfield_mobileNo setEnabled:YES];
    [textfield_buildingAddress setEnabled:YES];
    [textfield_registeredEmailId setEnabled:YES];
    [textfield_telephoneNo setEnabled:YES];
    [click_state setEnabled:YES];
    [click_city setEnabled:YES];
    [click_country setEnabled:YES];
    [textfield_registeredEmailId setDelegate:self];
    [textfield_mobileNo setDelegate:self];
    [textfield_buildingAddress setDelegate:self];
    [textfield_streetName setDelegate:self];
    [textfield_locationArea setDelegate:self];
    [textfield_pinCode setDelegate:self];
    [textfield_telephoneNo setDelegate:self];
    
    
    textfield_registeredEmailId.backgroundColor = [UIColor whiteColor];
    textfield_mobileNo.backgroundColor = [UIColor whiteColor];
    textfield_buildingAddress.backgroundColor = [UIColor whiteColor];
    textfield_streetName.backgroundColor = [UIColor whiteColor];
    textfield_locationArea.backgroundColor = [UIColor whiteColor];
    textfield_pinCode.backgroundColor = [UIColor whiteColor];
    click_state.backgroundColor = [UIColor whiteColor];
    click_city.backgroundColor = [UIColor whiteColor];
    click_country.backgroundColor = [UIColor whiteColor];
    textfield_telephoneNo.backgroundColor = [UIColor whiteColor];
}
-(void) getData{
    regEmailId = textfield_registeredEmailId.text;
    mobilNo = textfield_mobileNo.text;
    bldgAddress = textfield_buildingAddress.text;
    streetAddress = textfield_streetName.text;
    locationArea = textfield_locationArea.text;
    pincode = textfield_pinCode.text;
    telephoneNo = textfield_telephoneNo.text;
    if(firstTime==YES){
        CityId =[parentinfodetails objectForKey:@"cit_id"];
        CountryId =[parentinfodetails objectForKey:@"cnt_id"];
        StateId = [parentinfodetails objectForKey:@"ste_id"];
    }
    else{
        StateId;
        CountryId;
        CityId ;
        
        NSLog(@"AfterFirstTimeState:%@",StateId);
        NSLog(@"AfterFirstTimeCountry:%@",CountryId);
        NSLog(@"AfterFirstTimeCity:%@",CityId);
    }
    
    
}
- (IBAction)btn_save:(id)sender {
    if(self.internetActive == YES){
        save = YES;
        [click_edit setHidden:NO];
        [click_cancel setHidden:YES];
        [click_save setHidden: YES];
        _topConstraintCancel.constant = 87;
        _topConstraintSave.constant = 87;
        
        [textfield_pinCode setEnabled:NO];
        [textfield_locationArea setEnabled:NO];
        [textfield_streetName setEnabled:NO];
        [textfield_mobileNo setEnabled:NO];
        [textfield_buildingAddress setEnabled:NO];
        [textfield_registeredEmailId setEnabled:NO];
        [textfield_telephoneNo setEnabled:NO];
        [click_state setEnabled:NO];
        [click_city setEnabled:NO];
        [click_country setEnabled:NO];
        
        //SetBackground Color
        
        textfield_registeredEmailId.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
        textfield_mobileNo.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
        textfield_buildingAddress.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
        textfield_streetName.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
        textfield_locationArea.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
        textfield_pinCode.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
        click_state.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
        click_city.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
        click_country.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
        textfield_telephoneNo.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
        
        //Set Border to button
        [self.click_state.layer setBorderWidth:1.0];
        [self.click_state.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        
        [self.click_country.layer setBorderWidth:1.0];
        [self.click_country.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        
        [self.click_city.layer setBorderWidth:1.0];
        [self.click_city.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [self getData];
        [self httpPostRequest];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)btn_cancel:(id)sender {
    cancel = YES;
    [click_cancel setHidden:YES];
    [click_save setHidden:YES];
    [click_edit setHidden:NO];
    [state_tableData setHidden:YES];
    [city_tableData setHidden:YES];
    [country_tableData setHidden:YES];
    
    _topConstraintCancel.constant = 87;
    _topConstraintSave.constant = 87;
    
    [textfield_pinCode setEnabled:NO];
    [textfield_locationArea setEnabled:NO];
    [textfield_streetName setEnabled:NO];
    [textfield_mobileNo setEnabled:NO];
    [textfield_buildingAddress setEnabled:NO];
    [textfield_registeredEmailId setEnabled:NO];
    [textfield_telephoneNo setEnabled:NO];
    [click_state setEnabled:NO];
    [click_city setEnabled:NO];
    [click_country setEnabled:NO];
    
    textfield_registeredEmailId.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_mobileNo.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_buildingAddress.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_streetName.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_locationArea.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_pinCode.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    click_state.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    click_city.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    click_country.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    textfield_telephoneNo.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    
}


- (IBAction)state_btn:(id)sender {
    if(self.internetActive == YES){
        stateboolean = YES;
        firstTime = NO;
        [state_tableData setHidden:NO];
        [country_tableData setHidden:YES];
        [city_tableData setHidden:YES];
        statetableStatus = state_tableData.hidden;
        [self httpPostRequest];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
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
                //SiblingViewController.schoolName = schoolName;
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
                Status = @"0";
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
                Status = @"0";
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
