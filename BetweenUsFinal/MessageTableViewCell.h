//
//  MessageTableViewCell.h
//  TestAutoLayout
//
//  Created by podar on 23/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell{
    NSString *filename;
    NSString *filePath;
}
@property (weak, nonatomic) IBOutlet UILabel *label_senderName;
@property (weak, nonatomic) IBOutlet UILabel *label_date;
@property (weak, nonatomic) IBOutlet UILabel *label_message;
@property (weak, nonatomic) IBOutlet UILabel *label_subject;
- (IBAction)attachmentBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *attachmentClick;

@end
