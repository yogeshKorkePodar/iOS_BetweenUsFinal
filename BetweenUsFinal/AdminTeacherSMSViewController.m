//
//  AdminTeacherSMSViewController.m
//  BetweenUs
//
//  Created by podar on 19/10/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "AdminTeacherSMSViewController.h"
#import "AdminStudentSendSMSViewController.h"
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
#import "AdmTechList.h"
#import "AdminStudentSMSViewController.h"
#import "AdminStudentListTableViewCell.h"
#import "AdminSendSMSToTeacherSMSViewController.h"


@interface AdminTeacherSMSViewController (){
   
    BOOL firstTime,closebtnclick,loginClick,searchList,checkboxAllClicked,individualButtonClicked,selectAll;
    WYPopoverController *settingsPopoverController;
    NSDictionary *newDatasetinfoAdminTeacherSMS;
    UIButton *btn;
    NSIndexPath *path;
    NSInteger *cellRow;

}

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (nonatomic, strong) AdmTechList *AdmTechListItems;
@property(nonatomic,strong)   AdminStudentListTableViewCell *cell;

@end

@implementation AdminTeacherSMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    checkboxAllClicked = NO;
   // checkboxClicked = NO;
    firstTime = YES;
    Searchname = @"";
    PageNo = @"1";
    PageSize = @"300";
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    brd_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];

    [_closeView setHidden:YES];
    [_closeViewImg setHidden:YES];
    _enterTeacherName.delegate = self;
    _teacherSMSListData.delegate = self;
    _teacherSMSListData.dataSource = self;
    self.navigationItem.title = @"SMS";
    //Add drawer image button
    UIImage *faceImage = [UIImage imageNamed:@"drawer_icon.png"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake( 10, 0, 15, 15 );
    
    
    contactNoArray = [[NSMutableArray alloc] init];
    pathArray = [[NSMutableArray alloc] init];
    arrayForTag =  [[NSMutableArray alloc]init];
    
    
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
    
    UITapGestureRecognizer *tapGestTextfield =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
    [tapGestTextfield setNumberOfTapsRequired:1];
    [_enterTeacherName addGestureRecognizer:tapGestTextfield];
    tapGestTextfield.delegate = self;
    
    UITapGestureRecognizer *tapGestCloseView =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
    [tapGestCloseView setNumberOfTapsRequired:1];
    [_closeView addGestureRecognizer:tapGestCloseView];
    tapGestCloseView.delegate = self;

    UITapGestureRecognizer *tapGestCloseImg=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
    [tapGestCloseImg setNumberOfTapsRequired:1];
    [_closeViewImg addGestureRecognizer:tapGestCloseImg];
    tapGestCloseImg.delegate = self;

    [self checkInternetConnectivity];
    
}

-(void)handleDrawer{
    [self.rootNav drawerToggle];
}

