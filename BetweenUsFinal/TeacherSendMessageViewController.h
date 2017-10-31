//
//  TeacherSendMessageViewController.h
//  BetweenUs
//
//  Created by podar on 30/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TeacherSendMessageViewController : UIViewController<UITextViewDelegate, NSStreamDelegate, UIDocumentPickerDelegate>{
NSString *sender_usl_id,*attachedfilename,*filePath,*clt_id,*usl_id,*cls_ID,*device,*DeviceToken,*DeviceType,*stu_id,*subject,*message,*sendMessageStatus,*extension,*filename,*uploadFileStatus,*uploadFilePath,*serverText,*fileSize,*uploadStatusMsg;
Reachability* internetReachable;
Reachability* hostReachable;
NSStream *iStream;
NSArray *filenameArray;
}

@property BOOL internetActive;
@property BOOL hostActive;

- (IBAction)sendMessage:(id)sender;
- (IBAction)attachment:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *sendMessageClick;
@property (weak, nonatomic) IBOutlet UIButton *attachmentClick;
@property (weak, nonatomic) IBOutlet UITextView *enterMessage;
@property (weak, nonatomic) IBOutlet UITextField *subject_textfield;

@end
