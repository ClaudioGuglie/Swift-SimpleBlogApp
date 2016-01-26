//
//  AppDelegate.swift
//  ZEF
//
//  Created by Claudio on 11/12/15.
//  Copyright © 2015 Claudio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let zefConfig = NSDictionary(contentsOfFile: NSBundle.mainBundle()
            .pathForResource("ZEF", ofType: "plist")!)

        let gitkitClient = GITClient.sharedInstance()
        gitkitClient.apiKey = zefConfig?.valueForKey("gitkitClient.ApiKey") as? String
        gitkitClient.widgetURL = zefConfig?.valueForKey("gitkitClient.WidgetURL") as? String
        gitkitClient.providers = [kGITProviderGoogle]
        GIDSignIn.sharedInstance().clientID =
            zefConfig?.valueForKey("gitkitClient.ClientID") as? String

        let nowDouble = NSDate().timeIntervalSince1970

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = self.window?.rootViewController as! UINavigationController
        let viewController: UIViewController;

        if (UserPreferences.sharedInstance.gTokenExpireAt.doubleValue <= nowDouble)
        {
            //go to login VC
            viewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
        }
        else
        {
            viewController = mainStoryboard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController;
        }

        rootViewController.setViewControllers([viewController], animated: true)
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            // Handle custom scheme redirect here.
            return GITClient.handleOpenURL(url, sourceApplication : sourceApplication,
                annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

