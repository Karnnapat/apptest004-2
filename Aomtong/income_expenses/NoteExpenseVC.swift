//
//  NoteExpenseVC.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 16/1/2567 BE.
//

import UIKit

class NoteExpenseVC: UIViewController, UITextFieldDelegate {
    
    //  MARK: - var
        var totalExpensenote : ((String) -> Void)?
        var ExnoneNote : String = "ไม่มี"
    public enum stateType {
        case income
        case expenses
    }
 
    var thisnoteState : stateType?
    //    MARK: - weak var
        @IBOutlet weak var expensetextcount: UILabel!
        @IBOutlet weak var expensenote_TF: UITextField!
        @IBOutlet weak var btn_saveNote: UIButton!
        
    //    MARK: - lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            if ExnoneNote == "ไม่มี" {
                ExnoneNote = ""
                expensenote_TF.text = ExnoneNote
            }else{
                expensenote_TF.text = ExnoneNote
            }
            expensenote_TF.delegate = self

        }
    @IBAction func btn_SaveAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ExnoneNote
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // ตรวจสอบว่าจำนวนตัวอักษรใน text field ไม่เกิน 10 ตัว
        
            let incomenote = (textField.text ?? "") as NSString
            let UpdateNote = incomenote.replacingCharacters(in: range, with: string)

//        btn_saveNote.backgroundColor = .F_2_A_5_A_3
        let notecount = 50 - UpdateNote.unicodeScalars.count
        
        
        expensetextcount.text = "เหลืออีก " + "\(notecount)" + " ตัวอักษร"
        return UpdateNote.unicodeScalars.count <= 49
        }
    func textFieldDidEndEditing(_ textField: UITextField) {
            // นำค่าที่ผู้ใช้ป้อนมาใน textField ไปใช้ต่อหรือเก็บไว้ตามต้องการ
            let finalnote = expensenote_TF.text ?? ""
        ExnoneNote = finalnote
            if ExnoneNote == ""{
                ExnoneNote = "ไม่มี"
            }
        totalExpensenote?(ExnoneNote)
        }
    func addSaveExnoteAction(handlersaveExnote: @escaping ((String) -> Void)) {
        
        totalExpensenote = handlersaveExnote
    }
}
