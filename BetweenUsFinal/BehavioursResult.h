//
//  BehavioursResult.h
//  TestAutoLayout
//
//  Created by podar on 28/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BehavioursResult : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *date1;
@property (nonatomic, copy) NSString *msg_Message;
@property (nonatomic, copy) NSString *msg_date;
@property (nonatomic, copy) NSString *msg_type;
@property (nonatomic, copy) NSString *sbj_name;
@end