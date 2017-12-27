//
//  AdminDropResult.h
//  BetweenUs
//
//  Created by podar on 22/09/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdminDropResult : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Brd_ID;
@property (nonatomic, copy) NSString *Brd_Name;
@property (nonatomic, copy) NSString *Clt_id;
@property (nonatomic, copy) NSString *acy_Year;
@property (nonatomic, copy) NSString *cls_ID;
@property (nonatomic, copy) NSString *acy_id;
@property (nonatomic, copy) NSString *div_id;
@property (nonatomic, copy) NSString *div_name;
@property (nonatomic, copy) NSString *sch_id;
@property (nonatomic, copy) NSString *sch_name;
@property (nonatomic, copy) NSString *sec_ID;
@property (nonatomic, copy) NSString *sec_Name;
@property (nonatomic, copy) NSString *sec_srno;
@property (nonatomic, copy) NSString *sft_ID;
@property (nonatomic, copy) NSString *sft_Srno;
@property (nonatomic, copy) NSString *sft_name;
@property (nonatomic, copy) NSString *std_Name;
@property (nonatomic, copy) NSString *std_id;
@property (nonatomic, copy) NSString *std_srno;
@property (nonatomic, copy) NSString *str_ID;
@property (nonatomic, copy) NSString *str_Name;


@end
