//
//  RecipentResult2.h
//  BetweenUsFinal
//
//  Created by podar on 05/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipentResult2 : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *usl_Id;
@end
