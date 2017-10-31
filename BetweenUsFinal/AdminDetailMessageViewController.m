//
//  AdminDetailMessageViewController.m
//  BetweenUs
//
//  Created by podar on 23/10/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "AdminDetailMessageViewController.h"
#import "AdminSentMessagesViewController.h"
#import "RestAPI.h"
#import "MBProgressHUD.h"
#import "URL_Constant.h"

@interface AdminDetailMessageViewController (){
BOOL firstTime;
NSDictionary *newDatasetInfo1,*dic,*newDatasetinfoAdminUploadFile;
NSData *itemData;
NSOutputStream *outputStream;
NSMutableArray *byteArray;
BOOL attachFile;
}
@property (nonatomic, strong) RestAPI *restApi;

@end

@implementation AdminDetailMessageViewController

@synthesize msd_id,clt_id,usl_id,brd_Name,message,sender_name,subject,date,toUslId,pmuId,filePath,filename,EnterMessageViewValue,stud_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    msd_id = msd_id;
    stud_id = stud_id;
    usl_id = usl_id;
    clt_id = clt_id;
    brd_Name = brd_Name;
    message = message;
    date = date;
    subject = subject;
    sender_name = sender_name;
    toUslId = toUslId;
    pmuId = pmuId;
    filename = filename;
    filePath = filePath;
    
    NSLog(@"<<<<<<<<<< stu id :%@",stud_id);
    brd_Name = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"brd_name"];
    MessageClick = [[NSUserDefaults standardUserDefaults]stringForKey:@"AdminMessageClick"];
    
    if([MessageClick isEqualToString:@"1"]){
        [_enterMesssageView setHidden:NO];
    }
    else if([MessageClick isEqualToString:@"0"]){
        [_enterMesssageView setHidden:YES];
        
    }
    
    NSLog(@"sendername==%@", sender_name);
    if([EnterMessageViewValue isEqualToString:@"false"]){
        [_enterMesssageView setHidden:YES];
    }
    [_enterMessage_textfield setDelegate:self];
    [_detail_message setDelegate:self];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    NSLog(@"FilePath at start:%@",filePath);
    firstTime = YES;
    //  [_detailMessage setEditable:NO];
    [self setData];
    [self httpPostRequest];
    

}

-(void)setData{
    
    
    [_sendername_label setText:subject];
    [_date_label setText:date];
    //  _detailMessage.text = message;
    _detail_message.text = message;
    CGSize sizeThatFitsTextView = [_detail_message sizeThatFits:CGSizeMake(_detail_message.frame.size.width, MAXFLOAT)];
    
    _detailsMsgTextviewHeight.constant = sizeThatFitsTextView.height;
    NSLog( @"Height",_detailsMsgTextviewHeight.constant );
    if(_detailsMsgTextviewHeight.constant>150){
        _mainViewHeight.constant =  _mainViewHeight.constant+ _scrollViewHeight.constant;
        _scrollViewHeight.constant = _mainViewHeight.constant-60;
    }
    else{
        _mainViewHeight.constant = _mainViewHeight.constant+_mainViewHeight.constant;
        _scrollViewHeight.constant = _mainViewHeight.constant-30;
    }
    _mainView.layer.cornerRadius = 5;
    _mainView.layer.masksToBounds = YES;
    self.navigationItem.title = sender_name;
    NSLog(@"Sender NAme Deatils MEssage:%@",sender_name);
    UIColor *color = [UIColor whiteColor];
    
    _enterMessage_textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Message" attributes:@{NSForegroundColorAttributeName: color}];
    
    if ( [subject rangeOfString:@"Re: " options:NSCaseInsensitiveSearch].location != NSNotFound ) {
        NSLog( @"Found it!" );
        subject = subject;
        
    }
    else{
        subject = [NSString stringWithFormat: @"%@ %@ ",@"Re: ",subject];
    }
    
    
    if([filePath isEqualToString:@""] || [filePath isEqualToString:@"0"]){
        [_attachmentBtn setHidden:YES];
    }
    else if(![filePath isEqualToString:@"0"]){
        [_attachmentBtn setHidden:NO];
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // CGSize screenSize      = [[[UIScreen mainScreen] bounds] size];
    CGFloat widthOfScreen  = [[UIScreen mainScreen] bounds].size.width;
    CGFloat heightOfScreen = [[UIScreen mainScreen] bounds].size.height;
    // Assign new frame to your view
    if([device isEqualToString:@"ipad"]){
        [self.view setFrame:CGRectMake(0,-300,widthOfScreen,heightOfScreen)];
    }
    else if([device isEqualToString:@"iphone"]){
        [self.view setFrame:CGRectMake(0,-250,widthOfScreen,heightOfScreen)];
    }//here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{  CGFloat widthOfScreen  = [[UIScreen mainScreen] bounds].size.width;
    CGFloat heightOfScreen = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view setFrame:CGRectMake(0,0,widthOfScreen,heightOfScreen)];
}

