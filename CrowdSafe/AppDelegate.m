//
//  AppDelegate.m
//  CrowdSafe
//
//  Created by NG on 25/04/15.
//  Copyright (c) 2015 Neetesh Gupta. All rights reserved.
//

#import "AppDelegate.h"
#import "SpotzSDK/SpotzSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [SpotzSDK initializeWithAppId:@"rlpETa2JDBMBCjIOdydH1Odqa5iH83i7t52ieX7f" clientKey:@"eRHtE4E1OwrXdfgfj6DoQX9cLBJaOoPdzXHW9xnj" delegate:self withOptions:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzInsideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (note.object)
        {
            // Take out the Spotz object and its beacon
            NSDictionary *data = note.object;
            Spotz *spotz = data[@"spotz"];

            if (data[@"beacon"])
            {
                SpotzBeacon *beacon = data[@"beacon"];
                NSLog(@"Entry beacon (%@) detected with UUID: %@ major: %i minor: %i",spotz.name,beacon.uuid,beacon.major,beacon.minor);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"It works"
                                                                message:@":)"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else if (data[@"geofence"])
            {
                SpotzGeofence *geofence = data[@"geofence"];
                NSLog(@"Entry geofence (%@) detected with latitude: %f longitude %f",spotz.name,geofence.latitude,geofence.longitude);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"It works - Geofence"
                                                                message:@":)"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SpotzRangingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (note.object)
        {
            NSDictionary *data = note.object;

            Spotz *spotz = data[@"spotz"];
            NSNumber *acc = data[@"accuracy"];

            NSLog(@"Spotz id: %@ name: %@",spotz.id,spotz.name);
            NSLog(@"Accuracy %@", acc);
            
            // Do something with this Spotz and accuracy data
        }
    }];
    return YES;
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

#pragma mark - SpotzSDK delegates
- (void)spotzSDKInitSuccessfull {
    NSLog(@"SpotzSDK initialized successfully");
    [SpotzSDK startServices];
}

- (void)spotzSDKInitFailed:(NSError *)error {
    NSLog(@"Error %@",error);
}

@end
