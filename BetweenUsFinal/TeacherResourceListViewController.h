//
//  TeacherResourceListViewController.h
//  BetweenUs
//
//  Created by podar on 22/11/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TeacherResourceListViewController : UIViewController{
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *brd_Name;
    NSString *crf_id;
    NSString *resourceStatus;
    NSString *filename;
    NSString *fileExtension;
    NSString *crl_id;
    NSString *crl_file;
    NSString *crl_description;
    NSString *fileId;
    NSString *resourceUrl;
    NSDictionary *resourceDetails;
    NSArray *resourceData;
    UILabel *lb1;
    Reachability* internetReachable;
    Reachability* hostReachable;


}
@property BOOL internetActive;
@property BOOL hostActive;

@property (weak, nonatomic) IBOutlet UITableView *TeacherResourceTableView;
@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *brd_Name;
@property(nonatomic,strong) NSString *crf_id;
@end
