//
//  AnnouncementResult2.h
//  BetweenUsFinal
//
//  Created by podar on 06/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnouncementResult2 : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Clt_id;
@property (nonatomic, copy) NSString *msg_ID;
@property (nonatomic, copy) NSString *msg_Message;
@property (nonatomic, copy) NSString *msg_date;
@property (nonatomic, copy) NSString *msg_type;
@property (nonatomic, copy) NSString *pmu_readunreadstatus;
@property (nonatomic, copy) NSString *usl_id;
@end
