//
//  AdminAnnouncementViewController.m
//  BetweenUs
//
//  Created by podar on 14/09/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "AdminAnnouncementViewController.h"
#import "MBProgressHUD.h"
#import "AnnouncementResult2.h"
#import "AdminProfileViewController.h"
#import "RestAPI.h"
#import "CCKFNavDrawer.h"
#import "LoginViewController.h"
#import "ChangePassswordViewController.h"
#import "AdminAnnouncementTableViewCell2.h"
#import "WYPopoverController.h"
#import "AboutUsViewController.h"
#import "AdminViewMessageViewController.h"
#import "AdminUpdateAnnouncementViewController.h"
#import "AdminSchoolSMSViewController.h"
#import"NYAlertViewController.h"
#import "NYAlertView.h"
#import "CustomIOSAlertView.h"
#import "NavigationMenuButton.h"


@interface AdminAnnouncementViewController (){

    NSDictionary *newDatasetinfoAdminAnnouncement;
    NSDictionary *newDatasetinfoAdminLogout,*newDatasetinfoAdminUpdateAnnouncement,*newDatasetinfoAdminAddAnnouncement;
    BOOL announcementFirstTime,loginClick,updateClick,addAnnouncement;
    WYPopoverController *settingsPopoverController;
    UIAlertView *alertsubject;
    NSString *msg_id,*fulldate,*date,*formatedDate;
    NSString *old_announcement;
    NSArray *dateitems;
    UITextView *textView,*updateAnnouncementTextView,*addAnnouncementTextview;
}

//- (IBAction)open:(id)sender;
- (void)close:(id)sender;
@property (nonatomic, strong) AnnouncementResult2 *AnnouncementResultItems;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@end
 @interface NYAlertTextView : UITextView
@end
@implementation AdminAnnouncementViewController

@synthesize usl_id,clt_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    announcementFirstTime = YES;
    //Hide back button
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.title = @"Announcements";
    self.admin_announcement_tableview.dataSource = self;
    self.admin_announcement_tableview.delegate = self;
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];

    DeviceType= @"IOS";

    self.admin_announcement_tableview.estimatedRowHeight = 500.0; // put max you expect here.
    self.admin_announcement_tableview.rowHeight = UITableViewAutomaticDimension;
    //Add drawer image button
    UIImage *faceImage = [UIImage imageNamed:@"drawer_icon.png"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake( 15, 0, 15, 15 );
    UITapGestureRecognizer *tapdrawer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrawerAdminAnnouncement)];
    [tapdrawer setNumberOfTapsRequired:1];
    [face addGestureRecognizer:tapdrawer];
    tapdrawer.delegate = self;
    
    [face addTarget:self action:@selector(handleDrawerAdminAnnouncement) forControlEvents:UIControlEventTouchUpInside];
    [face setImage:faceImage forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:face];
    self.navigationItem.leftBarButtonItem = backButton;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setBackBarButtonItem:nil];
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self checkInternetConnectivity];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];

    
    UITapGestureRecognizer *tapGestSMS =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceAddAnnouncement)];
    [tapGestSMS setNumberOfTapsRequired:1];
    [_add_announcement_view addGestureRecognizer:tapGestSMS];
    tapGestSMS.delegate = self;


}
-(void)handleDrawerAdminAnnouncement{
    [self.rootNav drawerToggle];
}

-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)screenTappedOnceAddAnnouncement{
    addAnnouncement = YES;
    
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc]init];
    if([device isEqualToString:@"iphone"]){
        [alert setContainerView:[self createDemoViewIphone]];

    }
    else{
    [alert setContainerView:[self createDemoView]];
    }
    // Modify the parameters
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"Add", @"Cancel", nil]];
    [alert setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alert setUseMotionEffects:true];
    
   //  And launch the dialog
    [alert show];
    

}