-(void)TextfieldAdminUsername{
    [_closeView setHidden:NO];
    [_closeViewImg setHidden:NO];
    
}- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"went here ...");
    
    //  if([touch.view isKindOfClass:[UITextField class]]){
    if(touch.view==_enterTeacherName){
        [_closeViewImg setHidden:NO];
        [_closeView setHidden:NO];
        //   tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
        [self TextfieldAdminUsername];
        
    }
    else if(touch.view == _closeView){
      
        [self screenTappedOnceCloseView];
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
    closebtnclick = YES;
    _enterTeacherName.text = @"";
    [_closeView setHidden:YES];
    [_closeViewImg setHidden:YES];
    Searchname= @"";
    
    [[NSUserDefaults standardUserDefaults] setObject:checkAll forKey:@"CheckAll"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [arrayForTag removeAllObjects];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox.png"];
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    [contactNoArray removeAllObjects];
    checkboxAllClicked = NO;
    individualButtonClicked = NO;
    contactNo = [contactNoArray componentsJoinedByString:@","];
    NSLog(@"conatct id after all det: %@", contactNo);

    [self webserviceCall];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        if(tableView == _teacherSMSListData){
            return [AdminTeacherSMSArray count];
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
        UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox.png"];
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
                        contactNo = [[AdminTeacherSMSArray objectAtIndex:cellRow] objectForKey:@"stf_Mno"];
                        [contactNoArray addObject:contactNo];
                      
                        NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:contactNoArray];
                        contactNoArray = [[NSMutableArray alloc] initWithArray:[mySet array]];
                        contactNo = [contactNoArray componentsJoinedByString:@","];
                        NSLog(@"contact id after all selection: %@", contactNo);
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
        _cell.studentNamelabel.text = [[AdminTeacherSMSArray objectAtIndex:indexPath.row] objectForKey:@"fullname"];
        _cell.rollNoLabel.text = [[AdminTeacherSMSArray objectAtIndex:indexPath.row] objectForKey:@"SrNo"];
        
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
    checkAll = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:checkAll forKey:@"CheckAll"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIButton *checkBox=(UIButton*)sender;
    UIImage *btnCheckedImage = [UIImage imageNamed:@"smschecked_red_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox.png"];
    
    path = [NSIndexPath indexPathForRow:checkBox.tag inSection:0];
    contactNo = [[AdminTeacherSMSArray objectAtIndex:checkBox.tag] objectForKey:@"stf_Mno"];
    
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
    [contactNoArray addObject:contactNo];
  
    contactNo = [contactNoArray componentsJoinedByString:@","];
 
   NSLog(@"Contact ID after add  %@",contactNo);
    
    
}


-(void)deleteSelectedCheckBoxTag:(int)value
{
    
    for(int i=0;i<[arrayForTag count];i++)
    {
        if([[arrayForTag objectAtIndex:i] intValue]==value)
            [arrayForTag removeObjectAtIndex:i];
    }
    NSLog(@"After deletion  .." ,arrayForTag);
    [contactNoArray removeObject:contactNo];
   contactNo = [contactNoArray componentsJoinedByString:@","];
   NSLog(@"Contact ID after remove  %@",contactNo);
    
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
        if (settingsPopoverController == nil)
        {
            AboutUsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUs"];
            settingsViewController.preferredContentSize = CGSizeMake(320, 300);
            
            settingsViewController.title = @"AboutUs";
            settingsViewController.modalInPopover = NO;
            
            UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            
            settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            settingsPopoverController.delegate = self;
            settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            settingsPopoverController.wantsDefaultContentAppearance = NO;
            [settingsPopoverController presentPopoverAsDialogAnimated:YES
                                                              options:WYPopoverAnimationOptionFadeWithScale];
        }
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
    NSString *urlString = app_url @"PodarApp.svc/GetAdminTeacherList";
    
    //Pass The String to server
    newDatasetinfoAdminTeacherSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",brd_name,@"brd_name",PageNo,@"PageNo",PageSize,@"PageSize",Searchname,@"Name",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminTeacherSMS options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(closebtnclick == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminTeacherList";
        
        //Pass The String to server
        newDatasetinfoAdminTeacherSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",brd_name,@"brd_name",PageNo,@"PageNo",PageSize,@"PageSize",Searchname,@"Name",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminTeacherSMS options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(searchList == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminTeacherList";
        
        //Pass The String to server
        newDatasetinfoAdminTeacherSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",brd_name,@"brd_name",PageNo,@"PageNo",PageSize,@"PageSize",Searchname,@"Name",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminTeacherSMS options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }

    
}
-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    if(firstTime == YES){
        firstTime = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminTeacherSMS options:kNilOptions error:&err];
                
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
                    
                    TeacherSMSStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminTeacherSMSArray = [receivedData objectForKey:@"AdmTechList"];
                    if([TeacherSMSStatus isEqualToString:@"1"]){
                        _AdmTechListItems = [[AdmTechList alloc]init];
                        
                    }
                    else if([TeacherSMSStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_teacherSMSListData reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });

    }
    else if(closebtnclick == YES){
        closebtnclick = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminTeacherSMS options:kNilOptions error:&err];
                
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
                    
                    TeacherSMSStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminTeacherSMSArray = [receivedData objectForKey:@"AdmTechList"];
                    if([TeacherSMSStatus isEqualToString:@"1"]){
                        _AdmTechListItems = [[AdmTechList alloc]init];
                        

                        
                    }
                    else if([TeacherSMSStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_teacherSMSListData reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });


    }
    else if(searchList == YES){
        searchList = NO;
       
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminTeacherSMS options:kNilOptions error:&err];
                
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
                    
                    TeacherSMSStatus = [parsedJsonArray valueForKey:@"Status"];
                    AdminTeacherSMSArray = [receivedData objectForKey:@"AdmTechList"];
                    if([TeacherSMSStatus isEqualToString:@"1"]){
                        _AdmTechListItems = [[AdmTechList alloc]init];
                        
                    }
                    else if([TeacherSMSStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_teacherSMSListData reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });

}

}


