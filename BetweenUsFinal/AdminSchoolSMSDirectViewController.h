//
//  AdminSchoolSMSDirectViewController.h
//  BetweenUs
//
//  Created by podar on 12/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AdminSchoolSMSDirectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSString *SendSMSDirectStatus,*clt_id,*usl_id,*DeviceToken,*device,*std_name,*div_name,*studIDSMS,*clsIDSMS,*category,*sender_usl_id,*filePath,*AdminWriteMessage,*attachedfilename,*usl_IdMessage,*cls_id,*stu_id,*board_name,*mode,*enteredSms,*SendSMSTeaherStatus,*DeviceType,*contactList,*fileSize,*extension,*uploadFilePath,*filename,*base64String,*uploadFileStatus,*uploadStatusMsg;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSArray *CategoryTableData,*filenameArray;
}
- (IBAction)selectModule:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectModuleClick;
@property (weak, nonatomic) IBOutlet UIButton *Categoryclick;
- (IBAction)categoryBtn:(id)sender;
- (IBAction)studentSMSBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSClick;
- (IBAction)sendSMSBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *attachement;
- (IBAction)attachementBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImg;
- (IBAction)teacherSMSBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UITextView *enterMessage;
- (IBAction)schoolSMSBtn:(id)sender;
- (IBAction)downLloadSampleCSV:(id)sender;
@property BOOL internetActive;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UILabel *charachterLimit_label;
@property (weak, nonatomic) IBOutlet UITextField *template_textfield;

@end
