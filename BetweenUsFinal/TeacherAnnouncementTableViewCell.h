//
//  TeacherAnnouncementTableViewCell.h
//  BetweenUs
//
//  Created by podar on 22/11/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeacherAnnouncementTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *datelabel;
@property (weak, nonatomic) IBOutlet UITextView *announcementText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *announcementHeight;

@end
