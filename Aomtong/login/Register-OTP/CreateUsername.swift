//
//  CreateUsername.swift
//  apptest004
//
//  Created by Karnnapat Kamolwisutthipong on 27/12/2566 BE.
//

import UIKit
import RxSwift

class CreateUsername: UIViewController, UITextFieldDelegate {
    
//    MARK: - IBOutlet
    @IBOutlet weak var btn_accept: UIButton!
    @IBOutlet weak var Username_tf: UITextField!
    @IBOutlet weak var skip: UILabel!
    
//    MARK: - var
    var phoneforcreate : String?
    var PIN : String?
    var AccountModel = CreateAccountModel()
    var loginaccountmodel = LoginAccountModel()
    var appdelegate = UIApplication.shared.delegate as? AppDelegate

//    MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Username_tf.delegate = self
        AccountModel.password = PIN
        AccountModel.phone = phoneforcreate
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        let taptoskip = UITapGestureRecognizer(target: self, action: #selector(SkipTap))
        skip.addGestureRecognizer(taptoskip)
        skip.isUserInteractionEnabled = true
    }
    
//    MARK: - Tap
    @objc func handleTap() {
            // ซ่อน keyboard ทุกประการ
        
            view.endEditing(true)
        }
//    MARK: - Navi
    @objc func SkipTap() {
        self.AccountModel.username = ""
        CreateAccount()
//        let storyborad = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyborad.instantiateViewController(identifier: "Tabbar") as! Tabbar
//        self.navigationController?.pushViewController(vc, animated: true)
            }

    @IBAction func btn_AcceptAccount(_ sender: Any) {
        CreateAccount()
    }
    
    //    MARK: - Textfield
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

                let invalidCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|\"<>,.?/~`")

                let addingusername = (textField.text ?? "") as NSString
                let UpdateUsername = addingusername.replacingCharacters(in: range, with: string)
            switch textField.text {
            case "":
                btn_accept.backgroundColor = .C_4_C_6_C_9
                btn_accept.isEnabled = false
            default:
                btn_accept.backgroundColor = .F_97171
                btn_accept.isEnabled = true

            }
            if EmojiUtilities.containsEmoji(emoji: string) || ((string.rangeOfCharacter(from: invalidCharacterSet)) != nil) {
                btn_accept.backgroundColor = .C_4_C_6_C_9
                btn_accept.isEnabled = false
                return true
            }else{
                btn_accept.backgroundColor = .F_97171
                btn_accept.isEnabled = true
            }
            
           if UpdateUsername.unicodeScalars.count <= 50 {
               AccountModel.username = UpdateUsername
            }

            return UpdateUsername.unicodeScalars.count <= 50
            
            }
    
    //MARK: - AlmoFire API
        let apiClient : ApiClient = ApiClient()
        private let disposeBag = DisposeBag()

        func getDataAPI(data : CreateAccountModel) -> Observable<ComfirmOTPResponse> {
            return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/Authentication/CreateAccount"))
        }
            
        func CreateAccount() {
            print(self.AccountModel.username ?? "")
//
//            if AccountModel.username == "" {
//                AccountModel.username = phoneforcreate
//            }
//            print(self.AccountModel.username ?? "")

            getDataAPI(data: AccountModel)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resData in
                    
                    //print(resData)
                    if resData.success == true {
                        if resData.data?.is_Success == true {
                            self.loginAccount()
//                            let storyborad = UIStoryboard(name: "Main", bundle: nil)
//                            let vc = storyborad.instantiateViewController(identifier: "Tabbar") as! Tabbar
//                            
//                            vc.phonesend = self.AccountModel.phone
//                            self.appdelegate?.defaults.setValue("Y", forKey: "isLogin")
//                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            let alert = UIAlertController(title: "แจ้งเตือน", message: resData.data?.message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "ปิด", style: .default, handler: { [weak self] _ in
                                self?.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true)
                            print(resData)
                        }
                    }else{
                        
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
    
        func getDatatologinAPI(data : LoginAccountModel) -> Observable<LoginAccountResponse> {
            return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/Authentication/MemberLogin"))
        }
            
        func loginAccount() {
            loginaccountmodel.phone = phoneforcreate
            loginaccountmodel.password = PIN
            getDatatologinAPI(data: loginaccountmodel)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resData in
                    
                    //print(resData)
                    if resData.success == true {
                        if resData.data?.is_Verified == true {
                            let storyborad = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyborad.instantiateViewController(identifier: "Tabbar") as! Tabbar
                            
                            //Init Model To Encode
                            let loginModel : UserInfomationModel = UserInfomationModel.init(idmember: resData.data?.idmember, username: resData.data?.username, phone: self.phoneforcreate, password: self.PIN, image: resData.data?.image)
                            //Save To UserDefaults
                            self.appdelegate?.saveToUserInfo(model: loginModel)
                            self.appdelegate?.defaults.setValue("Y", forKey: "isLogin")
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        
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
    
//    func saveToUserInfo(model : UserInfomationModel) {
//        do {
//            //Save
//            let data = try JSONEncoder().encode(model)
//            self.appdelegate?.defaults.setValue(data, forKey: "userInfo")
//            
//            //Load
//            let Data = self.appdelegate?.defaults.object(forKey: "userInfo")
//            let model = try JSONDecoder().decode(UserInfomationModel.self, from: Data as! Data)
//            print(model)
//        }catch {
//            print("!!!!!Can Not Encode Data!!!!!")
//        }
//    }
    
}
