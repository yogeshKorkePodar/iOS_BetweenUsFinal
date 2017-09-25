//
//  PaymentInfoTableViewCell.h
//  TestAutoLayout
//
//  Created by podar on 15/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_description;
@property (weak, nonatomic) IBOutlet UILabel *label_paymentMode;
@property (weak, nonatomic) IBOutlet UILabel *label_receiptDate;
@property (weak, nonatomic) IBOutlet UILabel *label_amount;
@property (weak, nonatomic) IBOutlet UILabel *label_receiptNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstarint;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end