- (IBAction)searchBtn:(id)sender {
    if([_enterTeacherName isFirstResponder]){
    [_enterTeacherName resignFirstResponder];
}
    UIButton *checkBoxAll=(UIButton*)sender;
    [self.view endEditing:YES];
    searchList = YES;
    Searchname = _enterTeacherName.text;
    [[NSUserDefaults standardUserDefaults] setObject:checkAll forKey:@"CheckAll"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [arrayForTag removeAllObjects];
    
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox.png"];
    [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    [contactNoArray removeAllObjects];
    checkboxAllClicked = NO;
    individualButtonClicked = NO;
    contactNo = [contactNoArray componentsJoinedByString:@","];
    NSLog(@"conatct id after all det: %@", contactNo);

    [self webserviceCall];
}

- (IBAction)sendSMSBtn:(id)sender {
    if(checkboxAllClicked ==NO && individualButtonClicked == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Teacher" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (selectAll == NO && contactNoArray.count == 0 ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Teacher" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        contactNo = [contactNoArray componentsJoinedByString:@","];
        NSLog(@"all contact id  %@",contactNo);
        
        [[NSUserDefaults standardUserDefaults] setObject:contactNo forKey:@"SelectedContactNo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        AdminSendSMSToTeacherSMSViewController *adminSendSMSToTeacherSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSedSMSToTeacherSMS"];
        
        [self.navigationController pushViewController:adminSendSMSToTeacherSMSViewController animated:YES];
    }

}
- (IBAction)checkAllBtn:(id)sender {
    UIButton *checkBoxAll=(UIButton*)sender;
    checkboxAllClicked = YES;
    individualButtonClicked = NO;
    selectAll= YES;
    UIImage *btnCheckedImage = [UIImage imageNamed:@"smschecked_red_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox.png"];
    
    if(_checkAllClick.isSelected == YES){
        _checkAllClick.selected = NO;
        checkboxAllClicked = NO;
        checkAll = @"0";
        [[NSUserDefaults standardUserDefaults] setObject:checkAll forKey:@"CheckAll"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [arrayForTag removeAllObjects];
        [_checkAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
        [contactNoArray removeAllObjects];
    
        contactNo = [contactNoArray componentsJoinedByString:@","];
        NSLog(@"conatct id after all det: %@", contactNo);
        [_teacherSMSListData reloadData];
    }
    else if(_checkAllClick.isSelected == NO){
        checkAll = @"1";
        [[NSUserDefaults standardUserDefaults] setObject:checkAll forKey:@"CheckAll"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _checkAllClick.selected = YES;
        [_checkAllClick setImage:btnCheckedImage forState:UIControlStateNormal];
        [_teacherSMSListData reloadData];
    }
    

}
- (IBAction)schoolSMSBtn:(id)sender {
    AdminSchoolSMSViewController *adminSchoolSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSchoolSMS"];
    
    [self.navigationController pushViewController:adminSchoolSMSViewController animated:YES];
}

- (IBAction)teacherSMSBtn:(id)sender {
    AdminTeacherSMSViewController *adminTeacherSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminTeacherSMS"];
    
    [self.navigationController pushViewController:adminTeacherSMSViewController animated:YES];
}

- (IBAction)studentSMSBtn:(id)sender {
    AdminStudentSMSViewController *adminStudentSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminStudentSMS"];
    [self.navigationController pushViewController:adminStudentSMSViewController animated:YES];
}
@end
