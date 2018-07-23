//
//  PaymentInfoTableViewCell.m
//  TestAutoLayout
//
//  Created by podar on 15/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "PaymentInfoTableViewCell.h"

@implementation PaymentInfoTableViewCell
@synthesize label_amount = _label_amount;
@synthesize label_description = _label_description;
@synthesize label_paymentMode = _label_paymentMode;
@synthesize label_receiptDate = _label_receiptDate;
@synthesize label_receiptNumber = _label_receiptNumber;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
