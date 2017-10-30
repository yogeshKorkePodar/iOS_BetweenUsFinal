//
//  TeacherWriteMessageStudentListViewController.m
//  BetweenUs
//
//  Created by podar on 24/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherWriteMessageStudentListViewController.h"
#import "MsgStudentResult.h"
#import "AdminStudentListTableViewCell.h"
#import "RestAPI.h"
#import "MBProgressHUD.h"

@interface TeacherWriteMessageStudentListViewController ()
{
    UIButton *btn;
    NSIndexPath *path;
    NSInteger *cellRow;
    BOOL firstTime,checkboxAllClicked,checkboxClicked,loginClick,individualButtonClicked,searchStudent,closeBtnClick,selectAll;
    NSDictionary *newDatasetinfoTeacherWriteMessages_studentList,*newDatasetinfoTeacherLogout;
}

@property (nonatomic, strong) MsgStudentResult *MsgStudentResultItems;
@property(nonatomic,strong)   AdminStudentListTableViewCell *cell;

@end

@implementation TeacherWriteMessageStudentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    cls_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"cls_ID"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    cls_ID = [[NSUserDefaults standardUserDefaults]stringForKey:@"class_Id_TeacherWriteMsg"];
    DeviceType= @"IOS";
    self.navigationItem.title = @"Student List";
    self.TeacherwriteMessageStudentTableView.delegate = self;
    self.TeacherwriteMessageStudentTableView.dataSource = self;
    _studentNameTextfield.delegate = self;
    stuIdArray = [[NSMutableArray alloc] init];
    pathArray = [[NSMutableArray alloc] init];
    mystringArray = [[NSMutableArray alloc]init];
    buttonTagsTapped = [[NSMutableArray alloc] init];
    newMyStringArray = [[NSMutableArray alloc] init];
    arrayForTag =  [[NSMutableArray alloc]init];
    
    [_closeView setHidden:YES];
    [_close_click setHidden:YES];
    
    
    UITapGestureRecognizer *tapGestCloseView =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceCloseView)];
    [tapGestCloseView setNumberOfTapsRequired:1];
    [_closeView addGestureRecognizer:tapGestCloseView];
    tapGestCloseView.delegate = self;
    
    UITapGestureRecognizer *tapGestCloseImage =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceCloseView)];
    [tapGestCloseImage setNumberOfTapsRequired:1];
    [_close_click addGestureRecognizer:tapGestCloseImage];
    tapGestCloseImage.delegate = self;
    
    UITapGestureRecognizer *tapGestStudentTextfield =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceStudentTextfield)];
    [tapGestStudentTextfield setNumberOfTapsRequired:1];
    [_studentNameTextfield addGestureRecognizer:tapGestStudentTextfield];
    tapGestStudentTextfield.delegate = self;

    
    [self checkInternetConnectivity];

}


