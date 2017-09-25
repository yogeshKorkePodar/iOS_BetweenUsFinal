//
//  userListDetails.h
//  TestAutoLayout
//
//  Created by podar on 13/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userListDetails : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Brd_Name;
@property (nonatomic, copy) NSString *TeachAnoucementCnt;
@property (nonatomic, copy) NSString *acy_year;
@property (nonatomic, copy) NSString *clss_teacher;
@property (nonatomic, copy) NSString *clt_id;
@property (nonatomic, copy) NSString *div_name;
@property (nonatomic, copy) NSString *msd_ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *org_id;
@property (nonatomic, copy) NSString *rol_id;
@property (nonatomic, copy) NSString *sch_logo;
@property (nonatomic, copy) NSString *sch_name;
@property (nonatomic, copy) NSString *sft_name;
@property (nonatomic, copy) NSString *std_Name;
@property (nonatomic, copy) NSString *stu_ID;
@property (nonatomic, copy) NSString *usl_id;
@property (nonatomic, copy) NSString *vme_subscription;



@end
