//
//  passcode.swift
//  App_test003
//
//  Created by Karnnapat Kamolwisutthipong on 12/12/2566 BE.
//

import UIKit
import SwiftUI
import LocalAuthentication
import RxSwift


class passcode: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
//    MARK: - @IBOutlet
//    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var gotor_egisterpage: UILabel!
    @IBOutlet var digitButtons: [UIButton]!
    @IBOutlet var deleteButtons: [UIButton]!
    @IBOutlet weak var pincode_collection: UICollectionView!
    @IBOutlet weak var pincodestatus: UILabel!
    @IBOutlet var tryfaceid: UILabel!
    
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var forgetpin: UILabel!
    //    MARK: - VAR
    var pinnumber : [String] = []
    var arrText : [String] = []
    var faceIDAuthenticated: Bool = false
    var CreateAccount : String?
    var phonesend : String?
    var AccountModel = CreateAccountModel()
    var loginaccountmodel = LoginAccountModel()
    var forgetpinmodel = ForGetPINModel()
    var otpforgetpinmodel = OTPForGetPINModel()
    var phoneModel = phoneNumber()

    
    public enum stateType {
        case register
        case login
        case changePassword
        case forgetPassword
        case income
        case expenses
        case delAcount
        case UpdatePhone
    }
 
    var thisState : stateType?
    var appdelegate = UIApplication.shared.delegate as? AppDelegate
    
//   MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initcollectionview()
        registercell()
        tryfaceid.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(authenticateWithFaceID))
        tryfaceid.addGestureRecognizer(tapGestureRecognizer)
        tryfaceid.isUserInteractionEnabled = true
        
        let taptocreatepinpage = UITapGestureRecognizer(target: self, action: #selector(gotoregister))
        gotor_egisterpage.addGestureRecognizer(taptocreatepinpage)
        gotor_egisterpage.isUserInteractionEnabled = true
        
        let taptoresetpin = UITapGestureRecognizer(target: self, action: #selector(resetpin))
        forgetpin.addGestureRecognizer(taptoresetpin)
        forgetpin.isUserInteractionEnabled = true
        
        applyUnderline()
        // กำหนด tag ให้กับปุ่มตัวเลข
        for (index, button) in digitButtons.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(digitButtonTapped(_:)), for: .touchUpInside)
        }
        
        if thisState == .login {
            forgetpin.isHidden = false
            btn_back.isHidden = true
            forgetpin.text = "ลืมรหัสผ่าน"
        }else if thisState == .register {
            forgetpin.isHidden = true
            btn_back.isHidden = false
        }else if thisState == .changePassword {
            forgetpin.isHidden = true
            btn_back.isHidden = false
            pincodestatus.text = "ยืนยัน PIN"
        }else if thisState == .forgetPassword {
            forgetpin.isHidden = true
            btn_back.isHidden = false
            pincodestatus.text = "ยืนยัน PIN"
        }else if thisState == .delAcount{
            self.forgetpin.isHidden = true
        }else if thisState == .UpdatePhone{
            self.forgetpin.isHidden = true
            self.btn_back.isHidden = false
        }
