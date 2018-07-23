//
//  stundentListDetails.h
//  TestAutoLayout
//
//  Created by podar on 13/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface stundentListDetails : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, copy) NSString *Brd_Name;
@property (nonatomic, copy) NSString *Brd_ID;
@property (nonatomic, copy) NSString *SchoolLogo;
@property (nonatomic, copy) NSString *StudentResourceExist;
@property (nonatomic, copy) NSString *acy_Year;
@property (nonatomic, copy) NSString *acy_id;
@property (nonatomic, copy) NSString *annoucementCnt;
@property (nonatomic, copy) NSString *behaviourcnt;
@property (nonatomic, copy) NSString *cls_ID;
@property (nonatomic, copy) NSString *div_name;
@property (nonatomic, copy) NSString *msd_RollNo;
@property (nonatomic, copy) NSString *org_id;
@property (nonatomic, copy) NSString *sch_Area;
@property (nonatomic, copy) NSString *sch_id;
@property (nonatomic, copy) NSString *sec_ID;
@property (nonatomic, copy) NSString *sec_Name;
@property (nonatomic, copy) NSString *sft_ID;
@property (nonatomic, copy) NSString *sft_name;
@property (nonatomic, copy) NSString *std_ID;
@property (nonatomic, copy) NSString *stu_id;
@property (nonatomic, copy) NSString *std_Name;
@property (nonatomic, copy) NSString *str_ID;
@property (nonatomic, copy) NSString *stu_display;
@property (nonatomic, copy) NSString *AcadmicYear;
@property (nonatomic, copy) NSString *Board;
@property (nonatomic, copy) NSString *Division;
@property (nonatomic, copy) NSString *StudentId;
@property (nonatomic, copy) NSString *StudentName;
@property (nonatomic, copy) NSString *clt_id;
@property (nonatomic, copy) NSString *msd_ID;
@property (nonatomic, copy) NSString *standard;

@end
