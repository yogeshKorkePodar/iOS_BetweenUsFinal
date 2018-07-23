//
//  SiblingTableViewCell.h
//  TestAutoLayout
//
//  Created by podar on 15/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiblingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_studentName;
@property (weak, nonatomic) IBOutlet UILabel *label_std_div;
@property (weak, nonatomic) IBOutlet UIView *siblingUIView;


@end
