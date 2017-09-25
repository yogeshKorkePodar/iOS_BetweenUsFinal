//
//  BehaviourTableViewCell.h
//  TestAutoLayout
//
//  Created by podar on 28/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BehaviourTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *behaviourmsg;

@end
