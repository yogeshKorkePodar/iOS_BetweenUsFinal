//
//  CCKFNavDrawer.m
//  CCKFNavDrawer
//
//  Created by calvin on 23/1/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.
//

#import "CCKFNavDrawer.h"
#import "DrawerView.h"
#import "NavTableViewCell.h"
#import "StudentDashboardWithoutSibling.h"
#import "RestAPI.h"
#import "DrawerIphoneTableViewCell.h"
#import "stundentListDetails.h"

#define SHAWDOW_ALPHA 0.5
#define MENU_DURATION 0.3
#define MENU_TRIGGER_VELOCITY 350

@interface CCKFNavDrawer (){
    NSArray *drawerlabelData;
    NSString *username;
    NSString *password;
    NSMutableArray *drawerImage;
    NSString *loginStatus;
    NSString *studentProfileStatus;
    NSString *clt_id;
    NSString *usl_id;
    NSString *msd_id;
    NSString *div_name;
    NSString *sft_name;
    NSString *std_Name;
    NSString *teacherClassStdDiv;
    NSString *drawerName;
    NSString *drawerStd;
    NSString *drawerRollNo;
    NSString *drawerAcademicYear;
    NSString *isStudentResourcePresent;
    NSString *roll_id,*teachershiftstdDiv,*classTeacher;
    
    NSString *arraycount;
    BOOL firstTime;
    
}
@property (nonatomic) BOOL drawer_flag;
@property (nonatomic) BOOL isOpen;
@property (nonatomic) float meunHeight;
@property (nonatomic) float menuWidth;
@property (nonatomic) CGRect outFrame;
@property (nonatomic) CGRect inFrame;
@property (strong, nonatomic) UIView *shawdowView;
@property (strong, nonatomic) DrawerView *drawerView;

@property (nonatomic, strong) stundentListDetails *stundentListDetails;
@property (nonatomic, strong) stundentListDetails *item;
@property (nonatomic, strong) RestAPI *restApi;

@end

@implementation CCKFNavDrawer

#pragma mark - VC lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        NSLog(@"connection Unavailable");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet Connection!" message:@"Please make sure your device is connected to internet." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    //[self checkInternetConnectivity];
    firstTime = YES;
   
    if(UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPad){
        NSLog(@"<< ipad detected");
        device = @"ipad";
    }else if (UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPhone){
        NSLog(@"<< iphone detected");
        device = @"iphone";
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:device forKey:@"device"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    
    if([device isEqualToString:@"ipad"]){
        //_drawerView.bottonConstraintDrawerTableView.constant = 320;
    }
    else if([device isEqualToString:@"iphone"]){
        //_drawerView.bottonConstraintDrawerTableView.constant = 450;
    }

    [self setUpDrawer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.drawerView.drawerTableView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - push & pop

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    // disable gesture in next vc
    [self.pan_gr setEnabled:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    // enable gesture in root vc
    if ([self.viewControllers count]==1){
        [self.pan_gr setEnabled:YES];
    }
    return vc;
}

#pragma mark - drawer

- (void)setUpDrawer
{
    self.isOpen = NO;
    
    // load drawer view
    self.drawerView = [[[NSBundle mainBundle] loadNibNamed:@"DrawerView" owner:self options:nil] objectAtIndex:0];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.meunHeight = screenHeight;
    //self.meunHeight = self.drawerView.frame.size.height;
    self.menuWidth = self.drawerView.frame.size.width;
    self.outFrame = CGRectMake(-self.menuWidth,0,self.menuWidth,self.meunHeight);
    self.inFrame = CGRectMake (0,0,self.menuWidth,self.meunHeight);
    
    // drawer shawdow and assign its gesture
    self.shawdowView = [[UIView alloc] initWithFrame:self.view.frame];
    self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.shawdowView.hidden = YES;
    UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapOnShawdow:)];
    [self.shawdowView addGestureRecognizer:tapIt];
    self.shawdowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.shawdowView];
    
    // add drawer view
    [self.drawerView setFrame:self.outFrame];
    [self.view addSubview:self.drawerView];
    
    // drawer list
    [self.drawerView.drawerTableView setContentInset:UIEdgeInsetsMake(2, 0, 0, 0)]; // statuesBarHeight+navBarHeight
    self.drawerView.drawerTableView.dataSource = self;
    self.drawerView.drawerTableView.delegate = self;
    
    // gesture on self.view
    self.pan_gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveDrawer:)];
    self.pan_gr.maximumNumberOfTouches = 1;
    self.pan_gr.minimumNumberOfTouches = 1;
    self.pan_gr.delegate = self;
    [self.view addGestureRecognizer:self.pan_gr];
    
    [self.view bringSubviewToFront:self.navigationBar];
    
