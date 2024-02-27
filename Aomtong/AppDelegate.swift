//
//  AppDelegate.swift
//  apptest004
//
//  Created by Karnnapat Kamolwisutthipong on 21/12/2566 BE.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func saveToUserInfo(model : UserInfomationModel) {
        do {
            //Save
            let data = try JSONEncoder().encode(model)
            self.defaults.setValue(data, forKey: "userInfo")
        }catch {
            print("!!!!!Can Not Encode Data!!!!!")
        }
    }
    
    func loadUserInfo() -> UserInfomationModel {
        //Load
        do {
            let data = self.defaults.object(forKey: "userInfo")
            let model = try JSONDecoder().decode(UserInfomationModel.self, from: data as? Data ??  Data())
            print(model)
            return model
        }catch {
            print("!!!!!Can Not Decode Data!!!!!")
            return UserInfomationModel()
        }
    }
}

