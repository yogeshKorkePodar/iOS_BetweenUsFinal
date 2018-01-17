//
//  WriteMessageViewController.m
//  BetweenUsFinal
//
//  Created by podar on 22/08/17.
//  Copyright © 2017 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "WriteMessageViewController.h"
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
#import "SentMessagesViewController.h"
#import "RecipentResult2.h"
#import "StudentProfileWithSiblingViewController.h"
#import "SiblingStudentViewController.h"
#import "StudentResourcesViewController.h"


@interface WriteMessageViewController () <RestAPIDelegate>{
    BOOL firstTime,sendMessage,Selectrecipent,viewMessage,writeMessage,sentMessage,message,announcement,attendance,behaviour,loginClick,firstWebcall;
    NSDictionary *newDatasetinfoPostNewMessage;
}
@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) RecipentResult2 *RecipentResultDetails;
@property (nonatomic, strong) RecipentResult2 *RecipentResultItems;

@end

@implementation WriteMessageViewController

@synthesize msd_id,click_recipient,clt_id,usl_id,brd_Name,messageSubject;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _enterMsg.textColor = [UIColor blackColor];
    [ self checkInternetConnectivity];
    _my_tabBar.delegate = self;
    _my_tabBar.selectedItem = [_my_tabBar.items objectAtIndex:0];

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
    
    //[_receipienttextfield setEnabled:NO];
    [messageSubject setDelegate:self];
    self.enterMsg.layer.borderWidth = 1.0f;
    self.enterMsg.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _enterMsg.text = @"Please Enter Message";
    _enterMsg.textColor = [UIColor lightGrayColor];
    [_enterMsg setDelegate:self];
    
    //optional
    //[enterMessage setDelegate:self];
    
    firstWebcall = YES;
    msd_id = msd_id;
    usl_id = usl_id;
    clt_id = clt_id;
    brd_Name = brd_Name;
    firstTime = YES;
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    DeviceType= @"IOS";
    
    isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];

    self.recipientTableData.tableFooterView = [UIView new];
    self.recipientTableData.dataSource = self;
    self.recipientTableData.delegate = self;
    [self.recipientTableData setHidden: YES];
   //[self.errorMessage setHidden:YES];
    [self getData];

}

-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}

-(void) checkInternetConnectivity{
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
        
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    _enterMsg.textColor = [UIColor blackColor];
    _enterMsg.text = @"";
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string
{
    if(textField == messageSubject){
        if (textField.text.length >= 50 && range.length == 0)
            
            return NO;
    }
    return YES;
}

-(void) httpPostRequest{
    //Create the response and Error
    if(Selectrecipent==YES){
        NSLog(@"<<<<<<< httpPostRequest Selectrecipent==YES >>>>>>>>>");

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSError *err;
        NSString *str =app_url @"PodarApp.svc/GetRecipentDropDownValue";
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:str];
        
        //Pass The String to server
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:msd_id,@"msd_id",clt_id,@"clt_id",nil];
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
        NSLog(@"got studentinforesponse==%@", resSrt);
        [hud hideAnimated:YES];
    }
    else if(sendMessage == YES){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
       
        NSString *urlString =app_url @"PodarApp.svc/PostNewMessage";
        //Pass The String to server
        newDatasetinfoPostNewMessage = [NSDictionary dictionaryWithObjectsAndKeys:msd_id,@"msd_id",clt_id,@"clt_id",toUslId,@"Tousl_id",subject,@"subject",Message,@"MessageBody",usl_id,@"usl_id",nil];
        NSLog(@"the data Details is =%@", newDatasetinfoPostNewMessage);
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoPostNewMessage options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
        [hud hideAnimated:YES];
    }
    else if(loginClick == YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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
        [hud hideAnimated:YES];
        
    }
}

