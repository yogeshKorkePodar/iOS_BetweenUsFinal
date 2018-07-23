//
//  AdminDetailMessageViewController.h
//  BetweenUs
//
//  Created by podar on 23/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface AdminDetailMessageViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>
{
    NSString *msd_id;
    NSString *usl_id,*stud_id,*viewmessageClick,*MessageClick;
    NSString *clt_id;
    NSString *brd_Name;
    NSString *notmarked;
    NSString *message;
    NSString *date;
    NSString *subject;
    NSString *sender_name;
    NSString *readStatus;
    NSString *enteredMessage;
    NSString *replyStatus;
    NSString *replyStatusMessage;
    NSString *messageSubject;
    NSString *replyMessage;
    NSString *filename;
    NSString *filePath;
    NSDictionary *attendancedetailsdictionry;
    NSString *device,*fileSize,*extension,*uploadFilePath,*base64String,*uploadFileStatus,*uploadStatusMsg,*attachedfilename;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    
    NSArray *filenameArray;
    
    
}
@property(nonatomic,strong) NSString *msd_id;
@property(nonatomic,strong) NSString *usl_id;
@property(nonatomic,strong) NSString *clt_id;
@property(nonatomic,strong) NSString *brd_Name;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *subject;
@property(nonatomic,strong) NSString *toUslId;
@property(nonatomic,strong) NSString *pmuId;
@property(nonatomic,strong) NSString *stud_id;
@property(nonatomic,strong) NSString *filename;
@property(nonatomic,strong) NSString *filePath;
@property(nonatomic,strong) NSString *sender_name;
@property(nonatomic,strong) NSString *EnterMessageViewValue;

@property (weak, nonatomic) IBOutlet UILabel *sendername_label;
@property (weak, nonatomic) IBOutlet UILabel *date_label;
@property (weak, nonatomic) IBOutlet UIButton *download_attachement;
@property (weak, nonatomic) IBOutlet UITextView *detail_message;
- (IBAction)download_atteachment:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *enterMesssageView;
@property (weak, nonatomic) IBOutlet UITextField *enterMessage_textfield;
- (IBAction)replyButton:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;
- (IBAction)attach_file:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *mainView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsMsgTextviewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsMsgTextviewHeight;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *attachmentBtn;


@end
