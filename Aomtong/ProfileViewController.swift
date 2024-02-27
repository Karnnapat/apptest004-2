//
//  ProfileViewController.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 4/1/2567 BE.
//

import UIKit
import RxSwift

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    MARK: - Var
    var appdelegate = UIApplication.shared.delegate as? AppDelegate

//    MARK: - @IBOutle
    @IBOutlet weak var UserAvatar: UIImageView!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lb_Username: UILabel!
    
    @IBOutlet weak var Options: UITableView!
    
    let scrollView = UIScrollView()
    
//    MARK: - lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        registercell()
        inittable()
        
        //Call UserInfomation from UserDefaults
        let userInfo = self.appdelegate?.loadUserInfo()
        lb_Username.text = userInfo?.username

        setupScrollView()

    }
//    MARK: - Scrollview
    func setupScrollView() {
            // สร้าง UIScrollView
            scrollView.frame = view.bounds
            scrollView.contentSize = CGSize(width: view.bounds.width, height: 1000)  // ตั้งค่าขนาดเป็นตัวอย่าง

            // เพิ่ม UIScrollView เข้าไปในหน้าจอ
            contentView.addSubview(scrollView)

            // สร้าง UIRefreshControl
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

            // กำหนด refreshControl ให้กับ UIScrollView
            scrollView.refreshControl = refreshControl

            // สร้างข้อมูลใน UIScrollView (เป็นตัวอย่าง)

            // กำหนด contentInset เพื่อป้องกันการบังหน้าจอหลัก
            scrollView.contentInset = UIEdgeInsets(top: refreshControl.frame.size.height, left: 0, bottom: 0, right: 0)
        }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
            // ทำงานที่ต้องการทำในการรีเฟรช
            // ...
        let userInfo = self.appdelegate?.loadUserInfo()
        lb_Username.text = userInfo?.username
            // เมื่อเสร็จสิ้นการรีเฟรช
            sender.endRefreshing()
        }
    
//    MARK: - register / Init
    
    func registercell() {
        Options.register(UINib(nibName: "profilepage", bundle: nil), forCellReuseIdentifier: "profilepage")
    }
    
    func inittable() {
        if Options.delegate == nil{
            Options.delegate = self
            Options.dataSource = self
//            tableview.allowsSelection = false
            Options.separatorStyle = .none
            Options.reloadData()
        }else{
            Options.reloadData()
        }
    }
//    MARK: - Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profilepage") as? profilepage else {return UITableViewCell()}
       
        if indexPath.row == 0 {
            cell.options_icon.image = UIImage(named: "person_icon")
            cell.popPage_icon.image = UIImage(named: "options")
            cell.profileoptions.text = "ตั้งค่าบัญชี"
        }else if indexPath.row == 1 {
            cell.options_icon.image = UIImage(named: "phone_icon")
            cell.popPage_icon.image = UIImage(named: "options")
            cell.profileoptions.text = "หมายเลขโทรศัพท์"
        }else if indexPath.row == 2 {
            cell.options_icon.image = UIImage(named: "security")
            cell.popPage_icon.image = UIImage(named: "options")
            cell.profileoptions.text = "รหัสผ่าน และ ความปลอดภัย"
        }else if indexPath.row == 3 {
            cell.view.isHidden = true
            cell.options_icon.isHidden = true
            cell.popPage_icon.isHidden = true
            cell.profileoptions.isHidden = true
        }else if indexPath.row == 4 {
            cell.view.isHidden = true
            cell.options_icon.isHidden = true
            cell.popPage_icon.isHidden = true
            cell.profileoptions.isHidden = true
        }else if indexPath.row == 5 {
            cell.view.backgroundColor = .clear
            cell.view.borderWidth = 0
            cell.options_icon.image = UIImage(named: "logout")
            cell.popPage_icon.isHidden = true
            cell.profileoptions.text = "ออกจากระบบ"
            cell.profileoptions.textAlignment = .center
//            cell.options_icon.translatesAutoresizingMaskIntoConstraints = false
//            cell.options_icon.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
//            cell.options_icon.trailingAnchor.constraint(equalTo: cell.profileoptions.leadingAnchor, constant: -10).isActive = true
//            cell.profileoptions.translatesAutoresizingMaskIntoConstraints = false
//            cell.profileoptions.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
//            cell.profileoptions.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            cell.profileoptions.textColor = .E_70000
        }else{
//            cell.borderColor = .white
            cell.view.isHidden = true
            cell.options_icon.isHidden = true
            cell.popPage_icon.isHidden = true
            cell.profileoptions.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let storyborad = UIStoryboard(name: "AccountSetting", bundle: nil)
            let vc = storyborad.instantiateViewController(identifier: "accountSetting") as! accountSetting
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
        appdelegate?.defaults.setValue("check", forKey: "changepass")
            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyborad.instantiateViewController(identifier: "passcode") as! passcode
            vc.thisState = .changePassword
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1 {
                let storyborad = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyborad.instantiateViewController(identifier: "passcode") as! passcode
            vc.thisState = .UpdatePhone
                self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 5 {
            logout()
        }
    }
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        Options.headerView(forSection: indexPath.section)?.contentView.backgroundColor = .F_4_F_4_F_4
//
//    }
    
//  MARK: - Keychain
    func deletePINFromKeychain() {
        // กำหนด query สำหรับ Keychain
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName,
        ]

        // ลบรหัส PIN จาก Keychain
        let status = SecItemDelete(keychainQuery as CFDictionary)
        
        if status != errSecSuccess {
            print("Failed to delete PIN from Keychain. Status code: \(status)")
            // เพิ่มการดำเนินการตามต้องการหากต้องการทำบางอย่างเมื่อไม่สามารถลบได้
        }
    }
//    MARK: - logout
    func logout() {

        let alert = UIAlertController(title: "ออกจากระบบ", message: "คุณต้องการออกจากระบบ ?", preferredStyle: .alert)
                let acceptAction = UIAlertAction(title: "ออกจากระบบ", style: .default) { (action) in
                    // ลบข้อมูล UserDefaults ที่เก็บข้อมูลการล็อกอิน
                    UserDefaults.standard.removeObject(forKey: "isLogin")
                    UserDefaults.standard.removeObject(forKey: "checkpass")
                    UserDefaults.standard.removeObject(forKey: "isFaceIDEnabled")
                    UserDefaults.standard.removeObject(forKey: "userInfo")
                    // บังคับให้ UserDefaults ทำการบันทึกการเปลี่ยนแปลง
                    UserDefaults.standard.synchronize()
                    let storyborad = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyborad.instantiateViewController(identifier: "Register") as! Register
                    self.navigationController?.pushViewController(vc, animated: true)
                }

                let cancelAction = UIAlertAction(title: "ยกเลิก", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                    print("ผู้ใช้กด Cancel")
                    
                    self.deletePINFromKeychain()
                }

                // เพิ่มปุ่ม Accept และ Cancel ลงใน UIAlertController
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)
//        let storyborad = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyborad.instantiateViewController(identifier: "Register") as! Register
        present(alert, animated: true, completion: nil)
        }

}
