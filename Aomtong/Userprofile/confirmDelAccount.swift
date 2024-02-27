//
//  confirmDelAccount.swift
//  Aomtung
//
//  Created by Karnnapat Kamolwisutthipong on 13/2/2567 BE.
//

import UIKit
import RxSwift

class confirmDelAccount: UIViewController {

    var appdelegate = UIApplication.shared.delegate as? AppDelegate
    var DelAccountemodel = DelModel()
    var dispatchGroup: DispatchGroup?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lb_confimDel.textColor = .E_70000
        lb_subdetail.textColor = .E_70000
        lb_confimDel.text = "   แจ้งให้ทราบ ถ้าคุณลบบัญชีแล้วจะไม่สามารถกู้บัญชีคืนได้"
        
        lb_maindetail.text = "  หากท่านยืนยันที่จะดำเนินการลบบัญชีควรทราบว่ากระบวนการนี้ไม่สามารถย้อนกลับได้โปรดควรพิจารณาอย่างรอบคอบก่อนดำเนินการ" + "\n ท่านจะไม่สามารถกู้คืนบัญชีได้เนื่องจากข้อมูลภายในบัญชีทั้งหมดจะถูกลบหลังจากดำเนินการเสร็จสมบูรณ์แล้วอย่างถาวร "
        lb_subdetail.text = "ท่านต้องการดำเนินการนี้หรือไม่"
    }
    
    @IBAction func btn_ConfirmDelAction(_ sender: Any) {
        let alert = UIAlertController(title: "คุณแน่ใจ ว่าต้องการลบบัญชี ?", message: "", preferredStyle: .alert)
        let acceptDelAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
//           send tranID to service
            self.DelAccountData()
        }
        let cancelAction = UIAlertAction(title: "ยกเลิก", style: .default) { (action) in
            self.dismiss(animated: true)
        }
        alert.addAction(acceptDelAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var lb_confimDel: UILabel!
    
    @IBOutlet weak var lb_maindetail: UILabel!
    
    @IBOutlet weak var lb_subdetail: UILabel!
    
    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: Tabbar.self)
    }
    
    //    MARK: - Api Var
            let apiClient : ApiClient = ApiClient()
            private let disposeBag = DisposeBag()
            
    //    MARK: - Api DelAccount
        func DelAccountDataApi() -> Observable<DelAccountResModel> {
            if let userInfo = self.appdelegate?.loadUserInfo() {
                DelAccountemodel.id = userInfo.idmember ?? 0
            }
            return apiClient.requestAPI(ApiRouter.Delete(urlApi: "/api/Members/DeleteAccount", param: ["id" : DelAccountemodel.id.convertToString ?? "" ]))
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
                                UserDefaults.standard.removeObject(forKey: "isLogin")
                                UserDefaults.standard.removeObject(forKey: "checkpass")
                                UserDefaults.standard.removeObject(forKey: "isFaceIDEnabled")
                                UserDefaults.standard.removeObject(forKey: "userInfo")
                                self.navigationController?.popToViewController(ofClass: Register.self)
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
    
}