-(void) httpPostRequest{
    //Create the response and Error
    if(firstTime == YES){
        NSError *err;
        NSString *str = app_url @"PodarApp.svc/UpdateMessageReadStatus";
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:str];
        
        //Pass The String to server
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:pmuId,@"pmu_id",usl_id,@"usl_id",clt_id,@"clt_id",nil];
        NSLog(@"the data Details is =%@", newDatasetInfo);
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&err];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:POST];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        //Apply the data to the body
        [request setHTTPBody:jsonData];
        
        self.restApi.delegate = self;
        [self.restApi httpRequest:request];
        NSURLResponse *response;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
        
        //This is for Response
        NSLog(@"got readmsgResponse==%@", resSrt);
    }
    else{
        NSError *err;
        NSString *str = app_url @"PodarApp.svc/ReplyToMessage";
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:str];
        
        //Pass The String to server
        NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:subject,@"subject",usl_id,@"usl_id",clt_id,@"clt_id",toUslId,@"Tousl_id",msd_id,@"msd_id",replyMessage,@"MessageBody",nil];
        NSLog(@"the data Details is =%@", newDatasetInfo);
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&err];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:POST];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        //Apply the data to the body
        [request setHTTPBody:jsonData];
        
        self.restApi.delegate = self;
        [self.restApi httpRequest:request];
        NSURLResponse *response;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
        
        //This is for Response
        NSLog(@"got sentMessageResponse==%@", resSrt);
        _enterMessage_textfield.text = @"";
    }
}
-(void)getReceivedData:(NSMutableData *)data sender:(RestAPI *)sender
{
    if(firstTime == YES){
        firstTime = NO;
        NSError *error = nil;
        
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
        readStatus = [parsedJsonArray valueForKey:@"Status"];
        NSLog(@"Status:%@",readStatus);
        
        if([readStatus isEqualToString:@"1"]){
            
            NSLog(@"Message read :%@",@"Message read");
        }
    }
    else{
        NSError *error = nil;
        NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:&error];
        replyStatus = [parsedJsonArray valueForKey:@"Status"];
        replyStatusMessage = [parsedJsonArray valueForKey:@"StatusMsg"];
        NSLog(@"Status:%@",replyStatus);
        
        if([replyStatus isEqualToString:@"1"]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Successfull" message:replyStatusMessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:replyStatusMessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }
    
}

-(void)screenTappedOnceattachment{
    //download the file in a seperate thread.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    filePath = [filePath stringByReplacingOccurrencesOfString:@"C:/inetpub/"
                                                   withString:@""];
    
    NSArray* foo = [filePath componentsSeparatedByString: @"Messages/"];
    NSString* firstBit = [foo objectAtIndex: 1];
    
    NSLog(@"first bit%@",firstBit);
    NSLog(@"File Path:%@",filePath);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        
        // NSString     *urlToDownload  = [@"https://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        NSString     *urlToDownload = [@"http://www.betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        
        urlToDownload = [urlToDownload stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //   NSString *decodeString = [NSString alloc]initWithCString:ch encoding:NSUTF8StringEncoding];
        
        
        
        //  NSURL *url = [[NSURL alloc] initWithString:[urlToDownload stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        NSLog(@"UrlTodownload:%@",urlToDownload);
        
        NSURL *url = [NSURL URLWithString:urlToDownload];
        
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        
        NSLog(@"Url:%@",url);
        [[UIApplication sharedApplication] openURL:url];
        
        if ( urlData )
        {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePathnew = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.png"];
            NSLog(@"filepathnew %@",filePathnew);
            
            
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePathnew atomically:YES];
                NSLog(@"File Saved !");
                [hud hideAnimated:YES];
            });
        }
        
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    NSError *err;
    NSData* responseData = nil;
    NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    responseData = [NSMutableData data] ;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo1 options:kNilOptions error:&err];
    //   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:POST];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //Apply the data to the body
    [request setHTTPBody:jsonData];
    
    // self.restApi.delegate = self;
    //  [self.restApi httpRequest:request];
    NSURLResponse *response;
    
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    //This is for Response
    NSLog(@"got got response==%@", resSrt);
    
    
    NSError *error = nil;
    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
    replyStatus = [parsedJsonArray valueForKey:@"Status"];
    replyStatusMessage = [parsedJsonArray valueForKey:@"StatusMsg"];
    NSLog(@"Status:%@",replyStatus);
    
    if([replyStatus isEqualToString:@"1"]){
        _enterMessage_textfield.text  = @"";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Successful" message:replyStatusMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            AdminSentMessagesViewController *adminSentMessagesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminSentMessage"];
            [self.navigationController pushViewController:adminSentMessagesViewController animated:NO];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:replyStatusMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (IBAction)replyButton:(id)sender {
    
    if (attachFile == YES) {
        
        attachFile = NO;
    }
    else if(attachFile == NO){
        attachedfilename = @"0";
        filePath = @"0";
        
    }
    NSLog(@"reply clicked:%@",@"REPLY");
    NSLog(@"Button click:%@",@"Button click");
    enteredMessage = _enterMessage_textfield.text;
    replyMessage = [NSString stringWithFormat: @"%@ \n\n%@%@\n%@", enteredMessage,@"--Old Message--",date, message];
    NSLog(@"Reply message:%@",replyMessage);
    if(_enterMessage_textfield.text.length>0){
        NSString *urlString = app_url @"PodarApp.svc/ReplyToStudentMessage";
        //Pass The String to server
        NSLog(@"<<<<<<<<<< Student ID >>>>>>>>>:%@",stud_id);
        stud_id = @"274953";
//        newDatasetInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:subject,@"pmg_subject",usl_id,@"usl_id",clt_id,@"clt_id",toUslId,@"sender_uslId",replyMessage,@"msg_message",attachedfilename,@"filename",filePath,@"filepath",stud_id,@"stud_id",nil];
        
        newDatasetInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:
                           subject,@"pmg_subject",
                           usl_id,@"usl_id",
                           clt_id,@"clt_id",
                           toUslId,@"sender_uslId",
                           replyMessage,@"msg_message",
                           attachedfilename,@"filename",
                           filePath,@"filepath",
                           stud_id,@"stud_id",
                           nil];

        NSLog(@"the data Details is of reply =%@", newDatasetInfo1);
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo1 options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please Enter message" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud hideAnimated:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud hideAnimated:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud hideAnimated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud hideAnimated:YES];
}
- (IBAction)attach_file:(id)sender {
    attachFile = YES;
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
}
-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
//    [controller.presentingViewController dismissViewControllerAnimated:YES completion:^{
        // [self didPickLocalURL:url];
        NSLog(@"<<<<< Inside documentPicker >>>>>>");
        
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
//    }];
    
}
-(void) uploadFilewithData:(NSMutableArray *)fileByteArray{
    //Pass The String to server
    NSString *urlString = app_url @"PodarApp.svc/UploadAdminMsgAttachment";
    
    newDatasetinfoAdminUploadFile= [NSDictionary dictionaryWithObjectsAndKeys:clt_id,@"clt_id",usl_id,@"usl_id",filename,@"Filename",extension,@"extension",nil];
    
    NSLog(@"the data Details is =%@", newDatasetinfoAdminUploadFile);
    NSError *error = nil;
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoAdminUploadFile options:NSJSONWritingPrettyPrinted error:&error];
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

