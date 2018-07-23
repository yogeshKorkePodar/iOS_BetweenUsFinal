//
//  StudentResourcesViewController.h
//  TestAutoLayout
//
//  Created by podar on 18/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
@class Reachability;

@interface StudentResourcesViewController : UIViewController<CCKFNavDrawerDelegate>{
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *school_name;
    NSString *brdName;
    NSString *Status;
    NSString *SubjectStatus;
    NSString *TopicStatus;
    NSString *subject;
    NSString *cycletest;
    NSString *topic;
    NSString *topicname;
    NSString *cyclename;
    NSString *subjectname;
    NSString *selectedCycleTest;
    NSString *selectedSubject;
    NSString *selectedTopic;
    NSString *stdname;
    NSArray *cycleData;
    NSArray *subjectData;
    NSArray *topicData;
    NSString *crf_id;
    NSString *isStudentResourcePresent;
    NSString *LoginArrayCount;
    NSDictionary* subjectDetails;
    NSDictionary* CycleDetails;
    NSString *DeviceType;
    NSString *DeviceToken;
    UILabel *lbl1;
    Reachability* internetReachable;
    Reachability* hostReachable;

    
}
@property BOOL internetActive;
@property BOOL hostActive;

@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;

//@property (weak, nonatomic) IBOutlet UIView *cycletestView;
@property (weak, nonatomic) IBOutlet UIButton *click_cycletest;
- (IBAction)btn_cycleTest:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *click_subject;
- (IBAction)btn_subject:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *topic_tableData;
@property (weak, nonatomic) IBOutlet UITableView *subjectTableData;
@property (weak, nonatomic) IBOutlet UITableView *cycleTableData;
@property (weak, nonatomic) IBOutlet UILabel *clicktopic_label;
@property (weak, nonatomic) IBOutlet UIView *topicView;

@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *school_name;
@property(nonatomic,strong) NSString *Status;
@property(nonatomic,strong) NSString *brdName;
@property(nonatomic,strong) NSString *stdName;


@end
