//
//  AdminMessageTableViewCell.h
//  BetweenUs
//
//  Created by podar on 17/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *reciverList_view;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_subj;
@property (weak, nonatomic) IBOutlet UILabel *label_date;
@property (weak, nonatomic) IBOutlet UILabel *message_label;
@property (weak, nonatomic) IBOutlet UIButton *attachment_click;
@property (weak, nonatomic) IBOutlet UIButton *receiver_click;
@end
