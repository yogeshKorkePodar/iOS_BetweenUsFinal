//
//  MsgStudentResult.h
//  BetweenUs
//
//  Created by podar on 24/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgStudentResult : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Div;
@property (nonatomic, copy) NSString *Roll_No;
@property (nonatomic, copy) NSString *Section;
@property (nonatomic, copy) NSString *Std;
@property (nonatomic, copy) NSString *Student_Name;
@property (nonatomic, copy) NSString *stu_ID;
@property (nonatomic, copy) NSString *usl_Id;

@end
