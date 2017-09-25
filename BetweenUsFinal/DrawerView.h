//
//  Drawer.h
//  CCKFNavDrawer
//
//  Created by calvin on 2/2/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerView : UIView
//@property (weak, nonatomic) IBOutlet UITableView *drawerTableView;
//@property (weak, nonatomic) IBOutlet UITableView *drawerTableView;
@property (weak, nonatomic) IBOutlet UITableView *drawerTableView;
@property (weak, nonatomic) IBOutlet UILabel *academic_year;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *std;
@property (weak, nonatomic) IBOutlet UILabel *rollNo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *drawerDataHeight;
@property (weak, nonatomic) IBOutlet UIImageView *drawerimageview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *drawerStdConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonConstraintDrawerTableView;

//@property (weak, nonatomic) IBOutlet UITableView *drawerTableView;
@end
