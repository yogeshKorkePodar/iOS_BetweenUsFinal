
//
//  Created by podar on 24/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewMessageResult : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Clt_ID;
@property (nonatomic, copy) NSString *Fullname;
@property (nonatomic, copy) NSString *pmg_Message;
@property (nonatomic, copy) NSString *pmg_date;
@property (nonatomic, copy) NSString *pmg_file_name;
@property (nonatomic, copy) NSString *pmg_file_path;
@property (nonatomic, copy) NSString *pmg_subject;
@property (nonatomic, copy) NSString *pmu_ID;
@property (nonatomic, copy) NSString *usl_ID;
@property (nonatomic, copy) NSString *msg_Message;
@property (nonatomic, copy) NSString *msg_date;
@property (nonatomic, copy) NSString *msg_Message1;
@property (nonatomic, copy) NSString *msg_type;
@property (nonatomic, copy) NSString *stu_id;
@property (nonatomic, copy) NSString *pmg_ID;
@property (nonatomic, copy) NSString *pmu_readunredStatus;

@end
