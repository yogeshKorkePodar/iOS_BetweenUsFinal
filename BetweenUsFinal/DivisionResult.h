//
//  DivisionResult.h
//  BetweenUs
//
//  Created by podar on 24/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DivisionResult : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *div_name;
@property (nonatomic, copy) NSString *div_id;

@end
