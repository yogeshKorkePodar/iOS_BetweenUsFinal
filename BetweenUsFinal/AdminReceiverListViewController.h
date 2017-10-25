//
//  AdminReceiverListViewController.h
//  BetweenUs
//
//  Created by podar on 17/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface AdminReceiverListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    NSString *clt_id,*usl_id,*check,*pmg_Id,*rol_id,*DeviceToken,*DeviceType,*ReceiverListStatus,*receiverName,*receiverSrNo,*Receiver_shift,*receiver_Std,*receiver_divName,*device;
    NSArray *ViewReceiverTableData;
    NSDictionary *viewreceiverlistdetails;
    Reachability* internetReachable;
    Reachability* hostReachable;
    
}

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *top_name_label;
@property (weak, nonatomic) IBOutlet UITableView *ReceiverTableView;
@property BOOL internetActiveViewMessage;
@property BOOL hostActiveViewMessage;
@property (weak, nonatomic) IBOutlet UILabel *top_std_label;



@end
