//
//  AdmTechList.h
//  BetweenUs
//
//  Created by podar on 19/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdmTechList : NSObject
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Rol_ID;
@property (nonatomic, copy) NSString *SrNo;
@property (nonatomic, copy) NSString *fullname;
@property (nonatomic, copy) NSString *stf_Mno;
@property (nonatomic, copy) NSString *usl_Id;
@end
