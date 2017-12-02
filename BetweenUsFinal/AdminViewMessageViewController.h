//
//  AdminViewMessageViewController.h
//  BetweenUs
//
//  Created by podar on 19/09/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNumberBadgeView.h"
#import "Reachability.h"
#import "CCKFNavDrawer.h"

@interface AdminViewMessageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSString *clt_id,*usl_id,*check,*pageNo,*pageSize,*ViewMessageStatus,*msgReadStatus,*senderName,*date,*subject,*message,*filename,*filePath,*fulldate,*formatedDate,*device,*DeviceToken,*DeviceType,*toUslId,*pmuId,*AdminmessageClick,*stud_id;
    NSArray *ViewTableData,*dateitems;
    NSDictionary *viewmessagedetails;
    Reachability* internetReachable;
    Reachability* hostReachable;
    
}

@property (weak, nonatomic) IBOutlet UIButton *viewMessageClick;
@property (weak, nonatomic) IBOutlet UIButton *writeMessageClick;
@property (weak, nonatomic) IBOutlet UIButton *sentMessageClick;
@property (weak, nonatomic) IBOutlet UITableView *viewMessageTableView;
@property (retain) MKNumberBadgeView* badgeCount;
@property BOOL internetActiveViewMessage;
@property BOOL hostActiveViewMessage;

@end
