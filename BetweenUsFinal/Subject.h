//
//  Subject.h
//  TestAutoLayout
//
//  Created by podar on 18/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subject : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *sbj_name;
@end
