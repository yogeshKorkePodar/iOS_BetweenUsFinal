//
//  ReceiverListTableViewCell.h
//  BetweenUs
//
//  Created by podar on 17/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiverListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *SrNo_label;
@property (weak, nonatomic) IBOutlet UILabel *receiverName_label;
@property (weak, nonatomic) IBOutlet UILabel *receiverStd_label;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@end
