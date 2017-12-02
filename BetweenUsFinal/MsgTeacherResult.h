//
//  MsgTeacherResult.h
//  BetweenUs
//
//  Created by podar on 29/09/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgTeacherResult : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *StaffName;
@property (nonatomic, copy) NSString *usl_Id;
@end
