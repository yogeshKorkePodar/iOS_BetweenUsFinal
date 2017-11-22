//
//  TeacherTopicListViewController.h
//  BetweenUs
//
//  Created by podar on 18/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "HVTableView.h"

@interface TeacherTopicListViewController : UIViewController<HVTableViewDelegate,HVTableViewDataSource, UITableViewDataSource,UITableViewDataSource>{
    NSString *device,*clt_id,*usl_id,*check,*pmg_Id,*rol_id,*org_id,*Brd_Id,*sec_Id,*DeviceToken,*DeviceType,*brd_name,*TopicListStatus,*subject,* classname,*behaviourType,*shift,*subjecListClsID,*topicName,*srNo,*totalLogsFilled,*logfilled,*cycletest,*stdname,*cycleTestStatus,*selectedStd,*selectedSubject,*crf_id,*title,*selectedTopicName,*resourceStatus;
    NSArray *topictListArray,*cycleTestArray;
    NSMutableArray *selectedIndexPath,*expandedCells;
    Reachability* internetReachable;
    Reachability* hostReachable;
    int *selectedIndex;
    NSIndexPath *path;
}
@property (weak,nonatomic) id <HVTableViewDelegate> HVTableViewDelegate;
@property (weak,nonatomic) id <HVTableViewDataSource> HVTableViewDataSource;
@property (weak, nonatomic) IBOutlet UIView *showlogView;
- (IBAction)viewLogBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *showClick;@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintToTopicNameView;
//@property (weak, nonatomic) IBOutlet HVTableView *topicTableView;
@property (weak, nonatomic) IBOutlet UITableView *topicTblView;
//@property (weak, nonatomic) IBOutlet UITableView *topicListTableView;
@property (weak, nonatomic) IBOutlet UIButton *cycleTestClick;
- (IBAction)cycleTestBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *dropdownImage;
@property BOOL internetActive;
@property BOOL hostActive;

@end
