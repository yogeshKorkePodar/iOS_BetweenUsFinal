//
//  TeacherAttendanceViewController.h
//  BetweenUs
//
//  Created by podar on 29/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"

@interface TeacherAttendanceViewController : UIViewController<CCKFNavDrawerDelegate, UITabBarDelegate>{
    
}
@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property (weak, nonatomic) IBOutlet UITabBar *my_tabBar;
@end
