//
//  teacherBehaviourStudResult.h
//  BetweenUs
//
//  Created by podar on 07/11/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface teacherBehaviourStudResult : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Roll_No;
@property (nonatomic, copy) NSString *msd_candate;
@property (nonatomic, copy) NSString *msd_id;
@property (nonatomic, copy) NSString *stu_display;
@end
