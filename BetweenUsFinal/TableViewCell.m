//
//  TableViewCell.m
//  TestAutoLayout
//
//  Created by podar on 10/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell
@synthesize lable_name = _lable_name;
@synthesize label_std_div = _label_std_div;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
