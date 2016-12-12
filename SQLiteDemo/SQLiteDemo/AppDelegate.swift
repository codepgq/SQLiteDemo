//
//  AppDelegate.swift
//  SQLiteDemo
//
//  Created by Mac on 16/12/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //第一步打开数据库
        SQLManager.shareInstance().openDB(DBName: "BLOB.sqlite")
        
        return true
    }

   

}

