//
//  ViewLogsViewController.h
//  BetweenUs
//
//  Created by podar on 18/10/16.
//  Copyright © 2016 podar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface ViewLogsViewController : UIViewController<UITextFieldDelegate>
{
    Reachability* internetReachable;
    Reachability* hostReachable;
    NSInteger *topicInfoarraycount,*topicInfoAcyGrt16arrayCount;
    NSString *device,*clt_id,*usl_id,*check,*pmg_Id,*rol_id,*org_id,*Brd_Id,*sec_Id,*DeviceToken,*DeviceType,*brd_name,*viewLogStatus,*periodStatus,*saveStatus,*topicname,*crf_id,*acy_year,*selectedStd,*selectedSubject,*yesNo,*periodNo,*topicInfocount,*topicInfoAcyGrt16Count,*field1,*field2,*field3,*field4,*field5,*field6,*field7,*field8,*field9,*field10,*field11,*field12,*statusMsg;
    NSArray *periodArray,*topicInfoAcyGrt16Array,*topicInfoArray,*yesnoArray;

}
@property (weak, nonatomic) IBOutlet UIView *wholeView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topFromNobelowTextToNoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfYesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintFromyesNoBelowViewToYesNoBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintfromYesViewToYesnoBtn;
@property (weak, nonatomic) IBOutlet UITextField *suggestedCorrectionLessonPlanTextfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceToLastPeriodFromeditButton;
@property (weak, nonatomic) IBOutlet UITextField *suggeCorrInternalAssessmentTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceToBelow16FromEditButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceToBelow16FromSaveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpacetoLastPeriodFromSaveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceToLastPeriodFromCancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceTobelow16FromCancel;
@property (weak, nonatomic) IBOutlet UITextField *anyOtherRemarks_textfield;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightChallengesFaceByStud;
@property (weak, nonatomic) IBOutlet UITextField *suggested_correction_Textbook_TextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topaspaceToUpperNoButton;
@property BOOL internetActive;
@property BOOL hostActive;
@property (weak, nonatomic) IBOutlet UIButton *cancelClick;
- (IBAction)CancelBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *editClick;
- (IBAction)EditBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveClick;
- (IBAction)saveBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *yesButtonView;
@property (weak, nonatomic) IBOutlet UIView *NoButtonUpperView;
@property (weak, nonatomic) IBOutlet UILabel *suggestedCorrecto_in_textBookLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestedCorrecto_in_workBookLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceToUpperViewNoButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yesButtonViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *anyOtherRemarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestedCorrecto_in_internalAssessmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestedCorrecto_in_lessonPlanLabel;
@property (weak, nonatomic) IBOutlet UITextField *chalengesFacedbyStudentTextfield;
@property (weak, nonatomic) IBOutlet UILabel *chalengesFacedbyStudentLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackOfAssessmentLabel;
@property (weak, nonatomic) IBOutlet UITextField *feedbackOfAssesmentTextfield;
@property (weak, nonatomic) IBOutlet UITextField *dateOnWhichTextfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceNoButtonBelowText;
@property (weak, nonatomic) IBOutlet UILabel *dateOnWhichLabel;
@property (weak, nonatomic) IBOutlet UITextField *typeOfAssessmentTextfield;
@property (weak, nonatomic) IBOutlet UIView *NoButtonBelowTextView;
@property (weak, nonatomic) IBOutlet UILabel *typeOfAssessmentLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesNoClick;
- (IBAction)yesNoBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *yesNoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceBelowAcademicYear16;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceAcademicYearGreter16;
@property (weak, nonatomic) IBOutlet UITextField *topicCompletedOnTextfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceLastPeriod;
@property (weak, nonatomic) IBOutlet UILabel *topicCompletedOnLabel;
@property (weak, nonatomic) IBOutlet UITextField *topicStartedOnTextfield;
@property (weak, nonatomic) IBOutlet UILabel *topicStartedonLabel;
@property (weak, nonatomic) IBOutlet UITextField *fewOfStudentTextfield;
@property (weak, nonatomic) IBOutlet UILabel *fewOfStudentLabel;
@property (weak, nonatomic) IBOutlet UITextField *someOfStudentTextfield;
@property (weak, nonatomic) IBOutlet UILabel *someOfStudentLabel;
@property (weak, nonatomic) IBOutlet UITextField *mostOfStudentTextfield;
@property (weak, nonatomic) IBOutlet UILabel *mostOfStudentLabel;
@property (weak, nonatomic) IBOutlet UITextField *allOfStudentTextfield;
@property (weak, nonatomic) IBOutlet UIView *lastPeriodView;
@property (weak, nonatomic) IBOutlet UIView *graterThanaca16View;
@property (weak, nonatomic) IBOutlet UILabel *allOfStudentLabel;
@property (weak, nonatomic) IBOutlet UIView *belowAcademicyear16View;
@property (weak, nonatomic) IBOutlet UITextField *reasonforSameTextfield;
@property (weak, nonatomic) IBOutlet UILabel *reasonforSameLabel;
@property (weak, nonatomic) IBOutlet UITextField *workcarriedTextfield;
@property (weak, nonatomic) IBOutlet UILabel *workcarriedLabel;
@property (weak, nonatomic) IBOutlet UITextField *challengesFaceDuringLessonTextfield;
@property (weak, nonatomic) IBOutlet UILabel *challengesFaceDuringLessonLabel;
@property (weak, nonatomic) IBOutlet UITextField *suggested_Coorection_workBookTextfield;
@property (weak, nonatomic) IBOutlet UITextField *teachingStrategiesTextfield;
@property (weak, nonatomic) IBOutlet UILabel *teachingStrategiesLabel;
@property (weak, nonatomic) IBOutlet UITextField *describeYourLessonTextfield;
@property (weak, nonatomic) IBOutlet UILabel *describeYourLessonLabel;
@property (weak, nonatomic) IBOutlet UITextField *subTopicCompletedTextfield;
@property (weak, nonatomic) IBOutlet UILabel *subTopicCompletedLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *std_div;
@property (weak, nonatomic) IBOutlet UIButton *periodClick;
- (IBAction)periodButton:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editRightConstraint;


@end
