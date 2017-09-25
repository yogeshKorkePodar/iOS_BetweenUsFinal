//
//  RecipentResult.h
//  TestAutoLayout
//
//  Created by podar on 30/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipentResult : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *usl_Id;
@end
