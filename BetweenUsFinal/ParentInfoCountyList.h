//
//  ParentInfoCountyList.h
//  TestAutoLayout
//
//  Created by podar on 17/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParentInfoCountyList : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *cnt_ID;
@property (nonatomic, copy) NSString *cnt_Name;
@property (nonatomic, copy) NSString *cnt_code;

@end
