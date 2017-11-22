//
//  TeacherResourceListViewController.m
//  BetweenUs
//
//  Created by podar on 22/11/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "TeacherResourceListViewController.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "ResourceTableViewCell2.h"
#import "URL_Constant.h"

@interface TeacherResourceListViewController (){
    NSDictionary *newDatasetinfoTeacherResourceList,*newDatasetinfoTeacherUploadFileAccess;
    BOOL resourceClick,firstTime;
}

@end

@implementation TeacherResourceListViewController

@synthesize msd_id,clt_id,usl_id,brd_Name,crf_id;
- (void)viewDidLoad {
    [super viewDidLoad];
    msd_id = msd_id;
    clt_id = clt_id;
    usl_id = usl_id;
    brd_Name = brd_Name;
    crf_id = crf_id;
    self.TeacherResourceTableView.dataSource = self;
    self.TeacherResourceTableView.delegate = self;
      self.navigationItem.title = @"Resource";
    firstTime = YES;
    [self checkInternetConnectivity];
}
-(void)checkInternetConnectivity{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatusViewMessage:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    [hud hideAnimated:YES];
}
-(void) checkNetworkStatusViewMessage:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
        }
    }
    if(self.internetActive == YES){
        
        [self webserviceCall];
    }
    
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
//-(void)webserviceCall{
//    //Pass The String to server
//    NSString *urlString = app_url @"PodarApp.svc/GetSMSTemplate";
//  //  newDatasetinfoTeacherSendMessageStudent = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",subject,@"pmg_subject",message,@"msg_message",sender_usl_id,@"sender_uslId",cls_ID,@"cls_id",filePath,@"filepath",attachedfilename,@"filename",stu_id,@"stud_id",nil];
//    NSLog(@"the data Details is =%@", newDatasetinfoTeacherSendMessageStudent);
//    NSError *error = nil;
//    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherSendMessageStudent options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
//    [self checkWithServer:urlString jsonString:jsonInputString];
//}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
    
    int errorCode = httpResponse.statusCode;
    
    NSString *fileMIMEType = [[httpResponse MIMEType] lowercaseString];
    
    NSLog(@"response is %d, %@", errorCode, fileMIMEType);
    
}



-(void)webserviceCall{
    if(firstTime ==YES){
    NSString *urlString = app_url @"PodarApp.svc/GetTeacherResourceList";
    
    //Pass The String to server
    newDatasetinfoTeacherResourceList= [NSDictionary dictionaryWithObjectsAndKeys:crf_id,@"crf_id",usl_id,@"usl_id",nil];
    
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherResourceList options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else if(resourceClick == YES){
        NSString *urlString = app_url @"PodarApp.svc/UpdateFileAccess";
        
        //Pass The String to server
        newDatasetinfoTeacherResourceList= [NSDictionary dictionaryWithObjectsAndKeys:crl_file,@"filename",usl_id,@"usl_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherResourceList options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
}

-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    if(firstTime = YES){
        firstTime = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err;
            NSData* responseData = nil;
            NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            responseData = [NSMutableData data] ;
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherResourceList options:kNilOptions error:&err];
            
            [request setHTTPMethod:POST];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            //Apply the data to the body
            [request setHTTPBody:jsonData];
            NSURLResponse *response;
            
            responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
            
            //This is for Response
            NSLog(@"got response==%@", resSrt);
            
            
            NSError *error = nil;
            if(!responseData == nil){
                NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                resourceStatus = [parsedJsonArray valueForKey:@"Status"];
                
                resourceData = [receivedData objectForKey:@"ResourceList"];
                NSLog(@"Status:%@",resourceStatus);
                if([resourceStatus isEqualToString:@"1"]){
                    
                }
                else if([resourceStatus isEqualToString:@"0"]){
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"No records found" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                
                [_TeacherResourceTableView reloadData];
                [hud hideAnimated:YES];
            }
        });
    });
    }
    else if(resourceClick == YES){
        resourceClick = NO;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherResourceList options:kNilOptions error:&err];
                
                [request setHTTPMethod:POST];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                
                //Apply the data to the body
                [request setHTTPBody:jsonData];
                NSURLResponse *response;
                
                responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
                
                //This is for Response
                NSLog(@"got response==%@", resSrt);
                
                
                           });
        });
    }
    
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
    resourceClick = YES;
    [self webserviceCall];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try {
        return [resourceData count];
    }  @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    ResourceTableViewCell2 *Resourcecell = (ResourceTableViewCell2 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
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
    return Resourcecell;}



@end
