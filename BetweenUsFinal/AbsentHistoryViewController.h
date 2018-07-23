//
//  AbsentHistoryViewController.h
//  TestAutoLayout
//
//  Created by podar on 21/07/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reachability;

@interface AbsentHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString *abouUs;
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *school_name;
    NSString *brdName;
    NSString *schoolName;
    NSString *month;
    NSString *year;
    NSString *absentReason;
    NSString *absentDate;
    NSString *historyStatus;
    NSString *date;
    NSString *formatedDate;
    NSArray *attendanceHistortArray;
    NSArray *dateitems;
    NSDictionary *attendHostprydictonary;
    Reachability* internetReachable;
    Reachability* hostReachable;

}
@property BOOL internetActive;
@property BOOL hostActive;
@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *brd_Name;
@property (weak, nonatomic) IBOutlet UITableView *absentHistory;
@property(nonatomic,strong) NSString *schoolName;
@property(nonatomic,strong) NSString *month;
@property(nonatomic,strong) NSString *year;

@end
