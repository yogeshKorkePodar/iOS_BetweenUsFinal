//
//  AppDelegate.m
//  BetweenUsFinal
//
//  Created by podar on 15/07/17.
//  Copyright © 2017 podar. All rights reserved.
//

#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#include <AudioToolbox/AudioToolbox.h>
#import "StudentDashboardWithoutSibling.h"
#import "StudentProfileWithSiblingViewController.h"
#import "ViewMessageViewController.h"
#import "AnnouncementViewController.h"


@interface AppDelegate ()
{
NSString *usl_id;
NSString *token;
NSString *LoginUserCount;
NSString *roll_id;
NSString *name;
NSString *board_name;
NSString *school_name;
MBProgressHUD *hud;
NSString *message;
NSString *alert,*classTeacher;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    
    NSLog(@"<Launching App !!!");
    [self.window setTintColor:[UIColor whiteColor]];
    //-- Set Notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // Getting App preferences/ cached data
    
    
    usl_id = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"usl_id"];
    
    LoginUserCount  = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"LoginUserCount"];;
    
    roll_id = [[NSUserDefaults standardUserDefaults]
               stringForKey:@"Roll_id"];
    
    school_name = [[NSUserDefaults standardUserDefaults]
                   stringForKey:@"school_name"];
    board_name = [[NSUserDefaults standardUserDefaults]stringForKey:@"brd_name"];
    
    name = [[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
    
    classTeacher = [[NSUserDefaults standardUserDefaults]stringForKey:@"classTeacher"];
    
    NSLog(@"Usl Id---%@", usl_id);
    NSLog(@"ArrayCount---%@", LoginUserCount);
    NSLog(@"Board Name App---%@", board_name);
     if (launchOptions != nil)
     {
         //opened from a push notification when the app is closed
         NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
         if (userInfo != nil)
         {
             NSLog(@"userInfo->%@",[userInfo objectForKey:@"aps"]);
             
             UIApplicationState state = [application applicationState];
             NSLog(@"userinfo %@",userInfo);
             if(!usl_id==nil){
                 // Parent role
                 if( [roll_id isEqualToString:@"6"]) {
                     if (state == UIApplicationStateActive) {
                         
                         AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                         
                         // Below Code Shows Message While Your Application is in Active State
                         NSLog(@"Notification Received---  %@",@"Notification Received");
                         NSString *cancelTitle = @"Ok";
                         
                         message = [[userInfo valueForKey:@"aps"] valueForKey:@"Type"];
                         alert = [[userInfo valueForKey:@"aps"]valueForKey:@"alert"];
                         NSLog(@"Message %@",message);
                         
                         if([message isEqualToString:@"Message"]){
                             //                SystemSoundID soundID;
                             //                        CFBundleRef mainBundle = CFBundleGetMainBundle();
                             //                        CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"default.wav", NULL, NULL);
                             //                        AudioServicesCreateSystemSoundID(ref, &soundID);
                             AudioServicesPlaySystemSound(1004);
                             
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                                 message:alert
                                                                                delegate:nil
                                                                       cancelButtonTitle:cancelTitle
                                                                       otherButtonTitles: nil];
                             [alertView show];
                             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                                      bundle: nil];
                             ViewMessageViewController *controller = (ViewMessageViewController*)[mainStoryboard
                                                                                                  instantiateViewControllerWithIdentifier: @"Message"];
                             CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                             hud = [[MBProgressHUD alloc] initWithView:controller.view];
                             navController.navigationBar.barTintColor = [UIColor blackColor];
                             [navController.navigationBar setTitleTextAttributes:
                              @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                             [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
                             
                             self.window.rootViewController = navController;
                         }
                         else if([message isEqualToString:@"Annoucement"]){
                             
                             //            SystemSoundID soundID;
                             //                    CFBundleRef mainBundle = CFBundleGetMainBundle();
                             //                    CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"default.wav", NULL, NULL);
                             //                    AudioServicesCreateSystemSoundID(ref, &soundID);
                             AudioServicesPlaySystemSound(1004);
                             
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Announcement"
                                                                                 message:alert
                                                                                delegate:nil
                                                                       cancelButtonTitle:cancelTitle
                                                                       otherButtonTitles: nil];
                             [alertView show];
                             
                             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                                      bundle: nil];
                             AnnouncementViewController *controller = (AnnouncementViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"Announcement"];
                             CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                             hud = [[MBProgressHUD alloc] initWithView:controller.view];
                             navController.navigationBar.barTintColor = [UIColor blackColor];
                             [navController.navigationBar setTitleTextAttributes:
                              @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                             [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
                             
                             self.window.rootViewController = navController;
                             
                         }
                     } else if(state == UIApplicationStateInactive) {
                         NSLog(@"Notification Received---  %@",@"Notification Received");
                         NSString *cancelTitle = @"Ok";
                         
                         message = [[userInfo valueForKey:@"aps"] valueForKey:@"Type"];
                         NSLog(@"Message %@",message);
                         
                         if([message isEqualToString:@"Message"]){
                             
                             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                                      bundle: nil];
                             ViewMessageViewController *controller = (ViewMessageViewController*)[mainStoryboard
                                                                                                  instantiateViewControllerWithIdentifier: @"Message"];
                             CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                             hud = [[MBProgressHUD alloc] initWithView:controller.view];
                             navController.navigationBar.barTintColor = [UIColor blackColor];
                             [navController.navigationBar setTitleTextAttributes:
                              @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                             
                             self.window.rootViewController = navController;
                             
                             
                         }
                         else if([message isEqualToString:@"Annoucement"]){
                             
                             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                                      bundle: nil];
                             AnnouncementViewController *controller = (AnnouncementViewController*)[mainStoryboard
                                                                                                    instantiateViewControllerWithIdentifier: @"Announcement"];
                             CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                             hud = [[MBProgressHUD alloc] initWithView:controller.view];
                             navController.navigationBar.barTintColor = [UIColor blackColor];
                             [navController.navigationBar setTitleTextAttributes:
                              @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                             
                             self.window.rootViewController = navController;
                             
                         }
                         
                     }
                     else if(state == UIApplicationStateBackground) {
                         NSLog(@"Notification Received---  %@",@"Notification Received");
                         NSString *cancelTitle = @"Ok";
                         
                         message = [[userInfo valueForKey:@"aps"] valueForKey:@"Type"];
                         NSLog(@"Message %@",message);
                         
                         if([message isEqualToString:@"Message"]){
                             
                             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                                      bundle: nil];
                             ViewMessageViewController *controller = (ViewMessageViewController*)[mainStoryboard
                                                                                                  instantiateViewControllerWithIdentifier: @"Message"];
                             CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                             hud = [[MBProgressHUD alloc] initWithView:controller.view];
                             navController.navigationBar.barTintColor = [UIColor blackColor];
                             [navController.navigationBar setTitleTextAttributes:
                              @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                             
                             self.window.rootViewController = navController;
                             
                             
                         }
                         else if([message isEqualToString:@"Annoucement"]){
                             
                             UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                                      bundle: nil];
                             AnnouncementViewController *controller = (AnnouncementViewController*)[mainStoryboard
                                                                                                    instantiateViewControllerWithIdentifier: @"Announcement"];
                             CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                             hud = [[MBProgressHUD alloc] initWithView:controller.view];
                             navController.navigationBar.barTintColor = [UIColor blackColor];
                             [navController.navigationBar setTitleTextAttributes:
                              @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                             
                             self.window.rootViewController = navController;
                             
                         }
                         
                     }
                     
                 }
                
                 else if([roll_id isEqualToString:@"2"]){
                      // Admin role
                 }
                 else if([roll_id isEqualToString:@"5"]) {
                     // Teacher role
                 }
             }
             
         }
     }
    if (usl_id==nil) {
        NSLog(@"<Starting Login scene");
     
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        LoginViewController *controller = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"Login"];
        
        CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
        hud = [[MBProgressHUD alloc] initWithView:controller.view];
        navController.navigationBar.barTintColor = [UIColor blackColor];
        [navController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
        self.window.rootViewController = navController;

    }
    else if([roll_id isEqualToString:@"6"]) {
        if([LoginUserCount isEqualToString:@"1"]){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                     bundle: nil];
            StudentDashboardWithoutSibling *controller = (StudentDashboardWithoutSibling*)[mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDashboardWithoutSibling"];
            
            CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
            hud = [[MBProgressHUD alloc] initWithView:controller.view];
            navController.navigationBar.barTintColor = [UIColor blackColor];
            [navController.navigationBar setTitleTextAttributes:
             @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
           [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
            self.window.rootViewController = navController;
            
            //  navController.navigationBar.settc
            
        }
        else if(![LoginUserCount isEqualToString:@"1"]){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                     bundle: nil];
            StudentProfileWithSiblingViewController *controller = (StudentProfileWithSiblingViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"SiblingProfile"];
            CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
            hud = [[MBProgressHUD alloc] initWithView:controller.view];
            navController.navigationBar.barTintColor = [UIColor blackColor];
           [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
            [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            self.window.rootViewController = navController;
        }
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    NSLog(@"didRegisterUserNotificationSettings");
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Token: %@", token);
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"Device Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@",err);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"LaunchNotification %@",@"LaunchhhNotification");
    NSLog(@"<<<<<<<<<<<<<<<<<<< Notification Received >>>>>>>>>>>>>>>>>");
    UIApplicationState state = [application applicationState];
    NSLog(@"userinfo %@",userInfo);
    if(usl_id != nil){
        if( [roll_id isEqualToString:@"6"]){
            if (state == UIApplicationStateActive) {
                
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                
                // Below Code Shows Message While Your Application is in Active State
                NSLog(@"Notification Received---  %@",@"Notification Received");
                NSString *cancelTitle = @"Ok";
                
                message = [[userInfo valueForKey:@"aps"] valueForKey:@"Type"];
                alert = [[userInfo valueForKey:@"aps"]valueForKey:@"alert"];
                NSLog(@"Message %@",message);
                
                if([message isEqualToString:@"Message"]){
                    //                SystemSoundID soundID;
                    //                        CFBundleRef mainBundle = CFBundleGetMainBundle();
                    //                        CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"default.wav", NULL, NULL);
                    //                        AudioServicesCreateSystemSoundID(ref, &soundID);
                    AudioServicesPlaySystemSound(1004);
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message"
                                                                        message:alert
                                                                       delegate:nil
                                                              cancelButtonTitle:cancelTitle
                                                              otherButtonTitles: nil];
                    [alertView show];
                    //            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                    //                                                                     bundle: nil];
                    //            ViewMessageViewController *controller = (ViewMessageViewController*)[mainStoryboard
                    //                                                                                   instantiateViewControllerWithIdentifier: @"Message"];
                    //            CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                    //            hud = [[MBProgressHUD alloc] initWithView:controller.view];
                    //            navController.navigationBar.barTintColor = [UIColor blackColor];
                    //            [navController.navigationBar setTitleTextAttributes:
                    //             @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    //            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
                    //
                    //            self.window.rootViewController = navController;
                }
                else if([message isEqualToString:@"Annoucement"]){
                    
                    //            SystemSoundID soundID;
                    //                    CFBundleRef mainBundle = CFBundleGetMainBundle();
                    //                    CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"default.wav", NULL, NULL);
                    //                    AudioServicesCreateSystemSoundID(ref, &soundID);
                    AudioServicesPlaySystemSound(1004);
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Announcement"
                                                                        message:alert
                                                                       delegate:nil
                                                              cancelButtonTitle:cancelTitle
                                                              otherButtonTitles: nil];
                    [alertView show];
                    //
                    //            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                    //                                                                     bundle: nil];
                    //            AnnouncementViewController *controller = (AnnouncementViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"Announcement"];
                    //            CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                    //            hud = [[MBProgressHUD alloc] initWithView:controller.view];
                    //            navController.navigationBar.barTintColor = [UIColor blackColor];
                    //            [navController.navigationBar setTitleTextAttributes:
                    //             @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    //            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
                    //
                    //            self.window.rootViewController = navController;
                    //
                }
            } else if(state == UIApplicationStateInactive) {
                NSLog(@"Notification Received---  %@",@"Notification Received");
                NSString *cancelTitle = @"Ok";
                
                message = [[userInfo valueForKey:@"aps"] valueForKey:@"Type"];
                NSLog(@"Message %@",message);
                
                if([message isEqualToString:@"Message"]){
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                             bundle: nil];
                    ViewMessageViewController *controller = (ViewMessageViewController*)[mainStoryboard
                                                                                         instantiateViewControllerWithIdentifier: @"Message"];
                    CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                    hud = [[MBProgressHUD alloc] initWithView:controller.view];
                    navController.navigationBar.barTintColor = [UIColor blackColor];
                    [navController.navigationBar setTitleTextAttributes:
                     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    
                    self.window.rootViewController = navController;
                    
                    
                }
                else if([message isEqualToString:@"Annoucement"]){
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                             bundle: nil];
                    AnnouncementViewController *controller = (AnnouncementViewController*)[mainStoryboard
                                                                                           instantiateViewControllerWithIdentifier: @"Announcement"];
                    CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                    hud = [[MBProgressHUD alloc] initWithView:controller.view];
                    navController.navigationBar.barTintColor = [UIColor blackColor];
                    [navController.navigationBar setTitleTextAttributes:
                     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    
                    self.window.rootViewController = navController;
                    
                }
                
            }
            else if(state == UIApplicationStateBackground) {
                NSLog(@"Notification Received---  %@",@"Notification Received");
                NSString *cancelTitle = @"Ok";
                
                message = [[userInfo valueForKey:@"aps"] valueForKey:@"Type"];
                NSLog(@"Message %@",message);
                
                if([message isEqualToString:@"Message"]){
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                             bundle: nil];
                    ViewMessageViewController *controller = (ViewMessageViewController*)[mainStoryboard
                                                                                         instantiateViewControllerWithIdentifier: @"Message"];
                    CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                    hud = [[MBProgressHUD alloc] initWithView:controller.view];
                    navController.navigationBar.barTintColor = [UIColor blackColor];
                    [navController.navigationBar setTitleTextAttributes:
                     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    
                    self.window.rootViewController = navController;
                    
                    
                }
                else if([message isEqualToString:@"Annoucement"]){
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                             bundle: nil];
                    AnnouncementViewController *controller = (AnnouncementViewController*)[mainStoryboard
                                                                                           instantiateViewControllerWithIdentifier: @"Announcement"];
                    CCKFNavDrawer *navController = (CCKFNavDrawer *)[[CCKFNavDrawer alloc]initWithRootViewController:controller];
                    hud = [[MBProgressHUD alloc] initWithView:controller.view];
                    navController.navigationBar.barTintColor = [UIColor blackColor];
                    [navController.navigationBar setTitleTextAttributes:
                     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                    
                    self.window.rootViewController = navController;
                    
                }
            }
        }
        
        else if([roll_id isEqualToString:@"2"]){
            
        }
        else if([roll_id isEqualToString:@"5"]){
            
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
