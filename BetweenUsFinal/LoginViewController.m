//
//  LoginViewController.m
//  BetweenUsFinal
//
//  Created by podar on 25/07/17.
//  Copyright © 2017 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "LoginViewController.h"
#import "Reachability.h"
#import "RestAPI.h"
#import "userListDetails.h"
#import "MBProgressHUD.h"
#import "StudentDashboardWithoutSibling.h"
#import "StudentDashboardWithSibling.h"
#import "StudentProfileWithSiblingViewController.h"

@interface LoginViewController () <RestAPIDelegate>
@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *loginStatus;
@property (nonatomic,strong) userListDetails *userListDetails;
@property (nonatomic,strong) userListDetails *item;

@end

@implementation LoginViewController{
    NSArray* userdetails;
    NSInteger *arraycount;
    UIDevice *currentDevice;
    BOOL loginbtn;
    BOOL forgotPassword;
    NSString *classTeacher,*acy_year;

    
    UITapGestureRecognizer *tapGestRecog ;
    UITapGestureRecognizer *tapGesture;
    UITapGestureRecognizer *tapGestRecogAdmin;
    MBProgressHUD *hud;
}

@synthesize outlet_showPassword;
@synthesize msd_id,roll_id,org_id,teacher_announcementCount,clt_id,school_name,usl_id,brd_name,name,DeviceToken,DeviceType;

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    username = @"";
    password = @"";
    NSLog(@"<<<<<< Inside LoginViewController >>>>>>>>>>>");
    // Do any additional setup after loading the view.
    _textfield_username.delegate = self;
    _textfield_password.delegate = self;
    
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    
    checked = NO;
    sibling = NO;
    self.navigationItem.title = @"Login";
    
    DeviceType = @"IOS";
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
}

