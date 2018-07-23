//
//  AdminAnnouncementTableViewCell2.h
//  BetweenUs
//
//  Created by podar on 04/12/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminAnnouncementTableViewCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *announcement_date;
@property (weak, nonatomic) IBOutlet UILabel *label_announcement;
@property (weak, nonatomic) IBOutlet UIView *edit_announcement_view;
@property (weak, nonatomic) IBOutlet UIButton *edit_click;

@end
