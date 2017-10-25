//
//  TeacherWriteMessageStudentListViewController.m
//  BetweenUs
//
//  Created by podar on 24/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "TeacherWriteMessageStudentListViewController.h"
#import "MsgStudentResult.h"
#import "AdminStudentListTableViewCell.h"
@interface TeacherWriteMessageStudentListViewController ()
{
    UIButton *btn;
    NSIndexPath *path;
    NSInteger *cellRow;
    BOOL firstTime,checkboxAllClicked,checkboxClicked,loginClick,individualButtonClicked,searchStudent,closeBtnClick,selectAll;
    NSDictionary *newDatasetinfoTeacherWriteMessages_studentList,*newDatasetinfoTeacherLogout;
}

@property (nonatomic, strong) MsgStudentResult *MsgStudentResultItems;
@property(nonatomic,strong)   AdminStudentListTableViewCell *cell;

@end

@implementation TeacherWriteMessageStudentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    firstTime = YES;
    checkboxAllClicked = NO;
    checkboxClicked = NO;
    pageSize = @"200";
    pageIndex =@"1";
    student_name = @"";
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    cls_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"cls_ID"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    cls_ID = [[NSUserDefaults standardUserDefaults]stringForKey:@"class_Id_TeacherWriteMsg"];
    DeviceType= @"IOS";
    self.navigationItem.title = @"Student List";
    self.TeacherwriteMessageStudentTableView.delegate = self;
    self.TeacherwriteMessageStudentTableView.dataSource = self;
    _studentNameTextfield.delegate = self;
    stuIdArray = [[NSMutableArray alloc] init];
    pathArray = [[NSMutableArray alloc] init];
    mystringArray = [[NSMutableArray alloc]init];
    buttonTagsTapped = [[NSMutableArray alloc] init];
    newMyStringArray = [[NSMutableArray alloc] init];
    arrayForTag =  [[NSMutableArray alloc]init];
    
    [_closeView setHidden:YES];
    [_close_click setHidden:YES];
    
  //  [self checkInternetConnectivity];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
