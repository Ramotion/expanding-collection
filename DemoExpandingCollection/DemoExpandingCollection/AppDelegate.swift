//
//  AppDelegate.swift
//  DemoExpandingCollection
//
//  Created by Alex K. on 25/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    configureNavigationTabBar()
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    
  }

  func applicationDidEnterBackground(application: UIApplication) {
   
  }

  func applicationWillEnterForeground(application: UIApplication) {
  }

  func applicationDidBecomeActive(application: UIApplication) {
  }

  func applicationWillTerminate(application: UIApplication) {
  }
}

extension AppDelegate {
  
  private func configureNavigationTabBar() {
    //transparent background
    UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
    UINavigationBar.appearance().shadowImage     = UIImage()
    UINavigationBar.appearance().translucent     = true
    
    let shadow = NSShadow()
    shadow.shadowOffset = CGSize(width: 0, height: 2)
    shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    
    UINavigationBar.appearance().titleTextAttributes = [
      NSForegroundColorAttributeName : UIColor.whiteColor(),
      NSShadowAttributeName: shadow
    ]
  }
}
