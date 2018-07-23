//
//  ParentInfoState.h
//  TestAutoLayout
//
//  Created by podar on 17/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParentInfoState : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Ste_ID;
@property (nonatomic, copy) NSString *Ste_Name;
@end
