//
//  AdminSentMessagesViewController.h
//  BetweenUs
//
//  Created by podar on 23/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "MKNumberBadgeView.h"
#import "CCKFNavDrawer.h"
@interface AdminSentMessagesViewController : UIViewController<CCKFNavDrawerDelegate>
{
    NSString *clt_id,*usl_id,*check,*pageNo,*pageSize,*SentMessageStatus,*msgReadStatus,*senderName,*date,*subject,*message,*filename,*filePath,*fulldate,*formatedDate,*device,*DeviceToken,*DeviceType,*toUslId,*pmuId,*pmg_id,*AdminsentmessageClick,*attachementClick,*stud_id;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *SentTableData,*dateitems;
    NSDictionary *sentmessagedetails;
    NSString *classTeacher;
}
@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;
@property BOOL internetActiveViewMessage;
@property BOOL hostActiveViewMessage;
@property (retain) MKNumberBadgeView* badgeCount;

@property (weak, nonatomic) IBOutlet UITableView *adminSentMessageTableView;

@end
