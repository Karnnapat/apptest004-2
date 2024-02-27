//
//  OTPforgetpinViewController.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 2/1/2567 BE.
//

import UIKit
import RxSwift

class OTPforgetpinViewController: UIViewController, UITextFieldDelegate {
    var countdownTimer: Timer?
    var countdownLabel: UILabel?
    var secondsRemaining = 60
    var countdownAlert: UIAlertController?
    var generatedOTP: String?
    var textFields = [UITextField]()
    var enteredOTP: String?
    
    var codeOTP : String = ""
    var expired : Int = 0
    var countTime : Int = 0
    var refCode : String = ""
    var phonenum : String = ""
    var ComfirmModel = ConfirmOTPModel()
    var phoneModel = phoneNumber()
    var OTPforgetptn = OTPForGetPINModel()
    
    @IBOutlet var lb_resendOTP: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        handleAppBackground()
//        if let firstTextField = textFields.first {
//                   firstTextField.becomeFirstResponder()
//       }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        countdownTimer?.invalidate()
        
        lb_resendOTP.text = "ส่งรหัส OTP อีกครั้ง"
        lb_resendOTP.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countTime = max(self.expired - Int(Date().timeIntervalSince1970), 0)
        lb_resendOTP.text = "กรุณากรอกภายใน " + "\(countTime)" + " วินาที"
        showOTP()
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10

        for _ in 0..<6 {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.textAlignment = .center
            textField.keyboardType = .numberPad
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.FF_8686.cgColor
            textField.layer.cornerRadius = 7.0
            textField.backgroundColor = UIColor.white
            textField.textColor = UIColor.black
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            for textField in textFields {
                textField.addTarget(self, action: #selector(textFieldDidBackspace(_:)), for: .editingChanged)
            }
            stackView.addArrangedSubview(textField)
            textFields.append(textField)
            
            textField.widthAnchor.constraint(equalToConstant: 51).isActive = true
            textField.heightAnchor.constraint(equalToConstant: 51).isActive = true
            
        }

        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 266)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
               view.addGestureRecognizer(tapGesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lb_resendOTP.addGestureRecognizer(tapGestureRecognizer)
        lb_resendOTP.isUserInteractionEnabled = true
    }
    
    @objc func handleAppBackground() {
        for (index, textField) in textFields.enumerated() {
                textField.text = ""
                if index == 0 {
                    textField.becomeFirstResponder()
                }
            }
        
        }

        deinit {
            // ลบ observer เมื่อ UIViewController ถูกทำลาย
            NotificationCenter.default.removeObserver(self)
        }
    
    @objc func handleTap() {
            // ซ่อน keyboard ทุกประการ
            view.endEditing(true)
        }
    
    @objc func labelTapped() {
//        resetCountdownTimer()
//        showAlert()
        OTPforgetPIN()
        lb_resendOTP.isUserInteractionEnabled = false
        }
    
    @IBAction func btn_otpaccept(_ sender: Any) {
//        if let generatedOTP = generatedOTP {
//        enteredOTP = textFields.map { $0.text ?? "" }.joined()
//                if enteredOTP == generatedOTP {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "createpincode") as! createpincode
////                    vc.thisState = .forgetPassword
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    print("OTP ถูกต้อง!")
//                } else {
//                    let alert = UIAlertController(title: "แจ้งเตือน", message: "รหัส OTP ของคุณไม่ถูกต้อง", preferredStyle: .alert)
////                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in self?.handleAppBackground()}))
//                    present(alert, animated: true, completion: nil)
//                    
//                }
//            } else {
//                print("ไม่พบ generatedOTP")
//            }
//        if let enteredOTP = enteredOTP {
//                print("ค่า OTP ที่ผู้ใช้กรอก: \(enteredOTP)")
//            } else {
//                print("ผู้ใช้ยังไม่ได้กรอก OTP")
//            }
        enteredOTP = textFields.map { $0.text ?? "" }.joined()
//        Add to model
        ComfirmModel.otpCode = enteredOTP
        ComfirmModel.refCode = refCode
        ComfirmModel.phone = phonenum
        
        
        ConfirmOTP()
    }
    
    
    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Textfield
        @objc func textFieldDidChange(_ textField: UITextField) {
            guard let currentIndex = textFields.firstIndex(of: textField) else { return }
//            let validNumber = Int(textField.text ?? "") ?? 0
//
//            // หากตัวเลขไม่ถูกต้อง ให้ลบค่าที่กรอก
//            if validNumber < 0 || validNumber > 9 {
//                textField.text = ""
//                return
//            }
//
//            // ทำให้ UITextField ช่องถัดไปเป็น first responder หากมีตัวเลขที่ถูกต้อง
//            if validNumber >= 0 && validNumber <= 9 {
//                if currentIndex < textFields.count - 1 {
//                    textFields[currentIndex + 1].becomeFirstResponder()
//                }
//            }else {
//                handleAppBackground()
//            }
//     
//            if textField.text?.count ?? 0 > 0 {
//                if currentIndex < textFields.count - 1 {
//                    textFields[currentIndex + 1].becomeFirstResponder()
//                }
//            } else {
//                if currentIndex > 0 {
////                    textFields[currentIndex - 1].becomeFirstResponder()
//                    handleAppBackground()
//                }
//            }
            if let text = textField.text, text.count > 1 {
                    textField.text = String(text.prefix(1))
            }
                
                // ทำให้ UITextField ช่องถัดไปเป็น first responder
            if currentIndex < textFields.count - 1 {
                textFields[currentIndex + 1].becomeFirstResponder()
            } else {

            }
            
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)

