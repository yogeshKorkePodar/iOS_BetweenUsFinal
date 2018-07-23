//
//  AnnouncementTableViewCell.h
//  TestAutoLayout
//
//  Created by podar on 28/06/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementTableViewCell : UITableViewCell<UITextViewDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *datelabel;
//@property (weak, nonatomic) IBOutlet UITextView *announcement_text;
@property (weak, nonatomic) IBOutlet UILabel *announcement_label;

@property (weak, nonatomic) IBOutlet UIView *announcementView;
@property (weak, nonatomic) IBOutlet UIView *ViewAnnouncement;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *announcementMsgHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullAnnouncementViewHeight;
@property (weak, nonatomic) IBOutlet UITextView *announcement_text;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *announcementMsgHeight;
@property (weak, nonatomic) IBOutlet UILabel *datelabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *announcementMsgHeight;

@end