-(void)webserviceCall{
    if(announcementFirstTime==YES){
    
    NSString *urlString = app_url @"PodarApp.svc/GetTeacherAnnouncement";
    
    //Pass The String to server
    newDatasetinfoAdminAnnouncement = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminAnnouncement options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServer:urlString jsonString:jsonInputString];

    }
    else if(updateClick == YES){
        NSString *urlString = app_url @"PodarApp.svc/UpdateAdminAnnoucement";
        
        //Pass The String to server
        newDatasetinfoAdminUpdateAnnouncement = [NSDictionary dictionaryWithObjectsAndKeys:msg_id,@"msg_Id",newAnnouncement,@"message",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminUpdateAnnouncement options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(addAnnouncement == YES){
        NSString *urlString = app_url @"PodarApp.svc/AddAdminAnnoucement";
        
        //Pass The String to server
        newDatasetinfoAdminAddAnnouncement = [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",clt_id,@"clt_id",newAnnouncement,@"message",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminAddAnnouncement options:NSJSONWritingPrettyPrinted error:&error];
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
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminAnnouncement options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];

    }
}

-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    if(announcementFirstTime==YES){
        announcementFirstTime = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
    NSError *err;
    NSData* responseData = nil;
    NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    responseData = [NSMutableData data] ;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminAnnouncement options:kNilOptions error:&err];
    
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
    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
    announcementStatus = [parsedJsonArray valueForKey:@"Status"];
    adminAnnoucementArray = [receivedData valueForKey:@"AnnouncementResult"];
    NSLog(@"Status:%@",announcementStatus);
    
    if([announcementStatus isEqualToString:@"1"]){
        [self.admin_announcement_tableview setHidden:NO];
        for(int n = 0; n < [adminAnnoucementArray  count]; n++)
        {
            _AnnouncementResultItems = [[AnnouncementResult2 alloc]init];
            announcemntdetailsdictionry = [adminAnnoucementArray objectAtIndex:n];
            _AnnouncementResultItems.msg_date =[announcemntdetailsdictionry objectForKey:@"msg_date"];
            _AnnouncementResultItems.msg_Message = [announcemntdetailsdictionry objectForKey:@"msg_Message"];
            NSLog(@"Announcement msg:%@", _AnnouncementResultItems.msg_Message);
            // [cellBehaviourCount:%lu",(unsigned long)[behaviourdetails count]);
        }

    
    }
    else{
        [self.admin_announcement_tableview setHidden:YES];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
     [self.admin_announcement_tableview reloadData];
      [hud hideAnimated:YES];      
        });
    });
    }
    else if(updateClick == YES){
        updateClick = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminUpdateAnnouncement options:kNilOptions error:&err];
                
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
                //  NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                UpdateStatus = [parsedJsonArray valueForKey:@"Status"];
                //   adminAnnoucementArray = [receivedData valueForKey:@"AnnouncementResult"];
                NSLog(@"Status:%@",UpdateStatus);
                
                if([UpdateStatus isEqualToString:@"1"]){
                    NSLog(@"got response==%@", @"Updated" );
                    announcementFirstTime= YES;
                    [self webserviceCall];
                    
                }
                
                [hud hideAnimated:YES];
            });
        });

    }
    else if(addAnnouncement == YES){
        addAnnouncement = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminAddAnnouncement options:kNilOptions error:&err];
                
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
                //  NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                AddStatus = [parsedJsonArray valueForKey:@"Status"];
                //   adminAnnoucementArray = [receivedData valueForKey:@"AnnouncementResult"];
                NSLog(@"Status:%@",AddStatus);
                
                if([AddStatus isEqualToString:@"1"]){
                    NSLog(@"got response==%@", @"Updated" );
                    announcementFirstTime= YES;
                    [self webserviceCall];
                    
                }
                
                [hud hideAnimated:YES];
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
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [adminAnnoucementArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      static NSString *simpleTableIdentifier = @"AdminAnnouncementTableView";
    
    AdminAnnouncementTableViewCell2 *cell = (AdminAnnouncementTableViewCell2 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdminAnnouncementTableViewCell2" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.label_announcement.text = [[adminAnnoucementArray objectAtIndex:indexPath.row] objectForKey:@"msg_Message"];
    fulldate = [[adminAnnoucementArray objectAtIndex:indexPath.row] objectForKey:@"msg_date"];
    
    dateitems = [fulldate componentsSeparatedByString:@" "];
    date = dateitems[0];
    
    
    NSLog(@"firstdate==%@", date);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"MM/dd/yyyy";
    
    NSDate *yourDate = [dateFormat dateFromString:date];
    
    NSLog(@"your date%@",yourDate);
    dateFormat.dateFormat = @"dd-MMM-yyyy";
    NSLog(@"formated date%@",[dateFormat stringFromDate:yourDate]);
    formatedDate = [dateFormat stringFromDate:yourDate];
    
    cell.announcement_date.text = formatedDate;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    announcementFirstTime = NO;
    old_announcement =[[adminAnnoucementArray objectAtIndex:indexPath.row]objectForKey:@"msg_Message"];
    
    [[NSUserDefaults standardUserDefaults] setObject:old_announcement forKey:@"old_announcement"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_updateAnnouncementController.update_announcement_textview setText:old_announcement];
    
    msg_id =[[adminAnnoucementArray objectAtIndex:indexPath.row]objectForKey:@"msg_ID"];
    [[NSUserDefaults standardUserDefaults] setObject:msg_id forKey:@"msg_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Old Announcemnt:%@",old_announcement);
    NSLog(@"msg_id:%@",msg_id);
//    UIAlertView *testAlert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@""
//                                                       delegate:self
//                                              cancelButtonTitle:@"Cancel"
//                                              otherButtonTitles:@"Update", nil];
//    UIAlertView *tes = [[UIAlertView alloc] init];
//    tes.delegate = self;
//    
//    UIButton *title = [UIButton new];
//  [title setTitle:@"+ Add Announcement" forState:UIControlStateNormal];
//    [title setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    title.backgroundColor = [UIColor redColor];
//    textView = [UITextView new];
//    textView.scrollEnabled = NO;
//    textView.delegate = self;
// 
//    textView.text= old_announcement;
//      [textView setFont: [textView.font fontWithSize: 14.0]];
//    
//        [testAlert setValue: textView forKey:@"accessoryView"];
//      [testAlert setValue: title forKey:@"accessoryView"];
//    
//    [testAlert show];
    

    
    
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc]init];
    if([device isEqualToString:@"iphone"]){
          [alert setContainerView:[self createDemoViewIphone]];
    }
    else if([device isEqualToString:@"ipad"]){
          [alert setContainerView:[self createDemoView]];
    }
  
    // Modify the parameters
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"Update", @"Cancel", nil]];
    [alert setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alert setUseMotionEffects:true];
    
    // And launch the dialog
    [alert show];
    
    //   [self showpopover];
    
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if(buttonIndex == 0){
        if(addAnnouncement == NO){
        updateClick = YES;
        newAnnouncement = updateAnnouncementTextView.text;
            if([newAnnouncement isEqualToString:@""]){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Announcement can not be blank" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else{
        NSLog(@"NEw Anno:%@",newAnnouncement);
        [self webserviceCall];
            }
        }
        else if(addAnnouncement == YES){
            newAnnouncement = updateAnnouncementTextView.text;
            if([newAnnouncement isEqualToString:@""]){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Announcement can not be blank" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else {
                [self webserviceCall];
            }
            
        }
    }
    [alertView close];
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 490, 300)];

    UILabel *plusSign = [[UILabel alloc]initWithFrame:CGRectMake(135, 0, 30, 40)];
    plusSign.backgroundColor= [UIColor colorWithRed:0.0/255.0f green:130.0/255.0f blue:156.0/255.0f alpha:1.0];
    plusSign.font=[UIFont boldSystemFontOfSize:25];
    plusSign.text = @"+";
    plusSign.textAlignment = NSTextAlignmentCenter;
    plusSign.textColor = [UIColor whiteColor];
    
    
    UILabel *rateLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,490, 45)];
    rateLbl.backgroundColor= [UIColor colorWithRed:0.0/255.0f green:130.0/255.0f blue:156.0/255.0f alpha:1.0];
    rateLbl.font=[UIFont boldSystemFontOfSize:15];
    if(addAnnouncement == NO){
    rateLbl.text=@"Update Announcement";
    }
    else if(addAnnouncement== YES){
          rateLbl.text=@"Add Announcement";
    }
    rateLbl.textColor = [UIColor whiteColor];
    rateLbl.textAlignment = NSTextAlignmentCenter;
   // [rateLbl setCenter:demoView.center];
    
    updateAnnouncementTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 45, 490, 260)];
    updateAnnouncementTextView.backgroundColor=[UIColor whiteColor];
    [updateAnnouncementTextView setFont:[UIFont systemFontOfSize:16]];
    updateAnnouncementTextView.text = old_announcement;
    updateAnnouncementTextView.delegate = self;
    
    [demoView addSubview:rateLbl];
    [demoView addSubview:updateAnnouncementTextView];
    [demoView addSubview:plusSign];
    
    
    return demoView;
}

