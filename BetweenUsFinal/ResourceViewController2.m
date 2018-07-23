//
//  ResourceViewController2.m
//  BetweenUsFinal
//
//  Created by podar on 07/09/17.
//  Copyright © 2017 podar. All rights reserved.
//
//

//
#import "URL_Constant.h"
#import "ResourceViewController2.h"
#import "RestAPI.h"
#import "ResourceList.h"
#import "ResourceTableViewCell2.h"
@interface ResourceViewController2 ()

@property (nonatomic, strong) RestAPI *restApi;
@property (nonatomic, strong) ResourceList *ResourceListItems;
@property (nonatomic, strong) ResourceList *ResourceListDetails;


@end

@implementation ResourceViewController2
@synthesize msd_id,clt_id,usl_id,brd_Name,crf_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    msd_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"msd_Id"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    
    brd_Name = [[NSUserDefaults standardUserDefaults]
               stringForKey:@"brd_name"];
    
    crf_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"crf_id"];
    

    
    msd_id = msd_id;
    clt_id = clt_id;
    usl_id = usl_id;
    brd_Name = brd_Name;
    crf_id = crf_id;
    
    self.resourceTableData.tableFooterView = [UIView new];
    self.resourceTableData.dataSource = self;
    self.resourceTableData.delegate = self;
    [self httpPostRequest];
    
}
-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}
-(void) httpPostRequest{
    
    NSError *err;
    NSString *str = app_url @"GetResourceList";
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
    
    //Pass The String to server
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:crf_id,@"crf_id",nil];
    NSLog(@"the sentdata Details is =%@", newDatasetInfo);
    
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
    NSLog(@"got sentMessageesponse==%@", resSrt);
    
    
    
}

-(void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender

{
    NSError *error = nil;
    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
    resourceStatus= [parsedJsonArray valueForKey:@"Status"];
    NSLog(@"Status:%@",resourceStatus);
    
    resourceData = [receivedData objectForKey:@"ResourceList"];
    if([resourceStatus isEqualToString:@"1"]){
        for(int n = 0; n < [resourceData  count]; n++)
        {
            _ResourceListItems= [[ResourceList alloc]init];
            resourceDetails = [resourceData objectAtIndex:n];
            _ResourceListItems.crl_file_name = [resourceDetails objectForKey:@"crl_file_name"];
            NSLog(@"FileName:%@",_ResourceListItems.crl_file_name);
        }
    }
    else if([resourceStatus isEqualToString:@"0"]){
        
        [_resourceTableData setHidden:YES];
        lb1 = [[UILabel alloc] init];
        [lb1 setFrame: CGRectMake(100, 10, 250, 320)];
        lb1.backgroundColor=[UIColor clearColor];
        lb1.font= [UIFont systemFontOfSize:14.0];
        
        lb1.textColor=[UIColor blackColor];
        lb1.userInteractionEnabled=YES;
        lb1.font = [UIFont fontWithName:@"Arial-Bold" size:14.0f];
        [self.view addSubview:lb1];
        lb1.text= @"No Records Found";
        
    }
    [self.resourceTableData reloadData];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resourceData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    ResourceTableViewCell2 *Resourcecell = (ResourceTableViewCell2 *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (Resourcecell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ResourceTableViewCell2" owner:self options:nil];
        Resourcecell = [nib objectAtIndex:0];
    }
    filename = [[resourceData objectAtIndex:indexPath.row] objectForKey:@"crl_discription"];
    fileExtension = [[resourceData objectAtIndex:indexPath.row] objectForKey:@"ext"];
    crl_id = [[resourceData objectAtIndex:indexPath.row] objectForKey:@"crl_id"];
    crl_file = [[resourceData objectAtIndex:indexPath.row] objectForKey:@"crl_file"];
    crl_description = [[resourceData objectAtIndex:indexPath.row] objectForKey:@"crl_descp"];
    Resourcecell.resourceName_label.text = filename;
    
    
    if([crl_description isEqualToString:@"Worksheet"]){
        Resourcecell.icon.image = [UIImage imageNamed:@"pdf_file_format_symbol.png"];
    }
    else if([crl_description isEqualToString:@"Presentation"]){
        Resourcecell.icon.image = [UIImage imageNamed:@"ppt1_32.png"];
    }
    else if([crl_description isEqualToString:@"Audio/Video"]){
        Resourcecell.icon.image = [UIImage imageNamed:@"audio.png"];
    }
    else if([crl_description isEqualToString:@"Video"]){
        Resourcecell.icon.image = [UIImage imageNamed:@"videos.png"];
    }
    else {
        Resourcecell.icon.image = [UIImage imageNamed:@"pdf_file_format_symbol.png"];
    }
    return Resourcecell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    crl_file = [[resourceData objectAtIndex:indexPath.row] objectForKey:@"crl_file"];
    NSArray *listItems = [crl_file componentsSeparatedByString:@":"];
    fileId = listItems[1];
    
    //NSLog(@"FileID  %@",fileId);
    resourceUrl = [NSString stringWithFormat: @"%@%@ ", @"https://drive.google.com/a/podar.org/file/d/", fileId];
    
    //  NSString *newStringUrl;
    resourceUrl = [@"https://drive.google.com/a/podar.org/file/d/" stringByAppendingString:fileId];
    NSLog(@"FileID  %@",resourceUrl);
    NSURL *url = [NSURL URLWithString:resourceUrl];
    NSLog(@"Url%@",url);
    
    [[UIApplication sharedApplication] openURL:url];
    
}


@end
