//
//  AdminSendMessageViewController.h
//  BetweenUs
//
//  Created by podar on 30/09/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface AdminSendMessageViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>{
    NSString *usl_IdMessage,*clt_id,*usl_id,*device,*DeviceToken,*subject,*message,*sendMessageStatus,*sender_usl_id,*attachedfilename,*filePath,*cls_id,*AdminWriteMessage,*fileSize,*extension,*uploadFilePath,*filename,*base64String,*uploadFileStatus,*uploadStatusMsg;
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *filenameArray;
}
@property (weak, nonatomic) IBOutlet UITextField *subjectTextfield;
@property (weak, nonatomic) IBOutlet UITextView *enterMessageTextView;
- (IBAction)sentMessageBtn:(id)sender;
- (IBAction)attachementBtn:(id)sender;
@property BOOL internetActive;
@property BOOL hostActive;
@property(strong,nonatomic) NSString *stu_id;

@end
