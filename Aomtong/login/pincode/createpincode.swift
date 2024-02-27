//
//  createpincode.swift
//  apptest004
//
//  Created by Karnnapat Kamolwisutthipong on 21/12/2566 BE.
//
//import Security
import UIKit

let serviceName = "com.Aomtung.app.service" // ตั้งชื่อบริการตามที่คุณต้องการ
let accountName = "userPINCode"

class createpincode: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
//  MARK: - var
    let defaults = UserDefaults.standard
    @IBOutlet var digitButtons: [UIButton]!
    @IBOutlet var deleteButtons: [UIButton]!
    var currentPIN: String = ""
    @IBOutlet weak var createpincode_collection: UICollectionView!
    var arrText : [String] = []
    var phonesend : String?
    
    public enum stateType {
        case register
        case changePassword
        case forgetPassword
    }
 
    var thisState : stateType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initcollectionview()
        registercell()
        // ตั้งค่า delegate ของ UITextField
//        pinTextField.delegate = self
        // กำหนด tag ให้กับปุ่มตัวเลข
        for (index, button) in digitButtons.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(digitButtonTapped(_:)), for: .touchUpInside)
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrText = []
//        deletePINFromKeychain()
        createpincode_collection.reloadData()
    }
    
    func registercell(){
        createpincode_collection.register(UINib(nibName: "circlepinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "circlepinCollectionViewCell")
        }
    
    func initcollectionview(){
        
        if createpincode_collection.delegate == nil{
            createpincode_collection.delegate = self
            createpincode_collection.dataSource = self
            createpincode_collection.reloadData()
        }else{
            createpincode_collection.reloadData()
        }
    }
    
    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkAndShowResult(_ pincode : String) {
        if arrText.count == 6 {
            arrText.append(pincode)
            
        if savePIN(pin: arrText.joined()) {
        
            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyborad.instantiateViewController(identifier: "passcode") as! passcode
            UserDefaults.standard.set(arrText.joined(), forKey: "PIN")
            vc.pinnumber = arrText
            vc.phonesend = phonesend
            
            switch self.thisState {
            case .register:
                vc.thisState = .register
                break
            case .forgetPassword:
                vc.thisState = .forgetPassword
                break
            case .changePassword:
                vc.thisState = .changePassword
                break
            default:
                return
            }
//            defaults.set("0001", forKey: "user_id")
            
//            let user_id : String = defaults.object(forKey: "user_id") as? String ?? ""
//            defaults.removeObject(forKey: "user_id")
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Failed to save PIN.")
        }
          
        }
       
        createpincode_collection.reloadData()
    }
    
//    MARK: - ส่งPIN
    
    func checkConditionForNextPage(_ pincode : String) -> Bool {
        
        performSegue(withIdentifier: "createpincode", sender: pincode)

        return true
    }
    
    // MARK: - Action
        
        @objc func digitButtonTapped(_ sender: UIButton) {
            // เพิ่มตัวเลขที่ถูกกดไปยัง PIN textField
            if arrText.count < 6
            {
                arrText.append("\(sender.tag)")
//                pinTextField.text = arrText.joined()
            }
            updateCircleImages(arrText.joined())
            createpincode_collection.reloadData()
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
//        deletePINFromKeychain()
        
        createpincode_collection.reloadData()
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
//    MARK: - Keychain
    
    func savePIN(pin: String) -> Bool {
        
        // กำหนด query สำหรับ Keychain
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName,
            kSecValueData as String: pin.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        SecItemDelete(keychainQuery as CFDictionary)
        
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Failed to save PIN. Status code: \(status)")
        }
        return status == errSecSuccess
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
                return pin
            }
        }

        return nil
    }

//    func deletePINFromKeychain() {
//        // กำหนด query สำหรับ Keychain
//        let keychainQuery: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: serviceName,
//            kSecAttrAccount as String: accountName,
//        ]
//
//        // ลบรหัส PIN จาก Keychain
//        let status = SecItemDelete(keychainQuery as CFDictionary)
//        
//        if status != errSecSuccess {
//            print("Failed to delete PIN from Keychain. Status code: \(status)")
//            // เพิ่มการดำเนินการตามต้องการหากต้องการทำบางอย่างเมื่อไม่สามารถลบได้
//        }
//    }
    
}