-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)btn_login:(UIButton *)sender {
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        NSLog(@"connection Unavailable");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet Connection!" message:@"Please make sure your device is connected to internet." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
       
    }
    else
    {
        //connection available
        NSLog(@"connection Available");
        
        //Getting textfield values
        username = _textfield_username.text;
        password = _textfield_password.text;
        
//        username = @"test.parent1@podar.org";
//        password = @"india";
        
//        username = @"varshalipratham@gmail.com";
//        password = @"pratham";
        
        //Checking for null values
        if ([username isEqualToString:@""]) {
            NSLog(@"Null Username");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter username!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        if ([password isEqualToString:@""]) {
            NSLog(@"Null Username");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter password!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        NSLog(@"Username:%@",username);
        NSLog(@"Password:%@",password);
        
        //storing details in app preferences
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
        
        
        
        if (username!=nil & password!=nil) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    //Create the response and Error
                    NSError *err;
                    
                    NSString *str = app_url @"PodarApp.svc/DoLogin";
                   
                    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:str];
                    
                    //Pass The String to server
                    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:username,@"LoginId",password,@"Password",DeviceToken,@"DeviceId",DeviceType,@"DeviceType", nil];
                    NSLog(@"Data Details is: %@", newDatasetInfo);
                    
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
                    NSLog(@"Response received %@", resSrt);
                    
                    NSError *error = nil;
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                    //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
                    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                   
                    _loginStatus = [parsedJsonArray valueForKey:@"Status"];
                    
                    NSLog(@"Status:%@",_loginStatus);
                    
                    if([_loginStatus isEqualToString:@"1"]){
                        //mapping downloaded data to userListDetails array
                        NSArray* userdetails = [receivedData objectForKey:@"userListDetails"];
                        //getting count of array
                        arraycount = [userdetails count];
                        NSLog(@"Size array:%lu",(unsigned long)arraycount);
                        //converting int arraycount to string _LoginUserCount
                        _LoginUserCount = [NSString stringWithFormat:@"%d", arraycount];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:_LoginUserCount forKey:@"LoginUserCount"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        _item = [[userListDetails alloc]init];
                        
                        for(int n = 0; n < [userdetails count]; n++)
                        {
                            
                            NSDictionary* studentdetails = [userdetails objectAtIndex:n];
                            _item.rol_id = [studentdetails objectForKey:@"rol_id"];
                            _item.org_id = [studentdetails objectForKey:@"org_id"];
                            _item.sch_name =[studentdetails objectForKey:@"sch_name"];
                            _item.usl_id =[studentdetails objectForKey:@"usl_id"];
                            _item.Brd_Name =[studentdetails objectForKey:@"Brd_Name"];
                            _item.clt_id =[studentdetails objectForKey:@"clt_id"];
                            _item.msd_ID =[studentdetails objectForKey:@"msd_ID"];
                            _item.acy_year = [studentdetails objectForKey:@"acy_year"];
                            acy_year = _item.acy_year;
                            [[NSUserDefaults standardUserDefaults] setObject:acy_year forKey:@"academicYear"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            _item.TeachAnoucementCnt = [studentdetails objectForKey:@"TeachAnoucementCnt"];
                            _item.name = [studentdetails objectForKey:@"name"];
                            _item.clss_teacher = [studentdetails objectForKey:@"clss_teacher"];
                            msd_id = _item.msd_ID;
                            self.msd_id = _item.msd_ID;
                            usl_id = _item.usl_id;
                            clt_id = _item.clt_id;
                            brd_name = _item.Brd_Name;
                            name = _item.name;
                            teacher_announcementCount = _item.TeachAnoucementCnt;
                            org_id = _item.org_id;
                            roll_id = _item.rol_id;
                            school_name = _item.sch_name;
                            classTeacher = _item.clss_teacher;
                            [[NSUserDefaults standardUserDefaults] setObject:brd_name forKey:@"brd_name"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:msd_id forKey:@"msd_Id"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:usl_id forKey:@"usl_id"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:clt_id forKey:@"clt_id"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:roll_id forKey:@"Roll_id"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            
                            [[NSUserDefaults standardUserDefaults] setObject:school_name forKey:@"school_name"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:classTeacher forKey:@"classTeacher"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            //NSLog(@"MSD Idself:%@",self.msd_id);
                            //NSLog(@"MSD Id:%@",_item.msd_ID);
                            
                        }
                    }
                    
                    if([_loginStatus isEqualToString:@"1"]){
                        if([roll_id isEqualToString:@"2"]){
                           // [self screenTappedOnceAdmin];
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Sorry for inconvenience the App is under maintenance" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:ok];
                            
                            [self presentViewController:alertController animated:YES completion:nil];

                        }
                        else  if([roll_id isEqualToString:@"6"]){
                            [self parentDidLogin];
                                                   }
                        else if([roll_id isEqualToString:@"5"]){
                           // [self screenTappedOnceTeacher];
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Sorry for inconvenience the App is under maintenance" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:ok];
                            
                            [self presentViewController:alertController animated:YES completion:nil];

                        }
                        
                        else{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login Error" message:@"User does not exist" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:ok];
                            
                            [self presentViewController:alertController animated:YES completion:nil];
                        }
                        
                    }
                    else if([_loginStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login Error" message:@"User does not exist" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    }
                    [hud hideAnimated:YES];
                });
            });
          
        }
        
    }
    
    }

- (IBAction)btn_forgotPassword:(UIButton *)sender {
}

- (IBAction)btn_showPassword:(UIButton *)sender {
    NSLog(@"SHOW PASSWORD CHECKBOX CLICKED");
    if(checked==NO){
         NSLog(@"Checked");
        [outlet_showPassword setImage:[UIImage imageNamed:@"Checked_Checkbox.png"] forState:UIControlStateNormal];
        _textfield_password.secureTextEntry = NO;
        checked = YES;
        
       
    }
    else{
         NSLog(@"Unchecked");
        [outlet_showPassword setImage:[UIImage imageNamed:@"Unchecked_Checkbox.png"] forState:UIControlStateNormal];
        _textfield_password.secureTextEntry = YES;
        checked = NO;
        
    }

}

