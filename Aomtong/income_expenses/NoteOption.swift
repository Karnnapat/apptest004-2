//
//  NoteOption.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 9/1/2567 BE.
//

import UIKit

class NoteOption: UIViewController, UITextFieldDelegate {
//  MARK: - var
    var totalnote : ((String) -> Void)?
    var noneNote : String = "ไม่มี"
    var charCount : Int = 0
//    MARK: - weak var
    @IBOutlet weak var textcount: UILabel!
    @IBOutlet weak var note_TF: UITextField!
    @IBOutlet weak var btn_saveNote: UIButton!
    
    public enum stateType {
        case income
        case expenses
    }
 
    var thisState : stateType?
    
//    MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if noneNote == "ไม่มี" {
            noneNote = ""
            note_TF.text = noneNote
        }else{
            note_TF.text = noneNote
        }
        note_TF.delegate = self
        charCount = note_TF.text?.count ?? 0
        charCount = 50 - (note_TF.text?.unicodeScalars.count ?? 0)
        textcount.text = "เหลืออีก " + "\(charCount)" + " ตัวอักษร"

    }
    
    @IBAction func btn_SaveAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        charCount = note_TF.text?.count ?? 0
        charCount = 50 - (note_TF.text?.unicodeScalars.count ?? 0)
        textcount.text = "เหลืออีก " + "\(charCount)" + " ตัวอักษร"
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = noneNote
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let incomenote = (textField.text ?? "") as NSString
        let UpdateNote = incomenote.replacingCharacters(in: range, with: string)
        btn_saveNote.backgroundColor = ._81_C_8_E_4
        let notecount = 50 - UpdateNote.unicodeScalars.count
        
        
        textcount.text = "เหลืออีก " + "\(notecount)" + " ตัวอักษร"
        return UpdateNote.unicodeScalars.count <= 49
        
        }
    func textFieldDidEndEditing(_ textField: UITextField) {
            // นำค่าที่ผู้ใช้ป้อนมาใน textField ไปใช้ต่อหรือเก็บไว้ตามต้องการ
            let finalnote = note_TF.text ?? ""
            noneNote = finalnote
        if noneNote == ""{
            noneNote = "ไม่มี"
        }
        totalnote?(noneNote)
        }
    func addSavenoteAction(handlersavenote: @escaping ((String) -> Void)) {
        totalnote = handlersavenote
    }
    
}