- (IBAction)download_atteachment:(id)sender {
    //download the file in a seperate thread.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    filePath = [filePath stringByReplacingOccurrencesOfString:@"C:/inetpub/"
                                                   withString:@""];
    
    NSArray* foo = [filePath componentsSeparatedByString: @"Messages/"];
    NSString* firstBit = [foo objectAtIndex: 1];
    
    NSLog(@"first bit%@",firstBit);
    NSLog(@"File Path:%@",filePath);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        
        // NSString     *urlToDownload  = [@"https://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        NSString     *urlToDownload = [@"http://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        
        urlToDownload = [urlToDownload stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //   NSString *decodeString = [NSString alloc]initWithCString:ch encoding:NSUTF8StringEncoding];
        
        
        //  NSURL *url = [[NSURL alloc] initWithString:[urlToDownload stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        NSLog(@"UrlTodownload:%@",urlToDownload);
        
        NSURL *url = [NSURL URLWithString:urlToDownload];
        
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        
        NSLog(@"Url:%@",url);
        [[UIApplication sharedApplication] openURL:url];
        
        if ( urlData )
        {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePathnew = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.png"];
            NSLog(@"filepathnew %@",filePathnew);
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePathnew atomically:YES];
                NSLog(@"File Saved !");
                [hud hideAnimated:YES];
            });
        }
        
    });
    [hud hideAnimated:YES];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
