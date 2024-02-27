//
//  accountSetting.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 9/1/2567 BE.
//

import UIKit
import RxSwift

class accountSetting: UIViewController, UITextFieldDelegate {
//    MARK: - Var
    var DelAccountemodel = DelModel()
    var Editusernamemodel = EditUsernameModel()

    var dispatchGroup: DispatchGroup?
    var appdelegate = UIApplication.shared.delegate as? AppDelegate
    var username : String = ""
//    MARK: -  @IBOutlet

    @IBOutlet weak var Username_tf: UITextField!
    
    @IBOutlet weak var btn_accept: UIButton!
    @IBAction func btn_edit(_ sender: Any) {
    }
    @IBOutlet weak var UserImage: UIImageView!
    
    @IBAction func btn_Accept(_ sender: Any) {
    }
    
    @IBAction func btn_cancel(_ sender: Any) {
    }
    @IBOutlet weak var btn_delAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Username_tf.delegate = self
        let userInfo = self.appdelegate?.loadUserInfo()
        username = userInfo?.username ?? ""
        Username_tf.text = username
        btn_accept.isEnabled = false
        Editusernamemodel.idmember = userInfo?.idmember ?? 0
        tapped()
    }
    
    @IBAction func btn_BackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        
//        let userInfo = self.appdelegate?.loadUserInfo()
//        username = userInfo?.username ?? ""
//        Username_tf.text = username
//        return true
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let invalidCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|\"<>,.?/~`")

        let addingusername = (textField.text ?? "") as NSString
        let UpdateUsername = addingusername.replacingCharacters(in: range, with: string)
        if UpdateUsername != username {
            btn_accept.isEnabled = true
            btn_accept.backgroundColor = ._81_C_8_E_4
        }else{
            btn_accept.isEnabled = false
            btn_accept.backgroundColor = .gray
        }
        
        switch textField.text {
        case "":
            btn_accept.backgroundColor = .gray
            btn_accept.isEnabled = false
        default:
            btn_accept.backgroundColor = ._81_C_8_E_4
            btn_accept.isEnabled = true

        }
        if EmojiUtilities.containsEmoji(emoji: string) || ((string.rangeOfCharacter(from: invalidCharacterSet)) != nil) {
            btn_accept.backgroundColor = .gray
            btn_accept.isEnabled = false
            return true
        }else{
            btn_accept.backgroundColor = ._81_C_8_E_4
            btn_accept.isEnabled = true
        }
        
       if UpdateUsername.unicodeScalars.count <= 50 {
           username = UpdateUsername
        }
        
        Editusernamemodel.name = username
        return UpdateUsername.unicodeScalars.count <= 50
        }
    func textFieldDidEndEditing(_ textField: UITextField) {
        username = textField.text ?? ""
        Editusernamemodel.name = username
    }
//    @objc func DelAcount() {
//        let alert = UIAlertController(title: "คุณแน่ใจ ว่าต้องการลบบัญชี ?", message: "", preferredStyle: .alert)
//        let acceptDelAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
////           send tranID to service
//            self.DelAccountData()
//        }
//        let cancelAction = UIAlertAction(title: "ยกเลิก", style: .default) { (action) in
//            self.dismiss(animated: true)
//        }
//        alert.addAction(acceptDelAction)
//        alert.addAction(cancelAction)
//        present(alert, animated: true, completion: nil)
//        
//        }
//    MARK: - Tap
    @objc func DelAcount() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "passcode") as! passcode
        vc.thisState = .delAcount
        self.navigationController?.pushViewController(vc, animated: true)
        }

    @objc func dismisstap(){
        self.view.endEditing(true)
    }
    
    @objc func UpdateUsername(){
        self.UpdateUsernamedata()
    }
    
    func tapped(){
        let DelAccounttap = UITapGestureRecognizer(target: self, action: #selector(DelAcount))
        btn_delAccount.removeGestureRecognizer(UIGestureRecognizer())
        btn_delAccount.addGestureRecognizer(DelAccounttap)
        btn_delAccount.isUserInteractionEnabled = true
        
        let UpdateUsernameTap = UITapGestureRecognizer(target: self, action: #selector(UpdateUsername))
        btn_accept.removeGestureRecognizer(UIGestureRecognizer())
        btn_accept.addGestureRecognizer(UpdateUsernameTap)
        btn_accept.isUserInteractionEnabled = true
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismisstap))
        view.removeGestureRecognizer(UIGestureRecognizer())
        view.addGestureRecognizer(dismissTap)
        view.isUserInteractionEnabled = true
//        let DelAccounttap = UITapGestureRecognizer(target: self, action: #selector(DelAcount))
//        btn_delAccount.removeGestureRecognizer(UIGestureRecognizer())
//        btn_delAccount.addGestureRecognizer(DelAccounttap)
//        btn_delAccount.isUserInteractionEnabled = true
    }

