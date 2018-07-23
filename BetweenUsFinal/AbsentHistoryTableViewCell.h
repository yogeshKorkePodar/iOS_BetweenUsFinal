//
//  AbsentHistoryTableViewCell.h
//  TestAutoLayout
//
//  Created by podar on 22/07/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbsentHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date_label;
@property (weak, nonatomic) IBOutlet UITextView *absentReason_textview;

@end
