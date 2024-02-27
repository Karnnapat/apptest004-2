//
//  Register.swift
//  apptest004
//
//  Created by Karnnapat Kamolwisutthipong on 23/12/2566 BE.
//

import UIKit
import RxSwift

class Register: UIViewController, UITextFieldDelegate {

    @IBAction func btn_OTPsender(_ sender: Any) {
        if let phonenumber = phone_TF.text, phonenumber.count == 10 {
            //URLSession API
//            URLSend()
            
            //Alamofire API
            phoneModel.phone = phone_TF.text ?? ""
            regisPhoneNumber()
           return
        }
    
    }
//    MARK: - IBOutlet
    @IBOutlet weak var btn_sendOTP: UIButton!
    @IBOutlet var goto_username: UILabel!
    @IBOutlet var goto_pin: UILabel!
    
    @IBOutlet weak var lb_showPhonenum: UILabel!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var phone_TF: UITextField!
    @IBOutlet var goto_homepage: UILabel!
    @IBOutlet var goto_createpin: UILabel!
    
//    MARK: - var

    var appDelegate : AppDelegate!
    
    var phoneModel = phoneNumber()
    
    var thisState : stateType?
    var appdelegate = UIApplication.shared.delegate as? AppDelegate

    
    public enum stateType {
        case EditPhone
    }


    
//      MARK: - lifecycle
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // Hide the tab bar
            self.tabBarController?.tabBar.isHidden = true
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // Show the tab bar when navigating away
            self.tabBarController?.tabBar.isHidden = false
        }
        override func viewDidLoad() {
        super.viewDidLoad()
            switch thisState {
            case .EditPhone:
                btn_back.isHidden = false
                lb_title.isHidden = false
                lb_showPhonenum.isHidden = false
                let UserInfo = self.appdelegate?.loadUserInfo()
                lb_showPhonenum.text = UserInfo?.phone
                appDelegate = UIApplication.shared.delegate as? AppDelegate
            phone_TF.delegate = self
                phone_TF.attributedPlaceholder = NSAttributedString(string: "     063 - xxxxxxxx", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
//            AllTap()
            default:
                btn_back.isHidden = true
                lb_title.isHidden = true
                lb_showPhonenum.isHidden = true
                
                appDelegate = UIApplication.shared.delegate as? AppDelegate
            phone_TF.delegate = self
                phone_TF.attributedPlaceholder = NSAttributedString(string: "     063 - xxxxxxxx", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            AllTap()
            }
            
        
    }
//    MARK: - Textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // ตรวจสอบว่าจำนวนตัวอักษรใน text field ไม่เกิน 10 ตัว
            let invalidCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|\"<>,.?/~`")
            let phonenumber = (textField.text ?? "") as NSString
            let newphonenumber = phonenumber.replacingCharacters(in: range, with: string)
                
        if EmojiUtilities.containsEmoji(emoji: string) || ((string.rangeOfCharacter(from: invalidCharacterSet)) != nil) {
            return false
        }
        
        if newphonenumber.count < 10 {
            btn_sendOTP.backgroundColor = UIColor.lightGray
            btn_sendOTP.isEnabled = false

        }
        if newphonenumber.count == 10 {
            btn_sendOTP.isEnabled = true
            btn_sendOTP.backgroundColor = UIColor.F_2_A_5_A_3
        }
            return newphonenumber.count <= 10
        
        }
    
    
    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: Tabbar.self)
    }
    
    //MARK: - URLSession API
    func URLSend() {
        let value = phone_TF.text
        let dict : NSMutableDictionary = NSMutableDictionary()
        dict.setValue(value, forKey: "phone")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            let url = URL(string: "http://zaserzafear.thddns.net:9973/api/OTP/GenerateOTP")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("*/*", forHTTPHeaderField: "accept")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    
                    guard let data = data else { return }
                    //                print(String(data: data, encoding: .utf8)!)
                    let json : String = String(data: data, encoding: .utf8) ?? ""
                    let dictData : NSDictionary = json.convertToDictionary(text: json) ?? NSDictionary()
                    let success : Bool = dictData.object(forKey: "success") as? Bool ?? false
                    if (success) {
                        let data : NSDictionary = dictData.object(forKey: "data") as? NSDictionary ?? NSDictionary()
                        let codeotp : String = data.object(forKey: "codeotp") as? String ?? ""
                        let expired : Int = data.object(forKey: "expired") as? Int ?? 0
                        let refCode : String = data.object(forKey: "refCode") as? String ?? ""
                        
                        let storyborad = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyborad.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                        vc.codeOTP = codeotp
                        vc.expired = expired
                        vc.refCode = refCode
                        vc.phonenum = self.phoneModel.phone
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }else {
                        
                    }
                }
            }
            
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
//  MARK: - AlmoFire API
    let apiClient : ApiClient = ApiClient()
    private let disposeBag = DisposeBag()
