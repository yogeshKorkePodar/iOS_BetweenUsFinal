//
//  ViewController.h
//  BetweenUsFinal
//
//  Created by podar on 15/07/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    bool checked ;
}
- (IBAction)myButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *myOutlet;
@property (weak, nonatomic) IBOutlet UITextField *username_field;
@property (weak, nonatomic) IBOutlet UITextField *password_field;


- (IBAction)login_button:(UIButton *)sender;
- (IBAction)forgot_password_button:(UIButton *)sender;

@end

