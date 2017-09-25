//
//  MenuButton.m
//  BetweenUsFinal
//
//  Created by podar on 19/08/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "MenuButton.h"

@implementation MenuButton

-(void) viewDidLoad{
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];


    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"white-menu-icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 25)];
}

-(void) buttonAction{
    NSLog(@"Navigation bar button clicked!");
    [self.rootNav drawerToggle];
}

@end

