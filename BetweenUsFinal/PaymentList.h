//
//  PaymentList.h
//  TestAutoLayout
//
//  Created by podar on 15/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentList : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Pay_ReciptDate;
@property (nonatomic, copy) NSString *Pay_ReciptNo;
@property (nonatomic, copy) NSString *fcl_FOR;
@property (nonatomic, copy) NSString *fct_id;
@property (nonatomic, copy) NSString *pay_Amount;
@property (nonatomic, copy) NSString *pay_Bank;
@property (nonatomic, copy) NSString *pay_Branch;
@property (nonatomic, copy) NSString *pay_Date;
@property (nonatomic, copy) NSString *pay_ID;
@property (nonatomic, copy) NSString *pay_clear;
@property (nonatomic, copy) NSString *pay_serial;
@property (nonatomic, copy) NSString *pym_Name;
@property (nonatomic, copy) NSString *trm_Name;
@end
