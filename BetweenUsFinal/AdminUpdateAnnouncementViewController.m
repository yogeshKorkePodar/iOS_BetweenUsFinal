//
//  AdminUpdateAnnouncementViewController.m
//  BetweenUs
//
//  Created by podar on 19/09/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "AdminUpdateAnnouncementViewController.h"
#import "WYPopoverController.h"
#import "AdminAnnouncementViewController.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "CCKFNavDrawer.h"

@interface AdminUpdateAnnouncementViewController (){
    NSString *old_announcement;
    NSString *msg_id;
    NSString *newAnnouncement;
    NSString *updateannouncementStatus;
    WYPopoverController *settingsPopoverController;
    NSDictionary *newDatasetinfoAdminUpdateAnnouncement;
    AdminAnnouncementViewController *con;
    
}

@end

@implementation AdminUpdateAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_update_announcement_textview setDelegate:self];
    old_announcement = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"old_announcement"];
    msg_id = [[NSUserDefaults standardUserDefaults]
             stringForKey:@"msg_id"];

    [_update_announcement_textview setText:old_announcement];
    UITapGestureRecognizer *tapGestCancel=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnceCancel)];
    [tapGestCancel setNumberOfTapsRequired:1];
    [_cancel_click addGestureRecognizer:tapGestCancel];
    tapGestCancel.delegate = self;
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tapOnceCancel{
     AdminAnnouncementViewController *con  = [[AdminAnnouncementViewController alloc]init];
    NSLog(@"btn clicked tap==%@", @"btn clicked");
 //   [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    [self popoverControllerDidDismissPopover:(WYPopoverController *)_updateAnnouncementController];
    
}
- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == settingsPopoverController)
    {
        settingsPopoverController.delegate = nil;
        settingsPopoverController = nil;
        [settingsPopoverController dismissPopoverAnimated:YES completion:^{
            [self popoverControllerDidDismissPopover:settingsPopoverController];
        }];    }
}

//- (IBAction)cancel_btn:(id)sender {
//    
////    WYPopoverController  *controller = [[WYPopoverController alloc]init];
////    [controller dismissPopoverAnimated:YES];
////    
////    AdminAnnouncementViewController *con  = [[AdminAnnouncementViewController alloc]init];
////   // con popover
////    [[self presentingViewController] dismissViewControllerAnimated:YES
////                                                        completion:nil];
////    [con removeFromParentViewController];
//    [settingsPopoverController dismissPopoverAnimated:YES completion:^{
//        [self popoverControllerDidDismissPopover:settingsPopoverController];
//    }];
//}

- (IBAction)update_btn:(id)sender {
    newAnnouncement = _update_announcement_textview.text;
    [self webserviceCall];
}


- (IBAction)btn_cancel:(id)sender {
    //This is for Response
    NSLog(@"btn clicked==%@", @"btn clicked");
    

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(void)webserviceCall{
    
 
        
        NSString *urlString = app_url @"UpdateAdminAnnoucement";
        
        //Pass The String to server
        newDatasetinfoAdminUpdateAnnouncement = [NSDictionary dictionaryWithObjectsAndKeys:msg_id,@"msg_Id",newAnnouncement,@"message",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminUpdateAnnouncement options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
        

}

-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
 
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminUpdateAnnouncement options:kNilOptions error:&err];
                
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
              //  NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                updateannouncementStatus = [parsedJsonArray valueForKey:@"Status"];
             //   adminAnnoucementArray = [receivedData valueForKey:@"AnnouncementResult"];
                NSLog(@"Status:%@",updateannouncementStatus);
                
                if([updateannouncementStatus isEqualToString:@"1"]){
                    NSLog(@"got response==%@", @"Updated" );
                   
                }
    
                [hud hideAnimated:YES];
            });
        });
    
}

@end
