//
//  AdminSendMessageViewController.m
//  BetweenUs
//
//  Created by podar on 30/09/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "AdminSendMessageViewController.h"
#import "WriteMessageStudentTableViewCell.h"
#import "WYPopoverController.h"
#import "MBProgressHUD.h"
#import "AdminSentMessagesViewController.h"
#import "CCKFNavDrawer.h"
#import "ViewMessageResult.h"
#import "WYPopoverController.h"
#import "MBProgressHUD.h"
#import "AdminViewMessageViewController.h"
#import "RestAPI.h"
#import "DetailMessageViewController.h"
#import "ChangePassswordViewController.h"
#import "AdminProfileViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "AdminMessageTableViewCell.h"
//#import "AdminAnnouncementViewController.h"
#import "AdminWriteMessageViewController.h"
#import "AcedmicYearResult.h"
#import "AdminDropResult.h"
#import "AdminStudentListViewController.h"
#import "AdminWriteMessageTeacherViewController.h"
#import "MsgTeacherResult.h"
#import "AdminTeacherTableViewCell.h"
#import "AdminSendMessageViewController.h"
//#import "AdminStudentSMSViewController.h"
@interface AdminSendMessageViewController (){
  NSDictionary *newDatasetinfoAdminSendMessageStudent,*newDatasetinfoAdminSendMessageTeacher,*newDatasetinfoTeacherUploadFile,*dic;
    NSData *itemData;
    NSOutputStream *outputStream;
    NSMutableArray *byteArray;

}

@end

@implementation AdminSendMessageViewController
@synthesize stu_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Send Message";
    sender_usl_id = @"0";
    attachedfilename = @"0";
    filePath = @"0";
    self.enterMessageTextView.layer.borderWidth = 1.0f;
    self.enterMessageTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _enterMessageTextView.text = @"Type your message here";
    _enterMessageTextView.textColor = [UIColor lightGrayColor];
    [_enterMessageTextView setDelegate:self];
    [_subjectTextfield setDelegate:self];
    
    AdminWriteMessage  = [[NSUserDefaults standardUserDefaults]stringForKey:@"AdminWriteMessage"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    usl_IdMessage = [[NSUserDefaults standardUserDefaults] stringForKey:@"UslIDMessage"];
    cls_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"cls_ID"];
   
    stu_id = stu_id;
    
    NSLog(@"Stu id send message==%@", stu_id);
}

-(void)checkInternetConnectivity{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatusViewMessage:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    [hud hideAnimated:YES];
}
-(void) checkNetworkStatusViewMessage:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
        }
    }
    if(self.internetActive == YES){
        
     //   [self webserviceCall];
    }
    
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

-(void)webserviceCall{
        //Pass The String to server
     if([AdminWriteMessage isEqualToString:@"Student"]){
             NSString *urlString = app_url @"PodarApp.svc/PostMessageToStudent";
        newDatasetinfoAdminSendMessageStudent = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",subject,@"pmg_subject",message,@"msg_message",sender_usl_id,@"sender_uslId",cls_id,@"cls_id",filePath,@"filepath",attachedfilename,@"filename",stu_id,@"stud_id",nil];
        NSLog(@"the data Details is =%@", newDatasetinfoAdminSendMessageStudent);
         NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSendMessageStudent options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
     }
     else if([AdminWriteMessage isEqualToString:@"Teacher"]){
         NSString *urlString = app_url @"PodarApp.svc/PostMessageAdminToTeacher";
         newDatasetinfoAdminSendMessageTeacher = [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",subject,@"pmg_subject",message,@"msg_message",usl_IdMessage,@"sender_uslId",filePath,@"filepath",attachedfilename,@"filename",nil];
         NSLog(@"the data Details is =%@", newDatasetinfoAdminSendMessageTeacher);
         NSError *error = nil;
         NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSendMessageTeacher options:NSJSONWritingPrettyPrinted error:&error];
         NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
         [self checkWithServer:urlString jsonString:jsonInputString];
     }
    
}

