//
//  MonthTableViewController.h
//  TestAutoLayout
//
//  Created by podar on 27/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>{
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *school_name;
    NSString *brdName;
    NSString *DropdownStatus;
   // NSArray *MonthTableData;
    NSString *monthanme;
    NSString *monthid;
    NSDictionary *dropdowndetails;
}
@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *school_name;
@property(nonatomic,strong) NSString *Status;
@property(nonatomic,strong) NSString *brdName;
@property (strong, nonatomic) IBOutlet UITableView *monthTableView;

@end
