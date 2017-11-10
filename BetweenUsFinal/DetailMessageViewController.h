//
//  DetailMessageViewController.h
//  TestAutoLayout
//
//  Created by podar on 19/07/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMessageViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
{
    NSString *msd_id;
    NSString *usl_id;
    NSString *clt_id;
    NSString *brd_Name;
    NSString *notmarked;
    NSString *message;
    NSString *date;
    NSString *subject;
    NSString *senderName;
    NSString *readStatus;
    NSString *enteredMessage;
    NSString *replyStatus;
    NSString *replyStatusMessage;
    NSString *messageSubject;
    NSString *replyMessage;
    NSString *filename;
    NSString *filePath;
    NSDictionary *attendancedetailsdictionry;
    NSString *device;

}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageView_width;

@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *brd_Name;
@property (strong, nonatomic) IBOutlet UIView *superView;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *subject;
@property(nonatomic,strong) NSString *toUslId;
@property(nonatomic,strong) NSString *pmuId;
@property(nonatomic,strong) NSString *filename;
@property(nonatomic,strong) NSString *filePath;
@property(nonatomic,strong) NSString *EnterMessageViewValue;
- (IBAction)detailSend:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainviewHeightConstarint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet UIView *enterMessageView;
- (IBAction)send:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *clickReplyButton;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailtextviewHeight;
- (IBAction)sendMsg:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *replyClick;

@property (weak, nonatomic) IBOutlet UIView *mainView;
//- (IBAction)replyButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *date_label;
//@property (weak, nonatomic) IBOutlet UITextView *detailMessage;
//- (IBAction)sendMessageButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *detailMessage;
@property (weak, nonatomic) IBOutlet UIButton *attachment_btn;
@property (weak, nonatomic) IBOutlet UITextField *enterMessage_textfield;
- (IBAction)attchmentBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label_senderName;
//@property (weak, nonatomic) IBOutlet UIButton *sendMesgClick;
- (IBAction)reply:(id)sender;
@property(nonatomic,strong) NSString *sender_name;
@end
