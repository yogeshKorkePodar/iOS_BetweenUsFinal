//
//  AdminAnnouncementViewController.h
//  BetweenUs
//
//  Created by podar on 14/09/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "AdminUpdateAnnouncementViewController.h"
#import "WYPopoverController.h"

@interface AdminAnnouncementViewController : UIViewController{
    NSString *announcementStatus,*newAnnouncement,*UpdateStatus;
    NSString *DeviceToken,*device,*AddStatus;
    NSString *DeviceType;
    NSArray *adminAnnoucementArray;
    NSDictionary *announcemntdetailsdictionry;
    Reachability* internetReachable;
    Reachability* hostReachable;
    //AdminUpdateAnnouncementViewController *updateAnnouncementController;

}
//- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller;
@property (weak, nonatomic) IBOutlet UILabel *label_add;
@property (weak, nonatomic) IBOutlet UIView *add_announcement_view;
@property (weak, nonatomic) IBOutlet UITableView *admin_announcement_tableview;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *brd_name;
@property(nonatomic,strong) NSString *announcementUslId;
@property BOOL internetActiveViewMessage;
@property (retain) AdminUpdateAnnouncementViewController* updateAnnouncementController;

@property BOOL hostActiveViewMessage;

@end
