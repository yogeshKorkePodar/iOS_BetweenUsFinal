//
//  ViewBehaviourTableViewCell.h
//  BetweenUs
//
//  Created by podar on 07/11/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewBehaviourTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *behaviourLabel;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *behaviourImg;

@end
