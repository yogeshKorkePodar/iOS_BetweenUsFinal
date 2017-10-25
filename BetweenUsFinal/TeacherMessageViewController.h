//
//  TeacherMessageViewController.h
//  BetweenUs
//
//  Created by podar on 29/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
#import "Reachability.h"
#import "MKNumberBadgeView.h"
@interface TeacherMessageViewController : UIViewController<CCKFNavDrawerDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSString *clt_id,*usl_id,*check,*pageNo,*pageSize,*ViewMessageStatus,*msgReadStatus,*senderName,*date,*subject,*message,*filename,*filePath,*fulldate,*formatedDate,*device,*DeviceToken,*DeviceType,*toUslId,*pmuId,*messageClick,*month,*stud_id;
    NSArray *ViewTableData,*dateitems;
    NSDictionary *viewmessagedetails;
    Reachability* internetReachable;
    Reachability* hostReachable;
}

@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property BOOL internetActive;
@property BOOL hostActive;
@property (retain) MKNumberBadgeView* badgeCount;

@property (weak, nonatomic) IBOutlet UITableView *teacherViewMessageTableView;

@end
