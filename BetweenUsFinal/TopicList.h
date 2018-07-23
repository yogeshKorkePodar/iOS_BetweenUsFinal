//
//  TopicList.h
//  TestAutoLayout
//
//  Created by podar on 18/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicList : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *No_of_logs_filled;
@property (nonatomic, copy) NSString *crf_date;
@property (nonatomic, copy) NSString *crf_id;
@property (nonatomic, copy) NSString *crf_res_name;
@property (nonatomic, copy) NSString *crf_topicname;
@property (nonatomic, copy) NSString *srNo;
@property (nonatomic, copy) NSString *total_logs;
@end
