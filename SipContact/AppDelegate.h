//
//  AppDelegate.h
//  SipContact
//
//  Created by Tyurin Andrey on 16/03/16.
//  Copyright © 2016 Tyurin Andrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)UITabBarController *tabBarController;

-(void)presentViewControllerFromVisibleViewController:(UIViewController *)toPresent;
@end

