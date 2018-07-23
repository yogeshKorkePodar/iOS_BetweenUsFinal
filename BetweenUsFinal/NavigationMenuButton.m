//
//  NavigationMenuButton.m
//  BetweenUs
//
//  Created by podar on 28/09/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "NavigationMenuButton.h"

@implementation NavigationMenuButton

+(UIBarButtonItem*)addNavigationMenuButton: (NavigationMenuButton*) myself{
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"white-menu-icon.png"] forState:UIControlStateNormal];
    [button addTarget:myself action:@selector(buttonAction)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 25)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    return barButton;
}

@end
