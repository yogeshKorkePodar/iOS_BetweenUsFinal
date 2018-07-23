//
//  AttendHistory.h
//  TestAutoLayout
//
//  Created by podar on 22/07/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendHistory : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *atn_Reason;
@property (nonatomic, copy) NSString *atn_date;
@end
