//
//  CycleTest.h
//  TestAutoLayout
//
//  Created by podar on 18/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CycleTest : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *cyc_id;
@property (nonatomic, copy) NSString *cyc_name;
@end
