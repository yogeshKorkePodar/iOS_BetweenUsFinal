//
//  AdminAnnouncementTableViewCell.h
//  BetweenUs
//
//  Created by podar on 14/09/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminAnnouncementTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *announcement_date;
@property (weak, nonatomic) IBOutlet UILabel *label_announcement;
@property (weak, nonatomic) IBOutlet UIView *edit_announcement_view;
@property (weak, nonatomic) IBOutlet UIButton *edit_click;

@end