- (UIView *)createDemoViewIphone
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    UILabel *plusSign = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 26, 40)];
    plusSign.backgroundColor= [UIColor colorWithRed:0.0/255.0f green:130.0/255.0f blue:156.0/255.0f alpha:1.0];
    plusSign.font=[UIFont boldSystemFontOfSize:23];
    plusSign.text = @"+";
    plusSign.textAlignment = NSTextAlignmentCenter;
    plusSign.textColor = [UIColor whiteColor];
    
    
    UILabel *rateLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,290, 45)];
    rateLbl.backgroundColor= [UIColor colorWithRed:0.0/255.0f green:130.0/255.0f blue:156.0/255.0f alpha:1.0];
    rateLbl.font=[UIFont boldSystemFontOfSize:14];
    if(addAnnouncement == NO){
        rateLbl.text=@"Update Announcement";
    }
    else if(addAnnouncement== YES){
        rateLbl.text=@"Add Announcement";
    }
    rateLbl.textColor = [UIColor whiteColor];
    rateLbl.textAlignment = NSTextAlignmentCenter;
    // [rateLbl setCenter:demoView.center];
    
    updateAnnouncementTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 45, 290, 160)];
    updateAnnouncementTextView.backgroundColor=[UIColor whiteColor];
    [updateAnnouncementTextView setFont:[UIFont systemFontOfSize:15]];
    updateAnnouncementTextView.text = old_announcement;
    updateAnnouncementTextView.delegate = self;
    
    [demoView addSubview:rateLbl];
    [demoView addSubview:updateAnnouncementTextView];
    [demoView addSubview:plusSign];
    
    
    return demoView;
}
- (void)willPresentAlertView:(UIAlertView *)alertView {
    [alertView setFrame:CGRectMake(5, 20, 800, 920)];
    alertView.center = CGPointMake(320 / 2, 480 / 2);
}