-(void)TextfieldTeacherUsername{
    [_closeView setHidden:NO];
    [_close_click setHidden:NO];
    
}
-(void)screenTappedOnceStudentTextfield{
    [_close_click setHidden:NO];
    [_closeView setHidden:NO];
    
    [self TextfieldTeacherUsername];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"went here ...");
    
    //  if([touch.view isKindOfClass:[UITextField class]]){
    if(touch.view==_studentNameTextfield){
        [_close_click setHidden:NO];
        [_closeView setHidden:NO];
        
        [self TextfieldTeacherUsername];
        
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
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    closeBtnClick = YES;
    _studentNameTextfield.text = @"";
    [_closeView setHidden:YES];
    [_close_click setHidden:YES];
    student_name = @"";
    checkboxAllClicked = NO;
    individualButtonClicked = NO;
    [arrayForTag removeAllObjects];
    [_checkBoxAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    [stuIdArray removeAllObjects];
    stu_id = [stuIdArray componentsJoinedByString:@","];
    NSLog(@"Stu id after all det: %@", stu_id);
    
    [self webserviceCall];
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
    if(firstTime==YES){
        NSString *urlString = @"http://115.124.127.238:8021/PodarApp.svc/GetMessageStudentList";
        
        //Pass The String to server
        newDatasetinfoTeacherWriteMessages_studentList = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",cls_ID,@"cls_id",student_name,@"studentName",pageIndex,@"PageNo",pageSize,@"PageSize",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherWriteMessages_studentList options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    if(closeBtnClick==YES){
        NSString *urlString = @"http://115.124.127.238:8021/PodarApp.svc/GetMessageStudentList";
        
        //Pass The String to server
        newDatasetinfoTeacherWriteMessages_studentList = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",cls_ID,@"cls_id",student_name,@"studentName",pageIndex,@"PageNo",pageSize,@"PageSize",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherWriteMessages_studentList options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    
    else if(loginClick==YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *urlString = @"http://115.124.127.238:8021/PodarApp.svc/LogOut";
        //    newDatasetinfoAdminLogout = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        //Pass The String to server
        newDatasetinfoTeacherLogout= [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",DeviceType,@"DeviceType",DeviceToken,@"DeviceId",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherLogout options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else if (searchStudent == YES){
        NSString *urlString = @"http://115.124.127.238:8021/PodarApp.svc/GetMessageStudentList";
        
        //Pass The String to server
        newDatasetinfoTeacherWriteMessages_studentList = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",cls_ID,@"cls_id",student_name,@"studentName",pageIndex,@"PageNo",pageSize,@"PageSize",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherWriteMessages_studentList options:NSJSONWritingPrettyPrinted error:&error];
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
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherWriteMessages_studentList options:kNilOptions error:&err];
                
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
                    
                    TeacherStudentListStatus = [parsedJsonArray valueForKey:@"Status"];
                    teacherStudentArray = [receivedData objectForKey:@"MsgStudentResult"];
                    if([TeacherStudentListStatus isEqualToString:@"1"]){
                        _MsgStudentResultItems = [[MsgStudentResult alloc]init];
                        
                    }
                    else if([TeacherStudentListStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_TeacherwriteMessageStudentTableView reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    if(closeBtnClick==YES){
        closeBtnClick=NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherWriteMessages_studentList options:kNilOptions error:&err];
                
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
                    
                    TeacherStudentListStatus = [parsedJsonArray valueForKey:@"Status"];
                    teacherStudentArray = [receivedData objectForKey:@"MsgStudentResult"];
                    if([TeacherStudentListStatus isEqualToString:@"1"]){
                        _MsgStudentResultItems = [[MsgStudentResult alloc]init];
                        
                    }
                    else if([TeacherStudentListStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_TeacherwriteMessageStudentTableView reloadData];
                    
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
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherLogout options:kNilOptions error:&err];
                
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
    else  if(searchStudent==YES){
        searchStudent=NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherWriteMessages_studentList options:kNilOptions error:&err];
                
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
                    
                    TeacherStudentListStatus = [parsedJsonArray valueForKey:@"Status"];
                    teacherStudentArray = [receivedData objectForKey:@"MsgStudentResult"];
                    if([TeacherStudentListStatus isEqualToString:@"1"]){
                        _MsgStudentResultItems = [[MsgStudentResult alloc]init];
                        
                    }
                    else if([TeacherStudentListStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_TeacherwriteMessageStudentTableView reloadData];
                    
                    [hud hideAnimated:YES];
                }
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
        if(tableView == _TeacherwriteMessageStudentTableView){
            return [teacherStudentArray count];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
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
        UIImage *btnCheckedImage = [UIImage imageNamed:@"blue_messagechecked_32x32.png"];
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
            if(_checkBoxAllClick.selected == YES){
                NSInteger nSections = [tableView numberOfSections];
                for (int j=0; j<nSections; j++) {
                    NSInteger nRows = [tableView numberOfRowsInSection:j];
                    for (int i=0; i<nRows; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:j];
                        cellRow= indexPath.row;
                        
                        NSString *inStr = [NSString stringWithFormat: @"%ld", cellRow];
                        NSLog(@"Index: %@", inStr);
                        [arrayForTag addObject:inStr];
                        stu_id = [[teacherStudentArray objectAtIndex:cellRow] objectForKey:@"stu_ID"];
                        [stuIdArray addObject:stu_id];
                        NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:stuIdArray];
                        stuIdArray = [[NSMutableArray alloc] initWithArray:[mySet array]];
                        stu_id = [stuIdArray componentsJoinedByString:@","];
                        NSLog(@"Stu id after all selection: %@", stu_id);
                        
                    }
                }
                
                _cell.cellCheckBoxClick.selected = YES;
                [_cell.cellCheckBoxClick setTag:indexPath.row];
                [_cell.cellCheckBoxClick setImage:btnCheckedImage forState:UIControlStateNormal];
                
                
            }
            else if(_checkBoxAllClick.selected == NO){
                _cell.cellCheckBoxClick.selected = YES;
                [_cell.cellCheckBoxClick setTag:indexPath.row];
                [_cell.cellCheckBoxClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
                
            }
        }
        
        //Alternate color to cell
        _cell.rollNoView.layer.cornerRadius = 5;
        _cell.rollNoView.layer.masksToBounds = YES;
        _cell.studentNamelabel.text = [[teacherStudentArray objectAtIndex:indexPath.row] objectForKey:@"Student_Name"];
        _cell.rollNoLabel.text = [[teacherStudentArray objectAtIndex:indexPath.row] objectForKey:@"Roll_No"];
        if (indexPath.row % 2 == 0) {
            _cell.studentNamelabel.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
            _cell.rolNoBgView.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
            _cell.cellCheckBoxClick.backgroundColor = [UIColor colorWithRed:195.0/255.0f green:229.0/255.0f blue:247/255.0f alpha:1.0];
            
        }
        else
        {
            _cell.studentNamelabel.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
            _cell.rolNoBgView.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
            _cell.cellCheckBoxClick.backgroundColor = [UIColor colorWithRed:73.0/255.0f green:157.0/255.0f blue:204/255.0f alpha:1.0];
        }
        
        
        return _cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}


-(void)checkButtonPressed:(id)sender
{
    
    BOOL checked;
    selectAll = NO;
    individualButtonClicked = YES;
    UIButton *checkBox=(UIButton*)sender;
    UIImage *btnCheckedImage = [UIImage imageNamed:@"blue_messagechecked_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    
    path = [NSIndexPath indexPathForRow:checkBox.tag inSection:0];
    stu_id = [[teacherStudentArray objectAtIndex:checkBox.tag] objectForKey:@"stu_ID"];
    
    if ([checkBox.currentImage isEqual:[UIImage imageNamed:@"blue_messagechecked_32x32.png"]]){
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
    //   NSLog(@"After addition  .." ,arrayForTag);
    [stuIdArray addObject:stu_id];
    stu_id = [stuIdArray componentsJoinedByString:@","];
    NSLog(@"Stu ID after add  %@",stu_id);
    
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}
-(void)deleteSelectedCheckBoxTag:(int)value
{
    
    for(int i=0;i<[arrayForTag count];i++)
    {
        if([[arrayForTag objectAtIndex:i] intValue]==value)
            [arrayForTag removeObjectAtIndex:i];
    }
    //  NSLog(@"After deletion  .." ,arrayForTag);
    [stuIdArray removeObject:stu_id];
    stu_id = [stuIdArray componentsJoinedByString:@","];
    NSLog(@"Stu ID after remove  %@",stu_id);
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

- (IBAction)searchStudent:(id)sender {
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    searchStudent = YES;
    student_name = _studentNameTextfield.text;
    checkboxAllClicked = NO;
    individualButtonClicked = NO;
    [arrayForTag removeAllObjects];
    [_checkBoxAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
    [stuIdArray removeAllObjects];
    stu_id = [stuIdArray componentsJoinedByString:@","];
    NSLog(@"Stu id after all det: %@", stu_id);
    
    [self webserviceCall];
}

- (IBAction)sentMessageToStudent:(id)sender {
    
    if(checkboxAllClicked ==NO && individualButtonClicked == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(selectAll == NO && stuIdArray.count == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Student" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        stu_id = [stuIdArray componentsJoinedByString:@","];
        
        NSLog(@"all stu id  %@",stu_id);
        [[NSUserDefaults standardUserDefaults] setObject:stu_id forKey:@"Stud_ID_TeacherMessage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
// yocomment
//        TeacherSendMessageViewController *teacherSendMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherSendMessage"];
//        
//        [self.navigationController pushViewController:teacherSendMessageViewController animated:YES];
// yocomment
    }
    
    
}

- (IBAction)checkAll:(id)sender{
    UIButton *checkBoxAll=(UIButton*)sender;
    checkboxAllClicked = YES;
    individualButtonClicked = NO;
    selectAll = YES;
    UIImage *btnCheckedImage = [UIImage imageNamed:@"blue_messagechecked_32x32.png"];
    UIImage *btnUnCheckedImage = [UIImage imageNamed:@"unchecked_checkbox2.png"];
    
    if(_checkBoxAllClick.isSelected == YES){
        _checkBoxAllClick.selected = NO;
        checkboxAllClicked = NO;
        [arrayForTag removeAllObjects];
        [_checkBoxAllClick setImage:btnUnCheckedImage forState:UIControlStateNormal];
        [stuIdArray removeAllObjects];
        stu_id = [stuIdArray componentsJoinedByString:@","];
        NSLog(@"Stu id after all det: %@", stu_id);
        
        
        [_TeacherwriteMessageStudentTableView reloadData];
    }
    else if(_checkBoxAllClick.isSelected == NO){
        _checkBoxAllClick.selected = YES;
        [_checkBoxAllClick setImage:btnCheckedImage forState:UIControlStateNormal];
        [_TeacherwriteMessageStudentTableView reloadData];
    }
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