- (void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender{
    NSLog(@"Inside LoginViewController getReceivedData");
    
    //  [self activityStopIndicator];
    NSError *error = nil;
    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
    _loginStatus = [parsedJsonArray valueForKey:@"Status"];
    NSLog(@"Status:%@",_loginStatus);
    
    if([_loginStatus isEqualToString:@"1"]){
        
        NSArray* userdetails = [receivedData objectForKey:@"userListDetails"];
        arraycount = [userdetails count];
        NSLog(@"Size array:%lu",(unsigned long)arraycount);
        
        [[NSUserDefaults standardUserDefaults] setInteger:arraycount forKey:@"arrayCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _LoginUserCount = [NSString stringWithFormat:@"%d", arraycount];
        
        [[NSUserDefaults standardUserDefaults] setObject:_LoginUserCount forKey:@"LoginUserCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _item = [[userListDetails alloc]init];
        
        // NSLog(@"Size:%lu",(unsigned long)[userdetails count]);
        
        for(int n = 0; n < [userdetails count]; n++)
        {
            
            NSDictionary* studentdetails = [userdetails objectAtIndex:n];
            _item.rol_id = [studentdetails objectForKey:@"rol_id"];
            _item.org_id = [studentdetails objectForKey:@"org_id"];
            _item.sch_name =[studentdetails objectForKey:@"sch_name"];
            _item.usl_id =[studentdetails objectForKey:@"usl_id"];
            _item.Brd_Name =[studentdetails objectForKey:@"Brd_Name"];
            _item.clt_id =[studentdetails objectForKey:@"clt_id"];
            _item.msd_ID =[studentdetails objectForKey:@"msd_ID"];
            _item.TeachAnoucementCnt = [studentdetails objectForKey:@"TeachAnoucementCnt"];
            _item.name = [studentdetails objectForKey:@"name"];
            _item.sft_name = [studentdetails objectForKey:@"sft_name"];
            _item.std_Name = [studentdetails objectForKey:@"std_Name"];
            _item.div_name = [studentdetails objectForKey:@"div_name"];
            _item.clss_teacher = [studentdetails objectForKey:@"clss_teacher"];
            _item.acy_year = [studentdetails objectForKey:@"acy_year"];
            
            msd_id = _item.msd_ID;
            self.msd_id = _item.msd_ID;
            usl_id = _item.usl_id;
            clt_id = _item.clt_id;
            brd_name = _item.Brd_Name;
            name = _item.name;
            teacher_announcementCount = _item.TeachAnoucementCnt;
            org_id = _item.org_id;
            roll_id = _item.rol_id;
            acy_year = _item.acy_year;
            school_name = _item.sch_name;
            classTeacher = _item.clss_teacher;
            [[NSUserDefaults standardUserDefaults] setObject:brd_name forKey:@"brd_name"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:acy_year forKey:@"academicYear"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:roll_id forKey:@"Roll_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:msd_id forKey:@"msd_Id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:usl_id forKey:@"usl_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:clt_id forKey:@"clt_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:school_name forKey:@"school_name"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:org_id forKey:@"Org_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:classTeacher forKey:@"classTeacher"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            //yocomment
        //    _teacherShift=[NSString stringWithFormat: @"%@|%@|%@ ", _item.sft_name,_item.std_Name,_item.div_name];
       //     [[NSUserDefaults standardUserDefaults] setObject:_teacherShift forKey:@"shift"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        //    NSLog(@"teacher shift :%@",_teacherShift);
            NSLog(@"MSD Idself:%@",self.msd_id);
            //NSLog(@"MSD Id:%@",_item.msd_ID);
            
        }
    }
    
}


-(void)parentDidLogin{
    
    
    
    NSLog(@"<< parentDidLogin");
    
    if (arraycount==1) {
        
        NSLog(@"Starting StudentDashboardWithoutSibling scene");
        //Starting StudentDashboardWithoutSibling scene
        StudentDashboardWithoutSibling *studentDashboardWithoutSibling = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentDashboardWithoutSibling"];
        
        [ self.navigationController pushViewController:studentDashboardWithoutSibling animated:YES];
          self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
       
    } else {
        
        NSLog(@"Starting StudentDashboardWithSibling scene");
        //Starting StudentDashboardWithSibling scene
         StudentProfileWithSiblingViewController *SiblingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Sibling"];
//        SiblingViewController.msd_id = msd_id;
//        SiblingViewController.usl_id = usl_id;
//        SiblingViewController.clt_id = clt_id;
//        SiblingViewController.brdName = brd_name;
//        SiblingViewController.schoolName = school_name;
        
        [ self.navigationController pushViewController:SiblingViewController animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
         [self.navigationController setNavigationBarHidden:NO animated:YES];

    }
    
}

@end
