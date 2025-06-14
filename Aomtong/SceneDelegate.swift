//
//  SceneDelegate.swift
//  apptest004
//
//  Created by Karnnapat Kamolwisutthipong on 21/12/2566 BE.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appDelegate : AppDelegate!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        sleep(2)
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let windowScene = scene as? UIWindowScene {
            
//            MARK:- 1 time login
            
            let window = UIWindow(windowScene: windowScene)
            let nav = UINavigationController()
            let isLogin: String = appDelegate.defaults.string(forKey: "isLogin") ?? ""
            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            UserDefaults.standard.removeObject(forKey: "checkpass")
            // บังคับให้ UserDefaults ทำการบันทึกการเปลี่ยนแปลง
            UserDefaults.standard.synchronize()
            if(isLogin == "Y"){
                let pincodeVC = storyborad.instantiateViewController(identifier: "passcode") as! passcode
                pincodeVC.thisState = .login
                nav.viewControllers = [pincodeVC]
            }else{
                let signInVC = storyborad.instantiateViewController(identifier: "Register") as! Register
                nav.viewControllers = [signInVC]
            }

            nav.navigationBar.isHidden = true
            window.rootViewController = nav
            
            self.window = window
            window.makeKeyAndVisible()
            
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

