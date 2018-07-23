//
//  ViewLogsViewController.m
//  BetweenUs
//
//  Created by podar on 18/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import "ViewLogsViewController.h"
#import "MBProgressHUD.h"
#import "RestAPI.h"
#import "TopicInfoAcyGrtSixteenResult.h"
#import "TopicinfoResult.h"
#import "PeriodNoList.h"
#import "URL_Constant.h"

@interface ViewLogsViewController (){
    BOOL firstTime,periodSelected,save,cancel,saved;
    NSDictionary *newDatasetinfoTeacherViewLog;
    UITableView *periodtableview,*yesnoTableView;
    UIAlertView *alertperiod,*alertyesno;

}

@property (nonatomic, strong) TopicInfoAcyGrtSixteenResult *TopicInfoAcyGrtSixteenResulttems;
@property (nonatomic, strong) TopicinfoResult *TopicinfoResulttems;
@property (nonatomic, strong) PeriodNoList *PeriodNoListItems;

@end

@implementation ViewLogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    firstTime = YES;
    [_lastPeriodView setHidden:YES];
    [_saveClick setHidden:YES];
    [_cancelClick setHidden:YES];
    _editRightConstraint.constant = 8;
    _editClick.updateConstraints;
    [_editClick layoutIfNeeded];
    yesnoArray= [NSArray arrayWithObjects:@"Yes", @"No",nil];

    
    [self disableAll];
    
    [_subTopicCompletedTextfield setDelegate:self];

    [_describeYourLessonTextfield setDelegate:self];
    [_teachingStrategiesTextfield setDelegate:self];
    [_challengesFaceDuringLessonTextfield  setDelegate:self];
    [_workcarriedTextfield  setDelegate:self];
    [_reasonforSameTextfield  setDelegate:self];
    [ _topicStartedOnTextfield  setDelegate:self];
    [_topicCompletedOnTextfield setDelegate:self];
    [_typeOfAssessmentTextfield  setDelegate:self];
    [ _dateOnWhichTextfield  setDelegate:self];
    [_feedbackOfAssesmentTextfield  setDelegate:self];
    [_chalengesFacedbyStudentTextfield setDelegate:self];
    [_suggested_correction_Textbook_TextField setDelegate:self];
    [_suggested_Coorection_workBookTextfield  setDelegate:self];
    [_suggeCorrInternalAssessmentTextField setDelegate:self];
    [_suggestedCorrectionLessonPlanTextfield setDelegate:self];
    [_anyOtherRemarks_textfield setDelegate:self];
    
    //Set Border to button
    [self.yesNoClick.layer setBorderWidth:1.0];
    [self.yesNoClick.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    
    
 //  [_yesButtonView setHidden:YES];
    device =[[NSUserDefaults standardUserDefaults]
             stringForKey:@"device"];
    DeviceType= @"IOS";
    DeviceToken = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"Device Token"];
    
    clt_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"clt_id"];
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    brd_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];
    
    Brd_Id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Brd_ID"];
    topicname = [[NSUserDefaults standardUserDefaults]stringForKey:@"selectedTopicName"];
    crf_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"crf_ID"];
    rol_id = [[NSUserDefaults standardUserDefaults]
               stringForKey:@"Roll_id"];
    acy_year =[[NSUserDefaults standardUserDefaults]
                         stringForKey:@"academicYear"];
    
    selectedStd = [[NSUserDefaults standardUserDefaults]stringForKey:@"stdName_SubjectList"];
    selectedSubject = [[NSUserDefaults standardUserDefaults] objectForKey:@"subjectName_SubjectList"];

    self.navigationItem.title = topicname;
    [self checkInternetConnectivity];
    
  
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
    {
        [textField resignFirstResponder];
        return YES;
    }
