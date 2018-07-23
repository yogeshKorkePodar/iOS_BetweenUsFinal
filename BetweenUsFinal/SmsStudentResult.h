//
//  SmsStudentResult.h
//  BetweenUs
//
//  Created by podar on 13/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmsStudentResult : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Con_ID;
@property (nonatomic, copy) NSString *Div;
@property (nonatomic, copy) NSString *Reg_No;
@property (nonatomic, copy) NSString *Roll_No;
@property (nonatomic, copy) NSString *Section;
@property (nonatomic, copy) NSString *Shift;
@property (nonatomic, copy) NSString *Std;
@property (nonatomic, copy) NSString *Student_Name;
@property (nonatomic, copy) NSString *cls_ID;
@property (nonatomic, copy) NSString *con_MNo;
@property (nonatomic, copy) NSString *msd_ID;
@property (nonatomic, copy) NSString *msd_candate;
@property (nonatomic, copy) NSString *stu_ID;
@property (nonatomic, copy) NSString *usl_Id;









@end
