//
//  ResourceViewController2.h
//  BetweenUsFinal
//
//  Created by podar on 07/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourceViewController2 : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *brd_Name;
    NSString *crf_id;
    NSString *resourceStatus;
    NSString *filename;
    NSString *fileExtension;
    NSString *crl_id;
    NSString *crl_file;
    NSString *crl_description;
    NSString *fileId;
    NSString *resourceUrl;
    NSDictionary *resourceDetails;
    NSArray *resourceData;
    UILabel *lb1;
}

@property (weak, nonatomic) IBOutlet UITableView *resourceTableData;

@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *brd_Name;
@property(nonatomic,strong) NSString *crf_id;


@end
