//
//  ViewController.m
//  BetweenUsFinal
//
//  Created by podar on 15/07/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//@synthesize show_password_outlet;
@synthesize myOutlet;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    checked = NO;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myButton:(UIButton *)sender {
    NSLog(@"SHOW PASSWORD CHECKBOX CLICKED");
    if(!checked){
        [myOutlet setImage:[UIImage imageNamed:@"Checked_Checkbox.png"] forState:UIControlStateNormal];
        checked = YES;
        _password_field.secureTextEntry = YES;
        NSLog(@"Checked");
    }
    else{
        [myOutlet setImage:[UIImage imageNamed:@"Unchecked_Checkbox.png"] forState:UIControlStateNormal];
        checked = NO;
        _password_field.secureTextEntry = NO;
        NSLog(@"Unchecked");
    }

    
}
- (IBAction)login_button:(UIButton *)sender {
    
}

- (IBAction)forgot_password_button:(UIButton *)sender {
}
@end
