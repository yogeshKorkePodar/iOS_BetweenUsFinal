//
//  TeacherBehvaiourDetailsViewController.h
//  BetweenUs
//
//  Created by podar on 17/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TeacherBehvaiourDetailsViewController : UIViewController{
    NSString *selectedMsdId,*device,*clt_id,*usl_id,*check,*pmg_Id,*rol_id,*org_id,*Brd_Id,*sec_Id,*DeviceToken,*DeviceType,*brd_name,*BehaviourDetailsStatus,*behaviour,* class_id,*date,*behaviourType;
    NSArray *teacherBehaviourDetailsArray;
    Reachability* internetReachable;
    Reachability* hostReachable;
}
@property (weak, nonatomic) IBOutlet UITableView *behaviourDetailsTableView;

@property BOOL internetActive;
@property BOOL hostActive;

@end
