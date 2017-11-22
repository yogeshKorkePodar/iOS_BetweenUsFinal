//
//  TopicListTableViewCell.h
//  BetweenUs
//
//  Created by podar on 07/11/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topicName;
@property (weak, nonatomic) IBOutlet UIButton *totalLogs;
@property (weak, nonatomic) IBOutlet UIButton *logsFilled;
@property (weak, nonatomic) IBOutlet UIButton *plusButtonClick;
@property (weak, nonatomic) IBOutlet UIButton *viewLogClick;
@property (weak, nonatomic) IBOutlet UILabel *rollNo;
- (IBAction)plusBtn:(id)sender;
@end