-(void)disableAll{
    [_subTopicCompletedTextfield setEnabled:NO];
    [_describeYourLessonTextfield setEnabled:NO];
    [_teachingStrategiesTextfield setEnabled:NO];
    [_challengesFaceDuringLessonTextfield  setEnabled:NO];
    [_workcarriedTextfield  setEnabled:NO];
    [_reasonforSameTextfield  setEnabled:NO];
    [ _topicStartedOnTextfield  setEnabled:NO];
    [_topicCompletedOnTextfield setEnabled:NO];
    [_typeOfAssessmentTextfield  setEnabled:NO];
    [ _dateOnWhichTextfield  setEnabled:NO];
    [_feedbackOfAssesmentTextfield  setEnabled:NO];
    [_chalengesFacedbyStudentTextfield setEnabled:NO];
    [_suggested_correction_Textbook_TextField  setEnabled:NO];
    [_suggested_Coorection_workBookTextfield  setEnabled:NO];
    [_suggeCorrInternalAssessmentTextField setEnabled:NO];
    [_suggestedCorrectionLessonPlanTextfield setEnabled:NO];
    [_anyOtherRemarks_textfield setEnabled:NO];
    [_allOfStudentTextfield setEnabled:NO];
    [_mostOfStudentTextfield setEnabled:NO];
    [_someOfStudentTextfield setEnabled:NO];
    [_fewOfStudentTextfield setEnabled:NO];
    
    
    _subTopicCompletedTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _describeYourLessonTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _teachingStrategiesTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _challengesFaceDuringLessonTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _workcarriedTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _reasonforSameTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _topicStartedOnTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _topicCompletedOnTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _typeOfAssessmentTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _dateOnWhichTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _feedbackOfAssesmentTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _chalengesFacedbyStudentTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _suggested_correction_Textbook_TextField.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _suggested_Coorection_workBookTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _suggestedCorrectionLessonPlanTextfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _suggeCorrInternalAssessmentTextField.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _anyOtherRemarks_textfield.backgroundColor = [UIColor colorWithWhite:0.880f alpha:1.0f];
    _allOfStudentTextfield.backgroundColor =[UIColor colorWithWhite:0.880f alpha:1.0f];
    _mostOfStudentTextfield.backgroundColor =[UIColor colorWithWhite:0.880f alpha:1.0f];
    _someOfStudentTextfield.backgroundColor =[UIColor colorWithWhite:0.880f alpha:1.0f];
    _fewOfStudentTextfield.backgroundColor =[UIColor colorWithWhite:0.880f alpha:1.0f];

}
-(void)enableAll{
    [_subTopicCompletedTextfield setEnabled:YES];
    [_describeYourLessonTextfield setEnabled:YES];
    [_teachingStrategiesTextfield setEnabled:YES];
    [_chalengesFacedbyStudentTextfield setEnabled:YES];
    [_challengesFaceDuringLessonTextfield setEnabled:YES];
    [_workcarriedTextfield setEnabled:YES];
    [_reasonforSameTextfield setEnabled:YES];
    [_topicCompletedOnTextfield setEnabled:YES];
    [_topicStartedOnTextfield setEnabled:YES];
    [_typeOfAssessmentTextfield setEnabled:YES];
    [_dateOnWhichTextfield setEnabled:YES];
    [_feedbackOfAssesmentTextfield setEnabled:YES];
    [_suggested_Coorection_workBookTextfield setEnabled:YES];
    [_suggeCorrInternalAssessmentTextField setEnabled:YES];
    [_suggested_correction_Textbook_TextField setEnabled:YES];
    [_suggestedCorrectionLessonPlanTextfield setEnabled:YES];
    [_anyOtherRemarks_textfield setEnabled:YES];
    [_allOfStudentTextfield setEnabled:YES];
    [_someOfStudentTextfield setEnabled:YES];
    [_mostOfStudentTextfield setEnabled:YES];
    [_fewOfStudentTextfield setEnabled:YES];
    

    _subTopicCompletedTextfield.backgroundColor = [UIColor whiteColor];
    _describeYourLessonTextfield.backgroundColor = [UIColor whiteColor];
    _teachingStrategiesTextfield.backgroundColor = [UIColor whiteColor];    _challengesFaceDuringLessonTextfield.backgroundColor = [UIColor whiteColor];    _workcarriedTextfield.backgroundColor = [UIColor whiteColor];
    _reasonforSameTextfield.backgroundColor = [UIColor whiteColor];
    _topicStartedOnTextfield.backgroundColor = [UIColor whiteColor];
    _topicCompletedOnTextfield.backgroundColor = [UIColor whiteColor];    _typeOfAssessmentTextfield.backgroundColor = [UIColor whiteColor];
    _dateOnWhichTextfield.backgroundColor = [UIColor whiteColor];
    _feedbackOfAssesmentTextfield.backgroundColor = [UIColor whiteColor];
    _chalengesFacedbyStudentTextfield.backgroundColor = [UIColor whiteColor];
    _suggested_correction_Textbook_TextField.backgroundColor = [UIColor whiteColor];
    _suggested_Coorection_workBookTextfield.backgroundColor = [UIColor whiteColor];
    _suggestedCorrectionLessonPlanTextfield.backgroundColor = [UIColor whiteColor];
    _suggeCorrInternalAssessmentTextField.backgroundColor = [UIColor whiteColor];
    _anyOtherRemarks_textfield.backgroundColor = [UIColor whiteColor];
    _allOfStudentTextfield.backgroundColor =[UIColor whiteColor];
    _mostOfStudentTextfield.backgroundColor =[UIColor whiteColor];
    _someOfStudentTextfield.backgroundColor =[UIColor whiteColor];
   _fewOfStudentTextfield.backgroundColor =[UIColor whiteColor];
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
            self.internetActive= YES;
            
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
        
        [self webserviceCall];
    }
    
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Internet Error" message:@"Please Check Internet Connectivity" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
-(void)webserviceCall{
    if(firstTime == YES){
        NSString *urlString = app_url @"TopicViewlog";
        
        //Pass The String to server
        newDatasetinfoTeacherViewLog= [NSDictionary dictionaryWithObjectsAndKeys:crf_id,@"crf_id",usl_id,@"usl_id",clt_id,@"clt_id",acy_year,@"Acy_year",rol_id,@"rol_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherViewLog options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    
    }
    else if(periodSelected ==YES){
        NSString *urlString = app_url @"TopicViewlog";
        
        //Pass The String to server
        newDatasetinfoTeacherViewLog= [NSDictionary dictionaryWithObjectsAndKeys:crf_id,@"crf_id",usl_id,@"usl_id",clt_id,@"clt_id",acy_year,@"Acy_year",rol_id,@"rol_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherViewLog options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];

    }
    else if(save == YES){
        NSString *urlString = app_url @"InsertContentLog";
        
        //Pass The String to server
        newDatasetinfoTeacherViewLog= [NSDictionary dictionaryWithObjectsAndKeys:crf_id,@"crf_id",usl_id,@"usl_id",periodNo,@"periodno",field1,@"field1",field2,@"field2",field3,@"field3",field4,@"field4",field5,@"field5",field6,@"field6",field7,@"field7",field8,@"field8",field9,@"field9",field10,@"field10",field11,@"field11",field12,@"field12",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherViewLog options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];

    }
    else if(saved == YES){
        NSString *urlString = app_url @"TopicContentViewlog";
        
        //Pass The String to server
        newDatasetinfoTeacherViewLog= [NSDictionary dictionaryWithObjectsAndKeys:crf_id,@"crf_id",usl_id,@"usl_id",periodNo,@"PeriodNo",acy_year,@"Acy_year",clt_id,@"clt_id",rol_id,@"rol_id",nil];
        
        NSError *error = nil;
        NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherViewLog options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self checkWithServer:urlString jsonString:jsonInputString];
    }
}


-(void)checkWithServer:(NSString *)urlname jsonString:(NSString *)jsonString{
    if(firstTime == YES){
        firstTime = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherViewLog options:kNilOptions error:&err];
                
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
                if(!responseData == nil){
                    @try{
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                    viewLogStatus = [parsedJsonArray valueForKey:@"Status"];
                    statusMsg = [parsedJsonArray valueForKey:@"StatusMsg"];
                    topicInfoArray = [receivedData valueForKey:@"TopicinfoResult"];
                    topicInfoAcyGrt16Array = [receivedData valueForKey:@"TopicInfoAcyGrtSixteenResult"];
                    periodArray = [receivedData valueForKey:@"PeriodNoList"];
                    topicInfoarraycount = [topicInfoArray count];
                    topicInfoAcyGrt16arrayCount = [topicInfoAcyGrt16Array count];
                    topicInfocount = [NSString stringWithFormat:@"%d", topicInfoarraycount];
                    topicInfoAcyGrt16Count = [NSString stringWithFormat:@"%d", topicInfoAcyGrt16arrayCount];
                    
                    

                    NSLog(@"Status:%@",viewLogStatus);
                    if([viewLogStatus isEqualToString:@"1"]){
                        
                        [_wholeView setHidden:NO];
                        [_scrollView setHidden:NO];

                        _name.text = [receivedData valueForKey:@"TeacherName"];
                        _std_div.text = selectedStd;
                        _subject.text = selectedSubject;
                        if([topicInfocount isEqualToString:@"0"]){
                            [_graterThanaca16View setHidden:NO];
                            _topSpaceAcademicYearGreter16.constant = 3;
                            _yesButtonViewHeight.constant = 0;
                            [_belowAcademicyear16View setHidden:YES];
                            _heightChallengesFaceByStud.constant = 35;
                            

                            _topicStartedOnTextfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"top_started_on"];
                              _topicCompletedOnTextfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"top_completed_on"];
                              yesNo = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Int_Ass_based_on_top"];
                            [ _yesNoClick setTitle:yesNo forState:UIControlStateNormal];
                            _typeOfAssessmentTextfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Typ_of_assessment"];
                            _dateOnWhichTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Dt_which_it_conducted"];
                            _feedbackOfAssesmentTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Feed_of_assessment"];
                            _chalengesFacedbyStudentTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"chal_Faced_stud_lern_top"];
                            _suggested_correction_Textbook_TextField.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_in_txtbok"];
                            _suggested_Coorection_workBookTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_in_wrkbok"];_suggestedCorrectionLessonPlanTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_in_Leson_Pln"];
                            _suggeCorrInternalAssessmentTextField.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_inter_assess"];
                            yesNo = _yesNoClick.currentTitle;
                            _anyOtherRemarks_textfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Any_other_Remarks"];
                            if([yesNo isEqualToString:@"No"]){
//                                [_typeOfAssessmentTextfield setHidden:YES];
//                                [_typeOfAssessmentLabel setHidden:YES];
//                                [_feedbackOfAssesmentTextfield setHidden:YES];
//                                [_feedbackOfAssessmentLabel setHidden:YES];
//                                [_dateOnWhichTextfield setHidden:YES];
//                                [_dateOnWhichLabel setHidden:YES];
                              //  [_yesButtonView setHidden:YES];
                                
                            }
                            else if([yesNo isEqualToString:@"Yes"]){
//                                [_typeOfAssessmentTextfield setHidden:NO];
//                                [_typeOfAssessmentLabel setHidden:NO];
//                                [_feedbackOfAssesmentTextfield setHidden:NO];
//                                [_feedbackOfAssessmentLabel setHidden:NO];
//                                [_dateOnWhichTextfield setHidden:NO];
//                                [_dateOnWhichLabel setHidden:NO];
                                // [_yesButtonView setHidden:NO];
                            }
                            
                        }
                        else if([topicInfoAcyGrt16Count isEqualToString:@"0"]){
                            [_graterThanaca16View setHidden:YES];
                            [_belowAcademicyear16View setHidden:NO];
                             _topSpaceTobelow16FromCancel.constant = 39;
                            _topSpaceToBelow16FromEditButton.constant = 39;
                            _topSpaceToBelow16FromSaveButton.constant = 39;

                            _reasonforSameTextfield.text =[[topicInfoArray objectAtIndex:0]objectForKey:@"Reason_Fr_Same"];
                            _workcarriedTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Wrk_Carrd_Fward"];
                            _challengesFaceDuringLessonTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"chal_Faced_During_Les"];
                            _describeYourLessonTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"des_ur_Lesson"];
                            _subTopicCompletedTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"sub_Topic_Comp"];
                            _teachingStrategiesTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"teaching_Strategies"];
                            
                            NSUInteger *arraycount = [periodArray count];
                            NSString *text =[NSString stringWithFormat:@"%d", arraycount];
                            if([periodNo isEqualToString:text]){
                                
                                [_lastPeriodView setHidden:NO];
                                _topSpaceToLastPeriodFromeditButton.constant = 39;
                                _topSpaceToLastPeriodFromCancel.constant = 39;
                                _topSpacetoLastPeriodFromSaveButton.constant = 39;

                                _allOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"All_of_my_stu_can"];
                                _mostOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Mst_of_my_stud_can"];
                                _someOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Some_of_my_stud_can"];
                                _fewOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Few_of_my_stud_can"];
                            }
                            else{
                                [_lastPeriodView setHidden:YES];
                            }
                            
                        }
                       
                    }
                    else if([viewLogStatus isEqualToString:@"0"]){
                       [_wholeView setHidden:YES];
                        
                        [_scrollView setHidden:YES];

                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:statusMsg preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [hud hideAnimated:YES];
                }
                    @catch (NSException *exception) {
                        NSLog(@"Exception: %@", exception);
                    }
                }
               
            });
        });
        
    }
    else if(periodSelected ==YES){
        periodSelected = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherViewLog options:kNilOptions error:&err];
                
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
                if(!responseData == nil){
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                    viewLogStatus = [parsedJsonArray valueForKey:@"Status"];
                    statusMsg = [parsedJsonArray valueForKey:@"StatusMsg"];
                    topicInfoArray = [receivedData valueForKey:@"TopicinfoResult"];
                    topicInfoAcyGrt16Array = [receivedData valueForKey:@"TopicInfoAcyGrtSixteenResult"];
                    periodArray = [receivedData valueForKey:@"PeriodNoList"];
                    topicInfoarraycount = [topicInfoArray count];
                    topicInfoAcyGrt16arrayCount = [topicInfoAcyGrt16Array count];
                    topicInfocount = [NSString stringWithFormat:@"%d", topicInfoarraycount];
                    topicInfoAcyGrt16Count = [NSString stringWithFormat:@"%d", topicInfoAcyGrt16arrayCount];
                    
                    NSLog(@"Status:%@",viewLogStatus);
                    if([viewLogStatus isEqualToString:@"1"]){
                         [_wholeView setHidden:NO];
                        
                        [_scrollView setHidden:NO];

                        _name.text = [receivedData valueForKey:@"TeacherName"];
                        _std_div.text = selectedStd;
                        _subject.text = selectedSubject;
                        if([topicInfocount isEqualToString:@"0"]){
                            [_graterThanaca16View setHidden:NO];
                            _topSpaceAcademicYearGreter16.constant = 3;
                            _yesButtonViewHeight.constant = 0;
                            [_belowAcademicyear16View setHidden:YES];
                            _heightChallengesFaceByStud.constant = 35;
                            
                            
                            _topicStartedOnTextfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"top_started_on"];
                            _topicCompletedOnTextfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"top_completed_on"];
                            yesNo = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Int_Ass_based_on_top"];
                            [ _yesNoClick setTitle:yesNo forState:UIControlStateNormal];
                            _typeOfAssessmentTextfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Typ_of_assessment"];
                            _dateOnWhichTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Dt_which_it_conducted"];
                            _feedbackOfAssesmentTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Feed_of_assessment"];
                            _chalengesFacedbyStudentTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"chal_Faced_stud_lern_top"];
                            _suggested_correction_Textbook_TextField.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_in_txtbok"];
                            _suggested_Coorection_workBookTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_in_wrkbok"];_suggestedCorrectionLessonPlanTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_in_Leson_Pln"];
                            _suggeCorrInternalAssessmentTextField.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_inter_assess"];
                            yesNo = _yesNoClick.currentTitle;
                            _anyOtherRemarks_textfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Any_other_Remarks"];
                            if([yesNo isEqualToString:@"No"]){
                                //                                [_typeOfAssessmentTextfield setHidden:YES];
                                //                                [_typeOfAssessmentLabel setHidden:YES];
                                //                                [_feedbackOfAssesmentTextfield setHidden:YES];
                                //                                [_feedbackOfAssessmentLabel setHidden:YES];
                                //                                [_dateOnWhichTextfield setHidden:YES];
                                //                                [_dateOnWhichLabel setHidden:YES];
                                //[_yesButtonView setHidden:YES];
                                
                            }
                            else if([yesNo isEqualToString:@"Yes"]){
                                //                                [_typeOfAssessmentTextfield setHidden:NO];
                                //                                [_typeOfAssessmentLabel setHidden:NO];
                                //                                [_feedbackOfAssesmentTextfield setHidden:NO];
                                //                                [_feedbackOfAssessmentLabel setHidden:NO];
                                //                                [_dateOnWhichTextfield setHidden:NO];
                                //                                [_dateOnWhichLabel setHidden:NO];
                                // [_yesButtonView setHidden:NO];
                            }
                            
                        }
                        else if([topicInfoAcyGrt16Count isEqualToString:@"0"]){
                            [_graterThanaca16View setHidden:YES];
                            [_belowAcademicyear16View setHidden:NO];
                            _topSpaceTobelow16FromCancel.constant = 39;
                            _topSpaceToBelow16FromEditButton.constant = 39;
                            _topSpaceToBelow16FromSaveButton.constant = 39;
                            
                            _reasonforSameTextfield.text =[[topicInfoArray objectAtIndex:0]objectForKey:@"Reason_Fr_Same"];
                            _workcarriedTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Wrk_Carrd_Fward"];
                            _challengesFaceDuringLessonTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"chal_Faced_During_Les"];
                            _describeYourLessonTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"des_ur_Lesson"];
                            _subTopicCompletedTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"sub_Topic_Comp"];
                            _teachingStrategiesTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"teaching_Strategies"];
                            
                            NSUInteger *arraycount = [periodArray count];
                            NSString *text =[NSString stringWithFormat:@"%d", arraycount];
                            if([periodNo isEqualToString:text]){
                                
                                [_lastPeriodView setHidden:NO];
                                _topSpaceToLastPeriodFromeditButton.constant = 39;
                                _topSpaceToLastPeriodFromCancel.constant = 39;
                                _topSpacetoLastPeriodFromSaveButton.constant = 39;
                                
                                _allOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"All_of_my_stu_can"];
                                _mostOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Mst_of_my_stud_can"];
                                _someOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Some_of_my_stud_can"];
                                _fewOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Few_of_my_stud_can"];
                            }
                            else{
                                [_lastPeriodView setHidden:YES];
                            }
                            
                        }
                        
                    }
                    else if([viewLogStatus isEqualToString:@"0"]){
                        
                        [_wholeView setHidden:YES];
                        
                        [_scrollView setHidden:YES];

                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:statusMsg preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if (save == YES){
        save = NO;
      
        saved = YES;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherViewLog options:kNilOptions error:&err];
                
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
                if(!responseData == nil){
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                    saveStatus = [parsedJsonArray valueForKey:@"Status"];
                    statusMsg =[parsedJsonArray valueForKey:@"StatusMsg"];
                    NSLog(@"Status:%@",viewLogStatus);
                    if([saveStatus isEqualToString:@"1"]){
                        
                        [_cancelClick setHidden:YES];
                        [_saveClick setHidden:YES];
                        [self disableAll];
                        
                        [self webserviceCall];
                    
                    }
                    else if([viewLogStatus isEqualToString:@"0"]){
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:statusMsg preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    [hud hideAnimated:YES];
                }
            });
        });
    }
    else if (saved == YES){
        saved = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err;
                NSData* responseData = nil;
                NSURL *url=[NSURL URLWithString:[urlname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                responseData = [NSMutableData data] ;
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetinfoTeacherViewLog options:kNilOptions error:&err];
                
                [request setHTTPMethod:POST];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                
                //Apply the data to the body
                [request setHTTPBody:jsonData];
                NSURLResponse *response;
                
                responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
                
                //This is for Response
                NSLog(@"got response saved==%@", resSrt);
                
                
                NSError *error = nil;
                if(!responseData == nil){
                    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
                    NSArray *parsedJsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableContainers) error:&error];
                    viewLogStatus = [parsedJsonArray valueForKey:@"Status"];
                    statusMsg =[parsedJsonArray valueForKey:@"StatusMsg"];
                    topicInfoArray = [receivedData valueForKey:@"TopicinfoResult"];
                    topicInfoAcyGrt16Array = [receivedData valueForKey:@"TopicInfoAcyGrtSixteenResult"];
                    periodArray = [receivedData valueForKey:@"PeriodNoList"];
                    topicInfoarraycount = [topicInfoArray count];
                    topicInfoAcyGrt16arrayCount = [topicInfoAcyGrt16Array count];
                    topicInfocount = [NSString stringWithFormat:@"%d", topicInfoarraycount];
                    topicInfoAcyGrt16Count = [NSString stringWithFormat:@"%d", topicInfoAcyGrt16arrayCount];
                    
                    NSLog(@"Status:%@",viewLogStatus);
                    if([viewLogStatus isEqualToString:@"1"]){
                        [_wholeView setHidden:NO];
                        [_scrollView setHidden:NO];

                        _name.text = [receivedData valueForKey:@"TeacherName"];
                        _std_div.text = selectedStd;
                        _subject.text = selectedSubject;
                        if([topicInfocount isEqualToString:@"0"]){
                            [_graterThanaca16View setHidden:NO];
                            _topSpaceAcademicYearGreter16.constant = 3;
                            _yesButtonViewHeight.constant = 0;
                            [_belowAcademicyear16View setHidden:YES];
                            _heightChallengesFaceByStud.constant = 35;
                            
                            
                            _topicStartedOnTextfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"top_started_on"];
                            _topicCompletedOnTextfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"top_completed_on"];
                            yesNo = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Int_Ass_based_on_top"];
                            [ _yesNoClick setTitle:yesNo forState:UIControlStateNormal];
                            _typeOfAssessmentTextfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Typ_of_assessment"];
                            _dateOnWhichTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Dt_which_it_conducted"];
                            _feedbackOfAssesmentTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Feed_of_assessment"];
                            _chalengesFacedbyStudentTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"chal_Faced_stud_lern_top"];
                            _suggested_correction_Textbook_TextField.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_in_txtbok"];
                            _suggested_Coorection_workBookTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_in_wrkbok"];_suggestedCorrectionLessonPlanTextfield.text =  [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_in_Leson_Pln"];
                            _suggeCorrInternalAssessmentTextField.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Sugg_corr_chngs_inter_assess"];
                            yesNo = _yesNoClick.currentTitle;
                            _anyOtherRemarks_textfield.text = [[topicInfoAcyGrt16Array objectAtIndex:0]objectForKey:@"Any_other_Remarks"];
                            if([yesNo isEqualToString:@"No"]){
                                //                                [_typeOfAssessmentTextfield setHidden:YES];
                                //                                [_typeOfAssessmentLabel setHidden:YES];
                                //                                [_feedbackOfAssesmentTextfield setHidden:YES];
                                //                                [_feedbackOfAssessmentLabel setHidden:YES];
                                //                                [_dateOnWhichTextfield setHidden:YES];
                                //                                [_dateOnWhichLabel setHidden:YES];
                                //[_yesButtonView setHidden:YES];
                                
                            }
                            else if([yesNo isEqualToString:@"Yes"]){
                                //                                [_typeOfAssessmentTextfield setHidden:NO];
                                //                                [_typeOfAssessmentLabel setHidden:NO];
                                //                                [_feedbackOfAssesmentTextfield setHidden:NO];
                                //                                [_feedbackOfAssessmentLabel setHidden:NO];
                                //                                [_dateOnWhichTextfield setHidden:NO];
                                //                                [_dateOnWhichLabel setHidden:NO];
                                // [_yesButtonView setHidden:NO];
                            }
                            
                        }
                        else if([topicInfoAcyGrt16Count isEqualToString:@"0"]){
                            [_graterThanaca16View setHidden:YES];
                            [_belowAcademicyear16View setHidden:NO];
                            _topSpaceTobelow16FromCancel.constant = 39;
                            _topSpaceToBelow16FromEditButton.constant = 39;
                            _topSpaceToBelow16FromSaveButton.constant = 39;
                            
                            _reasonforSameTextfield.text =[[topicInfoArray objectAtIndex:0]objectForKey:@"Reason_Fr_Same"];
                            _workcarriedTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Wrk_Carrd_Fward"];
                            _challengesFaceDuringLessonTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"chal_Faced_During_Les"];
                            _describeYourLessonTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"des_ur_Lesson"];
                            _subTopicCompletedTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"sub_Topic_Comp"];
                            _teachingStrategiesTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"teaching_Strategies"];
                            
                            NSUInteger *arraycount = [periodArray count];
                            NSString *text =[NSString stringWithFormat:@"%d", arraycount];
                            if([periodNo isEqualToString:text]){
                                
                                [_lastPeriodView setHidden:NO];
                                _topSpaceToLastPeriodFromeditButton.constant = 39;
                                _topSpaceToLastPeriodFromCancel.constant = 39;
                                _topSpacetoLastPeriodFromSaveButton.constant = 39;
                                
                                _allOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"All_of_my_stu_can"];
                                _mostOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Mst_of_my_stud_can"];
                                _someOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Some_of_my_stud_can"];
                                _fewOfStudentTextfield.text = [[topicInfoArray objectAtIndex:0]objectForKey:@"Few_of_my_stud_can"];
                            }
                            else{
                                [_lastPeriodView setHidden:YES];
                            }
                            
                        }
                        
                    }
                    else if([viewLogStatus isEqualToString:@"0"]){
                         [_wholeView setHidden:YES];
                        [_scrollView setHidden:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:statusMsg preferredStyle:UIAlertControllerStyleAlert];
                        
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
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try{
        if(tableView == periodtableview){
            static NSString *CellIdentifier = @"Cell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            // Set up the cell...
            cell.textLabel.text = [[periodArray objectAtIndex:indexPath.row]objectForKey:@"id"];
            return cell;
        }
        else if(tableView == yesnoTableView){
            static NSString *CellIdentifier = @"Cell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            // Set up the cell...
            cell.textLabel.text =[yesnoArray objectAtIndex:indexPath.row];
            return cell;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try{
        if(tableView ==periodtableview)
        {
            return [periodArray count];
        }
        else if(tableView == yesnoTableView){
            return [yesnoArray count];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView ==periodtableview){
    [alertperiod dismissWithClickedButtonIndex:0 animated:YES];
    periodSelected = YES;
    periodNo = [[periodArray objectAtIndex:indexPath.row]objectForKey:@"id"];
    [self webserviceCall];
     }
     else if (tableView == yesnoTableView){
        [alertyesno dismissWithClickedButtonIndex:0 animated:YES];
         yesNo = [yesnoArray objectAtIndex:indexPath.row];
         if([yesNo isEqualToString:@"Yes"]){
          //   [_yesButtonView setHidden:NO];
          //   _topFromNobelowTextToNoView.constant = 224;
         //    _heightOfYesView.constant = 208;
            // _topConstraintFromyesNoBelowViewToYesNoBtn.constant = 224;
         }
         else if([yesNo isEqualToString:@"No"]){
         //    [_yesButtonView setHidden:YES];
             
         //   _heightOfYesView.constant = 0;
           //  _topConstraintFromyesNoBelowViewToYesNoBtn.constant = 8;
          //   _topFromNobelowTextToNoView.constant = -8;
             

         }
     }
}

- (IBAction)CancelBtn:(id)sender {
    [self disableAll];
    [_saveClick setHidden:YES];
    [_cancelClick setHidden:YES];
    [_editClick setHidden:NO];
    _editRightConstraint.constant = 8;
  //  cancel = YES;
   // [self webserviceCall];
}
- (IBAction)EditBtn:(id)sender {
    [_saveClick setHidden:NO];
    [_cancelClick setHidden:NO];
    _editRightConstraint.constant = 182;
    
    [self enableAll];
    
   
}
- (IBAction)saveBtn:(id)sender {
    save = YES;
    _editRightConstraint.constant = 8;
    periodNo = _periodClick.titleLabel.text;
    if([topicInfoAcyGrt16Count isEqualToString:@"0"]){
        field1 = _subTopicCompletedTextfield.text;
        field2 = _describeYourLessonTextfield.text;
        field3 = _teachingStrategiesTextfield.text;
        field4 = _challengesFaceDuringLessonTextfield.text;
        field5 = _workcarriedTextfield.text;
        field6 = _reasonforSameTextfield.text;
        field7 = _allOfStudentTextfield.text;
        field8 = _mostOfStudentTextfield.text;
        field9 = _someOfStudentTextfield.text;
        field10 = _fewOfStudentTextfield.text;
    }
    else if([topicInfocount isEqualToString:@"0"]){
        field1 = _topicStartedOnTextfield.text;
        field2 = _topicCompletedOnTextfield.text;
        field3 = _yesNoClick.titleLabel.text;
        field4 = _typeOfAssessmentTextfield.text;
        field5 = _dateOnWhichTextfield.text;
        field6 = _feedbackOfAssesmentTextfield.text;
        field7 = _chalengesFacedbyStudentTextfield.text;
        field8 = _suggested_correction_Textbook_TextField.text;
        field9 = _suggested_Coorection_workBookTextfield.text;
        field10 = _suggestedCorrectionLessonPlanTextfield.text;
        field11=  _suggeCorrInternalAssessmentTextField.text;
        field12 = _anyOtherRemarks_textfield.text;
     
    }
    
    if([topicInfocount isEqualToString:@"0"]){
        if([field1 isEqualToString:@""] && [field2 isEqualToString:@""] &&[field3 isEqualToString:@""] &&[field4 isEqualToString:@""]&&[field5 isEqualToString:@""] && [field6 isEqualToString:@""] &&[field7 isEqualToString:@""] && [field8 isEqualToString:@""] && [field9 isEqualToString:@""] && [field10 isEqualToString:@""] &&[field11 isEqualToString:@""] &&[field12 isEqualToString:@""]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Atleast one Field" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];

        }
        else{
            [self webserviceCall];
        }
    }
    else if([topicInfoAcyGrt16Count isEqualToString:@"0"]){
        if([field1 isEqualToString:@""] && [field2 isEqualToString:@""] &&[field3 isEqualToString:@""] &&[field4 isEqualToString:@""]&&[field5 isEqualToString:@""] && [field6 isEqualToString:@""] &&[field7 isEqualToString:@""] && [field8 isEqualToString:@""] && [field9 isEqualToString:@""] && [field10 isEqualToString:@""]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Please Enter Atleast one Field" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else{
            [self webserviceCall];
        }

    }
    
    
    //[self webserviceCall];
}
- (IBAction)yesNoBtn:(id)sender {
    alertyesno= [[UIAlertView alloc] initWithTitle:@"Select Category"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:(NSString *)nil];
    
    
    yesnoTableView= [[UITableView alloc] init];
    yesnoTableView.delegate = self;
    yesnoTableView.dataSource = self;
    [alertyesno setValue:yesnoTableView forKey:@"accessoryView"];
    [alertyesno show];

}
- (IBAction)periodButton:(id)sender {
    alertperiod= [[UIAlertView alloc] initWithTitle:@"Select Period"
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"Close"
                                   otherButtonTitles:(NSString *)nil];

    
    periodtableview= [[UITableView alloc] init];
    periodtableview.delegate = self;
    periodtableview.dataSource = self;
    [alertperiod setValue:periodtableview forKey:@"accessoryView"];
    [alertperiod show];

}
@end
