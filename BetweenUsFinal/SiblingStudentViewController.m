//
//  SiblingStudentViewController.m
//  TestAutoLayout
//
//  Created by podar on 15/06/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "SiblingStudentViewController.h"
#import "RestAPI.h"
#import "stundentListDetails.h"
#import "SiblingTableViewCell.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface SiblingStudentViewController ()
{
    BOOL firstWebcall;
}
@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) stundentListDetails *studentListDetails;
@property (nonatomic, strong) stundentListDetails *item;

@end

@implementation SiblingStudentViewController
@synthesize msd_id,clt_id,usl_id,schoolName,brdName;
-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    msd_id = msd_id;
    usl_id = usl_id;
    std = @"Std : ";
    div = @"Div : ";
    clt_id = clt_id;
    schoolName = schoolName;
    brdName = brdName;
    msd_id = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"msd_Id"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    NSLog(@"MSD Id Siblingnew:%@",msd_id);
    self.tableData.delegate = self;
    self.tableData.dataSource = self;
    [self httpPostRequest];
    self.automaticallyAdjustsScrollViewInsets = NO;
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

-(void) httpPostRequest{
    //Create the response and Error
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
    NSError *err;
    NSString *str = app_url @"PodarApp.svc/GetStundentInfo";
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
    
    //Pass The String to server
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:usl_id,@"usl_id",clt_id,@"clt_id",nil];
    NSLog(@"the data Details is =%@", newDatasetInfo);
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&err];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:POST];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //Apply the data to the body
    [request setHTTPBody:jsonData];
    
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];
    NSURLResponse *response;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    //This is for Response
    NSLog(@"got studentinforesponse==%@", resSrt);
            [hud hideAnimated:YES];
        });
    });
}
-(void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{

    NSError *error = nil;
    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
//    NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
    _Status = [parsedJsonArray valueForKey:@"Status"];
    NSLog(@"Status:%@",_Status);
    
    //  stundentDetails = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    
    stundentDetails = [receivedData objectForKey:@"stundentListDetails"];
    NSLog(@"Size sibling:%lu",(unsigned long)[stundentDetails count]);
    if([_Status isEqualToString:@"1"]){
        for(int n = 0; n < [stundentDetails  count]; n++)
        {
            _item = [[stundentListDetails alloc]init];
            studentinfodetails = [stundentDetails objectAtIndex:n];
            _item.StudentName = [studentinfodetails objectForKey:@"StudentName"];
            _item.Division =[studentinfodetails objectForKey:@"Division"];
            _item.standard = [studentinfodetails objectForKey:@"standard"];
            _item.msd_ID = [studentinfodetails objectForKey:@"msd_ID"];
            _item.StudentId = [studentinfodetails objectForKey:@"StudentId"];
            NSLog(@"StudentName:%@",_item.StudentName);
            // [cellArray addObject:_item.StudentName];
            student_std_div = [NSString stringWithFormat:@"%@ : %@, %@ : %@",@"Std", _item.standard,@"Div",_item.Division];
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                          _item.StudentName, _item.Division,nil];
            [myObject addObject:dictionary];
            NSLog(@"Myobjet:%lu",(unsigned long)[myObject count]);
        }
    }
    [self.tableData reloadData];
            [hud hideAnimated:YES];
        });
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [stundentDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SiblingTableViewCell";
    
    SiblingTableViewCell *cell = (SiblingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SiblingTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    std = [[stundentDetails objectAtIndex:indexPath.row] objectForKey:@"standard"];
    div = [[stundentDetails objectAtIndex:indexPath.row] objectForKey:@"Division"];
    //std = [NSString stringWithFormat: @"Std:",std];
    
    NSLog(@"Std:%@",std);
    
    
    cell.label_studentName.text = [[stundentDetails objectAtIndex:indexPath.row] objectForKey:@"StudentName"];
    cell.label_std_div.text = [NSString stringWithFormat: @"%@ : %@, %@ : %@ ", @"Std", std,@"Div",div];
    return cell;
  
}
//
//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    msd_id = [[stundentDetails objectAtIndex:indexPath.row] objectForKey:@"msd_ID"];
//      NSLog(@"MSD Cell:%@",msd_id);
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIAlertView *messageAlert = [[UIAlertView alloc]
//                                 initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    // Display Alert Message
//    [messageAlert show];
    
    msd_id = [[stundentDetails objectAtIndex:indexPath.row] objectForKey:@"msd_ID"];
     NSLog(@"Msd Id selection==%@", msd_id);
    
    [[NSUserDefaults standardUserDefaults] setObject:msd_id forKey:@"msd_Id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PresentFirstRow"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Not MarkedFirstRow"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AbsentFirstRow"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
// int   *n = [[NSUserDefaults standardUserDefaults]
//         integerForKey:@"Not MarkedFirstRow"];
    

    StudentProfileWithSiblingViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SiblingProfile"];
    secondViewController.msd_id = msd_id;
    secondViewController.usl_id = usl_id;
    secondViewController.clt_id = clt_id;
    secondViewController.school_name = schoolName;
    [self.navigationController pushViewController:secondViewController animated:YES];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
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
