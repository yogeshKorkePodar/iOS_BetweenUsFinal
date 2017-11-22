//
//  TopicListTableViewCell.m
//  BetweenUs
//
//  Created by podar on 07/11/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "TopicListTableViewCell.h"

@implementation TopicListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)plusBtn:(id)sender {
    NSLog(@"Cliked");
}

@end