//    for (id x in self.view.subviews){
//        NSLog(@"%@",NSStringFromClass([x class]));
//    }
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
        //  [self httpPostRequest];
        
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}



- (void)drawerToggle
{
    NSLog(@"<<<< drawerToggle called >>>>>");
    if (self.isOpen == NO) {
        
        self.isOpen= YES;
        
        username = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"username"];
        
        password = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"password"];
        
        msd_id = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"msd_Id"];
        clt_id = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"clt_id"];
        usl_id = [[NSUserDefaults standardUserDefaults]
                  stringForKey:@"usl_id"];
        
        roll_id = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Roll_id"];
        
        drawerRollNo = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"RollNo"];
        drawerName = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"name"];
        drawerStd = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"Std"];
        drawerAcademicYear =[[NSUserDefaults standardUserDefaults]
                             stringForKey:@"academicYear"];
        arraycount = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"LoginUserCount"];
        isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
        
        classTeacher = [[NSUserDefaults standardUserDefaults]stringForKey:@"classTeacher"];
        
        teacherClassStdDiv = [[NSUserDefaults standardUserDefaults]stringForKey:@"teacherClassStdDiv"];
        NSLog(@"<<<<<<<< From Drawer teacherClassStdDiv >>>>> %@", teacherClassStdDiv);
        teachershiftstdDiv = [[NSUserDefaults standardUserDefaults]stringForKey:@"shift"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:arraycount forKey:@"arrayCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        isStudentResourcePresent = [[NSUserDefaults standardUserDefaults]stringForKey:@"isStudenResourcePresent"];
        
        if([roll_id isEqualToString:@"6"]){
                      [_drawerView.std setText:drawerStd];
            [_drawerView.academic_year setText:drawerAcademicYear];
            [_drawerView.name setText:drawerName];
            [_drawerView.rollNo setText:drawerRollNo];
          
            //Non-sibling
            if([arraycount isEqualToString:@"1"]){
                
                if([isStudentResourcePresent isEqualToString:@"0"]){
               
                    drawerlabelData = [NSArray arrayWithObjects:@"Dashboard", @"Messages", @"Fees Information", @"Student Resource",@"Attendance", @"Student Information",@"Setting",@"Sign Out",@"About", nil];
                    
                    drawerImage = [[NSMutableArray alloc] initWithObjects:@"studentdashboardicon.png",@"messageboxicon.png", @"feesonlineicon.png",@"resourcesicon.png",@"attendanceicon.png",@"parentinfoicon.png",@"settingsicon.png",@"signouticon.png",@"aboutus_icon.png",nil];
                    [_drawerView.drawerTableView reloadData];
                    
                }
                
                else if([isStudentResourcePresent isEqualToString:@""]){
                    drawerlabelData = [NSArray arrayWithObjects:@"Dashboard", @"Messages", @"Fees Information", @"Attendance", @"Student Information",@"Setting",@"Sign Out",@"About", nil];
                    
                    drawerImage = [[NSMutableArray alloc] initWithObjects:@"studentdashboardicon.png",@"messageboxicon.png", @"feesonlineicon.png",@"attendanceicon.png",@"parentinfoicon.png",@"settingsicon.png",@"signouticon.png",@"aboutus_icon.png",nil];
                    [_drawerView.drawerTableView reloadData];
                    
                }
            }
            //Sibiling
            else if(![arraycount isEqualToString:@"1"]){
                
                if([isStudentResourcePresent isEqualToString:@"0"]){
                    drawerlabelData = [NSArray arrayWithObjects:@"Dashboard",@"Sibling", @"Messages", @"Fees Information", @"Student Resource",@"Attendance", @"Student Information",@"Setting",@"Sign Out",@"About", nil];
                    
                    drawerImage = [[NSMutableArray alloc] initWithObjects:@"studentdashboardicon.png",@"parentinfoicon.png",@"messageboxicon.png",@"feesonlineicon.png",@"resourcesicon.png",@"attendanceicon.png",@"parentinfoicon.png",@"settingsicon.png",@"signouticon.png",@"aboutus_icon.png",nil];
                    [_drawerView.drawerTableView reloadData];
                    
                }
                else if([isStudentResourcePresent isEqualToString:@""]){
                    drawerlabelData = [NSArray arrayWithObjects:@"Dashboard",@"Sibling", @"Messages", @"Fees Information", @"Attendance", @"Student Information",@"Setting",@"Sign Out",@"About", nil];
                    
                    drawerImage = [[NSMutableArray alloc] initWithObjects:@"studentdashboardicon.png",@"parentinfoicon.png",@"messageboxicon.png",@"feesonlineicon.png",@"attendanceicon.png",@"parentinfoicon.png",@"settingsicon.png",@"signouticon.png",@"aboutus_icon.png",nil];
                    [_drawerView.drawerTableView reloadData];
                    
                }
            }
            
        }
        // Teacher role
        else if([roll_id isEqualToString:@"5"]){
            if([classTeacher isEqualToString:@"1"]){
                NSLog(@"<<<<<  teachershiftstdDiv >>>>>>> %@", teachershiftstdDiv);

                if([teachershiftstdDiv isEqualToString:@"|| "]){
                    [_drawerView.academic_year setText:drawerName];
                    [_drawerView.name setText:drawerAcademicYear];
                    [_drawerView.std setText:teacherClassStdDiv];
                    [_drawerView.rollNo setHidden:YES];
                    _drawerView.drawerStdConstraint.constant = 55;
                }
                else{
                    [_drawerView.std setText:teacherClassStdDiv];
                    [_drawerView.academic_year setText:drawerName];
                    [_drawerView.name setText:drawerAcademicYear];
                    [_drawerView.rollNo setHidden:YES];
                    _drawerView.drawerStdConstraint.constant = 55;
                }
                drawerlabelData = [NSArray arrayWithObjects:@"Dashboard", @"Messages", @"SMS", @"Announcement",@"Attendance",@"Behaviour",@"Subject List",@"Setting",@"Sign Out",@"About", nil];
                
                drawerImage = [[NSMutableArray alloc] initWithObjects:@"studentdashboardicon.png",@"messageboxicon.png", @"sms_92x92.png",@"announcementicon_48x48.png",@"attendanceicon.png",@"behaviouricon_92x92.png",@"subjectlist_92x92.png",@"settingsicon.png",@"signouticon.png",@"aboutus_icon.png",nil];
                [_drawerView.drawerTableView reloadData];
            }
            else if([classTeacher isEqualToString:@"0"]) {
                
            NSLog(@"<<<<<  teachershiftstdDiv >>>>>>> %@", teachershiftstdDiv);
            
                if([teachershiftstdDiv isEqualToString:@"|| "]){
                    [_drawerView.academic_year setText:drawerName];
                    [_drawerView.name setText:drawerAcademicYear];
                    [_drawerView.std setText:teacherClassStdDiv];
                    [_drawerView.rollNo setHidden:YES];
                    _drawerView.drawerStdConstraint.constant = 55;
                }
                else{
                    [_drawerView.std setText:teacherClassStdDiv];
                    [_drawerView.academic_year setText:drawerName];
                    [_drawerView.name setText:drawerAcademicYear];
                    [_drawerView.rollNo setHidden:YES];
                    _drawerView.drawerStdConstraint.constant = 55;
                }
                drawerlabelData = [NSArray arrayWithObjects:@"Dashboard", @"Messages", @"SMS", @"Announcement",@"Subject List",@"Setting",@"Sign Out",@"About", nil];
                
                drawerImage = [[NSMutableArray alloc] initWithObjects:@"studentdashboardicon.png",@"messageboxicon.png", @"sms_92x92.png",@"announcementicon_48x48.png",@"subjectlist_92x92.png",@"settingsicon.png",@"signouticon.png",@"aboutus_icon.png",nil];
                [_drawerView.drawerTableView reloadData];
            }
            
        }
         NSLog(@"<<<< opening navigation drawer >>>>");
        [self openNavigationDrawer];

    }
    
    else if(self.isOpen == YES){
        NSLog(@"<<<< closing navigation drawer >>>>");
        [self closeNavigationDrawer];
    }
}

