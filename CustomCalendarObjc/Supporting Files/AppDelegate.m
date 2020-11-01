//
//  AppDelegate.m
//  CustomCalendarObjc
//
//  Created by Oleg Soloviev on 27.10.2020.
//  Copyright © 2020 Oleg Soloviev. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    CalendarViewController *vc = [[CalendarViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];
}

@end
