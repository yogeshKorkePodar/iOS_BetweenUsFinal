//
//  AdminSchoolSMSTeacherViewController.m
//  BetweenUs
//
//  Created by podar on 07/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "URL_Constant.h"
#import "NavigationMenuButton.h"
#import "AdminSchoolSMSTeacherViewController.h"
#import "AdminSendSMSViewController.h"
#import "AdminSendMessageViewController.h"
#import "WriteMessageStudentTableViewCell.h"
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
#import "AdminWriteMessageTeacherViewController.h"
#import "MsgTeacherResult.h"
#import "AdminTeacherTableViewCell.h"
#import "AdminSendMessageViewController.h"
#import "AdminSchoolSMSViewController.h"
#import "AdminStudentSMSViewController.h"
#import "AdminTeacherSMSViewController.h"
#import "AdminSchoolSMSDirectViewController.h"


@interface AdminSchoolSMSTeacherViewController (){
    NSDictionary *newDatasetinfoAdminSchoolSendSMSTeacher,*newDatasetinfoAdminLogout;
    BOOL loginClick;
    UIAlertView *alertCategory;
    UITableView *categoryTableView;
    WYPopoverController *settingsPopoverController;
}

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@end

@implementation AdminSchoolSMSTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"SMS";
    //Add drawer image button
    UIImage *faceImage = [UIImage imageNamed:@"drawer_icon.png"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake( 10, 0, 15, 15 );
    
    UITapGestureRecognizer *tapdrawer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrawer)];
    [tapdrawer setNumberOfTapsRequired:1];
    [face addGestureRecognizer:tapdrawer];
    tapdrawer.delegate = self;
    [face addTarget:self action:@selector(handleDrawer) forControlEvents:UIControlEventTouchUpInside];
    [face setImage:faceImage forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:face];
    self.navigationItem.leftBarButtonItem = backButton;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setBackBarButtonItem:nil];
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];


    sender_usl_id = @"0";
    attachedfilename = @"0";
    filePath = @"0";
    mode = @"Teacher";
    DeviceType= @"IOS";
    self.enterMessage.layer.borderWidth = 1.0f;
    self.enterMessage.layer.borderColor = [[UIColor grayColor] CGColor];
    _sendSMSClick.layer.cornerRadius = 5;
    _sendSMSClick.layer.masksToBounds = YES;
    _condition_label.layer.masksToBounds = YES;
    _condition_label.layer.cornerRadius = 5;

    _enterMessage.text = @"Type your message here";
    _enterMessage.textColor = [UIColor lightGrayColor];
    [_enterMessage setDelegate:self];
    
    AdminWriteMessage  = [[NSUserDefaults standardUserDefaults]stringForKey:@"AdminWriteMessage"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    usl_IdMessage = [[NSUserDefaults standardUserDefaults] stringForKey:@"UslIDMessage"];
    cls_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"cls_ID"];
    board_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];
    stu_id = stu_id;
    
    NSLog(@"Stu id send message==%@", stu_id);
     NSLog(@"board name==%@", board_name);
    
    [_charachterLengthLimit_label setHidden:YES];
    [self checkInternetConnectivity];
    
    UITapGestureRecognizer *tapGestStudentSMS =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceStudentSMS)];
    [tapGestStudentSMS setNumberOfTapsRequired:1];
    [_studentSMSClick addGestureRecognizer:tapGestStudentSMS];
    tapGestStudentSMS.delegate = self;
    
    UITapGestureRecognizer *tapGestSchoolSMS =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceSchoolSMS)];
    [tapGestSchoolSMS setNumberOfTapsRequired:1];
    [_schoolSMSClick addGestureRecognizer:tapGestSchoolSMS];
    tapGestSchoolSMS.delegate = self;
    
    UITapGestureRecognizer *tapGestTeacherSMS =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceTeacherSMS)];
    [tapGestTeacherSMS setNumberOfTapsRequired:1];
    [_teacherSMSClick addGestureRecognizer:tapGestTeacherSMS];
    tapGestTeacherSMS.delegate = self;
    
    

    CategoryTableData = [NSArray arrayWithObjects:@"Student", @"Teacher", @"Direct", nil];
}

-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)handleDrawer{
    [self.rootNav drawerToggle];
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
-(void)screenTappedOnceTeacherSMS{
    AdminTeacherSMSViewController *adminTeacherSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminTeacherSMS"];
    
    [self.navigationController pushViewController:adminTeacherSMSViewController animated:YES];
    

}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Type your message here"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Type your message here";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    // return YES;
    else{
        [_charachterLengthLimit_label setHidden:NO];
        NSString *length  =[NSString stringWithFormat:@"%d",textView.text.length + (text.length - range.length) ];
        
        length=   [NSString stringWithFormat:@"%@/%@",length,@"132"];
        _charachterLengthLimit_label.text = length;
        return textView.text.length + (text.length - range.length) < 132;
    }

    
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
        
        //   [self webserviceCall];
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
        NSString *urlString = app_url @"LogOut";
        //    newDatasetinfoAdminLogout = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        //Pass The String to server
        newDatasetinfoAdminLogout= [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminLogout options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    
    else{

    NSString *urlString = app_url @"AdminSendSMS";
    
    //Pass The String to server
    newDatasetinfoAdminSchoolSendSMSTeacher = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",mode,@"Mode",enteredSms,@"message",board_name,@"brd_name",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSendSMSTeacher options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServer:urlString jsonString:jsonInputString];
    }
    
}
-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
   if(loginClick == YES){
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
    else{
    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err;
            NSData* responseData = nil;
            NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            responseData = [NSMutableData data] ;
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSchoolSendSMSTeacher options:kNilOptions error:&err];
            
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
                
                SendSMSTeaherStatus = [parsedJsonArray valueForKey:@"Status"];
                
                if([SendSMSTeaherStatus isEqualToString:@"1"]){
                    
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Message Sent Successfully" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                        AdminSchoolSMSViewController *adminSchoolSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMS"];
                        [self.navigationController pushViewController:adminSchoolSMSViewController animated:NO];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                        
                    }];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else if([SendSMSTeaherStatus isEqualToString:@"0"]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Message Not Sent" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                [hud hideAnimated:YES];
            }
        });
    });
    }
    
}