-(BOOL)textView:(UITextView*)textView shouldChangeCharactersInRange:(NSRange)range replacementText:(NSString*)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else
        return YES;
}


- (void)showpopover
{
    if (settingsPopoverController == nil)
    {
    //    UIView *btn = (UIView *)sender;
        
        _updateAnnouncementController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminUpdateAnnouncement"];
        if([device isEqualToString:@"iphone"]){
            _updateAnnouncementController.preferredContentSize = CGSizeMake(320, 300);
        }
        else if([device isEqualToString:@"ipad"]){
             _updateAnnouncementController.preferredContentSize = CGSizeMake(520, 520);
        }
              _updateAnnouncementController.modalInPopover = NO;
        
            UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:_updateAnnouncementController];
        
            [contentViewController setNavigationBarHidden:YES];
        
            settingsPopoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
            settingsPopoverController.delegate = self;
        
            settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            settingsPopoverController.wantsDefaultContentAppearance = NO;
            [settingsPopoverController presentPopoverAsDialogAnimated:YES
                                                              options:WYPopoverAnimationOptionFadeWithScale];
        
        [_updateAnnouncementController.cancel_click addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    else
    {
        [self close:nil];
    }
}

-(void)cancelBtn:(id)sender
{
      NSLog(@"The iButtton.");
      UIButton *cancel=(UIButton*)sender;
    
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == settingsPopoverController)
    {
        settingsPopoverController.delegate = nil;
        settingsPopoverController = nil;
    }
}
- (void)cancel:(id)sender
{
    [settingsPopoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:settingsPopoverController];
    }];
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
            self.internetActiveViewMessage = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActiveViewMessage = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActiveViewMessage = YES;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActiveViewMessage = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActiveViewMessage = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActiveViewMessage = YES;
            
            break;
        }
    }
    if(self.internetActiveViewMessage == YES){
        
        [self webserviceCall];
    }
    
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}




@end
