//
//  password&security.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 17/1/2567 BE.
//

import UIKit

class password_security: UIViewController {
    
    @IBOutlet weak var FaceIDswitchstatus: UISwitch!
    var appdelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        let isFaceIDEnabled = UserDefaults.standard.bool(forKey: "isFaceIDEnabled")
        FaceIDswitchstatus.isOn = isFaceIDEnabled
    }
        
    @IBAction func faceIDSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isFaceIDEnabled")
        UserDefaults.standard.synchronize()
    }
    
    @IBOutlet weak var changePIN: UIButton!
    
    @IBAction func btn_changePINAction(_ sender: Any) {
        appdelegate?.defaults.setValue("changePIN", forKey: "changepass")
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "createpincode") as! createpincode
        self.appdelegate?.defaults.setValue("Y", forKey: "ischangepin")
        vc.thisState = .forgetPassword
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btn_backAction(_ sender: Any) {
//        let storyborad = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyborad.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.popToViewController(ofClass: Tabbar.self)
    }
}
