//
//  ParentInfoStudent.h
//  TestAutoLayout
//
//  Created by podar on 14/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParentInfoStudent : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
@property (nonatomic, copy) NSString *Ste_Name;
@property (nonatomic, copy) NSString *adr_Area;
@property (nonatomic, copy) NSString *adr_Building;
@property (nonatomic, copy) NSString *adr_Street;
@property (nonatomic, copy) NSString *adr_pincode;
@property (nonatomic, copy) NSString *cit_Name;
@property (nonatomic, copy) NSString *cit_id;
@property (nonatomic, copy) NSString *cnt_Name;
@property (nonatomic, copy) NSString *cnt_id;
@property (nonatomic, copy) NSString *con_MNo;
@property (nonatomic, copy) NSString *con_No;
@property (nonatomic, copy) NSString *con_std;
@property (nonatomic, copy) NSString *eml_mailID;
@property (nonatomic, copy) NSString *ste_id;
@end
