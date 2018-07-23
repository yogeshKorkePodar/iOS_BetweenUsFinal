//
//  MessageTableViewCell.m
//  TestAutoLayout
//
//  Created by podar on 23/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label_message.numberOfLines = 2;
    
    filename = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"filename"];
    filePath = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"filePath"];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)attachmentBtn:(id)sender {
    
    NSLog(@"attachment click:%@",@"attachment click");
        NSInteger tag = [sender tag];
}
@end
