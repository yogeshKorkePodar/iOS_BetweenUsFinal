//
//  SiblingStudentViewController.h
//  TestAutoLayout
//
//  Created by podar on 15/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentProfileWithSiblingViewController.h"
@interface SiblingStudentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    StudentProfileWithSiblingViewController *StudentProfileWithSiblingViewController;
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *schoolname;
    NSArray *tabledata;
    NSArray* stundentDetails;
    NSString * student_std_div;
    NSDictionary* studentinfodetails;
    NSArray *cellArray;
    NSMutableArray *myObject;
    // A dictionary object
    NSDictionary *dictionary;
    NSString *stu_name;
    NSString *div;
    NSString *std;
}

@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *Status;
@property(nonatomic,strong) NSString *div;
@property(nonatomic,strong) NSString *std;
@property(nonatomic,strong) NSString *schoolName;
@property(nonatomic,strong) NSString *brdName;
@property (weak, nonatomic) IBOutlet UITableView *tableData;
@property BOOL internetActive;
@property BOOL hostActive;



@end