-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
   
    if([AdminWriteMessage isEqualToString:@"Student"]){
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSendMessageStudent options:kNilOptions error:&err];
                
                [request setHTTPMethod:POST];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                
                //Apply the data to the body
                [request setHTTPBody:jsonData];
                NSURLResponse *response;
                
                responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
                
                //This is for Response
                NSLog(@"got response==%@", resSrt);
                
                NSError *error = nil;
                if(!responseData==nil){
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                    
                    sendMessageStatus = [parsedJsonArray valueForKey:@"Status"];
                    if([sendMessageStatus isEqualToString:@"1"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Message Sent Successfully" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                           /* AdminSentMessagesViewController *adminSentMessagesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSentMessage"];
                            [self.navigationController pushViewController:adminSentMessagesViewController animated:NO];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                            */
                            
                            //AdminWriteMsgToStd
                            
                             AdminWriteMessageViewController *adminWriteMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminWriteMsgToStd"];
                             [self.navigationController pushViewController:adminWriteMessageViewController animated:NO];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                            

                         
                        }];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    else if([sendMessageStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Message Not Sent" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if([AdminWriteMessage isEqualToString:@"Teacher"]){
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminSendMessageTeacher options:kNilOptions error:&err];
                
                [request setHTTPMethod:POST];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                
                //Apply the data to the body
                [request setHTTPBody:jsonData];
                NSURLResponse *response;
                
                responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
                
                //This is for Response
                NSLog(@"got response==%@", resSrt);
                
                NSError *error = nil;
                if(!responseData==nil){
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                    
                    sendMessageStatus = [parsedJsonArray valueForKey:@"Status"];
                    if([sendMessageStatus isEqualToString:@"1"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Message Sent Successfully" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            AdminSentMessagesViewController *adminSentMessagesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSentMessage2"];
                            [self.navigationController pushViewController:adminSentMessagesViewController animated:NO];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                        }];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    }
                    else if([sendMessageStatus isEqualToString:@"0"]){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Message Not Sent" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    }

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Type your message here"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Type your message here";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)sentMessageBtn:(id)sender {
    subject = _subjectTextfield.text;
    message = _enterMessageTextView.text;
    if([subject isEqualToString:@""] &&[message isEqualToString:@"Type your message here"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Fields" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if([subject isEqualToString:@""]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Subject" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if([message isEqualToString:@"Type your message here"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Type Message" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
          [self checkInternetConnectivity];
        [self webserviceCall];
    }
    
}

- (IBAction)attachementBtn:(id)sender {
    
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
    

}
-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
   // [controller.presentingViewController dismissViewControllerAnimated:YES completion:^ {
        // [self didPickLocalURL:url];
        NSLog(@"URL  :  %@",url);
        uploadFilePath = url.absoluteString;
        
        NSLog(@"Path  :  %@",uploadFilePath);
        
        extension= [url pathExtension];
        extension = [NSString stringWithFormat: @"%@%@", @".", extension];
        
        filename =[[url lastPathComponent] stringByDeletingPathExtension];
        NSLog(@"Extension  :  %@",extension);
        NSLog(@"Filename  :  %@",filename);
        
        
        NSError *attributesError;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[url path] error:&attributesError];
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
             fileSize = [NSByteCountFormatter stringFromByteCount:[fileAttributes fileSize] countStyle:NSByteCountFormatterCountStyleFile];
        NSLog(@"size   %@", fileSize);
        
        int fileSizeInt = [fileSize intValue];
        itemData = [NSData dataWithContentsOfFile:url];
        
        
        NSUInteger len = [itemData length];
        Byte *bytedata = (Byte*)malloc(len);
        memcpy(bytedata,[itemData bytes], len);
        
        
        const unsigned char *bytes = [itemData bytes];
        // no need to copy the data
        NSUInteger length = [itemData length];
        byteArray = [NSMutableArray array];
        for (NSUInteger i = 0; i < length; i++) {
            [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
        }
        
        dic = [byteArray mutableCopy];
        
        base64String = [itemData base64EncodedStringWithOptions:0];
        
        base64String = [base64String stringByReplacingOccurrencesOfString:@"/"
                                                               withString:@"_"];
        
        base64String = [base64String stringByReplacingOccurrencesOfString:@"+"
                                                               withString:@"-"];
        
        NSLog(@"Base 64 :--   =%@", base64String);
        
        
        
        NSString *filesContent = [[NSString alloc] initWithContentsOfFile:url];
        // myMediaFile is a path to my file eg. .../Documents/myvideo.mp4/
        outputStream = [[NSOutputStream alloc] initToMemory];
        [outputStream setDelegate:self];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
        [outputStream open];
        NSData *data = [ filesContent dataUsingEncoding:NSASCIIStringEncoding        allowLossyConversion:YES];
        
        const uint8_t *buf = [data bytes];
        
        NSUInteger length1 = [data length];
        NSLog(@"datalen = %d",length1);
        NSInteger nwritten = [outputStream write:buf maxLength:length];
        
        if (-1 == nwritten) {
            NSLog(@"Error writing to stream %@: %@", outputStream, [outputStream streamError]);
        }else{
            NSLog(@"Wrote %ld bytes to stream %@.", outputStream);
        }
        
        
        if(fileSizeInt>500){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"File size is greater than 500KB" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if(!([extension isEqualToString:@".pdf"] ||[extension isEqualToString:@".doc"] ||[extension isEqualToString:@".docx"])){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Upload only Word or PDF Document" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            [self uploadFilewithData:byteArray];
        }
    //}
     
  //   ];
    
}
-(void) uploadFilewithData:(NSMutableArray *)fileByteArray{
    //Pass The String to server
   NSString *urlString = app_url @"PodarApp.svc/UploadAdminMsgAttachment";
    
    newDatasetinfoTeacherUploadFile= [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",filename,@"Filename",extension,@"extension",nil];
    
    NSLog(@"the data Details is =%@", newDatasetinfoTeacherUploadFile);
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherUploadFile options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    
    [self checkWithServerUploadFile:urlString jsonString:jsonInputString fileData:fileByteArray];
    
}
-(void)checkWithServerUploadFile:(NSString *)urlname jsonString:(NSString *)jsonString fileData:(NSMutableArray *)fileByteArray{
    
    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err;
            NSData* responseData = nil;
            NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            responseData = [NSMutableData data] ;
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
            
            
            [request setHTTPMethod:POST];
            
            
            NSString *boundary = @"---BOUNDARY";
            
            NSString *contentType = [NSString stringWithFormat:@"application/octet-stream; boundary=%@",boundary];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            [request addValue:filename forHTTPHeaderField:@"Filename"];
            [request addValue:clt_id forHTTPHeaderField:@"clt_id"];
            [request addValue:extension forHTTPHeaderField:@"extension"];
            [request addValue:usl_id forHTTPHeaderField:@"usl_id"];
            [request setHTTPBody:itemData];
            
            
            NSURLResponse *response;
            
            responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
            
            //This is for Response
            NSLog(@"got response==%@", resSrt);
            
            NSError *error = nil;
            if(!responseData==nil){
                NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                
                uploadFileStatus = [parsedJsonArray valueForKey:@"Status"];
                uploadStatusMsg = [parsedJsonArray valueForKey:@"StatusMsg"];
                if([uploadFileStatus isEqualToString:@"1"]){
                    filePath = [parsedJsonArray valueForKey:@"Filepath"];
                    NSLog(@"Status==%@", uploadFileStatus);
                    
                    filenameArray = [filePath componentsSeparatedByString: @"\\"];
                    attachedfilename = [filenameArray lastObject];
                    NSLog(@"last object==%@", attachedfilename);
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:uploadStatusMsg preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
                else if([uploadFileStatus isEqualToString:@"0"]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:uploadStatusMsg preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                [hud hideAnimated:YES];
            }
        });
    });
    
}

@end