//    MARK: - Api Var
        let apiClient : ApiClient = ApiClient()
        private let disposeBag = DisposeBag()
        
//    MARK: - Api DelAccount
    func DelAccountDataApi() -> Observable<DelAccountResModel> {
        if let userInfo = self.appdelegate?.loadUserInfo() {
            DelAccountemodel.id = userInfo.idmember ?? 0
        }
        return apiClient.requestAPI(ApiRouter.Delete(urlApi: "/api/Incomes/DeleteIncome", param: ["id" : DelAccountemodel.id.convertToString ?? "" ]))
    }
        
        func DelAccountData() {
            self.dispatchGroup?.enter()
            DelAccountDataApi()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resData in
                    
                    print(resData)
                    if resData.success == true {
    //                    print("รายจ่าย add : " + "\(self.createincomedatalistmodel)")
                        self.dispatchGroup?.leave()
                        if resData.data.is_seccess == true {
                            let alert = UIAlertController(title: "ลบบัญชีสำเร็จ", message: "", preferredStyle: .alert)
                            let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                                self.navigationController?.popToViewController(ofClass: Tabbar.self)
                            }
                            alert.addAction(acceptAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        print(resData)

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
    
//    MARK: - Update Api
    func UpdateUsernameAPI(data : EditUsernameModel) -> Observable<EditUsernameRes> {
            return apiClient.requestAPI(ApiRouter.Patch(data: data.convertToData, urlApi:"/api/Members/ResetUsernameAccount"))
        }
            
    func UpdateUsernamedata() {
        print(Editusernamemodel)
        UpdateUsernameAPI(data: Editusernamemodel)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
                print("********* Edit Report : \(resData) ***********")
                if resData.success == true {
                    if resData.data?.is_Reseted == true {
                        let alert = UIAlertController(title: "บันทึกรายการสำเร็จ", message: "", preferredStyle: .alert)
                        let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
//                            UserDefaults.standard.set(self.username, forKey: self.appdelegate?.loadUserInfo().username ?? "")
//                            UserDefaults.standard.synchronize()
                            // บันทึกค่า username ลงใน UserDefaults
                            let UserInfo = self.appdelegate?.loadUserInfo()
                            
                            self.appdelegate?.saveToUserInfo(model: UserInfomationModel.init(idmember: UserInfo?.idmember, username: self.username, phone: UserInfo?.phone, password: UserInfo?.password, image: UserInfo?.image))

                            self.navigationController?.popToViewController(ofClass: Tabbar.self) }
                        alert.addAction(acceptAction)
                        self.present(alert, animated: true, completion: nil)
                    }else {
                        let alert = UIAlertController(title: "บันทึกรายการไม่สำเร็จ", message: "กรุณาลองใหม่อีกครั้ง", preferredStyle: .alert)
                        let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                            self.dismiss(animated: true)}
                        alert.addAction(acceptAction)
                        self.present(alert, animated: true, completion: nil)
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
}