-(void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender
{
    if(Selectrecipent == YES){
        Selectrecipent = NO;
        
        NSError *error = nil;
        NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
        NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
        recipientStatus= [parsedJsonArray valueForKey:@"Status"];
        NSLog(@"Status:%@",recipientStatus);
        
        recipientdetails = [receivedData objectForKey:@"RecipentResult"];
        //  NSLog(@"Size sibling:%lu",(unsigned long)[behaviourdetails count]);
        if([recipientStatus isEqualToString:@"1"]){
            for(int n = 0; n < [recipientdetails  count]; n++)
            {
                _RecipentResultItems= [[RecipentResult2 alloc]init];
                recipientdetailsdictionry = [recipientdetails objectAtIndex:n];
                _RecipentResultItems.name = [recipientdetailsdictionry objectForKey:@"name"];
                _RecipentResultItems.usl_Id =[recipientdetailsdictionry objectForKey:@"usl_Id"];
                NSLog(@"Recipientname:%@", _RecipentResultItems.name);
            }
        }
        [self.recipientTableData reloadData];
    }
    else if(sendMessage == YES){
        sendMessage = NO;
        NSError *error = nil;
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
        messageSentStatus= [parsedJsonArray valueForKey:@"Status"];
        statusMessage = [parsedJsonArray valueForKey:@"StatusMsg"];
        NSLog(@"Status:%@",messageSentStatus);
        //[self.errorMessage setHidden:NO];
        //_errorMessage.text = statusMessage;
        messageSubject.text = @"";
        _enterMsg.text= @"";
        if([messageSentStatus isEqualToString:@"1"]){
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Successful" message:statusMessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if([messageSentStatus isEqualToString:@"0"]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:statusMessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }
}


-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    NSError *err;
    NSData* responseData = nil;
    NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    responseData = [NSMutableData data] ;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoPostNewMessage options:kNilOptions error:&err];
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
    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
    messageSentStatus= [parsedJsonArray valueForKey:@"Status"];
    statusMessage = [parsedJsonArray valueForKey:@"StatusMsg"];
    NSLog(@"Status:%@",messageSentStatus);
   // [self.errorMessage setHidden:NO];
    //_errorMessage.text = statusMessage;
    messageSubject.text = @"";
    _enterMsg.text= @"";
    if([messageSentStatus isEqualToString:@"1"]){
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Successful" message:statusMessage preferredStyle:UIAlertControllerStyleAlert];
        //yocomment
      /*  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            SentMessagesViewController *SentMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SentMessage"];
            SentMessageViewController.msd_id = msd_id;
            SentMessageViewController.usl_id = usl_id;
            SentMessageViewController.clt_id = clt_id;
            SentMessageViewController.brd_Name = brd_Name;
            [self.navigationController pushViewController:SentMessageViewController animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            
        }];
       */
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];

       // [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if([messageSentStatus isEqualToString:@"0"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:statusMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipientdetails count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [[recipientdetails objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.recipientTableData setHidden:YES];
    [self.enterMsg setHidden:NO];
    
    toUslId = [[recipientdetails objectAtIndex:indexPath.row] objectForKey:@"usl_Id"];
    recipientName = [[recipientdetails objectAtIndex:indexPath.row] objectForKey:@"name"];
    [click_recipient setTitle:recipientName forState:UIControlStateNormal];
    [_recipientTableData setHidden:YES];
    
    [self.messageSubject setHidden:NO];
    NSLog(@"Name:%@",recipientName);
    NSLog(@"ToUslId:%@",toUslId);
}

-(void)getData{
    toUslId = toUslId;
    subject = messageSubject.text;
    Message = _enterMsg.text;
    usl_id = usl_id;
    clt_id = clt_id;
    msd_id = msd_id;
    
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
    
    
}


-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

- (IBAction)btn_PostIt:(id)sender {
    sendMessage = YES;
    [self getData];
    if([click_recipient.titleLabel.text isEqualToString:@"Select the Recipient"]){
      //  [self.errorMessage setHidden:YES];
       // _errorMessage.text = @"Please Select Recipient";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please Select Recipient" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if([messageSubject.text isEqualToString:@""]) {
    //    [self.errorMessage setHidden:NO];
     //   _errorMessage.text = @"Please Enter Subject";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please Enter Subject" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if([_enterMsg.text isEqualToString:@""] ){
        [self.enterMsg setHidden:NO];
        //  _enterMsg.text = @"Please Enter Message";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please Enter Message" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        if(self.internetActive == YES){
           // [self.errorMessage setHidden:YES];
            [self httpPostRequest];
        }
        else if(self.internetActive == NO){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (IBAction)btn_recipient:(id)sender {
    NSLog(@"<<<<<<< btn_recipient >>>>>>>>>");
    
    if(self.internetActive == YES){
        Selectrecipent = YES;
        self.recipientTableData.layer.borderWidth = 1;
        self.recipientTableData.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [self httpPostRequest];
        [self.messageSubject setHidden:YES];
        [self.recipientTableData setHidden:NO];
        [self.enterMsg setHidden:YES];
    }
    
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
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