            return allowedCharacters.isSuperset(of: characterSet)
        }
    
    @objc func textFieldDidBackspace(_ textField: UITextField) {
        guard let currentIndex = textFields.firstIndex(of: textField) else { return }
        
        // ถ้าไม่มีข้อมูลใน TextField และไม่ได้เป็น UITextField ช่องแรก
        if textField.text?.isEmpty == true && currentIndex > 0 {
            // ทำให้ UITextField ก่อนหน้านี้เป็น first responder
            clearAllTextFields()
//            textFields[currentIndex - 1].becomeFirstResponder()
        } else if textField.text?.isEmpty == true && currentIndex == 0 {
            // ถ้าเป็น UITextField ช่องแรกและไม่มีข้อมูลใน TextField
            // ให้ทำการลบข้อมูลทั้งหมด
            clearAllTextFields()
        }
    }
    
    func clearAllTextFields() {
        for textField in textFields {
            textField.text = ""
        }
        // เลือกให้ UITextField ช่องแรกเป็น first responder หากต้องการ
        if let firstTextField = textFields.first {
            firstTextField.becomeFirstResponder()
        }
    }
    
//    MARK: - createOTP
    func showAlert() {
        
            let randomNum1 = Int.random(in: 0..<10)
            let randomNum2 = Int.random(in: 0..<10)
            let randomNum3 = Int.random(in: 0..<10)
            let randomNum4 = Int.random(in: 0..<10)
            let randomNum5 = Int.random(in: 0..<10)
            let randomNum6 = Int.random(in: 0..<10)

        self.generatedOTP = "\(randomNum1)\(randomNum2)\(randomNum3)\(randomNum4)\(randomNum5)\(randomNum6)"
        let alert = UIAlertController(title: "แจ้งเตือน OTP ของคุณ", message: "OTP ของคุณคือ \(self.generatedOTP ?? "")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { 
            [weak self] _ in
               
                self?.countdownAlert?.dismiss(animated: true, completion: nil)
//                self?.resetCountdownTimer()
            }))
        present(alert, animated: true, completion: { [self] in
            // เมื่อ alert แสดงเสร็จ, เรียก resetCountdownTimer และ startCountdownTimer
//            resetCountdownTimer()
            startCountdownTimer(for: alert)

            // รองรับ animation ของการแสดง alert ให้เสร็จสิ้น
            DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                self.countdownAlert?.dismiss(animated: true, completion: nil)
            }
        })
        countdownAlert = alert
        }
//    MARK: - Countdown
            func startCountdownTimer(for alert: UIAlertController) {
            
              countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)

        }
    
        @objc func updateCountdown(_ timer: Timer) {
            if secondsRemaining > 0 {
                secondsRemaining -= 1
                lb_resendOTP.text = "กรุณากรอกภายใน" + " \(secondsRemaining) " + "วินาที"
            } else {
                countdownTimer?.invalidate()
                countdownAlert?.dismiss(animated: true, completion: nil)
                lb_resendOTP.text = "ส่งรหัส OTP อีกครั้ง"

            }
        }
    
    @objc func updateCountdownService() {
//        let dateTime : Date = Date.init(timeIntervalSince1970: expired)
//        var expTime : Int = Int(dateTime.timeIntervalSince1970) % 60
        
        self.countTime = self.countTime - 1
//        let time = (self.expired % 3600) % 60
        if self.countTime > 0 {
            lb_resendOTP.text = "กรุณากรอกภายใน " + "\(countTime)" + " วินาที"
        } else {
            countdownTimer?.invalidate()
//            countdownAlert?.dismiss(animated: true, completion: nil)
            lb_resendOTP.text = "ส่งรหัส OTP อีกครั้ง"
            self.lb_resendOTP.isUserInteractionEnabled = true
        }
    }
    
    func showOTP() {
        //CountDown Expired Time
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownService), userInfo: nil, repeats: true)
        
        let alert = UIAlertController(title: "แจ้งเตือน OTP ของคุณ", message: "OTP ของคุณคือ \(self.codeOTP)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.countdownAlert?.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
        countdownAlert = alert
    }
    
    func resetCountdownTimer() {
        countdownTimer?.invalidate()
        secondsRemaining = 60
    }
    
    //MARK: - AlmoFire API
        let apiClient : ApiClient = ApiClient()
        private let disposeBag = DisposeBag()

        func getDataAPIConfirm(data : ConfirmOTPModel) -> Observable<ComfirmOTPResponse> {
            return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/OTP/ConfirmOTP"))
        }
            
        func ConfirmOTP() {
            getDataAPIConfirm(data: ComfirmModel)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resData in
                    
                    //print(resData)
                    if resData.success == true {
                        if resData.data?.is_Success == true {
                            let storyborad = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyborad.instantiateViewController(identifier: "createpincode") as! createpincode
                            vc.phonesend = self.ComfirmModel.phone
                            vc.thisState = .forgetPassword
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            let alert = UIAlertController(title: "แจ้งเตือน", message: "รหัส OTP ของคุณไม่ถูก", preferredStyle: .alert)
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
    
    func getDataforgetAPI(data : OTPForGetPINModel) -> Observable<OTPForGetPINResponse> {
        return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/OTP/OTPForgotPassword"))
    }
        
    func OTPforgetPIN() {
        OTPforgetptn.phone = phonenum
        getDataforgetAPI(data: OTPforgetptn)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                //print(resData)
                self.codeOTP = resData.data?.codeotp ?? ""
                self.refCode = resData.data?.refCode ?? ""
                self.countTime = max((resData.data?.expired ?? 0) - Int(Date().timeIntervalSince1970), 0)
                self.lb_resendOTP.text = "กรุณากรอกภายใน " + "\(self.countTime)" + " วินาที"
                self.showOTP()
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
