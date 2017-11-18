//
//  teacherStudBehaviourResult.h
//  BetweenUs
//
//  Created by podar on 07/11/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface teacherStudBehaviourResult : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *TeacherName;
@property (nonatomic, copy) NSString *Usl_Id;
@property (nonatomic, copy) NSString *bhr_name;
@property (nonatomic, copy) NSString *bhr_type;
@property (nonatomic, copy) NSString *sbh_date;
@property (nonatomic, copy) NSString *sbh_date1;
@property (nonatomic, copy) NSString *sbh_id;
@property (nonatomic, copy) NSString *stud_ID;

@end
