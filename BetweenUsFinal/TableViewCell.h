//
//  TableViewCell.h
//  TestAutoLayout
//
//  Created by podar on 10/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lable_name;
@property (weak, nonatomic) IBOutlet UILabel *label_std_div;

@end
