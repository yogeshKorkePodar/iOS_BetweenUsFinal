//
//  MonthTableViewController.m
//  TestAutoLayout
//
//  Created by podar on 27/06/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "MonthTableViewController.h"
#import "RestAPI.h"
#import "DateDropdownValueDetails.h"

@interface MonthTableViewController ()

@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) DateDropdownValueDetails *DateDropdownValueDetails;
@property (nonatomic, strong) DateDropdownValueDetails *DateDropdownItems;
@property (nonatomic, strong) NSArray *MonthTableData;
@end

@implementation MonthTableViewController
@synthesize msd_id,usl_id,clt_id,brdName,school_name;
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
    CGRect newFrame = self.view.frame;
    
    newFrame.size.width = 200;
    
    newFrame.size.height = 300;
    
    [self.view setFrame:newFrame];
    msd_id = msd_id;
    clt_id = clt_id;
    usl_id = usl_id;
    brdName = brdName;
    self.monthTableView.dataSource = self;
    self.monthTableView.delegate = self;
    
    NSLog(@"MSD Id month: %@",msd_id);
    [self httpPostRequest];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) httpPostRequest{
    //Create the response and Error
    NSError *err;
    NSString *str = app_url @"PodarApp.svc/GetDateDropdownValue";
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
    
    //Pass The String to server
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:msd_id,@"msd_id",clt_id,@"clt_id",brdName,@"brd_name",nil];
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
    NSLog(@"got datedropdown==%@", resSrt);
    
}

-(void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender
{
    NSError *error = nil;
    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[receivedData objectForKey:@"response"]];
 //   NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:
                                (NSJSONReadingMutableContainers) error:&error];
    DropdownStatus = [parsedJsonArray valueForKey:@"Status"];
    self.MonthTableData = [receivedData objectForKey:@"DateDropdownValueDetails"];
    NSLog(@"MonthTableSize:%lu",(unsigned long)[self.MonthTableData count]);
    if([DropdownStatus isEqualToString:@"1"]){
        for(int n = 0; n < [self.MonthTableData count]; n++)
        {
            _DateDropdownItems = [[DateDropdownValueDetails alloc]init];
            dropdowndetails = [self.MonthTableData objectAtIndex:n];
            _DateDropdownItems.monthid = [dropdowndetails objectForKey:@"monthid"];
            _DateDropdownItems.MonthsName =[dropdowndetails objectForKey:@"MonthsName"];
            NSLog(@"MonthName:%@",_DateDropdownItems.MonthsName);
        }
        
    }
    [self.monthTableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [self.MonthTableData count];
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [MonthTableData count];
//    NSLog(@"MonthTableSize:%lu",(unsigned long)[MonthTableData count]);
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.MonthTableData.count;
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIndentifier = @"Cell";
//    
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
//    }
//    monthanme = [[MonthTableData objectAtIndex:indexPath.row] objectForKey:@"MonthsName"];
//    monthid = [[MonthTableData objectAtIndex:indexPath.row] objectForKey:@"monthid"];
//    cell.textLabel.text = [[MonthTableData objectAtIndex:indexPath.row] objectForKey:@"cit_Name"];
//    return cell;
//    
//    
//    
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    if (cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            //monthanme = [[MonthTableData objectAtIndex:indexPath.row] objectForKey:@"MonthsName"];
          //  monthid = [[MonthTableData objectAtIndex:indexPath.row] objectForKey:@"monthid"];
    
            NSLog(@"MonthNamecell:%@",monthanme);

           // cell.textLabel.text = [[MonthTableData objectAtIndex:indexPath.row] objectForKey:@"cit_Name"];
    cell.textLabel.text = @"April";
            return cell;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
