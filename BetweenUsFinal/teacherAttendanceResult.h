//
//  teacherAttendanceResult.h
//  BetweenUs
//
//  Created by podar on 02/11/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface teacherAttendanceResult : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Roll_No;
@property (nonatomic, copy) NSString *msd_id;
@property (nonatomic, copy) NSString *student_Name;
@property (nonatomic, copy) NSString *total;

@end
