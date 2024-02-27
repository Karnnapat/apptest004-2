//
//  Tabbar.swift
//  App_test003
//
//  Created by Karnnapat Kamolwisutthipong on 14/12/2566 BE.
//

import UIKit
import SwiftUI

class Tabbar: UITabBarController, UITabBarControllerDelegate {

//      MARK: - var
      var phonesend : String?
      var usernameAdded : String?
      var reportmonthmodel = GetReportModel()
      var reportmonthres : [GetReportRes] = [GetReportRes]()
      
      override func viewDidLoad() {
            super.viewDidLoad()
//            tabBar.selectedItem?.badgeColor = .F_97171
            self.navigationItem.hidesBackButton = true
            customizeTabBar()
            addMiddleButton()
            
      }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          

    }
      func customizeTabBar() {
              // Customize the appearance of the tab bar
//              tabBar.barTintColor = .F_97171
//            tabBar.selectedItem?.badgeColor = .F_97171
              tabBar.tintColor = .F_97171 //สีtabbarที่ถูกเลือก
              tabBar.unselectedItemTintColor = UIColor.gray
              tabBar.isTranslucent = false
          }

      func addMiddleButton() {
              // Create a custom button for the middle tab
            let middleButton = UIButton(type: .custom)
                middleButton.frame.size = CGSize(width: 60, height: 60)
                middleButton.center = CGPoint(x: tabBar.frame.width / 2, y: tabBar.frame.height / 2 - 10) // Adjust the position as needed
                middleButton.layer.cornerRadius = 30 // Make it round
                middleButton.setImage(UIImage(named: "Add"), for: .normal) // Set your image
                middleButton.imageView?.contentMode = .scaleAspectFit
                middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)


              // Add the button to the tab bar
              tabBar.addSubview(middleButton)
          }
      @objc func middleButtonTapped() {
            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyborad.instantiateViewController(identifier: "AddincomeViewController") as! AddincomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
//            print("Middle button tapped!")
            
          }


}
