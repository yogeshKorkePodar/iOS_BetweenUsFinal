//
//  TeacherSentMessageViewController.h
//  BetweenUs
//
//  Created by podar on 17/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
#import "MKNumberBadgeView.h"

@interface TeacherSentMessageViewController : UIViewController
{
    NSString *clt_id,*usl_id,*check,*pageNo,*pageSize,*SentMessageStatus,*msgReadStatus,*senderName,*date,*subject,*message,*filename,*filePath,*fulldate,*formatedDate,*device,*DeviceToken,*DeviceType,*toUslId,*pmuId,*pmg_id,*sentmessageClick,*attachementClick,*month,*classTeacher,*stud_id;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *SentTableData,*dateitems;
    NSDictionary *sentmessagedetails;

}
@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property BOOL internetActive;
@property BOOL hostActive;
@property (retain) MKNumberBadgeView* badgeCount;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property (weak, nonatomic) IBOutlet UITableView *teacherSentMessageTableView;

@end
