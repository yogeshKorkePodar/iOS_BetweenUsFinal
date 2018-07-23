//
//  ResourceList.h
//  TestAutoLayout
//
//  Created by podar on 06/07/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceList : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *crl_descp;
@property (nonatomic, copy) NSString *crl_discription;
@property (nonatomic, copy) NSString *crl_file;
@property (nonatomic, copy) NSString *crl_file_name;
@property (nonatomic, copy) NSString *crl_id;
@property (nonatomic, copy) NSString *ext;
@end