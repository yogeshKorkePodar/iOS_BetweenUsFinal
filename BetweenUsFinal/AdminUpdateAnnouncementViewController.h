//
//  AdminUpdateAnnouncementViewController.h
//  BetweenUs
//
//  Created by podar on 19/09/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminUpdateAnnouncementViewController : UIViewController<UIGestureRecognizerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *update_announcement_textview;
@property (weak, nonatomic) IBOutlet UIButton *add_click;
@property (weak, nonatomic) IBOutlet UIButton *cancel_click;
- (IBAction)update_btn:(id)sender;
- (IBAction)btn_cancel:(id)sender;
@property (retain) AdminUpdateAnnouncementViewController* updateAnnouncementController;


@end
