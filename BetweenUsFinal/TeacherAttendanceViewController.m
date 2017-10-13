//
//  TeacherAttendanceViewController.m
//  BetweenUs
//
//  Created by podar on 29/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherAttendanceViewController.h"
#import "TeacherAnnouncementViewController.h"
#import "TeacherBehaviourViewController.h"
#import "NavigationMenuButton.h"
@interface TeacherAttendanceViewController ()

@end

@implementation TeacherAttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    self.navigationItem.leftBarButtonItem = [NavigationMenuButton addNavigationMenuButton:self];
    
    _my_tabBar.delegate = self;
    _my_tabBar.selectedItem = [_my_tabBar.items objectAtIndex:1];

    
}


-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    if(item.tag==1)
    {
        NSLog(@"First tab selected");
        TeacherAnnouncementViewController *TeacherAnnouncementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAnnouncement"];
        [self.navigationController pushViewController:TeacherAnnouncementViewController animated:NO];
        
    }
    else if(item.tag==2)
        
    {
        NSLog(@"Second tab selected");
        
        TeacherAttendanceViewController *TeacherAttendanceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherAttendance"];
        [self.navigationController pushViewController:TeacherAttendanceViewController animated:NO];
        
    }
    else if(item.tag==3)
        
    {
        NSLog(@"Third tab selected");
        TeacherBehaviourViewController *TeacherBehaviourViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherBehaviour"];
        [self.navigationController pushViewController:TeacherBehaviourViewController animated:NO];
        
        
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
