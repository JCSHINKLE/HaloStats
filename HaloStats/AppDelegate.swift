//
//  AppDelegate.swift
//  HaloStats
//
//  Created by Joshua Shinkle on 5/11/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    Database.database().isPersistenceEnabled = true
    return true
  }
}
