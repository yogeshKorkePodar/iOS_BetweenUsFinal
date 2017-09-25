//
//  ResourceTableViewCell.h
//  TestAutoLayout
//
//  Created by podar on 06/07/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *resourceName_label;

@end