- (IBAction)category_btn:(id)sender {
    [alertCategory setFrame:CGRectMake(40, 150, 2500, 500)];
    alertCategory = [[UIAlertView alloc] initWithTitle:@"Category"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"Close"
                                     otherButtonTitles:(NSString *)nil];
    
    categoryTableView = [[UITableView alloc] init];
    categoryTableView.delegate = self;
    categoryTableView.dataSource = self;
    [alertCategory setValue:categoryTableView forKey:@"accessoryView"];
    [alertCategory show];
}
- (IBAction)sendSMSBtn:(id)sender {
    enteredSms = _enterMessage.text;
    NSLog(@"TExt%@",enteredSms);
    if([enteredSms isEqualToString:@"Type your message here"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"SMS can not be Blank" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"&+%=#'"];
        NSRange range = [enteredSms rangeOfCharacterFromSet:cset];
        if (range.location == NSNotFound) {
            // no ( or ) in the string
            
            enteredSms= [NSString stringWithFormat:@"%@ %@",@"Dear Teacher,Kindly Note",enteredSms];
            NSLog(@"NO%@",@"NO");
            NSLog(@"Afer text%@",enteredSms);
            
           [self webserviceCall];
            
        } else {
            // ( or ) are present
            NSLog(@"YES%@",@"Yes");
            NSString *message = @"There is special character in SMS";
            UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
            [toast show];
            int duration = 1; // in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [toast dismissWithClickedButtonIndex:0 animated:YES];
            });
        }
        
    }
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        if(tableView == categoryTableView)
            return [CategoryTableData count];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if(tableView == categoryTableView){
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SiblingTableViewCell" owner:self options:nil];
                // cell = [nib objectAtIndex:0];
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
                
                
                [cell.textLabel setFont: [cell.textLabel.font fontWithSize: 14]];
                cell.textLabel.text =  [CategoryTableData objectAtIndex:indexPath.row];
                //[_selectCategory_Click setTitle:currentacademicYear forState:UIControlStateNormal];
            }
            return cell;
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 30;
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == categoryTableView){
        category = [CategoryTableData objectAtIndex:indexPath.row];
        if([category isEqualToString:@"Student"]){
            NSLog(@"SelectedcycleCateg:%@",category);
            [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
            [_CategoryClick setTitle:category forState:UIControlStateNormal];
            
            
            AdminSchoolSMSViewController *adminSchoolSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMS"];
            
            [self.navigationController pushViewController:adminSchoolSMSViewController animated:NO];
            [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
        }
        else if([category isEqualToString:@"Teacher"]){
            NSLog(@"SelectedcycleCateg:%@",category);
            [_CategoryClick setTitle:category forState:UIControlStateNormal];
            
            AdminSchoolSMSTeacherViewController *adminSchoolSMSTeacherViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMSTeacher"];
            
            [self.navigationController pushViewController:adminSchoolSMSTeacherViewController animated:NO];
            [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
        }
        else if([category isEqualToString:@"Direct"]){
            NSLog(@"SelectedcycleCateg:%@",category);
            [_CategoryClick setTitle:category forState:UIControlStateNormal];
            
            AdminSchoolSMSDirectViewController *adminSchoolSMSDirectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMSDirect"];
            
            [self.navigationController pushViewController:adminSchoolSMSDirectViewController animated:NO];
            [alertCategory dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
    
}

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    
    if(selectionIndex == 0){
        
        AdminProfileViewController *adminProfileController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminProfile"];
        [self.navigationController pushViewController:adminProfileController animated:YES];
    }
    else if(selectionIndex == 1){
        //Messsage
        AdminViewMessageViewController *adminViewMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewMessage"];
        
        [self.navigationController pushViewController:adminViewMessageViewController animated:YES];
    }
    else if(selectionIndex == 2){
        //sms
        AdminSchoolSMSViewController *adminSchoolSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMS"];
        
        [self.navigationController pushViewController:adminSchoolSMSViewController animated:YES];
        
        
    }
    else if(selectionIndex == 3){
        AdminAnnouncementViewController *adminAnnouncementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminAnnouncement"];
        
        [self.navigationController pushViewController:adminAnnouncementViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    
    else if(selectionIndex == 4){
        ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
        [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    else if(selectionIndex == 5){
        loginClick = YES;
        [self webserviceCall];
        LoginViewController *LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self.navigationController pushViewController:LoginViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    else if(selectionIndex == 6){
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
        
    }
}


@end
