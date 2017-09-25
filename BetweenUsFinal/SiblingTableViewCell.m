//
//  SiblingTableViewCell.m
//  TestAutoLayout
//
//  Created by podar on 15/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "SiblingTableViewCell.h"

@implementation SiblingTableViewCell
@synthesize label_std_div = _label_std_div;
@synthesize label_studentName = _label_studentName;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