#pragma open and close action
#pragma open and close action

- (void)openNavigationDrawer{
    
    self.isOpen= YES;
    //    NSLog(@"open x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    self.shawdowView.hidden = NO;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:SHAWDOW_ALPHA];
                     }
                     completion:nil];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.inFrame;
                     }
                     completion:nil];
    
   
}

- (void)closeNavigationDrawer{
    
    self.isOpen= NO;

    //    NSLog(@"close x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         self.shawdowView.hidden = YES;
                     }];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.outFrame;
                     }
                     completion:nil];
   }

#pragma gestures

- (void)tapOnShawdow:(UITapGestureRecognizer *)recognizer {
    [self closeNavigationDrawer];
}

-(void)moveDrawer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)recognizer velocityInView:self.view];
    //    NSLog(@"velocity x=%f",velocity.x);
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
        //        NSLog(@"start");
        if ( velocity.x > MENU_TRIGGER_VELOCITY && !self.isOpen) {
          
            [self openNavigationDrawer];
        }else if (velocity.x < -MENU_TRIGGER_VELOCITY && self.isOpen) {
            [self closeNavigationDrawer];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged) {
        //        NSLog(@"changing");
        float movingx = self.drawerView.center.x + translation.x;
        if ( movingx > -self.menuWidth/2 && movingx < self.menuWidth/2){
            
            self.drawerView.center = CGPointMake(movingx, self.drawerView.center.y);
            [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
            
            float changingAlpha = SHAWDOW_ALPHA/self.menuWidth*movingx+SHAWDOW_ALPHA/2; // y=mx+c
            self.shawdowView.hidden = NO;
            self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:changingAlpha];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        //        NSLog(@"end");
        if (self.drawerView.center.x>0){
              NSLog(@"<<<<<Drwawer opened using gesture>>>>>>>");
            [self drawerToggle];
            //[self openNavigationDrawer];
        }else if (self.drawerView.center.x<0){
            NSLog(@"<<<<<Drwawer closed using gesture>>>>>>>");
            [self closeNavigationDrawer];
        }
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [drawerlabelData count];
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([device isEqualToString:@"iphone"]){
        
        return 32;
    }
    else{
        return 40;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if([device isEqualToString:@"iphone"]){
            
            static NSString *simpleTableIdentifier = @"DrawerIphoneTableViewCell";
            
            DrawerIphoneTableViewCell *cell = (DrawerIphoneTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DrawerIphoneTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            //        if([device isEqualToString:@"iphone"]){
            //             [cell.label_name setFont:[UIFont systemFontOfSize:8]];
            //            //[cell.img_icon.image drawInRect:CGRectMake(0,0,10,10)];
            //             cell.img_icon.frame=CGRectMake(8, 10, 10, 10);
            //        }
            cell.label_name.text =[drawerlabelData objectAtIndex:indexPath.row];
            cell.img_icon.image = [UIImage imageNamed:[drawerImage objectAtIndex:indexPath.row]];
            
            return cell;
            
        }
        else{
            static NSString *simpleTableIdentifier = @"NavTableViewCell";
            
            NavTableViewCell *cell = (NavTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            //        if([device isEqualToString:@"iphone"]){
            //             [cell.label_name setFont:[UIFont systemFontOfSize:8]];
            //            //[cell.img_icon.image drawInRect:CGRectMake(0,0,10,10)];
            //             cell.img_icon.frame=CGRectMake(8, 10, 10, 10);
            //        }
            cell.label_name.text =[drawerlabelData objectAtIndex:indexPath.row];
            cell.img_icon.image = [UIImage imageNamed:[drawerImage objectAtIndex:indexPath.row]];
            
            return cell;
        }
        
    } @catch (NSException *exception) {
        
        NSLog(@"Exception: %@", exception);
    }
    
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.CCKFNavDrawerDelegate CCKFNavDrawerSelection:[indexPath row]];
    [self closeNavigationDrawer];
}



@end
