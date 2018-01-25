//
//  ViewAttendanceViewController.h
//  BetweenUsFinal
//
//  Created by podar on 18/08/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"
#import "HVTableView.h"
@class Reachability;

@protocol PieChartViewDelegate;
@protocol PieChartViewDataSource;

@interface ViewAttendanceViewController : UIViewController<CCKFNavDrawerDelegate,UITabBarDelegate,HVTableViewDelegate, HVTableViewDataSource, UIScrollViewDelegate>
{
    
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *brd_Name;
    NSString *present;
    NSString *absent;
    NSString *notmarked;
    NSString *LoginArrayCount;
    NSString *year;
    NSString *month;
    NSString *attendanceStatus;
    NSArray *attendancedetails;
    NSDictionary *attendancedetailsdictionry;
    NSString *isStudentResourcePresent;
    NSString *DeviceType;
    NSString *DeviceToken;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSMutableArray *values;
    NSString *device;
    NSIndexPath *selectedIndexPath;
    NSIndexPath *tempSelectedIndexPath;
    int actionToTake;
    NSMutableArray* expandedIndexPaths;
    NSMutableArray *arrayForBool;
    NSString *row;

}
@property(strong, nonatomic) CCKFNavDrawer *rootNav;
@property(nonatomic,retain)UIPopoverPresentationController *aboutUsPopOver;

@property (weak, nonatomic) NSString *Status;
@property(nonatomic,strong) NSString *rol_id;
@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *school_name;
@property(nonatomic,strong) NSString *brd_Name;
@property(nonatomic,strong) NSString *org_id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *stdName;
@property(nonatomic,strong) NSString *sec_Id;
@property(nonatomic,strong) NSString *Brd_Id;
@property(nonatomic,strong) NSString *schoolName;
@property(nonatomic,strong) NSString *drawerstd;
@property(nonatomic,strong) NSString *drawername;
@property(nonatomic,strong) NSString *drawerRollNo;
@property(nonatomic,strong) NSString *draweracademicYear;
@property(strong, nonatomic) NSString *teacherAnnouncementCount;
@property (weak, nonatomic) IBOutlet UITabBar *my_tabBar;

@property (weak,nonatomic) id <HVTableViewDelegate> HVTableViewDelegate;
@property (weak,nonatomic) id <HVTableViewDataSource> HVTableViewDataSource;

@property (nonatomic) BOOL expandOnlyOneCell;
@property BOOL internetActive;
@property BOOL hostActive;

@property (strong, nonatomic) NSMutableArray *expandedCells;
//@property (weak, nonatomic) IBOutlet HVTableView2 *attendanceTable;
@property (weak, nonatomic) IBOutlet HVTableView *attendanceTable;

@property (nonatomic, assign) id <PieChartViewDataSource> datasource;
@property (nonatomic, assign) id <PieChartViewDelegate> delegate;

@end
