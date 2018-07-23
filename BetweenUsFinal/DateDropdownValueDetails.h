//
//  DateDropdownValueDetails.h
//  TestAutoLayout
//
//  Created by podar on 23/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateDropdownValueDetails : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *AttnPercent;
@property (nonatomic, copy) NSString *MonthYear;
@property (nonatomic, copy) NSString *MonthsName;
@property (nonatomic, copy) NSString *monthid;
@property (nonatomic, copy) NSString *years;
@end
