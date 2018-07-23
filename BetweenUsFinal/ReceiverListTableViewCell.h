//
//  ReceiverListTableViewCell.h
//  BetweenUs
//
//  Created by podar on 17/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiverListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *SrNo_label;
@property (strong, nonatomic) IBOutlet UILabel *receiverName_label;
@property (strong, nonatomic) IBOutlet UILabel *receiverStd_label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *std_constraint;
@property (strong, nonatomic) IBOutlet UIView *cellView;
@end
