//
//  stundentListDetails.m
//  TestAutoLayout
//
//  Created by podar on 13/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "stundentListDetails.h"

@implementation stundentListDetails



- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    if(self = [self init]) {
        
        // Assign all properties with keyed values from the dictionary
        _Brd_Name= [jsonDictionary objectForKey:@"_Brd_Name"];
        _SchoolLogo = [jsonDictionary objectForKey:@"SchoolLogo"];
        _StudentResourceExist = [jsonDictionary objectForKey:@"StudentResourceExist"];
        _acy_Year = [jsonDictionary objectForKey:@"acy_Year"];
        _acy_id = [jsonDictionary objectForKey:@"acy_id"];
        _annoucementCnt = [jsonDictionary objectForKey:@"annoucementCnt"];
        _behaviourcnt = [jsonDictionary objectForKey:@"behaviourcnt"];
        _cls_ID = [jsonDictionary objectForKey:@"cls_ID"];
        _div_name = [jsonDictionary objectForKey:@"div_name"];
        _msd_RollNo = [jsonDictionary objectForKey:@"msd_RollNo"];
        _org_id = [jsonDictionary objectForKey:@"org_id"];
        _sch_Area = [jsonDictionary objectForKey:@"sch_Area"];
        _sch_id = [jsonDictionary objectForKey:@"sch_id"];
        _sec_ID = [jsonDictionary objectForKey:@"sec_ID"];
        _sec_Name = [jsonDictionary objectForKey:@"sec_name"];
        _sft_ID = [jsonDictionary objectForKey:@"sft_ID"];
        _sft_name = [jsonDictionary objectForKey:@"sft_name"];
        _std_ID = [jsonDictionary objectForKey:@"std_ID"];
        _stu_id = [jsonDictionary objectForKey:@"stu_id"];
        _std_Name = [jsonDictionary objectForKey:@"std_Name"];
        _str_ID = [jsonDictionary objectForKey:@"str_ID"];
        _stu_display = [jsonDictionary objectForKey:@"stu_display"];
    }
    
    return self;
}

@end