//        if (appdelegate?.defaults.object(forKey: "isLogin") as? String == "Y") {
//            forgetpin.isHidden = false
//            btn_back.isHidden = true
//        }else if (appdelegate?.defaults.object(forKey: "changepass") as? String == "check"){
//            forgetpin.isHidden = true
//        }else {
//            forgetpin.isHidden = true
//            btn_back.isHidden = true
//
//        }
        
        if let changePass = UserDefaults.standard.string(forKey: "changepass"), changePass == "changePIN" 
        {
                // ถ้ามีการเปลี่ยนรหัสผ่านให้ปิดการใช้งาน Face ID
                UserDefaults.standard.removeObject( forKey: "isFaceIDEnabled")
                UserDefaults.standard.set(false, forKey: "isFaceIDEnabled")
                UserDefaults.standard.synchronize()
        }else
        {
            let isFaceIDEnabled = UserDefaults.standard.bool(forKey: "isFaceIDEnabled")
            if isFaceIDEnabled 
            {
                authenticateWithFaceID()
//                tryfaceid.isHidden = true
            }
        }
    }
    
    func check() {
        switch thisState {
        case .login:
            break
        case .register:
            break
        case .changePassword:
            break
        case .forgetPassword:
            break
        default:
            break
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        arrText = []
//        authenticateWithFaceID()
        pincode_collection.reloadData()
    }
    
    func registercell(){
        pincode_collection.register(UINib(nibName: "circlepinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "circlepinCollectionViewCell")
        }
    
    func initcollectionview(){
        
        if pincode_collection.delegate == nil{
            pincode_collection.delegate = self
            pincode_collection.dataSource = self
            pincode_collection.reloadData()
        }else{
            pincode_collection.reloadData()
        }
    }
    
//      MARK: - checkState

    func CheckState(_ pincode : String) {
        
            if thisState == .login {
                loginAccount()
            }else if thisState == .register {
              if checkConditionForNextPage(pincode) {
                    let storyborad = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyborad.instantiateViewController(identifier: "CreateUsername") as! CreateUsername
                    vc.phoneforcreate = phonesend
                    vc.PIN = pincode
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    let alert = UIAlertController(title: "แจ้งเตือน", message: "PIN ไม่ถูกต้อง กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    arrText = []
                    pincode_collection.reloadData()
                    pincodestatus.text = "กรุณาลองใหม่อีกครั้ง"
                }
            }else if thisState == .changePassword {
                 let userInfo = self.appdelegate?.loadUserInfo()

                    
                switch arrText.joined() {
                case userInfo?.password :
                    ForgetPIN()
                default:
                    let alert = UIAlertController(title: "แจ้งเตือน", message: "PIN ไม่ถูกต้อง กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    arrText = []
                    pincode_collection.reloadData()
                    pincodestatus.text = "กรุณาลองใหม่อีกครั้ง"
                }
               
            }else if thisState == .forgetPassword {
                switch arrText.joined() {
                case pinnumber.last:
                    ForgetPIN()
                default:
                    let alert = UIAlertController(title: "แจ้งเตือน", message: "PIN ไม่ถูกต้อง กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    arrText = []
                    pincode_collection.reloadData()
                    pincodestatus.text = "กรุณาลองใหม่อีกครั้ง"
                }
                
            }else if thisState == .delAcount {
//                switch arrText.joined() {
//                case pinnumber.last:
               
                let PIN = arrText.joined()
                let userInfo = self.appdelegate?.loadUserInfo()
                let password = userInfo?.password ?? ""
                    
                    if PIN == password {
                        let storyborad = UIStoryboard(name: "AccountSetting", bundle: nil)
                        let vc = storyborad.instantiateViewController(identifier: "confirmDelAccount") as! confirmDelAccount
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        //                default:
                        let alert = UIAlertController(title: "แจ้งเตือน", message: "PIN ไม่ถูกต้อง กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        present(alert, animated: true, completion: nil)
                        arrText = []
                        pincode_collection.reloadData()
                        pincodestatus.text = "กรุณาลองใหม่อีกครั้ง"
                    }
//                }
                
            }else if thisState == .UpdatePhone{
                let PIN = arrText.joined()
                let userInfo = self.appdelegate?.loadUserInfo()
                let password = userInfo?.password ?? ""
                    
                    if PIN == password {
                        let storyborad = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyborad.instantiateViewController(identifier: "Register") as! Register
                        vc.thisState = .EditPhone
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        //                default:
                        let alert = UIAlertController(title: "แจ้งเตือน", message: "PIN ไม่ถูกต้อง กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        present(alert, animated: true, completion: nil)
                        arrText = []
                        pincode_collection.reloadData()
                        pincodestatus.text = "กรุณาลองใหม่อีกครั้ง"
                    }
            }
//
    }
    func checkAndShowResult(_ pincode : String) {
        
//        if arrText.count <= 6 {
//            arrText.append(pincode)
//        }
        if (appdelegate?.defaults.object(forKey: "changepass") as? String == "check") {
            if checkConditionForNextPage(pincode) {
                UserDefaults.standard.removeObject(forKey: "changepass")
                // บังคับให้ UserDefaults ทำการบันทึกการเปลี่ยนแปลง
                UserDefaults.standard.synchronize()

                  let storyborad = UIStoryboard(name: "Userprofile", bundle: nil)
                  let vc = storyborad.instantiateViewController(identifier: "password_security") as! password_security
                  self.navigationController?.pushViewController(vc, animated: true)
                
//                appdelegate?.defaults.setValue("Y", forKey: "isLogin")

//                pincodestatus.text = "Enter Pincode"
            } else {
                let alert = UIAlertController(title: "แจ้งเตือน", message: "PINCODE ไม่ถูกต้อง กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                arrText = []
                pincode_collection.reloadData()
                pincodestatus.text = "กรุณาลองใหม่อีกครั้ง"
            }
            pincode_collection.reloadData()
        }else if (appdelegate?.defaults.object(forKey: "changepass") as? String == "changePIN"){
            if checkConditionForNextPage(pincode) {
                UserDefaults.standard.removeObject(forKey: "changepass")
                // บังคับให้ UserDefaults ทำการบันทึกการเปลี่ยนแปลง
                UserDefaults.standard.synchronize()
                self.navigationController?.popToViewController(ofClass: Tabbar.self)
            } else {
                let alert = UIAlertController(title: "แจ้งเตือน", message: "PINCODE ไม่ถูกต้อง กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                arrText = []
                pincode_collection.reloadData()
                pincodestatus.text = "กรุณาลองใหม่อีกครั้ง"
            }
            pincode_collection.reloadData()
        }else{
//            if checkConditionForNextPage(pincode) {
                
                if (appdelegate?.defaults.object(forKey: "isLogin") as? String == "Y"){
                    loginAccount()
                }else{
                    let storyborad = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyborad.instantiateViewController(identifier: "CreateUsername") as! CreateUsername
                    vc.phoneforcreate = phonesend
                    vc.PIN = pincode
                    self.navigationController?.pushViewController(vc, animated: true)
                }
//            } else {
//                let alert = UIAlertController(title: "แจ้งเตือน", message: "PINCODE ไม่ถูกต้อง กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                present(alert, animated: true, completion: nil)
//                arrText = []
//                pincode_collection.reloadData()
//                pincodestatus.text = "กรุณาลองใหม่อีกครั้ง"
//            }
            pincode_collection.reloadData()
        }
        
    }
    
    func checkConditionForNextPage(_ pincode : String) -> Bool {
//        if arrText == pinnumber {
//            return true
//        }
//        return false
        if let savedPIN = getPIN() {
            if pincode == savedPIN {
                return true
            } else {
                print("Saved PIN: \(savedPIN)")
            }
        }
        return false
    }
    
    // MARK: - Action
        
        @objc func digitButtonTapped(_ sender: UIButton) {
            if arrText.count < 6
            {
                arrText.append("\(sender.tag)")
            }
            print(arrText.count)
            if arrText.count == 6 {
                print("Condition Check!!!!!!!")
                CheckState(arrText.joined())
//                checkAndShowResult(arrText.joined())
            }

//            updateCircleImages(arrText.joined())
            pincode_collection.reloadData()
        }
    
    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Helper
        
    func updateCircleImages(_ pin: String) {
                
               // เช็คถ้า PIN ถูกกรอกครบ 4 ตัว
               if pin.count == 6 {
                   print(pin)

                   checkAndShowResult(pin)
               }
           }
//    userdefault
    @IBAction func deleteButtonTapped(_ deleteButtons: UIButton) {
        
        if arrText.isEmpty {
            
        }else{
            arrText.removeLast()
//            pinTextField.text = arrText.joined()
        }
        pincode_collection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "circlepinCollectionViewCell", for: indexPath) as? circlepinCollectionViewCell else {return UICollectionViewCell()}
        let filledCircles = min(indexPath.row + 1, arrText.count)
            
            // Set the image based on whether the circle should be filled or not
            if indexPath.row < filledCircles {
                cell.circle.image = UIImage(systemName: "circle.fill")
            } else {
                cell.circle.image = UIImage(systemName: "circle")
            }
            
            return cell
//        return cell
    }
    
    //    MARK: - Faceid
    @objc func authenticateWithFaceID() {
            let context = LAContext()
            var error: NSError?

            // Check if the device supports Face ID
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                             let userInfo = self.appdelegate?.loadUserInfo()
                                
                            
                            // Face ID authentication succeeded
                            self.arrText.append(userInfo?.password ?? "")
                            print("Retrieved PIN from Keychain: \(self.arrText)")
                                self.CheckState(self.arrText.joined())

                        } else {
                            let alert = UIAlertController(title: "Authanticationfailed", message: "You could not be verified; Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            // Face ID authentication failed or was canceled
                            if let error = authenticationError as NSError? {
                                print("Face ID authentication failed: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                self.pincode_collection.reloadData()
            } else {
                let alert = UIAlertController(title: "Biometry unavailable", message: "Your Device is not configured for biometric authentication.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                // Device does not support Face ID or Face ID is not set up
                print("Face ID not available on this device")
            }
        }
    
    func applyUnderline() {
            // Create an attributed string with an underline
            let underlineAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ]

            let attributedString = NSAttributedString(string: forgetpin.text ?? "ลืม PIN CODE", attributes: underlineAttributes)

            // Set the attributed text to the label
        forgetpin.attributedText = attributedString
        }
    
//    MARK: - nav
    @objc func gotoregister() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "Register") as! Register
        self.navigationController?.pushViewController(vc, animated: true)
        }
    @objc func gotocreateusername() {
        if (appdelegate?.defaults.object(forKey: "isLogin") as? String == "Y"){
            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyborad.instantiateViewController(identifier: "Tabbar") as! Tabbar
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyborad.instantiateViewController(identifier: "CreateUsername") as! CreateUsername
            self.navigationController?.pushViewController(vc, animated: true)
        }
        }
    @objc func resetpin() {
//        let storyborad = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyborad.instantiateViewController(identifier: "OTPforgetpinViewController") as! OTPforgetpinViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        OTPforgetpin()
        }
    
    
    func getPIN() -> String? {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &item)

        if status == errSecSuccess {
            if let data = item as? Data, let pin = String(data: data.prefix(6), encoding: .utf8) {
                print("\(pin)")
                return pin
            }
        }

        return nil
    }
    
    //MARK: - AlmoFire API
        let apiClient : ApiClient = ApiClient()
        private let disposeBag = DisposeBag()
    
    func getDatatologinAPI(data : LoginAccountModel) -> Observable<LoginAccountResponse> {
        return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/Authentication/MemberLogin"))
    }
        
    func loginAccount() {
//        let savedPIN = self.getPIN()
        loginaccountmodel.phone = phonesend
        if let userInfo = self.appdelegate?.loadUserInfo() {
            if userInfo.phone != "" {
                loginaccountmodel.phone = userInfo.phone
            }else {
                loginaccountmodel.phone = phonesend
            }
        }
        loginaccountmodel.password = arrText.joined()
        print(loginaccountmodel)
        getDatatologinAPI(data: loginaccountmodel)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
                //print(resData)
                if resData.success == true {
                    if resData.data?.is_Verified == true {
                        if self.thisState == .changePassword{
                            let storyborad = UIStoryboard(name: "Userprofile", bundle: nil)
                            let vc = storyborad.instantiateViewController(identifier: "password_security") as! password_security
                            self.appdelegate?.saveToUserInfo(model: UserInfomationModel.init(idmember: resData.data?.idmember, username: resData.data?.username, phone: self.loginaccountmodel.phone, password: self.loginaccountmodel.password, image: resData.data?.image))
                            UserDefaults.standard.removeObject(forKey: "ischangepin")
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else if self.thisState == .forgetPassword {
                            let storyborad = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyborad.instantiateViewController(identifier: "Tabbar") as! Tabbar
                            //Save To Userinfomation
                            self.appdelegate?.saveToUserInfo(model: UserInfomationModel.init(idmember: resData.data?.idmember, username: resData.data?.username, phone: self.loginaccountmodel.phone, password: self.loginaccountmodel.password, image: resData.data?.image))
                            self.appdelegate?.defaults.setValue("Y", forKey: "isLogin")
                            self.navigationController?.pushViewController(vc, animated: true)
//                            let storyborad = UIStoryboard(name: "Userprofile", bundle: nil)
//                            let vc = storyborad.instantiateViewController(identifier: "password_security") as! password_security
//                            UserDefaults.standard.removeObject(forKey: "ischangepin")
//                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }else {
                            let storyborad = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyborad.instantiateViewController(identifier: "Tabbar") as! Tabbar
                            //Save To Userinfomation
                            self.appdelegate?.saveToUserInfo(model: UserInfomationModel.init(idmember: resData.data?.idmember, username: resData.data?.username, phone: self.loginaccountmodel.phone, password: self.loginaccountmodel.password, image: resData.data?.image))
                            self.appdelegate?.defaults.setValue("Y", forKey: "isLogin")
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                                            
                            //Save To Userinfomation
//                            self.appdelegate?.saveToUserInfo(model: UserInfomationModel.init(idmember: resData.data?.idmember, username: resData.data?.username, phone: self.loginaccountmodel.phone, password: self.loginaccountmodel.password, image: resData.data?.image))
//                            self.navigationController?.popToViewController(ofClass: Tabbar.self)
//                            self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        let alert = UIAlertController(title: "แจ้งเตือน", message: "PIN ไม่ถูกต้อง กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ปิด", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.arrText = []
                        self.pincode_collection.reloadData()
                        self.pincodestatus.text = "กรุณาลองใหม่อีกครั้ง"
                    }
                }else{
                    let alert = UIAlertController(title: "แจ้งเตือน", message: "บางอย่างผิดพลาด กรุณาลองใหม่อีกครั้ง", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ปิด", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            },onError: { error in
                switch error {
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            }) .disposed(by: disposeBag)
    }
func getDataForGetPINAPI(data : ForGetPINModel) -> Observable<ForGetPINResponse> {
        return apiClient.requestAPI(ApiRouter.Patch(data: data.convertToData, urlApi:"/api/Members/ForgotPassword"))
    }
        
    func ForgetPIN() {
//        let savedPIN = self.getPIN()
        forgetpinmodel.phone = phonesend
        if let userInfo = self.appdelegate?.loadUserInfo() {
            if userInfo.phone != "" {
                forgetpinmodel.phone = userInfo.phone
            }else {
                forgetpinmodel.phone = phonesend
            }
        }
        forgetpinmodel.newPassword = arrText.joined()
        print(forgetpinmodel)
        getDataForGetPINAPI(data: forgetpinmodel)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
                //print(resData)
                if resData.success == true {
                    if resData.data?.is_Seccess == true {
//                        let storyborad = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = storyborad.instantiateViewController(identifier: "Tabbar") as! Tabbar
                        //Save To Userinfomation
                        self.appdelegate?.saveToUserInfo(model: UserInfomationModel.init(idmember: resData.data?.idmember, phone: self.forgetpinmodel.phone, password: self.forgetpinmodel.newPassword))
                        if (self.appdelegate?.defaults.object(forKey: "ischangepin") as? String == "Y")  {
                            self.thisState = .changePassword
                        }
                        self.loginAccount()
//                        self.appdelegate?.defaults.setValue("Y", forKey: "isLogin")
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        let alert = UIAlertController(title: "แจ้งเตือน", message: "PIN ไม่ถูกต้อง กรุณากรอกใหม่อีกครั้ง", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ปิด", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.arrText = []
                        self.pincode_collection.reloadData()
                        self.pincodestatus.text = "กรุณาลองใหม่อีกครั้ง"
                    }
                }else{
                    let alert = UIAlertController(title: "แจ้งเตือน", message: "บางอย่างผิดพลาด กรุณาลองใหม่อีกครั้ง", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ปิด", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            },onError: { error in
                switch error {
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            }) .disposed(by: disposeBag)
    }
    
    //  ส่งdata
    func getDataAPI(data : OTPForGetPINModel) -> Observable<OTPForGetPINResponse> {
        return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/OTP/OTPForgotPassword"))
    }
        
    func OTPforgetpin() {
        
        otpforgetpinmodel.phone = phonesend
        if let userInfo = self.appdelegate?.loadUserInfo() {
            if userInfo.phone != "" {
                otpforgetpinmodel.phone = userInfo.phone
            }else {
                otpforgetpinmodel.phone = phonesend
            }
        }
        getDataAPI(data: otpforgetpinmodel)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
                //print(resData)
                if resData.data?.is_seccess == true {
                    let storyborad = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyborad.instantiateViewController(identifier: "OTPforgetpinViewController") as! OTPforgetpinViewController
                    vc.codeOTP = resData.data?.codeotp ?? ""
                    vc.expired = resData.data?.expired ?? 0
                    vc.refCode = resData.data?.refCode ?? ""
                    vc.phonenum = resData.data?.sendTO ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            },onError: { error in
                switch error {
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            }).disposed(by: disposeBag)
    }
    
    
}
