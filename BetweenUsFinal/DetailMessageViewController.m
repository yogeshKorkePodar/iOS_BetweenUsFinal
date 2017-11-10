//
//  DetailMessageViewController.m
//  TestAutoLayout
//
//  Created by podar on 19/07/16.
//  Copyright © 2016 podar. All rights reserved.
//
#import "URL_Constant.h"
#import "DetailMessageViewController.h"
#import "RestAPI.h"
#import "OpenInChromeController.h"
#import "MBProgressHUD.h"
#import "SentMessagesViewController.h"
@interface DetailMessageViewController (){
    BOOL firstTime;
    NSDictionary *newDatasetInfo1;
}

@property (nonatomic, strong) RestAPI *restApi;
@end

@implementation DetailMessageViewController
@synthesize msd_id,clt_id,usl_id,brd_Name,message,sender_name,subject,date,toUslId,pmuId,filePath,filename,EnterMessageViewValue;
Boolean firsttime = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    msd_id = msd_id;
    EnterMessageViewValue = EnterMessageViewValue;
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
    brd_Name = [[NSUserDefaults standardUserDefaults]
               stringForKey:@"brd_name"];
    if([EnterMessageViewValue isEqualToString:@"false"]){
        [_enterMessageView setHidden:YES];
    }
    [_enterMessage_textfield setDelegate:self];
    [_detailsTextview setDelegate:self];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    NSLog(@"FilePath at start:%@",filePath);
    firstTime = YES;
    //  [_detailMessage setEditable:NO];
    [self setData];
    
    [self httpPostRequest];
    UITapGestureRecognizer *tapGestPost=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOncePost)];
    [tapGestPost setNumberOfTapsRequired:1];
    [_clickReplyButton addGestureRecognizer:tapGestPost];
    tapGestPost.delegate = self;
    
    UITapGestureRecognizer *tapGestattachement=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTappedOnceattachment)];
    [tapGestattachement setNumberOfTapsRequired:1];
    [_attachment_btn addGestureRecognizer:tapGestattachement];
    tapGestattachement.delegate = self;
    
    
}
-(RestAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RestAPI alloc] init];
    }
    return _restApi;
}
//- (void)update {
//    _openInButton.enabled = [[OpenInChromeController sharedInstance] isChromeInstalled];
//    [self appendToInfoView:[NSString stringWithFormat:@"Chrome installed: %@",
//                            _openInButton.enabled ? @"YES" : @"NO"]];
//
//}



-(void) setData{
    [_label_senderName setText:subject];
    [_date_label setText:date];
  //_detailMessage.text = message;
    _detailsTextview.text = message;
    //CGRect frame =_detailsTextview.frame;
    //frame.size.height = _detailsTextview.contentSize.height;
    //_detailsTextview.frame = frame;
//    _detailsTextview.translatesAutoresizingMaskIntoConstraints = true;
//    [_detailsTextview sizeToFit];
//    _detailsTextview.scrollEnabled = true;

    
//    CGSize sizeThatFitsTextView = [_detailsTextview sizeThatFits:CGSizeMake(_detailsTextview.frame.size.width, MAXFLOAT)];
    
//    _detailtextviewHeight.constant = sizeThatFitsTextView.height;
//       NSLog( @"Height",_detailtextviewHeight.constant );
//    if(_detailtextviewHeight.constant>150){
//    _mainviewHeightConstarint.constant =  _mainviewHeightConstarint.constant+ _scrollHeight.constant;
//    _scrollHeight.constant = _mainviewHeightConstarint.constant-60;
//    }
//    else{
//        _mainviewHeightConstarint.constant = _mainviewHeightConstarint.constant+_detailtextviewHeight.constant;
//        _scrollHeight.constant = _mainviewHeightConstarint.constant-30;
//    }
//    _mainView.layer.cornerRadius = 5;
//    _mainView.layer.masksToBounds = YES;
    
    
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
        [_attachment_btn setHidden:YES];
    }
    else if(![filePath isEqualToString:@"0"]){
        [_attachment_btn setHidden:NO];
    }
    
}
//-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
//{
//    NSLog(@"URL: %@", URL);
//    //You can do anything with the URL here (like open in other web view).
//    return NO;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(firstTime == YES){
        firstTime == NO;
       // [_enterMessage_textfield setText:@""];
    }
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
            
//            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:ok];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                SentMessagesViewController *SentMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SentMessage"];
                SentMessageViewController.msd_id = msd_id;
                SentMessageViewController.usl_id = usl_id;
                SentMessageViewController.clt_id = clt_id;
                SentMessageViewController.brdName = brd_Name;
                [self.navigationController pushViewController:SentMessageViewController animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
                
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
        NSString     *urlToDownload = [@"http://betweenus.in/Uploads/Messages/" stringByAppendingString:firstBit];
        //yocommentstart
        //urlToDownload = [urlToDownload stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //yocommentend
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

- (IBAction)attchmentBtnClick:(id)sender {
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
    
}

-(void)screenTappedOncePost {
    NSLog(@"Button click:%@",@"Button click");
    enteredMessage = _enterMessage_textfield.text;
    replyMessage = [NSString stringWithFormat: @"%@ \n\n%@%@\n%@", enteredMessage,@"--Old Message--",date, message];
    NSLog(@"Reply message:%@",replyMessage);
    if(_enterMessage_textfield.text.length>0){
    
        NSString *urlString = app_url @"PodarApp.svc/ReplyToMessage";
        //Pass The String to server
        newDatasetInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:subject,@"subject",usl_id,@"usl_id",clt_id,@"clt_id",toUslId,@"Tousl_id",msd_id,@"msd_id",replyMessage,@"MessageBody",nil];
        NSLog(@"the data Details is =%@", newDatasetInfo1);
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

-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString
{
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
            SentMessagesViewController *SentMessageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SentMessage"];
            SentMessageViewController.msd_id = msd_id;
            SentMessageViewController.usl_id = usl_id;
            SentMessageViewController.clt_id = clt_id;
            SentMessageViewController.brdName = brd_Name;
            [self.navigationController pushViewController:SentMessageViewController animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
            
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


- (IBAction)reply:(id)sender {
    NSLog(@"Button click:%@",@"Button click");
    enteredMessage = _enterMessage_textfield.text;
    replyMessage = [NSString stringWithFormat: @"%@ \n\n%@%@\n%@", enteredMessage,@"--Old Message--",date, message];
    NSLog(@"Reply message:%@",replyMessage);
    if(_enterMessage_textfield.text.length>0){
        NSString *urlString = app_url @"PodarApp.svc/ReplyToMessage";
        //Pass The String to server
        newDatasetInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:subject,@"subject",usl_id,@"usl_id",clt_id,@"clt_id",toUslId,@"Tousl_id",msd_id,@"msd_id",replyMessage,@"MessageBody",nil];
            NSLog(@"the data Details is =%@", newDatasetInfo1);
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
@end
