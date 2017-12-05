//
//  AdminStudentSMSViewController.m
//  BetweenUs
//
//  Created by podar on 13/10/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"

#import "AdminStudentSMSViewController.h"
#import "AdminStudentSMSViewController.h"
#import "AdminSchoolSMSDirectViewController.h"
#import "WYPopoverController.h"
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
#import "AdminStudentSMSStudentListViewController.h"
#import "AdminTeacherSMSViewController.h"
@interface AdminStudentSMSViewController (){
    BOOL loginClick,firstTime,closeBtnClick,academicYear,academicYearSelected,firstTimeList,ListSearch;
    WYPopoverController *settingsPopoverController;
    NSDictionary *newDatasetinfoAdminStudentSMS_academicYear,*newDatasetinfoAdminStudentlSMS,*newDatasetinfoAdminLogout;
    UIAlertView *alertcycle;
    UITableView *academicYearTaleView;
    UITapGestureRecognizer *tapGestureTextfield;
}


@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (nonatomic, strong) AcedmicYearResult *AcedemicYearItems;
@property (nonatomic, strong) AdminDropResult *AdminDropResultItems;

@end

@implementation AdminStudentSMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    firstTime = YES;
    searchKey =@"";
    searchValue = @"";
    DeviceType= @"IOS";
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
   
    self.StudentSMSList.delegate = self;
    self.StudentSMSList.dataSource = self;
    _searchKey.delegate = self;
    [_searchView setHidden:YES];
    _topConstraintToAcademicYearView.constant = 0;
    [_closeClick setHidden:YES];
    
    clsIDArraySMS = [[NSMutableArray alloc]init];
    
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
    
       
    

    UITapGestureRecognizer *tapGestStudentSMS =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceStudentSMS)];
    [tapGestStudentSMS setNumberOfTapsRequired:1];
    [_studentSMSClick addGestureRecognizer:tapGestStudentSMS];
    tapGestStudentSMS.delegate = self;
    
    UITapGestureRecognizer *tapGestAcademicYearDropDownView =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceDopDownView)];
    [tapGestAcademicYearDropDownView setNumberOfTapsRequired:1];
    [_dropdowImg addGestureRecognizer:tapGestAcademicYearDropDownView];
    tapGestAcademicYearDropDownView.delegate = self;

    tapGestureTextfield =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextfieldAdminUsername)];
    [tapGestureTextfield setNumberOfTapsRequired:1];
    [_searchKey addGestureRecognizer:tapGestureTextfield];
    tapGestureTextfield.delegate = self;

    [self checkInternetConnectivity];

}
-(void)handleDrawer{
    [self.rootNav drawerToggle];
}
-(void)screenTappedOnceStudentSMS{
    AdminStudentSMSViewController *adminStudentSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminStudentSMS"];
    [self.navigationController pushViewController:adminStudentSMSViewController animated:YES];
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

-(void)TextfieldAdminUsername{
    [_closeClick setHidden:NO];
}
-(void)TextfieldAdminUsernameCloseButton{
    _searchKey.text = @"";
    searchValue = @"";
    closeBtnClick = YES;
    [self webserviceCall];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"went here ...");
    
    //  if([touch.view isKindOfClass:[UITextField class]]){
    if(touch.view==_searchKey){
        [_closeClick setHidden:NO];
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
-(void)webserviceCall{
    if(firstTime==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminAcedmicYearList";
        
        //Pass The String to server
        newDatasetinfoAdminStudentSMS_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminStudentSMS_academicYear options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        
    }
    else if(academicYear==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminAcedmicYearList";
        
        //Pass The String to server
        newDatasetinfoAdminStudentSMS_academicYear = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminStudentSMS_academicYear options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(firstTimeList==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminStudentlSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminStudentlSMS options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(academicYearSelected == YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminStudentlSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminStudentlSMS options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(ListSearch==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminStudentlSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminStudentlSMS options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(closeBtnClick==YES){
        NSString *urlString = app_url @"PodarApp.svc/GetAdminSMSDropDtls";
        
        //Pass The String to server
        newDatasetinfoAdminStudentlSMS = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",searchKey,@"SearchKey",searchValue,@"SearchValue",selectedAcademicYearId,@"acy_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminStudentlSMS options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(loginClick==YES){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"usl_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *urlString = app_url @"PodarApp.svc/LogOut";
        //    newDatasetinfoAdminLogout = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
        
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
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminStudentSMS_academicYear options:kNilOptions error:&err];
                
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
                    
                    AcademiYearStatus = [parsedJsonArray valueForKey:@"Status"];
                    AcademicYearTableData = [receivedData objectForKey:@"AcedmicYearResult"];
                    if([AcademiYearStatus isEqualToString:@"1"]){
                        _AcedemicYearItems = [[AcedmicYearResult alloc]init];
                        academicYearDetails = [AcademicYearTableData objectAtIndex:0];
                        firstTimeList = YES;
                        selectedAcademicYearId =[academicYearDetails objectForKey:@"acy_id"];
                        currentacademicYear = [academicYearDetails objectForKey:@"acy_Year"];
                        
                        [_academicYearClick setTitle:currentacademicYear forState:UIControlStateNormal];
                        [self webserviceCall];
                    }
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if(academicYear ==YES){
        academicYear=NO;
    }
    else if(firstTimeList == YES){
        firstTimeList = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminStudentlSMS options:kNilOptions error:&err];
                
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
                    
                    studentlListStatus = [parsedJsonArray valueForKey:@"Status"];
                    StudentListData = [receivedData objectForKey:@"AdminDropResult"];
                    if([studentlListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([studentlListStatus isEqualToString:@"0"]){
                        [_StudentSMSList setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_StudentSMSList reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
        
    }
    else if(academicYearSelected == YES){
        academicYearSelected = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminStudentlSMS options:kNilOptions error:&err];
                
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
                    
                    studentlListStatus = [parsedJsonArray valueForKey:@"Status"];
                    StudentListData = [receivedData objectForKey:@"AdminDropResult"];
                    if([studentlListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([studentlListStatus isEqualToString:@"0"]){
                        [_StudentSMSList setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [_StudentSMSList reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
        
    }
    else if(ListSearch == YES){
        ListSearch = NO;
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminStudentlSMS options:kNilOptions error:&err];
                
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
                    
                    studentlListStatus = [parsedJsonArray valueForKey:@"Status"];
                    StudentListData = [receivedData objectForKey:@"AdminDropResult"];
                    if([studentlListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([studentlListStatus isEqualToString:@"0"]){
                        //   [_studentTableView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [_StudentSMSList reloadData];
                    
                    [hud hideAnimated:YES];
                }
            });
        });
        
        
    }
    else if(closeBtnClick == YES){
        closeBtnClick = NO;
        [_closeClick setHidden:YES];
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminStudentlSMS options:kNilOptions error:&err];
                
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
                    
                    studentlListStatus = [parsedJsonArray valueForKey:@"Status"];
                    StudentListData = [receivedData objectForKey:@"AdminDropResult"];
                    if([studentlListStatus isEqualToString:@"1"]){
                        
                    }
                    else if([studentlListStatus isEqualToString:@"0"]){
                        [_StudentSMSList setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [_StudentSMSList reloadData];
                    
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

- (IBAction)AcademicYearBtn:(id)sender {
    alertcycle = [[UIAlertView alloc] initWithTitle:@"Academic Year"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:(NSString *)nil];
    if(self.internetActive == YES){
        
        academicYear = YES;
        [self webserviceCall];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    academicYearTaleView = [[UITableView alloc] init];
    academicYearTaleView.delegate = self;
    academicYearTaleView.dataSource = self;
    [alertcycle setValue:academicYearTaleView forKey:@"accessoryView"];
    [alertcycle show];
}
-(void)screenTappedOnceDopDownView{
    alertcycle = [[UIAlertView alloc] initWithTitle:@"Academic Year"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:(NSString *)nil];
    if(self.internetActive == YES){
        
        academicYear = YES;
        [self webserviceCall];
    }
    else if(self.internetActive == NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    academicYearTaleView = [[UITableView alloc] init];
    academicYearTaleView.delegate = self;
    academicYearTaleView.dataSource = self;
    [alertcycle setValue:academicYearTaleView forKey:@"accessoryView"];
    [alertcycle show];
}

- (IBAction)searchByBtn:(id)sender {
    if(_searchView.isHidden==YES){
        [_searchView setHidden:NO];
        _topConstraintToAcademicYearView.constant=62;
    }
    else{
        [_searchView setHidden:YES];
        _topConstraintToAcademicYearView.constant=0;
    }

}

- (IBAction)selectAllBtn:(id)sender {
    selectAllClicked = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:selectAllClicked forKey:@"SelectAll"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    for(int n = 0; n < [StudentListData  count]; n++)
    {
        _AdminDropResultItems= [[AdminDropResult alloc]init];
        AdminStudentSMSDetails = [StudentListData
                          objectAtIndex:n];
        _AdminDropResultItems.cls_ID = [AdminStudentSMSDetails objectForKey:@"cls_ID"];
        cls_id = _AdminDropResultItems.cls_ID;
        [clsIDArraySMS addObject:cls_id];
        cls_id = [clsIDArraySMS componentsJoinedByString:@","];
        NSLog(@"Cls id: %@", cls_id);
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:cls_id forKey:@"StudentSMScls_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:cls_id forKey:@"StudentSMScls_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    AdminStudentSMSStudentListViewController *adminStudentSMSStudentListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminStudentSMSStudentList"];
    
    [self.navigationController pushViewController:adminStudentSMSStudentListViewController animated:YES];
    
}

- (IBAction)shiftBtn:(id)sender {
    _shiftClick.selected = YES;
    searchKey = @"Shift";
    UIImage *btnOnImage = [UIImage imageNamed:@"radio-on.png"];
    UIImage *btnOffImage = [UIImage imageNamed:@"radio-off.png"];
    [_shiftClick setImage:btnOnImage forState:UIControlStateNormal];
    [_stdClick setImage:btnOffImage forState:UIControlStateNormal];
    [_sectionClick setImage:btnOffImage forState:UIControlStateNormal];
}
- (IBAction)sectionBtn:(id)sender {
    _sectionClick.selected = YES;
    searchKey = @"Section";
    UIImage *btnOnImage = [UIImage imageNamed:@"radio-on.png"];
    UIImage *btnOffImage = [UIImage imageNamed:@"radio-off.png"];
    [_sectionClick setImage:btnOnImage forState:UIControlStateNormal];
    [_stdClick setImage:btnOffImage forState:UIControlStateNormal];
    [_shiftClick setImage:btnOffImage forState:UIControlStateNormal];

}
- (IBAction)StdBtn:(id)sender {
    _stdClick.selected = YES;
    searchKey = @"Std";
    UIImage *btnOnImage = [UIImage imageNamed:@"radio-on.png"];
    UIImage *btnOffImage = [UIImage imageNamed:@"radio-off.png"];
    [_stdClick setImage:btnOnImage forState:UIControlStateNormal];
    [_sectionClick setImage:btnOffImage forState:UIControlStateNormal];
    [_shiftClick setImage:btnOffImage forState:UIControlStateNormal];
}
- (IBAction)closeBtn:(id)sender {
    [self TextfieldAdminUsernameCloseButton];
}
- (IBAction)searchResult:(id)sender {
    if([_searchKey isFirstResponder]){
        [_searchKey resignFirstResponder];
    }
    [self.view endEditing:YES];
    searchValue = _searchKey.text;
    NSLog(@"Value: %@", searchValue);
    if(_shiftClick.selected==NO && _sectionClick.selected==NO && _stdClick.selected ==NO){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Select Search Key" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if([searchValue isEqualToString:@""]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Search Key" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(_shiftClick.selected==YES && [searchValue isEqualToString:@""]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Search Key" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(_sectionClick.selected==YES &&  [searchValue isEqualToString:@""]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Search Key" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(_stdClick.selected==YES &&  [searchValue isEqualToString:@""]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Search Key" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if(_shiftClick.selected == YES &&  ![searchValue isEqualToString:@""]){
        ListSearch = YES;
        [self webserviceCall];
    }
    else if(_sectionClick.selected == YES &&  ![searchValue isEqualToString:@""]){
        ListSearch = YES;
        [self webserviceCall];
    }
    else if(_stdClick.selected == YES &&  ![searchValue isEqualToString:@""]){
        ListSearch = YES;
        [self webserviceCall];
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    @try {
        if(tableView == academicYearTaleView){
            return [AcademicYearTableData count];
        }
        else if(tableView == _StudentSMSList){
            return [StudentListData count];
        }
       
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if(tableView==academicYearTaleView){
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
                
                
                [cell.textLabel setFont: [cell.textLabel.font fontWithSize: 14]];
                acy_year= [[AcademicYearTableData objectAtIndex:indexPath.row] objectForKey:@"acy_Year"];
                cell.textLabel.text = acy_year;
            }
            return cell;
        }
        else if(tableView == _StudentSMSList){
            
            static NSString *simpleTableIdentifier = @"WriteMessageStudentTableViewCell";
            
            WriteMessageStudentTableViewCell *cell = (WriteMessageStudentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WriteMessageStudentTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            cell.shift_label.text = [[StudentListData objectAtIndex:indexPath.row] objectForKey:@"sft_name"];
            cell.section_label.text = [[StudentListData objectAtIndex:indexPath.row] objectForKey:@"sec_Name"];
            
            std_name =[[StudentListData objectAtIndex:indexPath.row] objectForKey:@"std_Name"];
            div_name = [[StudentListData objectAtIndex:indexPath.row] objectForKey:@"div_name"];
            cell.std_label.text = [NSString stringWithFormat:@"%@-%@",std_name,div_name];
            // cell.std_label.text = [[StudentTableData objectAtIndex:indexPath.row] objectForKey:@"std_Name"];
            
            if (indexPath.row % 2 == 0) {
                cell.shift_label.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:229.0/255.0f blue:222/255.0f alpha:1.0];
                cell.section_label.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:229.0/255.0f blue:222/255.0f alpha:1.0];
                cell.std_label.backgroundColor =[UIColor colorWithRed:255.0/255.0f green:229.0/255.0f blue:222/255.0f alpha:1.0];
                
                
            }
            else
            {
                cell.shift_label.backgroundColor = [UIColor colorWithRed:244.0/255.0f green:202.0/255.0f blue:190/255.0f alpha:1.0];
                cell.section_label.backgroundColor = [UIColor colorWithRed:244.0/255.0f green:202.0/255.0f blue:190/255.0f alpha:1.0];
                cell.std_label.backgroundColor =[UIColor colorWithRed:244.0/255.0f green:202.0/255.0f blue:190/255.0f alpha:1.0];
                
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
    if(tableView == _StudentSMSList){
        return 35;
    }
    else{
        return 30;
    }
    
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == academicYearTaleView){
        [alertcycle dismissWithClickedButtonIndex:0 animated:YES];
        
        selectedAcademicYearId = [[AcademicYearTableData objectAtIndex:indexPath.row] objectForKey:@"acy_id"];
        selectedAcademicYear  = [[AcademicYearTableData objectAtIndex:indexPath.row] objectForKey:@"acy_Year"];
        [_academicYearClick setTitle:selectedAcademicYear forState:UIControlStateNormal];
        academicYearSelected = YES;
        [self webserviceCall];
        NSLog(@"SelectedcycleTEST:%@",selectedAcademicYear);
    }
    else if(tableView == _StudentSMSList){
        selectAllClicked = @"0";
        
        [[NSUserDefaults standardUserDefaults] setObject:selectAllClicked forKey:@"SelectAll"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        cls_id  = [[StudentListData objectAtIndex:indexPath.row] objectForKey:@"cls_ID"];
        selectedShiftname= [[StudentListData objectAtIndex:indexPath.row] objectForKey:@"sft_name"];
        selected_sectionName= [[StudentListData objectAtIndex:indexPath.row] objectForKey:@"sec_Name"];
        
        std_name =[[StudentListData objectAtIndex:indexPath.row] objectForKey:@"std_Name"];
        div_name = [[StudentListData objectAtIndex:indexPath.row] objectForKey:@"div_name"];
        selected_std= [NSString stringWithFormat:@"%@-%@",std_name,div_name];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myString"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"btnTapped"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Array"];
        
        [[NSUserDefaults standardUserDefaults] setObject:cls_id forKey:@"StudentSMScls_ID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:selected_std forKey:@"SelectedStdStudentSMS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:selected_sectionName forKey:@"SelectedSectionNameStudentSMS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:selectedShiftname forKey:@"SelectedShiftNameStudentSMS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
       AdminStudentSMSStudentListViewController *adminStudentSMSStudentListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminStudentSMSStudentList"];
        
        [self.navigationController pushViewController:adminStudentSMSStudentListViewController animated:YES];
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
@end
