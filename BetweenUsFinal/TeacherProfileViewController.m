//
//  TeacherProfileViewController.m
//  BetweenUs
//
//  Created by podar on 28/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherProfileViewController.h"
#import "NavigationMenuButton.h"
#import "TeacherSMSViewController.h"
#import "TeacherMessageViewController.h"
#import "TeacherBehaviourViewController.h"
#import "TeacherAttendanceViewController.h"
#import "TeacherSubjectListViewController.h"
#import "TeacherAnnouncementViewController.h"
#import "ChangePassswordViewController.h"
#import "LoginViewController.h"
#import "AboutUsViewController.h"

@interface TeacherProfileViewController ()

@end

@implementation TeacherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];
}

-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    
    if(selectionIndex == 0){
        
        TeacherProfileViewController *teacherProfileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherProfile"];
        [self.navigationController pushViewController:teacherProfileViewController animated:YES];
    }
    else if(selectionIndex == 1){
        // Messsage
        
        TeacherMessageViewController *teacherMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherViewMessage"];
        
        [self.navigationController pushViewController:teacherMessageViewController animated:YES];
    }
    else if(selectionIndex == 2){
        //sms
        TeacherSMSViewController *teacherSMSViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherSMS"];
        [self.navigationController pushViewController:teacherSMSViewController animated:YES];
    }
    else if(selectionIndex == 3){
        TeacherAnnouncementViewController *teacherAnnouncementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAnnouncement"];
        
        [self.navigationController pushViewController:teacherAnnouncementViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    
    else if(selectionIndex == 4){
        TeacherAttendanceViewController *teacherAttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAttendance"];
        [self.navigationController pushViewController:teacherAttendanceViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    else if(selectionIndex == 5){
        //Behaviour
        TeacherBehaviourViewController *teacherBehaviourViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherBehaviour"];
        [self.navigationController pushViewController:teacherBehaviourViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    else if(selectionIndex == 6){
        //SubjectList
        TeacherSubjectListViewController *teacherSubjectListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherSubjectList"];
        [self.navigationController pushViewController:teacherSubjectListViewController animated:YES];
    }
    else if(selectionIndex == 7){
        //Setting
        ChangePassswordViewController *ChangePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
        [self.navigationController pushViewController:ChangePasswordViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    else if(selectionIndex == 8){
        //loginClick = YES;
       // [self webserviceCallForLogout];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