//  ส่งdata
    func getDataAPI(data : phoneNumber) -> Observable<responseOTP> {
        return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/OTP/GenerateOTP"))
    }
        
    func regisPhoneNumber() {
        getDataAPI(data: phoneModel)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
                print(resData)
                if resData.success == true {
//                    if resData.data?.validateLegthPhone == true {
                        if resData.data?.is_Duplicate == true {
                            switch self.thisState {
                            case .EditPhone:
                                let alert = UIAlertController(title: "หมายเลขนี้มีบัญชีอยู่แล้ว", message: "กรุณากรอกหมายเลขอื่น", preferredStyle: .alert)
                                let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                                    self.phone_TF.text = ""
                                }
                                alert.addAction(acceptAction)
                                self.present(alert, animated: true, completion: nil)
                            default:
                                let storyborad = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyborad.instantiateViewController(identifier: "passcode") as! passcode
                                vc.phonesend = self.phone_TF.text
                                vc.thisState = .login
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                           
//                            ซ้ำกลับหน้าเดิม
                            
                        }else {
                            switch self.thisState {
                            case .EditPhone:
                                let storyborad = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyborad.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                                vc.codeOTP = resData.data?.codeotp ?? ""
                                vc.expired = resData.data?.expired ?? 0
                                vc.refCode = resData.data?.refCode ?? ""
                                vc.phonenum = resData.data?.sendTO ?? ""
                                vc.OtpState = .EditPhone
                                self.navigationController?.pushViewController(vc, animated: true)
                            default:
                                let storyborad = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyborad.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                                vc.codeOTP = resData.data?.codeotp ?? ""
                                vc.expired = resData.data?.expired ?? 0
                                vc.refCode = resData.data?.refCode ?? ""
                                vc.phonenum = resData.data?.sendTO ?? ""
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
//                    }
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
    
//    MARK: - Actiontap
    @objc func handleTap() {
            // ซ่อน keyboard ทุกประการ
            view.endEditing(true)
        }
    
    @objc func gotopin() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "passcode") as! passcode
        self.navigationController?.pushViewController(vc, animated: true)
        } 
    @objc func gotocreatepin() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc2 = storyborad.instantiateViewController(identifier: "createpincode") as! createpincode
        self.navigationController?.pushViewController(vc2, animated: true)
        }
    @objc func gotousername() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc3 = storyborad.instantiateViewController(identifier: "CreateUsername") as! CreateUsername
        self.navigationController?.pushViewController(vc3, animated: true)
        
        }
    @objc func gotohomepage() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc4 = storyborad.instantiateViewController(identifier: "Tabbar") as! Tabbar
        self.navigationController?.pushViewController(vc4, animated: true)
        }
    func AllTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        let taptocreatepinpage = UITapGestureRecognizer(target: self, action: #selector(gotocreatepin))
        goto_createpin.addGestureRecognizer(taptocreatepinpage)
        goto_createpin.isUserInteractionEnabled = true
//        goto_createpin.isHidden = true
            
        let taptopinpage = UITapGestureRecognizer(target: self, action: #selector(gotopin))
        goto_pin.addGestureRecognizer(taptopinpage)
        goto_pin.isUserInteractionEnabled = true
//        goto_pin.isHidden = true
        
        let taptousername = UITapGestureRecognizer(target: self, action: #selector(gotousername))
        goto_username.addGestureRecognizer(taptousername)
        goto_username.isUserInteractionEnabled = true
//         goto_username.isHidden = true
        
        let taptohome = UITapGestureRecognizer(target: self, action: #selector(gotohomepage))
        goto_homepage.addGestureRecognizer(taptohome)
        goto_homepage.isUserInteractionEnabled = true
//        goto_homepage.isHidden = true
    }
    
}
