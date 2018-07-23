//
//  ParentInfocity.h
//  TestAutoLayout
//
//  Created by podar on 17/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParentInfocity : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *cit_ID;
@property (nonatomic, copy) NSString *cit_Name;
@end