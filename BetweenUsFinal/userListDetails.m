//
//  userListDetails.m
//  TestAutoLayout
//
//  Created by podar on 13/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "userListDetails.h"

@implementation userListDetails

// Init the object with information from a dictionary
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    if(self = [self init]) {
        // Assign all properties with keyed values from the dictionary
        _Brd_Name= [jsonDictionary objectForKey:@"_Brd_Name"];
        _TeachAnoucementCnt = [jsonDictionary objectForKey:@"TeachAnoucementCnt"];
        _acy_year = [jsonDictionary objectForKey:@"acy_year"];
        _clss_teacher = [jsonDictionary objectForKey:@"clss_teacher"];
        _clt_id = [jsonDictionary objectForKey:@"clt_id"];
        _div_name = [jsonDictionary objectForKey:@"div_name"];
        _msd_ID = [jsonDictionary objectForKey:@"msd_ID"];
        _name = [jsonDictionary objectForKey:@"name"];
        _org_id = [jsonDictionary objectForKey:@"org_id"];
        _rol_id = [jsonDictionary objectForKey:@"rol_id"];
        _sch_logo = [jsonDictionary objectForKey:@"sch_logo"];
        _sch_name = [jsonDictionary objectForKey:@"sch_name"];
        _sft_name = [jsonDictionary objectForKey:@"sft_name"];
        _std_Name = [jsonDictionary objectForKey:@"std_Name"];
        _stu_ID = [jsonDictionary objectForKey:@"stu_ID"];
        _usl_id = [jsonDictionary objectForKey:@"usl_id"];
        _vme_subscription = [jsonDictionary objectForKey:@"vme_subscription"];
    }
    
    return self;
}

@end
