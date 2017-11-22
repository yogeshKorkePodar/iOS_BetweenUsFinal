//
//  TeacherSubjectListViewController.h
//  BetweenUs
//
//  Created by podar on 29/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
@interface TeacherSubjectListViewController : UIViewController<CCKFNavDrawerDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSString *device,*clt_id,*usl_id,*check,*pmg_Id,*rol_id,*org_id,*Brd_Id,*sec_Id,*DeviceToken,*DeviceType,*brd_name,*SubjectListStatus,*subject,* classname,*behaviourType,*shift,*subjecListClsID,*selectedstd;
    NSArray *subjectListArray;
    Reachability* internetReachable;
    Reachability* hostReachable;
}

@property BOOL internetActive;
@property BOOL hostActive;

@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (weak, nonatomic) IBOutlet UITableView *subjectListTableView;

@end
