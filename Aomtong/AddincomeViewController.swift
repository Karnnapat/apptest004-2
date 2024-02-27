//
//  AddincomeViewController.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 4/1/2567 BE.
//

import UIKit
import RxSwift
import EGPieChart

class AddincomeViewController: UIViewController, UITextFieldDelegate {
//   MARK: - var
    var appdelegate = UIApplication.shared.delegate as? AppDelegate
//    var incomedatatodel : Int? = 0
//    var expensesdatatodel : Int? = 0
    var calendar = Calendar.current
    var datatoDel : AllListReportInSubRes = AllListReportInSubRes()
    var dataIncomeSumlist : InSubReportlistSummarizeRes = InSubReportlistSummarizeRes()
    var dataExpensesSumlist : InSubReportlistSummarizeRes = InSubReportlistSummarizeRes()
    var dataExpensestoDel : AllListReportInSubRes = AllListReportInSubRes()
    var ReDateStr: String?
    var CalculatorAddincome: Double = 0.00
    var CalculatorAddexpen: Double = 0.00
    var selectedType: String?
    var total_fromTF: String?
    var onSelectionComplete: (() -> Void)?
    var IncomeCat: String? = "เลือก"
    var ExpenCat: String? = "เลือก"
    var IncomeNote: String? = "ไม่มี"
    var ExpenNote: String? = "ไม่มี"
    var AutoSaveIncome: String? = "ไม่มี"
    var AutoSaveExpen: String? = "ไม่มี"
    var AutoSaveExpenid: Int? = 0
    var AutoSaveIncomeid: Int? = 0
    var Incometype: String? = "เลือก"
    var expensetype: String? = "เลือก"
    var unixTime : Int = 0
    var dispatchGroup: DispatchGroup?
    var createincomedatalistmodel = CreateDatalistModel()
    var Updateincomemodel = UpdateincomeModel()
    var Updateexpensesmodel = UpdateExpensesModel()
    var Delincomemodel = DelModel()
    var sendreport : ((Any) -> Void)?
    var Autosavemodel : SubAutoSaveRes = SubAutoSaveRes()
    var editdate = Date()
    var checkstate :Bool? = false
    var textfieldcheck :Bool? = false
    public enum stateType {
        case delincome
        case delexpenses
        case Autosaveexpenses
        case Autosaveincome
        case income
        case expenses
    }
 
    var delState : stateType?
    public enum segmentstate {
        case segment0
        case segment1
    }
 
    var segmentState : segmentstate?
//    var getincometypeRes = GetTypeIncomeResponse()

//      MARK: - Outlet
    @IBOutlet weak var lb_SelectedType: UILabel!
    @IBOutlet weak var lb_SelectedCategory: UILabel!
    
    @IBOutlet weak var lb_ShowTital: UILabel!
    @IBOutlet weak var view_Del: UIView!
    @IBOutlet weak var hideorshowline: UIView!
    @IBOutlet weak var btn_DelData: UIButton!
    @IBOutlet weak var btn_Calculator: UIButton!
    @IBOutlet weak var datetimepicker: UIDatePicker!
    @IBOutlet weak var btn_TypeOption: UIButton!
    @IBOutlet weak var lb_SelectedAutoSave: UILabel!
    @IBOutlet weak var lb_NoteAdded: UILabel!
    
    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var img_Asave: UIImageView!
    @IBOutlet weak var AoSOptions: UIImageView!
    @IBOutlet weak var lb_Autosave: UILabel!
    @IBOutlet weak var img_Ots: UIImageView!
    @IBOutlet weak var img_calendar: UIImageView!
    
    @IBOutlet weak var result_TF: UITextField!
    @IBOutlet weak var btn_statusAutosave: UILabel!
    @IBOutlet weak var btn_Category: UIButton!
    @IBOutlet weak var btn_saveincomelist: UIButton!
    @IBOutlet weak var btn_Note: UIButton!
    @IBOutlet weak var btn_SaveAuto: UIButton!
    
    //    MARK: - IBAction
    
    @IBAction func btn_datepickerAction(_ sender: Any) {
       
        
             let selectedDate = datetimepicker.date
             // แปลงเป็น Unix timestamp
             let unixTimestamp = selectedDate.timeIntervalSince1970
         
         let startdate = calendar.date(byAdding: DateComponents(hour: 7),to: datetimepicker.date)
         let startTimeStamp = selectedDate.timeIntervalSince1970
         unixTime = Int(startTimeStamp)
             createincomedatalistmodel.dateCreated = unixTime
         switch delState {
         case .delincome:
             Updateincomemodel.createdateTime = unixTime
         case .delexpenses:
             Updateexpensesmodel.createdateTime = unixTime
         case .Autosaveexpenses:
             Updateexpensesmodel.createdateTime = unixTime
         case .Autosaveincome:
             Updateincomemodel.createdateTime = unixTime
         case .income:
             Updateincomemodel.createdateTime = unixTime
         case .expenses:
             Updateexpensesmodel.createdateTime = unixTime
         default:
             break
         }
            // แสดงผลลัพธ์ (เช่น พิมพ์บน Console)
            print("Selected Date: \(selectedDate)")
            print("Unix Timestamp: \(unixTimestamp)")
//        if delState != .Autosaveexpenses || delState != .Autosaveincome || delState != .delexpenses || delState != .delincome{
//                datetimepicker.minimumDate = Date()
//            }
        myFunction()
        Zerocheck()
        handleDatetimePickerValueChange()
        if self.textfieldcheck == false {
            self.btn_saveincomelist.isEnabled = false
            self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
        }else{
            self.btn_saveincomelist.isEnabled = true
            self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
        }
        }
    
    //    MARK: - convertUnix to String
        func convertUnixTimestampToDateString(timestamp: TimeInterval) -> String {
            // สร้าง Date จาก Unix timestamp
            let date = Date(timeIntervalSince1970: timestamp)

            // กำหนดรูปแบบของวันที่ที่คุณต้องการ
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = "yyyy-MM-dd" // เปลี่ยนรูปแบบตามความต้องการ

            // แปลง Date เป็นสตริงของวันที่
            let dateString = dateFormatter.string(from: date)

            return dateString
        }

    
    func handleDatetimePickerValueChange() {
        let formatdate = DateFormatter()
//        let selectedDate = datetimepicker.date
        switch segment.selectedSegmentIndex {
        case 0:
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
            formatdate.locale = Locale(identifier: "th-TH")
            let selectedDay = formatdate.string(from: datetimepicker.date)
            let editDay = formatdate.string(from: editdate)
//            let ReDate = Double(datatoDel.timestamp ?? 0)
//             ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())

            if selectedDay < DayNow{
               if selectedDay == editDay{
                    self.createincomedatalistmodel.auto_schedule = 1
                    self.btn_statusAutosave.text = "ไม่มี"
                    self.btn_statusAutosave.textColor = .gray
                    self.lb_Autosave.textColor = .gray
                    self.img_Asave.image = UIImage(named: "graysaveauto")
                    self.AoSOptions.image = UIImage(named: "grayopions")
                    btn_SaveAuto.isEnabled = false
                    btn_saveincomelist.isEnabled = false
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
               }else{
                   self.createincomedatalistmodel.auto_schedule = 1
                   self.btn_statusAutosave.text = "ไม่มี"
                   self.btn_statusAutosave.textColor = .gray
                   self.lb_Autosave.textColor = .gray
                   self.img_Asave.image = UIImage(named: "graysaveauto")
                   self.AoSOptions.image = UIImage(named: "grayopions")
                   btn_SaveAuto.isEnabled = false
                   btn_saveincomelist.isEnabled = true
                   btn_saveincomelist.backgroundColor = ._81_C_8_E_4
               }
            }else if selectedDay >= DayNow {
                self.btn_statusAutosave.text = AutoSaveIncome
                self.createincomedatalistmodel.auto_schedule = self.AutoSaveIncomeid
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
                btn_saveincomelist.isEnabled = true
                btn_saveincomelist.backgroundColor = ._81_C_8_E_4
            }else if selectedDay >= DayNow && btn_statusAutosave.text == "ไม่มี" {
                self.btn_statusAutosave.text = AutoSaveIncome
                self.createincomedatalistmodel.auto_schedule = self.AutoSaveIncomeid
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
                btn_saveincomelist.isEnabled = true
                btn_saveincomelist.backgroundColor = ._81_C_8_E_4
            }else{
                self.btn_statusAutosave.text = AutoSaveIncome
                self.createincomedatalistmodel.auto_schedule = self.AutoSaveIncomeid
                self.btn_statusAutosave.textColor = .black
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .black
                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
                btn_saveincomelist.isEnabled = true
                btn_saveincomelist.backgroundColor = ._81_C_8_E_4
            }
//            btn_SaveAuto.isEnabled = true
        case 1:
            segment.selectedSegmentTintColor = .FF_8686
            btn_calculatornoac.backgroundColor = .FF_8686
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
            formatdate.locale = Locale(identifier: "th-TH")
            let selectedDay = formatdate.string(from: datetimepicker.date)
            let DayNow = formatdate.string(from: Date())
            let editDay = formatdate.string(from: editdate)
            if selectedDay < DayNow {
                if selectedDay == editDay{
                     self.createincomedatalistmodel.auto_schedule = 1
                     self.btn_statusAutosave.text = "ไม่มี"
                     self.btn_statusAutosave.textColor = .gray
                     self.lb_Autosave.textColor = .gray
                     self.img_Asave.image = UIImage(named: "graysaveauto")
                     self.AoSOptions.image = UIImage(named: "grayopions")
                     btn_SaveAuto.isEnabled = false
                     btn_saveincomelist.isEnabled = false
                     btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    self.createincomedatalistmodel.auto_schedule = 1
                    self.btn_statusAutosave.text = "ไม่มี"
                    self.btn_statusAutosave.textColor = .gray
                    self.lb_Autosave.textColor = .gray
                    self.img_Asave.image = UIImage(named: "graysaveauto")
                    self.AoSOptions.image = UIImage(named: "grayopions")
                    btn_SaveAuto.isEnabled = false
                    btn_saveincomelist.isEnabled = true
                    btn_saveincomelist.backgroundColor = .FF_8686
                }
            } else if selectedDay >= DayNow {
                self.btn_statusAutosave.text = AutoSaveExpen
                self.createincomedatalistmodel.auto_schedule = self.AutoSaveExpenid
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
                self.btn_statusAutosave.textColor = .black
                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
                btn_saveincomelist.isEnabled  = true
                btn_saveincomelist.backgroundColor = .FF_8686
            }else if selectedDay >= DayNow && btn_statusAutosave.text == "ไม่มี" {
                self.btn_statusAutosave.text = AutoSaveExpen
                self.createincomedatalistmodel.auto_schedule = self.AutoSaveExpenid
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
                self.btn_statusAutosave.textColor = .black
                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
                btn_saveincomelist.isEnabled  = true
                btn_saveincomelist.backgroundColor = .FF_8686
            }else{
                self.btn_statusAutosave.text = AutoSaveExpen
                self.btn_statusAutosave.textColor = .black
                self.createincomedatalistmodel.auto_schedule = self.AutoSaveExpenid
                self.btn_statusAutosave.textColor = .black
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .black
                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
                btn_saveincomelist.isEnabled  = true
                btn_saveincomelist.backgroundColor = .FF_8686
            }
        default:
            break
        }
            myFunction()
            Zerocheck()
        
        }
    
//    MARK: - Back Button
    @IBAction func btn_back(_ sender: Any)
    {
//        let amount = String(datatoDel.amount)
        if btn_saveincomelist.isEnabled == false {
            self.navigationController?.popToViewController(ofClass: Tabbar.self)

        }else if btn_saveincomelist.isEnabled == true{
            switch result_TF.text {
            case "0.0":
                self.navigationController?.popToViewController(ofClass: Tabbar.self)
            case "":
                self.navigationController?.popToViewController(ofClass: Tabbar.self)
            default:
                let alert = UIAlertController(title: "คุณต้องการออกจากหน้านี้ ?", message: "หากคุณต้องการออกจากหน้านี้ การเปลี่ยนแปลงที่คุณทำไปจะไม่ได้รับการบันทึก", preferredStyle: .alert)
                let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                    self.navigationController?.popToViewController(ofClass: Tabbar.self) }
                let cancelAction = UIAlertAction(title: "ยกเลิก", style: .default) { (action) in         self.dismiss(animated: true)
                }
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            }
        }else if btn_saveincomelist.isEnabled == true || result_TF.text == datatoDel.amount || result_TF.text == dataExpensestoDel.amount || result_TF.text == Autosavemodel.amount || result_TF.text == dataIncomeSumlist.amount || result_TF.text == dataExpensesSumlist.amount{
            switch result_TF.text {
            case "0.0":
                self.navigationController?.popToViewController(ofClass: Tabbar.self)
            case "":
                self.navigationController?.popToViewController(ofClass: Tabbar.self)
            default:
//                let alert = UIAlertController(title: "คุณต้องการออกจากหน้านี้ ?", message: "หากคุณต้องการออกจากหน้านี้ การเปลี่ยนแปลงที่คุณทำไปจะไม่ได้รับการบันทึก", preferredStyle: .alert)
//                let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                    self.navigationController?.popToViewController(ofClass: Tabbar.self)
//                }
//                let cancelAction = UIAlertAction(title: "ยกเลิก", style: .default) { (action) in         self.dismiss(animated: true)
//                }
//                alert.addAction(acceptAction)
//                alert.addAction(cancelAction)
//                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    
    @IBAction func total_tf(_ sender: Any) {
        
    }
    
    @IBAction func btn_calculator(_ sender: Any) {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "Calculator") as! Calculator
        self.navigationController?.pushViewController(vc, animated: true)

    }

//    @IBAction func btn_categoryoption(_ sender: Any) {
//        let storyborad = UIStoryboard(name: "Options", bundle: nil)
//        let vc = storyborad.instantiateViewController(identifier: "CategoryVC") as! CategoryVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
//    @IBAction func btn_noteoption(_ sender: Any) {
//        let storyborad = UIStoryboard(name: "Options", bundle: nil)
//        let vc = storyborad.instantiateViewController(identifier: "NoteOption") as! NoteOption
//        
//        if let presentationController = vc.presentationController as? UISheetPresentationController {
//            presentationController.detents = [.custom { context in 400}]
//        }
//        self.present(vc, animated: true)
//    }
    
    @IBOutlet weak var btn_calculatornoac: UIButton!
    
    
//    MARK: - Viewdidload
    override func viewWillDisappear(_ animated: Bool) {
        result_TF.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_saveincomelist.isEnabled = false
        btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
        result_TF.delegate = self
        result_TF.keyboardType = .decimalPad
        datetimepicker.calendar = Calendar(identifier: .gregorian)
        setupSegment()
        GettypeIncome()
        GettypeExpenses()
        GetCategoryIncome()
        GetCategoryExpenses()
        myFunction()
        SaveAutoIncome()
            btn_saveincomelist.isEnabled = true
        if checkstate == true && textfieldcheck == true{
            btn_saveincomelist.backgroundColor = ._81_C_8_E_4
        }else{
            btn_saveincomelist.isEnabled = false
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
        }
        switch delState {
        case .delincome:
            lb_ShowTital.text = "แก้ไข"
            segment.selectedSegmentIndex = 0
            hideorshowline.isHidden =  false
            btn_DelData.isHidden = false
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
//            formatdate.locale = Locale(identifier: "th-TH")
            let ReDate = Double(datatoDel.timestamp ?? 0)
             ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())
            self.btn_statusAutosave.text = self.datatoDel.save_auto_name
            
            result_TF.text = datatoDel.amount
            let deldate = Double(datatoDel.timestamp ?? 0)
            editdate = Date(timeIntervalSince1970: deldate)
            datetimepicker.date = editdate
            
            let dateNowsetup = DateConverter.convertDatetoDayString(date: Date())
            let dateEdit = DateConverter.convertUnixTimestampToDayString(timestamp: deldate)
            
            if self.datatoDel.save_auto_id != 1 && dateNowsetup < dateEdit {
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = false
                self.btn_SaveAuto.isEnabled = false
            }else if ReDateStr! < DayNow && btn_statusAutosave.text == "ไม่มี"{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = false
            } else if ReDateStr! >= DayNow && btn_statusAutosave.text == "ไม่มี" {
                self.btn_statusAutosave.text = datatoDel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = datatoDel.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            } else if ReDateStr! >= DayNow && btn_statusAutosave.text != "ไม่มี" {
                self.btn_statusAutosave.text = datatoDel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = datatoDel.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if self.datatoDel.save_auto_id == 1{
                self.btn_statusAutosave.text = datatoDel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = datatoDel.save_auto_id
                self.btn_statusAutosave.textColor = .black
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if btn_statusAutosave.text != "ไม่มี" && ReDateStr! < DayNow {
                self.btn_statusAutosave.textColor = .gray
                self.lb_Autosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .black
//                datetimepicker.isEnabled = false
                btn_SaveAuto.isEnabled = false
            }else{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = false
                btn_SaveAuto.isEnabled = false
            }
            result_TF.text = self.datatoDel.amount
            Updateincomemodel.income_id = self.datatoDel.transaction_id
            
            if AoSOptions.image == nil{
                AoSOptions.image = UIImage(named: "opions")
            }
        case .delexpenses:
            lb_ShowTital.text = "แก้ไข"
            segment.selectedSegmentIndex = 1
            segment.selectedSegmentTintColor = .FF_8686
            btn_calculatornoac.backgroundColor = .FF_8686
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            hideorshowline.isHidden =  false
            btn_DelData.isHidden = false
            result_TF.text = dataExpensestoDel.amount

            
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
//            formatdate.locale = Locale(identifier: "th-TH")
            
            let ReDate = Double(dataExpensestoDel.timestamp ?? 0)
            ReDateStr = DateConverter.convertUnixTimestampToDayString(timestamp: ReDate)
            let DayNow = DateConverter.convertDatetoDayString(date: Date())
            self.btn_statusAutosave.text = self.dataExpensestoDel.save_auto_name
            if self.dataExpensestoDel.save_auto_id != 1 && ReDateStr! < DayNow {
//                self.datetimepicker.isEnabled = false
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
//                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
                self.btn_SaveAuto.isEnabled = false
            }else if ReDateStr! < DayNow && btn_statusAutosave.text == "ไม่มี" {
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = false
            } else if ReDateStr! >= DayNow && btn_statusAutosave.text == "ไม่มี"{
                self.btn_statusAutosave.text = dataExpensestoDel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = dataExpensestoDel.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "opions")
                self.img_Ots.image = UIImage(named: "opions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if ReDateStr! >= DayNow && btn_statusAutosave.text != "ไม่มี"{
                self.btn_statusAutosave.text = dataExpensestoDel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = dataExpensestoDel.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "opions")
                self.img_Ots.image = UIImage(named: "opions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if self.dataExpensestoDel.save_auto_id == 1{
                self.btn_statusAutosave.text = dataExpensestoDel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = dataExpensestoDel.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "opions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else{
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
//                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
                self.btn_statusAutosave.textColor = .gray
                btn_SaveAuto.isEnabled = false
            }
            if AoSOptions.image == nil{
                AoSOptions.image = UIImage(named: "opions")
            }
            result_TF.text = self.dataExpensestoDel.amount
            Updateexpensesmodel.expenses_id = self.dataExpensestoDel.transaction_id
//            handleDatetimePickerValueChange()
            
        case .Autosaveincome:
            lb_ShowTital.text = "แก้ไข"
            segment.selectedSegmentIndex = 0
            hideorshowline.isHidden =  false
            btn_DelData.isHidden = false
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            result_TF.text = Autosavemodel.amount
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
            let ReDate = Double(Autosavemodel.timestamp ?? 0)
             ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())
            self.btn_statusAutosave.text = self.Autosavemodel.save_auto_name
            if self.Autosavemodel.save_auto_id != 1 && ReDateStr! < DayNow{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
//                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = false
                self.btn_SaveAuto.isEnabled = false
            }else if ReDateStr! < DayNow && btn_statusAutosave.text == "ไม่มี"{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = false
            } else if ReDateStr! >= DayNow && btn_statusAutosave.text == "ไม่มี"{
                self.btn_statusAutosave.text = Autosavemodel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = Autosavemodel.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if ReDateStr! >= DayNow && btn_statusAutosave.text != "ไม่มี"{
                self.btn_statusAutosave.text = Autosavemodel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = Autosavemodel.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if self.Autosavemodel.save_auto_id == 1{
                self.btn_statusAutosave.text = Autosavemodel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = Autosavemodel.save_auto_id
                self.btn_statusAutosave.textColor = .black
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if btn_statusAutosave.text != "ไม่มี" && ReDateStr! < DayNow {
                self.btn_statusAutosave.textColor = .gray
                self.lb_Autosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
//                self.lb_date.textColor = .gray
//                datetimepicker.isEnabled = false
                btn_SaveAuto.isEnabled = false
            }else{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
//                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = false
                btn_SaveAuto.isEnabled = false
            }
            if AoSOptions.image == nil{
                AoSOptions.image = UIImage(named: "opions")
            }
//            handleDatetimePickerValueChange()
//            result_TF.text = self.datatoDel.amount
//            Updateincomemodel.income_id = self.datatoDel.transaction_id
        case .Autosaveexpenses:
            lb_ShowTital.text = "แก้ไข"
            segment.selectedSegmentIndex = 1
            segment.selectedSegmentTintColor = .FF_8686
            btn_calculatornoac.backgroundColor = .FF_8686
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            hideorshowline.isHidden =  false
            btn_DelData.isHidden = false
//            btn_saveincomelist.isEnabled = false
            result_TF.text = Autosavemodel.amount
            
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
//            formatdate.locale = Locale(identifier: "th-TH")
            
            let ReDate = Double(Autosavemodel.timestamp ?? 0)
             ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())
            self.btn_statusAutosave.text = self.Autosavemodel.save_auto_name
            if self.Autosavemodel.save_auto_id != 1 && ReDateStr! < DayNow{
//                self.datetimepicker.isEnabled = false
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
//                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
                self.btn_SaveAuto.isEnabled = false
            }else if ReDateStr! < DayNow && btn_statusAutosave.text == "ไม่มี" {
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = false
            } else if ReDateStr! >= DayNow && btn_statusAutosave.text == "ไม่มี"{
                self.btn_statusAutosave.text = Autosavemodel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = Autosavemodel.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "opions")
                self.img_Ots.image = UIImage(named: "opions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if ReDateStr! >= DayNow && btn_statusAutosave.text != "ไม่มี"{
                self.btn_statusAutosave.text = Autosavemodel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = Autosavemodel.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "opions")
                self.img_Ots.image = UIImage(named: "opions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if self.Autosavemodel.save_auto_id == 1{
                self.btn_statusAutosave.text = Autosavemodel.save_auto_name
                self.createincomedatalistmodel.auto_schedule = Autosavemodel.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "opions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else{
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
//                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
                self.btn_statusAutosave.textColor = .gray
                btn_SaveAuto.isEnabled = false
            }
            if AoSOptions.image == nil{
                AoSOptions.image = UIImage(named: "opions")
            }
//            handleDatetimePickerValueChange()
    case .income:
            lb_ShowTital.text = "แก้ไข"
            segment.selectedSegmentIndex = 0
            hideorshowline.isHidden =  false
            btn_DelData.isHidden = false
            result_TF.text = dataIncomeSumlist.amount
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
//            formatdate.locale = Locale(identifier: "th-TH")
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9

            
            let ReDate = Double(dataIncomeSumlist.timestamp ?? 0)
             ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())
            self.btn_statusAutosave.text = self.dataIncomeSumlist.save_auto_name
            if self.dataIncomeSumlist.save_auto_id != 1 && ReDateStr! < DayNow{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
//                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = false
                self.btn_SaveAuto.isEnabled = false
            }else if ReDateStr! < DayNow && btn_statusAutosave.text == "ไม่มี"{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = false
            } else if ReDateStr! >= DayNow && btn_statusAutosave.text == "ไม่มี"{
                self.btn_statusAutosave.text = dataIncomeSumlist.save_auto_name
                self.createincomedatalistmodel.auto_schedule = dataIncomeSumlist.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if ReDateStr! >= DayNow && btn_statusAutosave.text != "ไม่มี"{
                self.btn_statusAutosave.text = dataIncomeSumlist.save_auto_name
                self.createincomedatalistmodel.auto_schedule = dataIncomeSumlist.save_auto_id
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.btn_statusAutosave.textColor = .black
                self.lb_Autosave.textColor = .black
                self.lb_date.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if self.datatoDel.save_auto_id == 1{
                self.btn_statusAutosave.text = dataIncomeSumlist.save_auto_name
                self.createincomedatalistmodel.auto_schedule = dataIncomeSumlist.save_auto_id
                self.btn_statusAutosave.textColor = .black
                self.img_Asave.image = UIImage(named: "Save")
                self.AoSOptions.image = UIImage(named: "options")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "opions")
                self.lb_date.textColor = .black
                self.lb_Autosave.textColor = .black
//                datetimepicker.isEnabled = true
                btn_SaveAuto.isEnabled = true
            }else if btn_statusAutosave.text != "ไม่มี" && ReDateStr! < DayNow {
                self.btn_statusAutosave.textColor = .gray
                self.lb_Autosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
//                self.lb_date.textColor = .gray
//                datetimepicker.isEnabled = false
                
                btn_SaveAuto.isEnabled = false
            }else{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "datetime")
                self.img_Ots.image = UIImage(named: "grayopions")
//                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = false
                btn_SaveAuto.isEnabled = false
            }
            if AoSOptions.image == nil{
                AoSOptions.image = UIImage(named: "opions")
            }
            Updateincomemodel.income_id = self.dataIncomeSumlist.transaction_id ?? 0
    case .expenses:
            result_TF.text = dataExpensesSumlist.amount
                    lb_ShowTital.text = "แก้ไข"
                    segment.selectedSegmentIndex = 1
                    segment.selectedSegmentTintColor = .FF_8686
                    btn_calculatornoac.backgroundColor = .FF_8686
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    hideorshowline.isHidden =  false
                    btn_DelData.isHidden = false
                    
                    let formatdate = DateFormatter()
                    formatdate.dateFormat = "yyyy-MM-dd"
                    formatdate.calendar = Calendar(identifier: .gregorian)
        //            formatdate.locale = Locale(identifier: "th-TH")
                    
                    let ReDate = Double(dataExpensesSumlist.timestamp ?? 0)
                     ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
                    let DayNow = formatdate.string(from: Date())
                    self.btn_statusAutosave.text = self.dataExpensesSumlist.save_auto_name
                    if self.dataExpensesSumlist.save_auto_id != 1 && ReDateStr! < DayNow {
                        self.datetimepicker.isEnabled = false
                        self.btn_statusAutosave.textColor = .gray
                        self.img_Asave.image = UIImage(named: "graysaveauto")
                        self.AoSOptions.image = UIImage(named: "grayopions")
                        self.img_calendar.image = UIImage(named: "datetime")
                        self.img_Ots.image = UIImage(named: "grayopions")
//                        self.lb_date.textColor = .gray
                        self.lb_Autosave.textColor = .gray
                        self.btn_SaveAuto.isEnabled = false
                    }else if ReDateStr! < DayNow && btn_statusAutosave.text == "ไม่มี" {
                        self.btn_statusAutosave.textColor = .gray
                        self.img_Asave.image = UIImage(named: "graysaveauto")
                        self.AoSOptions.image = UIImage(named: "grayopions")
                        self.img_calendar.image = UIImage(named: "datetime")
                        self.img_Ots.image = UIImage(named: "opions")
                        self.lb_date.textColor = .black
                        self.lb_Autosave.textColor = .gray
//                        datetimepicker.isEnabled = true
                        btn_SaveAuto.isEnabled = false
                    } else if ReDateStr! >= DayNow && btn_statusAutosave.text == "ไม่มี"{
                        self.btn_statusAutosave.text = dataExpensesSumlist.save_auto_name
                        self.createincomedatalistmodel.auto_schedule = dataExpensesSumlist.save_auto_id
                        self.img_Asave.image = UIImage(named: "Save")
                        self.AoSOptions.image = UIImage(named: "opions")
                        self.img_Ots.image = UIImage(named: "opions")
                        self.img_calendar.image = UIImage(named: "datetime")
                        self.lb_Autosave.textColor = .black
                        self.lb_date.textColor = .black
                        self.btn_statusAutosave.textColor = .black
                        self.lb_Autosave.textColor = .black
//                        datetimepicker.isEnabled = true
                        btn_SaveAuto.isEnabled = true
                    }else if ReDateStr! >= DayNow && btn_statusAutosave.text != "ไม่มี"{
                        self.btn_statusAutosave.text = dataExpensesSumlist.save_auto_name
                        self.createincomedatalistmodel.auto_schedule = dataExpensesSumlist.save_auto_id
                        self.img_Asave.image = UIImage(named: "Save")
                        self.AoSOptions.image = UIImage(named: "opions")
                        self.img_Ots.image = UIImage(named: "opions")
                        self.img_calendar.image = UIImage(named: "datetime")
                        self.lb_Autosave.textColor = .black
                        self.lb_date.textColor = .black
                        self.btn_statusAutosave.textColor = .black
                        self.lb_Autosave.textColor = .black
//                        datetimepicker.isEnabled = true
                        btn_SaveAuto.isEnabled = true
                    }else if self.dataIncomeSumlist.save_auto_id == 1{
                        self.btn_statusAutosave.text = dataExpensesSumlist.save_auto_name
                        self.createincomedatalistmodel.auto_schedule = dataExpensesSumlist.save_auto_id
                        self.img_Asave.image = UIImage(named: "Save")
                        self.AoSOptions.image = UIImage(named: "opions")
                        self.img_calendar.image = UIImage(named: "datetime")
                        self.img_Ots.image = UIImage(named: "opions")
                        self.btn_statusAutosave.textColor = .black
                        self.lb_Autosave.textColor = .black
                        self.lb_date.textColor = .black
//                        datetimepicker.isEnabled = true
                        btn_SaveAuto.isEnabled = true
                    }else{
                        self.img_Asave.image = UIImage(named: "graysaveauto")
                        self.AoSOptions.image = UIImage(named: "grayopions")
                        self.img_calendar.image = UIImage(named: "datetime")
                        self.img_Ots.image = UIImage(named: "grayopions")
//                        self.lb_date.textColor = .gray
                        self.lb_Autosave.textColor = .gray
                        self.btn_statusAutosave.textColor = .gray
                        btn_SaveAuto.isEnabled = false
                    }
            if AoSOptions.image == nil{
                AoSOptions.image = UIImage(named: "opions")
            }
//            result_TF.text = self.dataExpensestoDel.amount
//            Updateexpensesmodel.expenses_id = self.dataExpensestoDel.transaction_id
//            handleDatetimePickerValueChange()
        default:
            result_TF.text = "0.00"
            lb_ShowTital.text = "เพิ่มรายการ"
            segment.selectedSegmentIndex = 0
            view_Del.isHidden = true
            hideorshowline.isHidden =  true
            btn_DelData.isHidden = true
            if AoSOptions.image == nil{
                AoSOptions.image = UIImage(named: "opions")
            }
//            handleDatetimePickerValueChange()
        }
        if AoSOptions.image == nil{
            AoSOptions.image = UIImage(named: "AutoOption")
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        AllTap()
        myFunction()
        Zerocheck()
        if segment.selectedSegmentIndex == 0{
            if checkstate == true && textfieldcheck == true{
                btn_saveincomelist.isEnabled = true
                btn_saveincomelist.backgroundColor = ._81_C_8_E_4
            }else{
                btn_saveincomelist.isEnabled = false
                btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            }
        }else{
            if checkstate == true && textfieldcheck == true{
                btn_saveincomelist.isEnabled = true
                btn_saveincomelist.backgroundColor = .FF_8686
            }else{
                btn_saveincomelist.isEnabled = false
                btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            }
        }
        
        self.navigationItem.hidesBackButton = true

    }
    
    
    // MARK: - segment
    func setupSegment() {
       
        btn_saveincomelist.isEnabled = false
        switch delState {
        case .delincome:
            segment.selectedSegmentIndex = 0
            segment.selectedSegmentTintColor = ._81_C_8_E_4
            btn_calculatornoac.backgroundColor = ._81_C_8_E_4
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            segment.isEnabled = false
            if segment.selectedSegmentIndex == 0{
                result_TF.text = datatoDel.amount
                let deldate = Double(datatoDel.timestamp ?? 0)
                editdate = Date(timeIntervalSince1970: deldate)
                datetimepicker.date = editdate
                self.lb_SelectedType.text = self.datatoDel.type_name
                self.lb_SelectedCategory.text = self.datatoDel.category_name
                if self.datatoDel.description != ""{
                    self.lb_NoteAdded.text = self.datatoDel.description
                }else{
                    self.lb_NoteAdded.text = "ไม่มี"
                }
                if self.datatoDel.save_auto_name != ""{
                    
                    self.AutoSaveIncome = self.datatoDel.save_auto_name
                    AutoSaveIncomeid = self.datatoDel.save_auto_id
                    createincomedatalistmodel.auto_schedule = self.datatoDel.save_auto_id
                }else{
                    self.AutoSaveIncome = "ไม่มี"
                }
//                Updateincomemodel.amount = CalculatorAddincome
                Updateincomemodel.createdateTime = self.datatoDel.timestamp ?? 0
                IncomeTap()
                if AoSOptions.image == nil{
                    AoSOptions.image = UIImage(named: "opions")
                }
                btn_savecheck()
            }
//            handleDatetimePickerValueChange()
        case .delexpenses :
            segment.selectedSegmentTintColor = .FF_8686
            btn_calculatornoac.backgroundColor = .FF_8686
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            segment.selectedSegmentIndex = 1
            segment.isEnabled = false
            if segment.selectedSegmentIndex == 1{
                result_TF.text = dataExpensestoDel.amount
            let deldate = Double(dataExpensestoDel.timestamp ?? 0)
            editdate = Date(timeIntervalSince1970: deldate)
            datetimepicker.date = editdate
            self.lb_SelectedType.text = self.dataExpensestoDel.type_name
            self.lb_SelectedCategory.text = self.dataExpensestoDel.category_name
            if self.dataExpensestoDel.description != ""{
                self.lb_NoteAdded.text = self.dataExpensestoDel.description
            }else{
                self.lb_NoteAdded.text = "ไม่มี"
            }
            if self.dataExpensestoDel.save_auto_name != ""{
                self.AutoSaveExpen = self.dataExpensestoDel.save_auto_name
                AutoSaveExpenid = self.dataExpensestoDel.save_auto_id
                createincomedatalistmodel.auto_schedule = self.AutoSaveExpenid
            }else{
                self.btn_statusAutosave.text = "ไม่มี"
            }
                if createincomedatalistmodel.idcategory == 0{
                    createincomedatalistmodel.idcategory = dataExpensestoDel.category_id ?? 15
                }
                if createincomedatalistmodel.idtype == 0 {
                    createincomedatalistmodel.idtype = dataExpensestoDel.type_id ?? 12
                }
//            Updateexpensesmodel.amount = CalculatorAddexpen
            Updateexpensesmodel.createdateTime = self.dataExpensestoDel.timestamp ?? 0
//            result_TF.text = self.dataExpensestoDel.amount
            ExpenseTap()
            if AoSOptions.image == nil{
                AoSOptions.image = UIImage(named: "opions")
            }
            btn_savecheck()
        }
            
//            handleDatetimePickerValueChange()
        case .Autosaveincome:
            segment.selectedSegmentIndex = 0
            segment.selectedSegmentTintColor = ._81_C_8_E_4
            btn_calculatornoac.backgroundColor = ._81_C_8_E_4
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            segment.isEnabled = false
            if segment.selectedSegmentIndex == 0{
                result_TF.text = self.Autosavemodel.amount
//                self.CalculatorAddincome = Double(self.Autosavemodel.amount ?? "") ?? 0.00
                let deldate = Double(Autosavemodel.timestamp ?? 0)
                let date = Date(timeIntervalSince1970: deldate)
                datetimepicker.date = date
                self.lb_SelectedType.text = self.Autosavemodel.type_name
                self.lb_SelectedCategory.text = self.Autosavemodel.category_name
                createincomedatalistmodel.idcategory = self.Autosavemodel.category_id
                createincomedatalistmodel.idtype = self.Autosavemodel.type_id
                if self.Autosavemodel.description != ""{
                    self.lb_NoteAdded.text = self.Autosavemodel.description
                }else{
                    self.lb_NoteAdded.text = "ไม่มี"
                }
                createincomedatalistmodel.description =  self.lb_NoteAdded.text
                if self.Autosavemodel.save_auto_name != ""{
                    self.AutoSaveIncome = self.Autosavemodel.save_auto_name
                    AutoSaveIncomeid = self.Autosavemodel.save_auto_id
                    self.createincomedatalistmodel.auto_schedule = self.Autosavemodel.save_auto_id
                }else{
                    self.AutoSaveIncome = "ไม่มี"
                    createincomedatalistmodel.auto_schedule = 1
                }
//                Updateincomemodel.amount = CalculatorAddincome
                Updateincomemodel.createdateTime = self.Autosavemodel.timestamp ?? 0
                IncomeTap()
                if AoSOptions.image == nil{
                    AoSOptions.image = UIImage(named: "opions")
                }
                btn_savecheck()
            }
//            handleDatetimePickerValueChange()
        case .Autosaveexpenses:
            segment.selectedSegmentTintColor = .FF_8686
            btn_calculatornoac.backgroundColor = .FF_8686
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            segment.selectedSegmentIndex = 1
            segment.isEnabled = false
            if segment.selectedSegmentIndex == 1{
            result_TF.text = self.Autosavemodel.amount
            let deldate = Double(Autosavemodel.timestamp ?? 0)
            let date = Date(timeIntervalSince1970: deldate)
            datetimepicker.date = date
            self.lb_SelectedType.text = self.Autosavemodel.type_name
            self.lb_SelectedCategory.text = self.Autosavemodel.category_name
            createincomedatalistmodel.idcategory = self.Autosavemodel.category_id
            createincomedatalistmodel.idtype = self.Autosavemodel.type_id
            if self.Autosavemodel.description != ""{
                self.lb_NoteAdded.text = self.Autosavemodel.description
            }else{
                self.lb_NoteAdded.text = "ไม่มี"
            }
            createincomedatalistmodel.description =  self.lb_NoteAdded.text
            if self.Autosavemodel.save_auto_name != ""{
                self.AutoSaveExpen = self.Autosavemodel.save_auto_name
                AutoSaveExpenid = self.Autosavemodel.save_auto_id
                self.createincomedatalistmodel.auto_schedule = self.Autosavemodel.save_auto_id

            }else{
                self.btn_statusAutosave.text = "ไม่มี"
                createincomedatalistmodel.auto_schedule = 1
            }
                if createincomedatalistmodel.idcategory == 0{
                    createincomedatalistmodel.idcategory = Autosavemodel.category_id ?? 15
                }
                if createincomedatalistmodel.idtype == 0 {
                    createincomedatalistmodel.idtype = Autosavemodel.type_id ?? 12
                }
//            Updateexpensesmodel.amount = CalculatorAddexpen
            Updateexpensesmodel.createdateTime = self.Autosavemodel.timestamp ?? 0
//            result_TF.text = self.dataExpensestoDel.amount
            ExpenseTap()
            if AoSOptions.image == nil{
                AoSOptions.image = UIImage(named: "opions")
            }
            btn_savecheck()
        }
//            handleDatetimePickerValueChange()
    case .income:
            segment.selectedSegmentTintColor = ._81_C_8_E_4
            btn_calculatornoac.backgroundColor = ._81_C_8_E_4
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            segment.selectedSegmentIndex = 0
            segment.isEnabled = false
            if segment.selectedSegmentIndex == 0{
                result_TF.text = self.dataIncomeSumlist.amount
                let deldate = Double(dataIncomeSumlist.timestamp ?? 0)
                let date = Date(timeIntervalSince1970: deldate)
                datetimepicker.date = date
                self.lb_SelectedType.text = self.dataIncomeSumlist.type_name
                self.lb_SelectedCategory.text = self.dataIncomeSumlist.category_name
                createincomedatalistmodel.idcategory = self.dataIncomeSumlist.category_id
                createincomedatalistmodel.idtype = self.dataIncomeSumlist.type_id
                if self.dataIncomeSumlist.description != ""{
                    self.lb_NoteAdded.text = self.dataIncomeSumlist.description
                }else{
                    self.lb_NoteAdded.text = "ไม่มี"
                }
                createincomedatalistmodel.description =  self.lb_NoteAdded.text
                if self.dataIncomeSumlist.save_auto_name != ""{
                    self.AutoSaveExpen = self.dataIncomeSumlist.save_auto_name
                    AutoSaveExpenid = self.dataIncomeSumlist.save_auto_id
                    self.createincomedatalistmodel.auto_schedule = self.dataIncomeSumlist.save_auto_id

                }else{
                    self.btn_statusAutosave.text = "ไม่มี"
                    createincomedatalistmodel.auto_schedule = 1
                }
                    if createincomedatalistmodel.idcategory == 0{
                        createincomedatalistmodel.idcategory = dataIncomeSumlist.category_id ?? 15
                    }
                    if createincomedatalistmodel.idtype == 0 {
                        createincomedatalistmodel.idtype = dataIncomeSumlist.type_id ?? 12
                    }
    //            Updateexpensesmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.createdateTime = self.dataIncomeSumlist.timestamp ?? 0
    //            result_TF.text = self.dataExpensestoDel.amount
                IncomeTap()
                if AoSOptions.image == nil{
                    AoSOptions.image = UIImage(named: "opions")
                }
                btn_savecheck()
            }
//            handleDatetimePickerValueChange()
    case .expenses:
                segment.selectedSegmentTintColor = .FF_8686
                btn_calculatornoac.backgroundColor = .FF_8686
                btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                segment.selectedSegmentIndex = 1
                segment.isEnabled = false
                if segment.selectedSegmentIndex == 1{
                result_TF.text = self.dataExpensesSumlist.amount
                let deldate = Double(dataExpensesSumlist.timestamp ?? 0)
                let date = Date(timeIntervalSince1970: deldate)
                datetimepicker.date = date
                self.lb_SelectedType.text = self.dataExpensesSumlist.type_name
                self.lb_SelectedCategory.text = self.dataExpensesSumlist.category_name
                createincomedatalistmodel.idcategory = self.dataExpensesSumlist.category_id
                createincomedatalistmodel.idtype = self.dataExpensesSumlist.type_id
                if self.dataExpensesSumlist.description != ""{
                    self.lb_NoteAdded.text = self.dataExpensesSumlist.description
                }else{
                    self.lb_NoteAdded.text = "ไม่มี"
                }
                createincomedatalistmodel.description =  self.lb_NoteAdded.text
                if self.dataExpensesSumlist.save_auto_name != ""{
                    self.AutoSaveExpen = self.dataExpensesSumlist.save_auto_name
                    AutoSaveExpenid = self.dataExpensesSumlist.save_auto_id
                    self.createincomedatalistmodel.auto_schedule = self.dataExpensesSumlist.save_auto_id

                }else{
                    self.btn_statusAutosave.text = "ไม่มี"
                    createincomedatalistmodel.auto_schedule = 1
                }
                    if createincomedatalistmodel.idcategory == 0{
                        createincomedatalistmodel.idcategory = dataExpensesSumlist.category_id ?? 15
                    }
                    if createincomedatalistmodel.idtype == 0 {
                        createincomedatalistmodel.idtype = dataExpensesSumlist.type_id ?? 12
                    }
    //            Updateexpensesmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.createdateTime = self.dataExpensesSumlist.timestamp ?? 0
    //            result_TF.text = self.dataExpensestoDel.amount
                ExpenseTap()
                if AoSOptions.image == nil{
                    AoSOptions.image = UIImage(named: "opions")
                }
                btn_savecheck()
            }
//            handleDatetimePickerValueChange()
        default:
            segment.selectedSegmentTintColor = ._81_C_8_E_4
            btn_calculatornoac.backgroundColor = ._81_C_8_E_4
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            segment.selectedSegmentIndex = 0
            self.lb_SelectedType.text = self.Incometype
            self.lb_SelectedCategory.text = self.IncomeCat
            self.lb_NoteAdded.text = self.IncomeNote
            self.btn_statusAutosave.text = self.AutoSaveIncome
            let result = String(CalculatorAddincome)
            result_TF.text = result
            IncomeTap()
            if AoSOptions.image == nil{
                AoSOptions.image = UIImage(named: "opions")
            }
//            handleDatetimePickerValueChange()
            btn_savecheck()
        }
        
    }
    
    @IBAction func didchangesegment(_ sender: UISegmentedControl) {
        myFunction()
        Zerocheck()
//        switch segmentState {
//        case .segment0:
//            segment.selectedSegmentIndex = 0
//            segment.selectedSegmentTintColor = ._81_C_8_E_4
//            if checkstate == true && textfieldcheck == true{
//                btn_saveincomelist.isEnabled = true
//                btn_saveincomelist.backgroundColor = ._81_C_8_E_4
//            }else{
//                btn_saveincomelist.isEnabled = false
//                btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//            }
//        case .segment1:
//            segment.selectedSegmentIndex = 1
//            segment.selectedSegmentTintColor = .FF_8686
//                if checkstate == true && textfieldcheck == true{
//                    btn_saveincomelist.isEnabled = true
//                    btn_saveincomelist.backgroundColor = .FF_8686
//                }else{
//                    btn_saveincomelist.isEnabled = false
//                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                }
//            
//        default:
//            if segment.selectedSegmentIndex == 0{
//                segment.selectedSegmentTintColor = ._81_C_8_E_4
//                if checkstate == true && textfieldcheck == true{
//                    btn_saveincomelist.isEnabled = true
//                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
//                }else{
//                    btn_saveincomelist.isEnabled = false
//                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                }
//            }else{
//                segment.selectedSegmentTintColor = .FF_8686
//                if checkstate == true && textfieldcheck == true{
//                    btn_saveincomelist.isEnabled = true
//                    btn_saveincomelist.backgroundColor = .FF_8686
//                }else{
//                    btn_saveincomelist.isEnabled = false
//                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                }
//            }
//        }
        switch delState {
        case .delincome:
            setupSegment()
        case .delexpenses:
            setupSegment()
        case .Autosaveexpenses:
            setupSegment()
        case .Autosaveincome:
            setupSegment()
        case .income:
            setupSegment()
        case .expenses:
            setupSegment()
        default:
            if self.lb_SelectedCategory.text == "เลือก" && self.lb_SelectedType.text == "เลือก" || self.result_TF.text == "0.00" || self.result_TF.text == "0.0" || self.result_TF.text == "0"{
                if segment.selectedSegmentIndex == 0{
                    segment.selectedSegmentTintColor = ._81_C_8_E_4
                    btn_calculatornoac.backgroundColor = ._81_C_8_E_4
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    
                    self.lb_SelectedType.text = self.Incometype
                    self.lb_SelectedCategory.text = self.IncomeCat
                    self.lb_NoteAdded.text = self.IncomeNote
                    self.btn_statusAutosave.text = self.AutoSaveIncome
                    let result = String(CalculatorAddincome)
                    result_TF.text = result
                    IncomeTap()
                    btn_saveincomelist.isEnabled = false
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    btn_savecheck()
                }else{
                    segment.selectedSegmentTintColor = .FF_8686
                    btn_calculatornoac.backgroundColor = .FF_8686
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    btn_saveincomelist.isEnabled = false
                    self.lb_SelectedType.text = self.expensetype
                    self.lb_SelectedCategory.text = self.ExpenCat
                    self.lb_NoteAdded.text = self.ExpenNote
                    self.btn_statusAutosave.text = self.AutoSaveExpen
                    let result = String(CalculatorAddexpen)
                    result_TF.text = result
                    ExpenseTap()
                    btn_savecheck()
                }
            }else{
                if segment.selectedSegmentIndex == 0 || segmentState == .segment0 {
                    segment.selectedSegmentTintColor = ._81_C_8_E_4
                    btn_calculatornoac.backgroundColor = ._81_C_8_E_4
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                    btn_saveincomelist.isEnabled = true
                    self.lb_SelectedType.text = self.Incometype
                    self.lb_SelectedCategory.text = self.IncomeCat
                    self.lb_NoteAdded.text = self.IncomeNote
                    self.btn_statusAutosave.text = self.AutoSaveIncome
                    let result = String(CalculatorAddincome)
                    result_TF.text = result
                    IncomeTap()
                    btn_savecheck()
                    
                }else if segment.selectedSegmentIndex == 1 || segmentState == .segment1{
                    segment.selectedSegmentTintColor = .FF_8686
                    btn_calculatornoac.backgroundColor = .FF_8686
                    btn_saveincomelist.backgroundColor = .FF_8686
                    btn_saveincomelist.isEnabled = true
                    self.lb_SelectedType.text = self.expensetype
                    self.lb_SelectedCategory.text = self.ExpenCat
                    self.lb_NoteAdded.text = self.ExpenNote
                    self.btn_statusAutosave.text = self.AutoSaveExpen
                    let result = String(CalculatorAddexpen)
                    result_TF.text = result
                    ExpenseTap()
                    btn_savecheck()
                    
                }
            }
        }
//        
//            
//            switch delState {
//            case .delincome:
//                segment.selectedSegmentIndex = 0
//            case .delexpenses :
//                segment.selectedSegmentIndex = 1
//            case .Autosaveincome:
//                segment.selectedSegmentIndex = 0
//            case .Autosaveexpenses:
//                segment.selectedSegmentIndex = 1
//            case .income:
//                segment.selectedSegmentIndex = 1
//            case .expenses:
//                segment.selectedSegmentIndex = 1
//            default:
                
//                if segment.selectedSegmentIndex == 0{
//                    segment.selectedSegmentTintColor = ._81_C_8_E_4
//                    btn_calculatornoac.backgroundColor = ._81_C_8_E_4
//                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                    self.lb_SelectedType.text = self.Incometype
//                    self.lb_SelectedCategory.text = self.IncomeCat
//                    self.lb_NoteAdded.text = self.IncomeNote
//                    self.btn_statusAutosave.text = self.AutoSaveIncome
//                    let result = String(CalculatorAddincome)
//                    result_TF.text = result
//                    if result_TF.text != "0.0" && result_TF.text != "0.00" && result_TF.text != "0" && result_TF.text != "" {
//                        btn_saveincomelist.backgroundColor = ._81_C_8_E_4
//                        btn_saveincomelist.isEnabled = true
//            //            createincomedatalistmodel.amount = CalculatorAddincome
//                    }else{
//                        btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                        btn_saveincomelist.isEnabled = false
//                    }
//                    IncomeTap()
//                }else if segment.selectedSegmentIndex == 1{
//                    segment.selectedSegmentTintColor = .FF_8686
//                    btn_calculatornoac.backgroundColor = .FF_8686
//                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                    self.lb_SelectedType.text = self.expensetype
//                    self.lb_SelectedCategory.text = self.ExpenCat
//                    self.lb_NoteAdded.text = self.ExpenNote
//                    self.btn_statusAutosave.text = self.AutoSaveExpen
//                    let result = String(CalculatorAddexpen)
//                    result_TF.text = result
//                    if result_TF.text != "0.0" && result_TF.text != "0.00" && result_TF.text != "0" && result_TF.text != "" {
//                        btn_saveincomelist.backgroundColor = .FF_8686
//                        btn_saveincomelist.isEnabled = true
//            //            createincomedatalistmodel.amount = CalculatorAddincome
//                    }else{
//                        btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                        btn_saveincomelist.isEnabled = false
//                    }
//                    ExpenseTap()
//                }
//                break
//            }
            return
    }
    
//    MARK: - func Get data
    
    @objc func handleTap() {
            view.endEditing(true)
            
        myFunction()
        Zerocheck()
        if checkstate == false && textfieldcheck == false{
            btn_saveincomelist.isEnabled = false
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
        }else if checkstate == true && textfieldcheck == false{
            btn_saveincomelist.isEnabled = false
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
        }else if checkstate == false && textfieldcheck == true {
            btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            btn_saveincomelist.isEnabled = false
        }else{
            btn_saveincomelist.isEnabled = true
            if segment.selectedSegmentIndex == 0{
                btn_saveincomelist.backgroundColor = ._81_C_8_E_4
            }else{
                btn_saveincomelist.backgroundColor = .FF_8686
            }
        }

        }
    @objc func CategoryTap() {
        result_TF.endEditing(true)
       
        let storyborad = UIStoryboard(name: "Options", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "CategoryVC") as! CategoryVC
        if self.textfieldcheck == false {
            self.btn_saveincomelist.isEnabled = false
            self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
        }else{
            self.btn_saveincomelist.isEnabled = true
            self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
        }
        vc.getIncomeCat = self.getincomeCatRes
        vc.addCatIncomeAction(handlerIncomeCat: {Catincome in
            self.IncomeCat = Catincome.category
            self.lb_SelectedCategory.text = Catincome.category
            self.createincomedatalistmodel.idcategory = Catincome.id
            switch self.delState {
            case .delincome:
                self.handleDatetimePickerValueChange()
                self.Updateincomemodel.category_id =  self.createincomedatalistmodel.idcategory ?? 0
                if self.Updateincomemodel.category_id != self.datatoDel.category_id && self.textfieldcheck == true {
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
                
            case .delexpenses:
                break
            case .Autosaveexpenses:
                break
            case .Autosaveincome:
                self.Updateincomemodel.category_id =  self.createincomedatalistmodel.idcategory ?? 0
                if self.Updateincomemodel.category_id != self.Autosavemodel.category_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .income:
                self.Updateincomemodel.category_id =  self.createincomedatalistmodel.idcategory ?? 0
                if self.Updateincomemodel.category_id != self.dataIncomeSumlist.category_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            default:
                self.createincomedatalistmodel.idcategory = Catincome.id
            }
            if self.lb_SelectedCategory.text != "เลือก" {
                self.lb_SelectedCategory.textColor = .black
            }

        })
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        }
    @objc func ExpenseCategoryTap() {
        result_TF.endEditing(true)
        let storyborad = UIStoryboard(name: "Options", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "ExpenseCategoryVC") as! ExpenseCategoryVC
        vc.CatExpenses = self.getexpensesCatRes
        vc.addCatExpenAction(handlerExpenCat: {Catexpense in
            self.ExpenCat = Catexpense.category
            self.lb_SelectedCategory.text = Catexpense.category
            self.createincomedatalistmodel.idcategory = Catexpense.id
            switch self.delState {
            case .delincome:
                break
            case .delexpenses:
                self.Updateexpensesmodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
                if self.Updateexpensesmodel.category_id != self.dataExpensestoDel.category_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .Autosaveexpenses:
                self.Updateexpensesmodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
                if self.Updateexpensesmodel.category_id != self.Autosavemodel.category_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .expenses:
                self.Updateexpensesmodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
                if self.Updateexpensesmodel.category_id != self.dataExpensesSumlist.category_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .Autosaveincome:
                break
            default:
                self.createincomedatalistmodel.idcategory = Catexpense.id
            }
            if self.lb_SelectedCategory.text != "เลือก" {
                self.lb_SelectedCategory.textColor = .black
            }
        })
        
        self.navigationController?.pushViewController(vc, animated: true)
        }
    
    @objc func NoteincomeTap() {
        result_TF.endEditing(true)
        let storyborad = UIStoryboard(name: "Options", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "NoteOption") as! NoteOption
        
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.custom { context in 400}]
        }
        self.IncomeNote = lb_NoteAdded.text
        vc.noneNote = self.IncomeNote ?? ""
//        vc.thisState = .income
        vc.addSavenoteAction(handlersavenote: { Incomesenote in
            self.IncomeNote = Incomesenote
            self.lb_NoteAdded.text = self.IncomeNote
            if self.Incometype != "" {
                self.createincomedatalistmodel.description = self.IncomeNote
            }else{
                self.createincomedatalistmodel.description = "ไม่มี"
            }
            switch self.delState {
            case .delincome:
                self.Updateincomemodel.description = self.createincomedatalistmodel.description ?? "ไม่มี"
                if self.Updateincomemodel.description != self.datatoDel.description && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .delexpenses:
                break
            case .Autosaveexpenses:
                break
            case .Autosaveincome:
                self.Updateincomemodel.description = self.createincomedatalistmodel.description ?? "ไม่มี"
                if self.Updateincomemodel.description != self.Autosavemodel.description && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .income:
                self.Updateincomemodel.description = self.createincomedatalistmodel.description ?? "ไม่มี"
                if self.Updateincomemodel.description != self.dataIncomeSumlist.description && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            default:
                break
            }
        })
        self.present(vc, animated: true)
        }
    
    @objc func NoteExpenseTap() {
        result_TF.endEditing(true)
        let storyborad = UIStoryboard(name: "Options", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "NoteExpenseVC") as! NoteExpenseVC
        
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.custom { context in 400}]
        }
        self.ExpenNote = lb_NoteAdded.text
        vc.ExnoneNote = self.ExpenNote ?? ""
        
//        vc.thisState = .expenses
        vc.addSaveExnoteAction(handlersaveExnote: { Expensenote in
            self.ExpenNote = Expensenote
            self.lb_NoteAdded.text = self.ExpenNote
            if self.Incometype != "" {
                self.createincomedatalistmodel.description = self.ExpenNote
            }else{
                self.createincomedatalistmodel.description = "ไม่มี"
            }
            switch self.delState {
            case .delincome:
                break
            case .delexpenses:
                self.Updateexpensesmodel.description = self.createincomedatalistmodel.description ?? "ไม่มี"
                if self.Updateexpensesmodel.description != self.dataExpensestoDel.description && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .Autosaveexpenses:
                self.Updateexpensesmodel.description = self.createincomedatalistmodel.description ?? "ไม่มี"
                if self.Updateexpensesmodel.description != self.Autosavemodel.description && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .expenses:
                self.Updateexpensesmodel.description = self.createincomedatalistmodel.description ?? "ไม่มี"
                if self.Updateexpensesmodel.description != self.dataExpensesSumlist.description && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .Autosaveincome:
                break
            default:
                break
            }
            
        })
        self.present(vc, animated: true)
        }
    
    @objc func IncomeTypeTap() {
        result_TF.endEditing(true)
        let storyborad = UIStoryboard(name: "Options", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "IncomeType") as! IncomeType
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.custom { context in 200}]
        }
        vc.getIncometype = self.getincometypeRes
        vc.addAction(handler: { incomeType in
            self.Incometype = incomeType.type
            self.lb_SelectedType.text = self.Incometype
            print("รายรับ Add : " + "\(String(describing: self.Incometype))")
            self.createincomedatalistmodel.idtype = incomeType.id
            switch self.delState {
            case .delincome:
                self.Updateincomemodel.type_id = self.createincomedatalistmodel.idtype ?? 0
                if self.Updateincomemodel.type_id != self.datatoDel.type_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .delexpenses:
                break
            case .Autosaveexpenses:
                break
            case .Autosaveincome:
                self.Updateincomemodel.type_id = self.createincomedatalistmodel.idtype ?? 0
                if self.Updateincomemodel.type_id != self.Autosavemodel.type_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .income:
                self.Updateincomemodel.type_id = self.createincomedatalistmodel.idtype ?? 0
                if self.Updateincomemodel.type_id != self.dataIncomeSumlist.type_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            default:
                break
            }
            if self.lb_SelectedType.text != "เลือก" {
                self.lb_SelectedType.textColor = .black
            }
        })
        self.present(vc, animated: true)

    }
    
    @objc func ExpensesTypeTap() {
        result_TF.endEditing(true)
        let storyborad = UIStoryboard(name: "Options", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "ExpensesType") as! ExpensesType
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.custom { context in 200}]
        }
        vc.getExpensestype = self.getexpensestypeRes
        vc.addExpenAction(handlerExpen: { ExpenpensesType in
            self.expensetype = ExpenpensesType.type
            self.lb_SelectedType.text = self.expensetype
            self.createincomedatalistmodel.idtype = ExpenpensesType.id
            switch self.delState {
            case .delincome:
                break
            case .delexpenses:
                self.Updateexpensesmodel.type_id = self.createincomedatalistmodel.idtype ?? 0
                if self.Updateexpensesmodel.type_id != self.dataExpensestoDel.type_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .Autosaveexpenses:
                self.Updateexpensesmodel.type_id = self.createincomedatalistmodel.idtype ?? 0
                if self.Updateexpensesmodel.type_id != self.Autosavemodel.type_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .expenses:
                self.Updateexpensesmodel.type_id = self.createincomedatalistmodel.idtype ?? 0
                if self.Updateexpensesmodel.type_id != self.dataExpensesSumlist.type_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .Autosaveincome:
                break
            default:
                break
            }
            if self.lb_SelectedType.text != "เลือก" {
                self.lb_SelectedType.textColor = .black
            }
        })
        self.present(vc, animated: true)

        }
    
    @objc func autosaveIncomeTap() {
        result_TF.endEditing(true)
        let storyborad = UIStoryboard(name: "Options", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "IncomeAutoSave") as! IncomeAutoSave
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.custom { context in 300}]
        }
            vc.SaveAuto = self.getlistSaveAutoRes
        vc.addautosaveincomeAction(handlerautosave: { incomeautosave in
            self.AutoSaveIncome = incomeautosave.frequency
            self.AutoSaveIncomeid = incomeautosave.id
            if self.AutoSaveIncome == "" {
                self.AutoSaveIncome = "ไม่มี"
            }else{
                self.AutoSaveIncome = incomeautosave.frequency
            }
            self.createincomedatalistmodel.auto_schedule = self.AutoSaveIncomeid ?? 0
            
            self.myFunction()
            self.Zerocheck()
            
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
            
            let selectedDate = self.datetimepicker.date
            // แปลงเป็น Unix timestamp
            let unixTimestamp = selectedDate.timeIntervalSince1970
            let ReDate = Double(unixTimestamp)
            self.ReDateStr = self.convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())

            switch self.delState {
            case .delincome:
                self.Updateincomemodel.auto_schedule = incomeautosave.id ?? 0
                self.btn_statusAutosave.text = self.AutoSaveIncome
                if self.Updateincomemodel.auto_schedule != self.datatoDel.save_auto_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
                if self.ReDateStr ?? "" < DayNow {
                    self.btn_statusAutosave.text = "ไม่มี"
                    self.createincomedatalistmodel.auto_schedule = 1
                }else if self.ReDateStr ?? "" >= DayNow {
                    self.AutoSaveIncome = incomeautosave.frequency
                    self.btn_statusAutosave.text = self.AutoSaveIncome
                    self.createincomedatalistmodel.auto_schedule = self.AutoSaveIncomeid
                }
            case .delexpenses:
                break
            case .Autosaveincome:
                self.Updateincomemodel.auto_schedule = incomeautosave.id ?? 0
                self.btn_statusAutosave.text = self.AutoSaveIncome
                if self.Updateincomemodel.auto_schedule != self.Autosavemodel.save_auto_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
                if self.ReDateStr ?? "" < DayNow && self.textfieldcheck == true{
                    self.btn_statusAutosave.text = "ไม่มี"
                    self.createincomedatalistmodel.auto_schedule = 1
                }else if self.ReDateStr ?? "" >= DayNow && self.textfieldcheck == true{
                    self.AutoSaveIncome = incomeautosave.frequency
                    self.btn_statusAutosave.text = self.AutoSaveIncome
                    self.createincomedatalistmodel.auto_schedule = self.AutoSaveIncomeid
                }
            case .income:
                self.Updateincomemodel.auto_schedule = incomeautosave.id ?? 0
                self.btn_statusAutosave.text = self.AutoSaveIncome
                if self.Updateincomemodel.auto_schedule != self.dataIncomeSumlist.save_auto_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
                if self.ReDateStr ?? "" < DayNow{
                    self.btn_statusAutosave.text = "ไม่มี"
                    self.createincomedatalistmodel.auto_schedule = 1
                }else if self.ReDateStr ?? "" >= DayNow{
                    self.AutoSaveIncome = incomeautosave.frequency
                    self.btn_statusAutosave.text = self.AutoSaveIncome
                    self.createincomedatalistmodel.auto_schedule = incomeautosave.id
                }
            case .Autosaveexpenses:
                break
            default:
                self.createincomedatalistmodel.auto_schedule = incomeautosave.id ?? 0
                self.btn_statusAutosave.text = self.AutoSaveIncome
            }
            
        })
        self.present(vc, animated: true)
        
    }
    
    @objc func autosaveExpenseTap() {
        result_TF.endEditing(true)
        let storyborad = UIStoryboard(name: "Options", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "ExpenseAutoSaveVC") as! ExpenseAutoSaveVC
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.custom { context in 300}]
        }
        vc.SaveAuto = self.getlistSaveAutoRes
        vc.addautosaveincomeAction(handlerexpenseautosave: { expenseautosave in
            self.AutoSaveExpen = expenseautosave.frequency
            self.AutoSaveExpenid = expenseautosave.id
            self.myFunction()
            self.Zerocheck()
            if self.AutoSaveExpen == "" {
                self.AutoSaveExpen = "ไม่มี"
            }else{
                self.AutoSaveExpen = expenseautosave.frequency
            }
            self.createincomedatalistmodel.auto_schedule = expenseautosave.id
            
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
            
            let selectedDate = self.datetimepicker.date
            // แปลงเป็น Unix timestamp
            let unixTimestamp = selectedDate.timeIntervalSince1970
            let ReDate = Double(unixTimestamp)
            self.ReDateStr = self.convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())

            switch self.delState {
            case .delincome:
                break
            case .delexpenses:
                self.Updateexpensesmodel.auto_schedule = expenseautosave.id ?? 0
                self.btn_statusAutosave.text = self.AutoSaveExpen
                if self.Updateexpensesmodel.auto_schedule != self.dataExpensestoDel.save_auto_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
                if self.ReDateStr ?? "" < DayNow{
                    self.btn_statusAutosave.text = "ไม่มี"
                    self.createincomedatalistmodel.auto_schedule = 1
                }else if self.ReDateStr ?? "" >= DayNow{
                    self.AutoSaveExpen = expenseautosave.frequency
                    self.btn_statusAutosave.text = self.AutoSaveExpen
                    self.createincomedatalistmodel.auto_schedule = expenseautosave.id
                }
            case .Autosaveexpenses:
                self.Updateexpensesmodel.auto_schedule = expenseautosave.id ?? 0
                self.btn_statusAutosave.text = self.AutoSaveExpen
                if self.Updateexpensesmodel.auto_schedule != self.Autosavemodel.save_auto_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
                if self.ReDateStr ?? "" < DayNow{
                    self.btn_statusAutosave.text = "ไม่มี"
                    self.createincomedatalistmodel.auto_schedule = 1
                }else if self.ReDateStr ?? "" >= DayNow{
                    self.AutoSaveExpen = expenseautosave.frequency
                    self.btn_statusAutosave.text = self.AutoSaveExpen
                    self.createincomedatalistmodel.auto_schedule = expenseautosave.id
                }
            case .expenses:
                self.Updateexpensesmodel.auto_schedule = expenseautosave.id ?? 0
                self.btn_statusAutosave.text = self.AutoSaveExpen
                if self.Updateexpensesmodel.auto_schedule != self.dataExpensesSumlist.save_auto_id && self.textfieldcheck == true{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
                if self.ReDateStr ?? "" < DayNow{
                    self.btn_statusAutosave.text = "ไม่มี"
                    self.createincomedatalistmodel.auto_schedule = 1
                }else if self.ReDateStr ?? "" >= DayNow{
                    self.AutoSaveExpen = expenseautosave.frequency
                    self.btn_statusAutosave.text = self.AutoSaveExpen
                    self.createincomedatalistmodel.auto_schedule = expenseautosave.id
                }
            case .Autosaveincome:
                break
            default:
                self.createincomedatalistmodel.auto_schedule = expenseautosave.id ?? 0
                self.btn_statusAutosave.text = self.AutoSaveExpen
            }
        })
        self.present(vc, animated: true)

        }
    
    @objc func AllsaveExpenselistTap() {
//        if (createincomedatalistmodel.idcategory == 0) || createincomedatalistmodel.idtype == 0{
//            let alert = UIAlertController(title: "บันทึกไม่สำเร็จ", message: "กรุณากรอกข้อมูลให้ครบถ้วน", preferredStyle: .alert)
//            let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
//                self.dismiss(animated: true)
//        }
//            alert.addAction(acceptAction)
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
        switch delState {
        case .Autosaveexpenses:
            Updateexpensesmodel.expenses_id = self.Autosavemodel.transaction_id ?? 0
            Updateexpensesmodel.type_id = self.createincomedatalistmodel.idtype ?? 0
            Updateexpensesmodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
            Updateexpensesmodel.description = self.createincomedatalistmodel.description ?? ""
            Updateexpensesmodel.amount = self.createincomedatalistmodel.amount ?? 0.00
//            Updateexpensesmodel.createdateTime = self.Autosavemodel.timestamp ?? 0
            Updateexpensesmodel.auto_schedule = self.createincomedatalistmodel.auto_schedule ?? 0
            Updateexpensesdata()
        case .delexpenses:
            Updateexpensesmodel.expenses_id = self.dataExpensestoDel.transaction_id
            Updateexpensesmodel.type_id = self.createincomedatalistmodel.idtype ?? 0
            Updateexpensesmodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
            Updateexpensesmodel.description = self.createincomedatalistmodel.description ?? ""
            Updateexpensesmodel.amount = self.createincomedatalistmodel.amount ?? 0.00
//            Updateexpensesmodel.createdateTime = self.dataExpensestoDel.timestamp ?? 0
            Updateexpensesmodel.auto_schedule = self.createincomedatalistmodel.auto_schedule ?? 0
            Updateexpensesdata()
        case .expenses:
            Updateexpensesmodel.expenses_id = self.dataExpensesSumlist.transaction_id ?? 0
            Updateexpensesmodel.type_id = self.createincomedatalistmodel.idtype ?? 0
            Updateexpensesmodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
            Updateexpensesmodel.description = self.createincomedatalistmodel.description ?? ""
            Updateexpensesmodel.amount = self.createincomedatalistmodel.amount ?? 0.00
//            Updateexpensesmodel.createdateTime = self.dataExpensesSumlist.timestamp ?? 0
            Updateexpensesmodel.auto_schedule = self.createincomedatalistmodel.auto_schedule ?? 0
            Updateexpensesdata()
        default:
            if (createincomedatalistmodel.idcategory == 0) || createincomedatalistmodel.idtype == 0 {
                let alert = UIAlertController(title: "บันทึกไม่สำเร็จ", message: "กรุณากรอกข้อมูลให้ครบถ้วน", preferredStyle: .alert)
                let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                    switch self.lb_SelectedType.text {
                    case "เลือก":
                        self.lb_SelectedType.textColor = .red
                    default:
                        self.lb_SelectedType.textColor = .black
                    }
                    switch self.lb_SelectedCategory.text {
                    case "เลือก":
                        self.lb_SelectedCategory.textColor = .red
                    default:
                        self.lb_SelectedCategory.textColor = .black
                    }
                    self.dismiss(animated: true)
                }
                alert.addAction(acceptAction)
                self.present(alert, animated: true, completion: nil)

                return
            }
            CreateexpenseslistData()
        }
    }
    @objc func AllsaveIncomelistTap() {
        switch delState {
        case .delincome:
            Updateincomemodel.income_id = self.datatoDel.transaction_id
            Updateincomemodel.type_id = self.createincomedatalistmodel.idtype ?? 0
            Updateincomemodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
            Updateincomemodel.description = self.createincomedatalistmodel.description ?? ""
            Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
//            Updateincomemodel.createdateTime = self.datatoDel.timestamp ?? 0
            Updateincomemodel.auto_schedule = self.createincomedatalistmodel.auto_schedule ?? 0
            
            Updateincomedata()
        case .delexpenses:
            break
        case .Autosaveincome:
            Updateincomemodel.income_id = self.Autosavemodel.transaction_id ?? 0
            Updateincomemodel.type_id = self.createincomedatalistmodel.idtype ?? 0
            Updateincomemodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
            Updateincomemodel.description = self.createincomedatalistmodel.description ?? ""
            Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
//            Updateincomemodel.createdateTime = self.datatoDel.timestamp ?? 0
            Updateincomemodel.auto_schedule = self.createincomedatalistmodel.auto_schedule ?? 0
            
            Updateincomedata()
        case .income:
            Updateincomemodel.income_id = self.dataIncomeSumlist.transaction_id ?? 0
            Updateincomemodel.type_id = self.createincomedatalistmodel.idtype ?? 0
            Updateincomemodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
            Updateincomemodel.description = self.createincomedatalistmodel.description ?? ""
            Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
//            Updateincomemodel.createdateTime = self.datatoDel.timestamp ?? 0
            Updateincomemodel.auto_schedule = self.createincomedatalistmodel.auto_schedule ?? 0
            
            Updateincomedata()
        default:
            if (createincomedatalistmodel.idcategory == 0) || createincomedatalistmodel.idtype == 0 {
                let alert = UIAlertController(title: "บันทึกไม่สำเร็จ", message: "กรุณากรอกข้อมูลให้ครบถ้วน", preferredStyle: .alert)
                let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                    switch self.lb_SelectedType.text {
                    case "เลือก":
                        self.lb_SelectedType.textColor = .red
                    default:
                        self.lb_SelectedType.textColor = .black
                    }
                    switch self.lb_SelectedCategory.text {
                    case "เลือก":
                        self.lb_SelectedCategory.textColor = .red
                    default:
                        self.lb_SelectedCategory.textColor = .black
                    }
                    self.dismiss(animated: true)
                }
                alert.addAction(acceptAction)
                self.present(alert, animated: true, completion: nil)

                return
            }
            CreatelistData()
        }
            
//        self.navigationController?.popToViewController(ofClass: Tabbar.self)
    }
    
    @objc func incomeCal() {
        result_TF.endEditing(true)
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "Calculator") as! Calculator
        self.navigationController?.pushViewController(vc, animated: true)
        vc.addState = .income
        let filteredString = result_TF.text?.filter { $0.isNumber || $0 == "."}
        let doubleresult = Double(filteredString ?? "")
        vc.result = doubleresult ?? 0.00
            
        vc.addCalAction(handleraddtotal: { addresult in
            self.CalculatorAddincome = addresult
//            self.createincomedatalistmodel.amount = addresult
            let resultstring = String(addresult)
            if resultstring.count > 13{
                self.result_TF.text = "999999999.99"
            }else{
                self.result_TF.text = String(addresult)
            }
            
            switch self.delState {
            case .delincome:
                if self.result_TF.text == self.datatoDel.amount{
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    
                }else{
                    if self.result_TF.text != "0.0" && self.result_TF.text != "0" && self.result_TF.text != "" && self.result_TF.text != "0.00"{
                        self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                        self.btn_saveincomelist.isEnabled = true
                        self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
                    }else if self.result_TF.text == "0.0" && self.result_TF.text == "0" && self.result_TF.text == "" && self.result_TF.text == "0.00"{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                        self.btn_saveincomelist.isEnabled = false
                        self.createincomedatalistmodel.amount = self.CalculatorAddincome
                    }
                }
            case .Autosaveincome:
                if self.result_TF.text == self.Autosavemodel.amount{
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    if self.result_TF.text != "0.0" && self.result_TF.text != "0" && self.result_TF.text != "" && self.result_TF.text != "0.00"{
                        self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                        self.btn_saveincomelist.isEnabled = true
                        self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
                    }else if self.result_TF.text == "0.0" && self.result_TF.text == "0" && self.result_TF.text == "" && self.result_TF.text == "0.00"{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                        self.btn_saveincomelist.isEnabled = false
                        self.createincomedatalistmodel.amount = self.CalculatorAddincome
                    }
                }
            case .income:
                if self.result_TF.text == self.dataIncomeSumlist.amount{
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    if self.result_TF.text != "0.0" && self.result_TF.text != "0" && self.result_TF.text != "" && self.result_TF.text != "0.00"{
                        self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                        self.btn_saveincomelist.isEnabled = true
                        self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
                    }else if self.result_TF.text == "0.0" && self.result_TF.text == "0" && self.result_TF.text == "" && self.result_TF.text == "0.00"{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                        self.btn_saveincomelist.isEnabled = false
                        self.createincomedatalistmodel.amount = self.CalculatorAddincome
                    }
                }
            default:
                if self.result_TF.text != "0.0" && self.result_TF.text != "0" && self.result_TF.text != "" && self.result_TF.text != "0.00"{
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                    self.btn_saveincomelist.isEnabled = true
                    self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
                }else if self.result_TF.text == "0.0" && self.result_TF.text == "0" && self.result_TF.text == "" && self.result_TF.text == "0.00"{
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                    self.createincomedatalistmodel.amount = self.CalculatorAddincome
                }
            }
            
            self.Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
        })
            
        }
    
    @objc func expenseCal() {
        result_TF.endEditing(true)
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "Calculator") as! Calculator
        self.navigationController?.pushViewController(vc, animated: true)
        vc.addState = .expenses
        let filteredString = result_TF.text?.filter { $0.isNumber || $0 == "."}
        let doubleresult = Double(filteredString ?? "")
        vc.result = doubleresult ?? 0.00
            vc.addCalAction(handleraddtotal: { addresult in
                self.CalculatorAddexpen = addresult
    //            self.createincomedatalistmodel.amount = addresult
                let resultstring = String(addresult)
                if resultstring.count > 13{
                    self.result_TF.text = "999999999.99"
                }else{
                    self.result_TF.text = String(addresult)
                }
//
                switch self.delState {
                case .delexpenses:
                    if self.result_TF.text == self.dataExpensestoDel.amount{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    }else{
                        if self.result_TF.text != "0.0" && self.result_TF.text != "0" && self.result_TF.text != "" && self.result_TF.text != "0.00" {
                            self.btn_saveincomelist.backgroundColor = .FF_8686
                            self.btn_saveincomelist.isEnabled = true
                            self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
//                            self.Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
                        }else if self.result_TF.text == "0.0" && self.result_TF.text == "0" && self.result_TF.text == "" && self.result_TF.text == "0.00"{
                            self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                            self.btn_saveincomelist.isEnabled = false
                            self.createincomedatalistmodel.amount = self.CalculatorAddexpen
                        }
                    }
                case .Autosaveexpenses:
                    if self.result_TF.text == self.Autosavemodel.amount{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    }else{
                        if self.result_TF.text != "0.0" && self.result_TF.text != "0" && self.result_TF.text != "" && self.result_TF.text != "0.00" {
                            self.btn_saveincomelist.backgroundColor = .FF_8686
                            self.btn_saveincomelist.isEnabled = true
                            self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
//                            self.Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
                        }else if self.result_TF.text == "0.0" && self.result_TF.text == "0" && self.result_TF.text == "" && self.result_TF.text == "0.00"{
                            self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                            self.btn_saveincomelist.isEnabled = false
                            self.createincomedatalistmodel.amount = self.CalculatorAddexpen
                        }
                    }
                case .expenses:
                    if self.result_TF.text == self.dataExpensesSumlist.amount{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    }else{
                        if self.result_TF.text != "0.0" && self.result_TF.text != "0" && self.result_TF.text != "" && self.result_TF.text != "0.00" {
                            self.btn_saveincomelist.backgroundColor = .FF_8686
                            self.btn_saveincomelist.isEnabled = true
                            self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
//                            self.Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
                        }else if self.result_TF.text == "0.0" && self.result_TF.text == "0" && self.result_TF.text == "" && self.result_TF.text == "0.00"{
                            self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                            self.btn_saveincomelist.isEnabled = false
                            self.createincomedatalistmodel.amount = self.CalculatorAddexpen
                        }
                    }
                default:
                    if self.result_TF.text != "0.0" && self.result_TF.text != "0" && self.result_TF.text != "" && self.result_TF.text != "0.00" {
                        self.btn_saveincomelist.backgroundColor = .FF_8686
                        self.btn_saveincomelist.isEnabled = true
                        self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
//                        self.Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
                    }else if self.result_TF.text == "0.0" && self.result_TF.text == "0" && self.result_TF.text == "" && self.result_TF.text == "0.00"{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                        self.btn_saveincomelist.isEnabled = false
                        self.createincomedatalistmodel.amount = self.CalculatorAddexpen
                    }
                }
                
            })
        
        
        }
    @objc func Delincome() {
        result_TF.endEditing(true)
        let alert = UIAlertController(title: "คุณต้องการลบรายการนี้หรือไม่ ?", message: "", preferredStyle: .alert)
        let acceptDelAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
            switch self.delState {
            case .delincome:
                let transID = self.datatoDel.transaction_id
                self.Delincomemodel.id = transID
                self.DelIncomeData()
            case .delexpenses:
                let transID = self.dataExpensestoDel.transaction_id
                self.Delincomemodel.id = transID
                self.DelIncomeData()
            case .Autosaveincome:
                let transID = self.Autosavemodel.transaction_id
                self.Delincomemodel.id = transID ?? 0
                self.DelIncomeData()
            case .Autosaveexpenses:
                let transID = self.Autosavemodel.transaction_id
                self.Delincomemodel.id = transID ?? 0
                self.DelIncomeData()
            case .income:
                let transID = self.dataIncomeSumlist.transaction_id
                self.Delincomemodel.id = transID ?? 0
                self.DelIncomeData()
            case .expenses:
                let transID = self.dataExpensesSumlist.transaction_id
                self.Delincomemodel.id = transID ?? 0
                self.DelIncomeData()
            default:
                break
            }
        }
            let cancelAction = UIAlertAction(title: "ยกเลิก", style: .default) { (action) in
                if self.textfieldcheck == false {
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }
            self.dismiss(animated: true)
        }
        alert.addAction(acceptDelAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        }
    @objc func Delexpenses() {
        let alert = UIAlertController(title: "คุณต้องการลบรายการนี้หรือไม่ ?", message: "", preferredStyle: .alert)
        let acceptDelAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
            switch self.delState {
            case .delincome:
                let transID = self.datatoDel.transaction_id
                self.Delincomemodel.id = transID
                self.DelExpensesData()
            case .delexpenses:
                let transID = self.dataExpensestoDel.transaction_id
                self.Delincomemodel.id = transID
                self.DelExpensesData()
            case .Autosaveincome:
                let transID = self.Autosavemodel.transaction_id
                self.Delincomemodel.id = transID ?? 0
                self.DelExpensesData()
            case .Autosaveexpenses:
                let transID = self.Autosavemodel.transaction_id
                self.Delincomemodel.id = transID ?? 0
                self.DelExpensesData()
            case .income:
                let transID = self.dataIncomeSumlist.transaction_id
                self.Delincomemodel.id = transID ?? 0
                self.DelExpensesData()
            case .expenses:
                let transID = self.dataExpensesSumlist.transaction_id
                self.Delincomemodel.id = transID ?? 0
                self.DelExpensesData()
            default:
                break
            }
            
        }
        let cancelAction = UIAlertAction(title: "ยกเลิก", style: .default) { (action) in
            if self.textfieldcheck == false {
                self.btn_saveincomelist.isEnabled = false
                self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            }else{
                self.btn_saveincomelist.isEnabled = true
                self.btn_saveincomelist.backgroundColor = .FF_8686
            }
            self.dismiss(animated: true)
        }
        alert.addAction(acceptDelAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        }
    
    
//    MARK: - Tap func
    func btn_savecheck() {
        myFunction()
        Zerocheck()
        if segment.selectedSegmentIndex == 0{
            if checkstate == true && textfieldcheck == true{
                btn_saveincomelist.isEnabled = true
                btn_saveincomelist.backgroundColor = ._81_C_8_E_4
            }else{
                btn_saveincomelist.isEnabled = false
                btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            }
        }else{
            if checkstate == true && textfieldcheck == true{
                btn_saveincomelist.isEnabled = true
                btn_saveincomelist.backgroundColor = .FF_8686
            }else{
                btn_saveincomelist.isEnabled = false
                btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            }
        }
        
    }
    func AllTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    func ExpenseTap(){
        handleDatetimePickerValueChange()
        
        result_TF.endEditing(true)
        let noteExpensetap = UITapGestureRecognizer(target: self, action: #selector(NoteExpenseTap))
        btn_Note.removeGestureRecognizer(UIGestureRecognizer())
        btn_Note.addGestureRecognizer(noteExpensetap)
        btn_Note.isUserInteractionEnabled = true

        let catExpensetap = UITapGestureRecognizer(target: self, action: #selector(ExpenseCategoryTap))
        btn_Category.removeGestureRecognizer(UIGestureRecognizer())
        btn_Category.addGestureRecognizer(catExpensetap)
        btn_Category.isUserInteractionEnabled = true
        
        let ExpensesTypetap = UITapGestureRecognizer(target: self, action: #selector(ExpensesTypeTap))
        btn_TypeOption.removeGestureRecognizer(UIGestureRecognizer())
        btn_TypeOption.addGestureRecognizer(ExpensesTypetap)
        btn_TypeOption.isUserInteractionEnabled = true

        let ExpenseAUTOsavetap = UITapGestureRecognizer(target: self, action: #selector(autosaveExpenseTap))
        btn_SaveAuto.removeGestureRecognizer(UIGestureRecognizer())
        btn_SaveAuto.addGestureRecognizer(ExpenseAUTOsavetap)
        btn_SaveAuto.isUserInteractionEnabled = true
        
        let ExpenseSavelist = UITapGestureRecognizer(target: self, action: #selector(AllsaveExpenselistTap))
        btn_saveincomelist.removeGestureRecognizer(UIGestureRecognizer())
        btn_saveincomelist.addGestureRecognizer(ExpenseSavelist)
        btn_saveincomelist.isUserInteractionEnabled = true
        
        let ExpenseCal = UITapGestureRecognizer(target: self, action: #selector(expenseCal))
        btn_Calculator.removeGestureRecognizer(UIGestureRecognizer())
        btn_Calculator.addGestureRecognizer(ExpenseCal)
        btn_Calculator.isUserInteractionEnabled = true
        
        let ExpenseDel = UITapGestureRecognizer(target: self, action: #selector(Delexpenses))
        btn_DelData.removeGestureRecognizer(UIGestureRecognizer())
        btn_DelData.addGestureRecognizer(ExpenseDel)
        btn_DelData.isUserInteractionEnabled = true


    }
    
    func IncomeTap(){
        handleDatetimePickerValueChange()
        result_TF.endEditing(true)
        let noteIncometap = UITapGestureRecognizer(target: self, action: #selector(NoteincomeTap))
        btn_Note.removeGestureRecognizer(UIGestureRecognizer())
        btn_Note.addGestureRecognizer(noteIncometap)
        btn_Note.isUserInteractionEnabled = true

        let catIncometap = UITapGestureRecognizer(target: self, action: #selector(CategoryTap))
        btn_Category.removeGestureRecognizer(UIGestureRecognizer())
        btn_Category.addGestureRecognizer(catIncometap)
        btn_Category.isUserInteractionEnabled = true

        let incomeTypetap = UITapGestureRecognizer(target: self, action: #selector(IncomeTypeTap))
        btn_TypeOption.removeGestureRecognizer(UIGestureRecognizer())
        btn_TypeOption.addGestureRecognizer(incomeTypetap)
        btn_TypeOption.isUserInteractionEnabled = true
      
        let IncomeAUTOsavetap = UITapGestureRecognizer(target: self, action: #selector(autosaveIncomeTap))
        btn_SaveAuto.removeGestureRecognizer(UIGestureRecognizer())
        btn_SaveAuto.addGestureRecognizer(IncomeAUTOsavetap)
        btn_SaveAuto.isUserInteractionEnabled = true
        
        let IncomeSavelist = UITapGestureRecognizer(target: self, action: #selector(AllsaveIncomelistTap))
        btn_saveincomelist.removeGestureRecognizer(UIGestureRecognizer())
        btn_saveincomelist.addGestureRecognizer(IncomeSavelist)
        btn_saveincomelist.isUserInteractionEnabled = true
        
        let incomeCal = UITapGestureRecognizer(target: self, action: #selector(incomeCal))
        btn_Calculator.removeGestureRecognizer(UIGestureRecognizer())
        btn_Calculator.addGestureRecognizer(incomeCal)
        btn_Calculator.isUserInteractionEnabled = true
        
        let incomeDel = UITapGestureRecognizer(target: self, action: #selector(Delincome))
        btn_DelData.removeGestureRecognizer(UIGestureRecognizer())
        btn_DelData.addGestureRecognizer(incomeDel)
        btn_DelData.isUserInteractionEnabled = true

    }
    
//    MARK: - Function เสริม
    func myFunction() {
        
        switch delState {
        case .delincome:
            if datatoDel.description == ""{
                datatoDel.description = "ไม่มี"
                lb_NoteAdded.text = "ไม่มี"
            }
            if result_TF.text != datatoDel.amount || btn_statusAutosave.text != datatoDel.save_auto_name || lb_SelectedType.text != datatoDel.type_name || lb_SelectedCategory.text != datatoDel.category_name || lb_NoteAdded.text != datatoDel.description{
                checkstate = true
            } else if result_TF.text == datatoDel.amount || btn_statusAutosave.text == datatoDel.save_auto_name || lb_SelectedType.text == datatoDel.type_name || lb_SelectedCategory.text == datatoDel.category_name || lb_NoteAdded.text == datatoDel.description{
                checkstate = false
            } else {
                checkstate = false
            }
        case .delexpenses:
            if dataExpensestoDel.description == ""{
                dataExpensestoDel.description = "ไม่มี"
                lb_NoteAdded.text = "ไม่มี"
            }
            if result_TF.text != dataExpensestoDel.amount || btn_statusAutosave.text != dataExpensestoDel.save_auto_name || lb_SelectedType.text != dataExpensestoDel.type_name || lb_SelectedCategory.text != dataExpensestoDel.category_name || lb_NoteAdded.text != dataExpensestoDel.description{
                checkstate = true
            } else if result_TF.text == dataExpensestoDel.amount || btn_statusAutosave.text == dataExpensestoDel.save_auto_name || lb_SelectedType.text == dataExpensestoDel.type_name || lb_SelectedCategory.text == dataExpensestoDel.category_name || lb_NoteAdded.text == dataExpensestoDel.description{
                checkstate = false
            } else {
                checkstate = false
            }
        case .Autosaveexpenses:
            if Autosavemodel.description == ""{
                Autosavemodel.description = "ไม่มี"
                lb_NoteAdded.text = "ไม่มี"
            }
            if result_TF.text != Autosavemodel.amount || btn_statusAutosave.text != Autosavemodel.save_auto_name || lb_SelectedType.text != Autosavemodel.type_name || lb_SelectedCategory.text != Autosavemodel.category_name || lb_NoteAdded.text != Autosavemodel.description{
                checkstate = true
            } else if result_TF.text == Autosavemodel.amount || btn_statusAutosave.text == Autosavemodel.save_auto_name || lb_SelectedType.text == Autosavemodel.type_name || lb_SelectedCategory.text == Autosavemodel.category_name || lb_NoteAdded.text == Autosavemodel.description{
                checkstate = false
            } else {
                checkstate = false
            }
        case .Autosaveincome:
            if Autosavemodel.description == ""{
                Autosavemodel.description = "ไม่มี"
                lb_NoteAdded.text = "ไม่มี"
            }
            if result_TF.text != Autosavemodel.amount || btn_statusAutosave.text != Autosavemodel.save_auto_name || lb_SelectedType.text != Autosavemodel.type_name || lb_SelectedCategory.text != Autosavemodel.category_name || lb_NoteAdded.text != Autosavemodel.description{
                checkstate = true
            } else if result_TF.text == Autosavemodel.amount || btn_statusAutosave.text == Autosavemodel.save_auto_name || lb_SelectedType.text == Autosavemodel.type_name || lb_SelectedCategory.text == Autosavemodel.category_name || lb_NoteAdded.text == Autosavemodel.description{
                checkstate = false
            } else {
                checkstate = false
            }
        case .income:
            if dataIncomeSumlist.description == ""{
                dataIncomeSumlist.description = "ไม่มี"
                lb_NoteAdded.text = "ไม่มี"
            }
            if result_TF.text != dataIncomeSumlist.amount || btn_statusAutosave.text != dataIncomeSumlist.save_auto_name || lb_SelectedType.text != dataIncomeSumlist.type_name || lb_SelectedCategory.text != dataIncomeSumlist.category_name || lb_NoteAdded.text != dataIncomeSumlist.description{
                checkstate = true
            } else if result_TF.text == dataIncomeSumlist.amount || btn_statusAutosave.text == dataIncomeSumlist.save_auto_name || lb_SelectedType.text == dataIncomeSumlist.type_name || lb_SelectedCategory.text == dataIncomeSumlist.category_name || lb_NoteAdded.text == dataIncomeSumlist.description{
                checkstate = false
            } else {
                checkstate = false
            }
        case .expenses:
            if dataExpensesSumlist.description == ""{
                dataExpensesSumlist.description = "ไม่มี"
                lb_NoteAdded.text = "ไม่มี"
            }
            if result_TF.text != dataExpensesSumlist.amount || btn_statusAutosave.text != dataExpensesSumlist.save_auto_name || lb_SelectedType.text != dataExpensesSumlist.type_name || lb_SelectedCategory.text != dataExpensesSumlist.category_name || lb_NoteAdded.text != dataExpensesSumlist.description{
                checkstate = true
            } else if result_TF.text == dataExpensesSumlist.amount || btn_statusAutosave.text == dataExpensesSumlist.save_auto_name || lb_SelectedType.text == dataExpensesSumlist.type_name || lb_SelectedCategory.text == dataExpensesSumlist.category_name || lb_NoteAdded.text == dataExpensesSumlist.description{
                checkstate = false
            } else {
                checkstate = false
            }
        default:
            if textfieldcheck == true {
                checkstate = true
            }
            
        }
        
    }
    
    func Zerocheck(){
        
        if result_TF.text != "0" && result_TF.text != "0.00" && result_TF.text != "0.0" && result_TF.text != "000" && result_TF.text != "00" && result_TF.text != "0000" && result_TF.text != "00000" && result_TF.text != "000000"{
            textfieldcheck = true
        } else if  result_TF.text == "0" || result_TF.text == "0.00" || result_TF.text == "000" || result_TF.text == "0.0" || result_TF.text == "00" || result_TF.text == "0000"{
            textfieldcheck = false
        } else {
            textfieldcheck = true
        }
    }

    
//    MARK: - escaping
    func sendreportidAction(handlersendreport: @escaping ((Any) -> Void)) {
        sendreport = handlersendreport
    }
    
//    MARK: - textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let result = String(datatoDel.amount)
        if segment.selectedSegmentIndex == 0 {
            switch delState {
            case .delincome:
                if textField.text == "0" || textField.text == "0.0" || textField.text == "0.00" || textField.text == "00000"{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else if textField.text == ""{
                    let filteredString = datatoDel.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddincome = doubleTF ?? 0
                    
                }else if textField.text == datatoDel.amount{
                    let filteredString = datatoDel.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddincome = doubleTF ?? 0
                }
            case .delexpenses:
                break
            case .Autosaveincome:
                if textField.text == "0" || textField.text == "0.0" || textField.text == "0.00" || textField.text == "00000"{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else if textField.text == ""{
                    let filteredString = Autosavemodel.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddincome = doubleTF ?? 0
                    
                }else if textField.text == Autosavemodel.amount{
                    let filteredString = Autosavemodel.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddincome = doubleTF ?? 0
                }
            case .income:
                if textField.text == "0" || textField.text == "0.0" || textField.text == "0.00" || textField.text == "00000"{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else if textField.text == ""{
                    let filteredString = dataIncomeSumlist.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddincome = doubleTF ?? 0
                    
                }else if textField.text == dataIncomeSumlist.amount{
                    let filteredString = dataIncomeSumlist.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddincome = doubleTF ?? 0
                }
            default:
                if CalculatorAddincome == 0.0{
                    textField.text = ""
                }else if textField.text == "-"{
                    textField.text = "0.0"
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddincome = doubleTF ?? 0
                }
                break
            }
            
        }else{
            switch delState {
            case .delincome:
                let filteredString = dataExpensestoDel.amount!.filter { $0.isNumber || $0 == "."}
                textField.text = String(filteredString)
                let doubleTF = Double(textField.text ?? "")
                CalculatorAddincome = doubleTF ?? 0
                break
            case .delexpenses:
                if textField.text == "0" || textField.text == "0.0" || textField.text == "0.00" || textField.text == "00000"{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else if textField.text == ""{
                    let filteredString = dataExpensestoDel.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddexpen = doubleTF ?? 0
                    
                }else if textField.text == datatoDel.amount{
                    let filteredString = dataExpensestoDel.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddexpen = doubleTF ?? 0
                }
                
            case .Autosaveexpenses:
                if textField.text == "0" || textField.text == "0.0" || textField.text == "0.00" || textField.text == "00000"{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else if textField.text == ""{
                    let filteredString = Autosavemodel.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddexpen = doubleTF ?? 0
                    
                }else if textField.text == Autosavemodel.amount{
                    let filteredString = Autosavemodel.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddexpen = doubleTF ?? 0
                }
                
            case .expenses:
                if textField.text == "0" || textField.text == "0.0" || textField.text == "0.00" || textField.text == "00000"{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else if textField.text == ""{
                    let filteredString = dataExpensesSumlist.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddexpen = doubleTF ?? 0
                    
                }else if textField.text == dataExpensesSumlist.amount{
                    let filteredString = dataExpensesSumlist.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddexpen = doubleTF ?? 0
                }
                
                let filteredString = dataExpensesSumlist.amount!.filter { $0.isNumber || $0 == "."}
                textField.text = String(filteredString)
                let doubleTF = Double(textField.text ?? "")
                CalculatorAddexpen = doubleTF ?? 0
            default:
                if CalculatorAddexpen == 0.0{
                    textField.text = ""
                }else if textField.text == "-"{
                    textField.text = "0.0"
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddexpen = doubleTF ?? 0
                }
                break
            }
        }
       
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.text {
        case "0":
            self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            self.btn_saveincomelist.isEnabled = false
//            self.btn_saveincomelist.isHidden = true
        case "0.0":
            self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            self.btn_saveincomelist.isEnabled = false
        case "0.00":
            self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
            self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
        default:
            
//            self.btn_saveincomelist.isEnabled = true
            break
        }
        
        
        myFunction()
        Zerocheck()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//             ตรวจสอบว่าจำนวนตัวอักษรใน text field ไม่เกิน 10 ตัว
    
        
        let totalIncome_Expense = (textField.text ?? "") as NSString
        let Updatetotal = totalIncome_Expense.replacingCharacters(in: range, with: string)
        if Updatetotal.count == 0 {
            btn_saveincomelist.backgroundColor = UIColor.lightGray
            btn_saveincomelist.isEnabled = false

        }
        if Updatetotal.count >= 1 {
            btn_saveincomelist.isEnabled = true
            btn_saveincomelist.backgroundColor = UIColor.F_2_A_5_A_3
        }
    if Updatetotal.unicodeScalars.count <= 13{
        switch delState {
        case .delincome:
            if segment.selectedSegmentIndex == 0 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                    let result = Double(textField.text ?? "")
                    CalculatorAddincome = Double(result ?? 0.0)
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                CalculatorAddincome = Double(Updatetotal) ?? 0
                createincomedatalistmodel.amount = CalculatorAddincome
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
                myFunction()
                Zerocheck()
            }else if segment.selectedSegmentIndex == 1 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                myFunction()
                Zerocheck()
            }
            myFunction()
            Zerocheck()
            CalculatorAddexpen = Double(Updatetotal) ?? 0
            createincomedatalistmodel.amount = CalculatorAddexpen
            Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
           
        case .delexpenses:
            if segment.selectedSegmentIndex == 0 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                CalculatorAddexpen = Double(Updatetotal) ?? 0
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateincomemodel.amount = createincomedatalistmodel.amount ?? 0.00
                myFunction()
                Zerocheck()
            }else if segment.selectedSegmentIndex == 1 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                CalculatorAddexpen = Double(Updatetotal) ?? 0
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
                myFunction()
                Zerocheck()
            }
            
        case .Autosaveexpenses:
            if segment.selectedSegmentIndex == 0 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                CalculatorAddincome = Double(Updatetotal) ?? 0
                createincomedatalistmodel.amount = CalculatorAddincome
                Updateincomemodel.amount = createincomedatalistmodel.amount ?? 0.00
                myFunction()
                Zerocheck()
            }else if segment.selectedSegmentIndex == 1 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                CalculatorAddexpen = Double(Updatetotal) ?? 0
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
                myFunction()
                Zerocheck()
            }
        case .expenses:
            if segment.selectedSegmentIndex == 0 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                CalculatorAddincome = Double(Updatetotal) ?? 0
                createincomedatalistmodel.amount = CalculatorAddincome
                Updateincomemodel.amount = createincomedatalistmodel.amount ?? 0.00
                myFunction()
                Zerocheck()
            }else if segment.selectedSegmentIndex == 1 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                CalculatorAddexpen = Double(Updatetotal) ?? 0
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
                myFunction()
                Zerocheck()
            }
        case .Autosaveincome:
            if segment.selectedSegmentIndex == 0 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                CalculatorAddincome = Double(Updatetotal) ?? 0
                createincomedatalistmodel.amount = CalculatorAddincome
                Updateincomemodel.amount = createincomedatalistmodel.amount ?? 0.00
                myFunction()
                Zerocheck()
            }else if segment.selectedSegmentIndex == 1 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                CalculatorAddexpen = Double(Updatetotal) ?? 0
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
                myFunction()
                Zerocheck()
            }
        case .income:
            if segment.selectedSegmentIndex == 0 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                CalculatorAddincome = Double(Updatetotal) ?? 0
                createincomedatalistmodel.amount = CalculatorAddincome
                Updateincomemodel.amount = createincomedatalistmodel.amount ?? 0.00
                myFunction()
                Zerocheck()
            }else if segment.selectedSegmentIndex == 1 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                CalculatorAddexpen = Double(Updatetotal) ?? 0
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
                myFunction()
                Zerocheck()
            }
        default:
            if segment.selectedSegmentIndex == 0 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                myFunction()
                Zerocheck()
                
                createincomedatalistmodel.amount = CalculatorAddincome
            }else if segment.selectedSegmentIndex == 1 {
                switch Updatetotal {
                case "0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.0":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
                case "0.00":
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    self.btn_saveincomelist.isEnabled = false
//                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                   createincomedatalistmodel.amount = CalculatorAddexpen
                myFunction()
                Zerocheck()
            }
        }
        
    }
        return Updatetotal.unicodeScalars.count <= 13
        }
    func textFieldDidEndEditing(_ textField: UITextField) {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = NumberFormatter.Style.decimal
//        let text = Double(textField.text ?? "0.00") ?? 0.00
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
//        let formattedValue = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
//        textField.text = formattedValue
        if segment.selectedSegmentIndex == 0{
            switch delState {
            case .delincome:
                let doubleResult = Double(textField.text ?? "0.00")
                CalculatorAddincome = doubleResult ?? 0.00
                if result_TF.text == self.datatoDel.amount{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = false
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    let doubleResult = Double(textField.text ?? "0.00")
                    CalculatorAddincome = doubleResult ?? 0.00
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = true
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
//                    CalculatorAddincome = Double(result_TF.text ?? "") ?? 0
//                    createincomedatalistmodel.amount = CalculatorAddincome
                }
            case .delexpenses:
                break
            case .Autosaveexpenses:
                let doubleResult = Double(textField.text ?? "0.00")
                CalculatorAddincome = doubleResult ?? 0.00
                if result_TF.text == self.Autosavemodel.amount{
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = false
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.backgroundColor = .FF_8686
                    btn_saveincomelist.isEnabled = true
                }
            case .Autosaveincome:
                let doubleResult = Double(textField.text ?? "0.00")
                CalculatorAddincome = doubleResult ?? 0.00
                if result_TF.text == self.Autosavemodel.amount{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = false
                }else{
                    let doubleResult = Double(textField.text ?? "0.00")
                    CalculatorAddincome = doubleResult ?? 0.00
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = true
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
//                    CalculatorAddincome = Double(result_TF.text ?? "") ?? 0
//                    createincomedatalistmodel.amount = CalculatorAddincome
                }
            case .expenses:
                if result_TF.text == self.dataExpensesSumlist.amount{
                    let doubleResult = Double(textField.text ?? "0.00")
                    CalculatorAddincome = doubleResult ?? 0.00
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = false
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    let doubleResult = Double(textField.text ?? "0.00")
                    CalculatorAddincome = doubleResult ?? 0.00
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = true
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }
            case .income:
                if result_TF.text == self.dataIncomeSumlist.amount{
                    let doubleResult = Double(textField.text ?? "0.00")
                    CalculatorAddincome = doubleResult ?? 0.00
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = false
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    let doubleResult = Double(textField.text ?? "0.00")
                    CalculatorAddincome = doubleResult ?? 0.00
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = true
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                    
//                    CalculatorAddincome = Double(result_TF.text ?? "") ?? 0
//                    createincomedatalistmodel.amount = CalculatorAddincome
                }
            default:
                if result_TF.text != "0.0" {
                    btn_saveincomelist.isEnabled = true
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else if result_TF.text == "0.0"{
                    btn_saveincomelist.isEnabled = false
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
                let doubleResult = Double(textField.text ?? "0.00")
                CalculatorAddincome = doubleResult ?? 0.00
                let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                textField.text = formattedNumber
                
            }
        }else{
            switch delState {
            case .delincome:
                break
            case .delexpenses:
                if result_TF.text == self.dataExpensestoDel.amount{
                    btn_saveincomelist.isEnabled = false
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    btn_saveincomelist.isEnabled = true
                    btn_saveincomelist.backgroundColor = .FF_8686
//                    createincomedatalistmodel.amount = CalculatorAddexpen
                }
                let doubleResult = Double(textField.text ?? "0.00")
                CalculatorAddexpen = doubleResult ?? 0.00
                let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddexpen))
                textField.text = formattedNumber
                

            case .Autosaveexpenses:
                if result_TF.text == self.Autosavemodel.amount{
                    btn_saveincomelist.isEnabled = false
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    btn_saveincomelist.isEnabled = true
                    btn_saveincomelist.backgroundColor = .FF_8686
//                    createincomedatalistmodel.amount = CalculatorAddexpen
                }
                let doubleResult = Double(textField.text ?? "0.00")
                CalculatorAddexpen = doubleResult ?? 0.00
                let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddexpen))
                textField.text = formattedNumber
            case .expenses:
                if result_TF.text == self.dataExpensesSumlist.amount{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    btn_saveincomelist.isEnabled = false
                }else{
                    btn_saveincomelist.backgroundColor = .FF_8686
                    btn_saveincomelist.isEnabled = true
//                    createincomedatalistmodel.amount = CalculatorAddexpen
                }
                let doubleResult = Double(textField.text ?? "0.00")
                CalculatorAddexpen = doubleResult ?? 0.00
                let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddexpen))
                textField.text = formattedNumber
            case .Autosaveincome:
                break
            default:
                if result_TF.text != "0.0" {
                    btn_saveincomelist.backgroundColor = .FF_8686
                    btn_saveincomelist.isEnabled = true
        //            createincomedatalistmodel.amount = CalculatorAddincome
                }else if result_TF.text == "0.0"{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    btn_saveincomelist.isEnabled = false
                }
                let doubleResult = Double(textField.text ?? "0.00")
                CalculatorAddexpen = doubleResult ?? 0.00
                let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddexpen))
                textField.text = formattedNumber


            }
        }
        
        
            // นำค่าที่ผู้ใช้ป้อนมาใน textField ไปใช้ต่อหรือเก็บไว้ตามต้องการ
//            let finalnote = note_TF.text ?? ""
//        totalnote?(finalnote)
        }
    
    //  MARK: - AlmoFire API
        let apiClient : ApiClient = ApiClient()
        private let disposeBag = DisposeBag()
    //    Income Type
        var getincometypeRes : [SubGetTypeIncomeResponse] = [SubGetTypeIncomeResponse]()
    
    //    Expenses Type
        var getexpensestypeRes : [SubGetTypeIncomeResponse] = [SubGetTypeIncomeResponse]()
    //    Income Category
        var getincomeCatRes : [SubGetCateResponse] = [SubGetCateResponse]()
    
    //    Expenses Type
        var getexpensesCatRes : [SubGetCateResponse] = [SubGetCateResponse]()
    
    //    Income Category
        var getlistSaveAutoRes : [SubAutoSaveResponse] = [SubAutoSaveResponse]()
    //    Income datalist
        var createincomedatalistRes : [SubCreateDatalistRes] = [SubCreateDatalistRes]()
    
    //    Expenses datalist
        var createexpensesdatalistRes : [SubCreateDatalistRes] = [SubCreateDatalistRes]()
    
    //    Income Delete datalist
        var DelIncome : SubDel = SubDel()
        
  //    MARK: - Get API Income Type
    func GettypeIncomeDataApi() -> Observable<GetTypeIncomeResponse> {
        return apiClient.requestAPI(ApiRouter.Get(urlApi: "api/Type/GetAllTypeIncome"))
    }
            
        func GettypeIncome() {
            self.dispatchGroup?.enter()
            GettypeIncomeDataApi()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resData in
                    
//                    print(resData)
                    if resData.success == true {
                        self.getincometypeRes = resData.data
                        self.dispatchGroup?.leave()
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
    func GettypeExpensesDataApi() -> Observable<GetTypeIncomeResponse> {
            return apiClient.requestAPI(ApiRouter.Get(urlApi: "/api/Type/GetAllTypeExpenses"))
        }
                
    func GettypeExpenses() {
//        print("ID รายจ่าย" + "\(self.createincomedatalistmodel.idtype)")
        self.dispatchGroup?.enter()
        GettypeExpensesDataApi()
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { resData in
//                print(resData)
            if resData.success == true {
                self.getexpensestypeRes = resData.data
                print(resData.data)
                self.dispatchGroup?.leave()
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
//    MARK: - Category list
    func GetCategoryIncomeDataApi() -> Observable<GetCateResponse> {
            return apiClient.requestAPI(ApiRouter.Get(urlApi: "/api/Category/GetAllCategoryincome"))
        }
                
    func GetCategoryIncome() {
        self.dispatchGroup?.enter()
        GetCategoryIncomeDataApi()
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { resData in
//                        print(resData)
        if resData.success == true {
            self.getincomeCatRes = resData.data
            self.dispatchGroup?.leave()
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

    func GetCategoryExpensesDataApi() -> Observable<GetCateResponse> {
            return apiClient.requestAPI(ApiRouter.Get(urlApi: "/api/Category/GetAllCategoryExpenses"))
        }
                
    func GetCategoryExpenses() {
        self.dispatchGroup?.enter()
        GetCategoryExpensesDataApi()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
//                print(resData)
                if resData.success == true {
                    self.getexpensesCatRes = resData.data
                    self.dispatchGroup?.leave()
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
    
    func SaveAutoIncomeDataApi() -> Observable<AutoSaveResponse> {
                return apiClient.requestAPI(ApiRouter.Get(urlApi: "/api/ScheduleAutoSave/ListScheduleAuto"))
            }
                
    func SaveAutoIncome() {
        self.dispatchGroup?.enter()
        SaveAutoIncomeDataApi()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
//                print(resData)
                if resData.success == true {
                    self.getlistSaveAutoRes = resData.data
                    self.dispatchGroup?.leave()

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
//    MARK: - Add list
    func CreatelistDataApi(data : CreateDatalistModel) -> Observable<CreateDatalistRes> {
        return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/Incomes/CreateListIncome"))
    }
                
    func CreatelistData() {
        if let userInfo = self.appdelegate?.loadUserInfo() {
            createincomedatalistmodel.idmember = userInfo.idmember
        }
        self.dispatchGroup?.enter()
        CreatelistDataApi(data: createincomedatalistmodel)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
                if resData.success == true {
                    self.dispatchGroup?.leave()
                    if resData.data.create_success == true {
                        let alert = UIAlertController(title: "บันทึกรายการสำเร็จ", message: "", preferredStyle: .alert)
                        let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                            print(self.createincomedatalistmodel)

//                        let vc = storyborad.instantiateViewController(identifier: "Tabbar") as! Tabbar
            //            vc.product_data = select_data
//                            self.sendreport?(self.selectedType ?? "")
//                            self.sendreport?(self.unixTime ?? 0)
                            
                            self.navigationController?.popViewController(animated: true)
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                        alert.addAction(acceptAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    print("รายรับ : " + "\(resData)")

                }
//                    print("รายรับ : " + "\(resData)")

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
    
    func CreateexpenseslistDataApi(data : CreateDatalistModel) -> Observable<CreateExpensesDatalistRes> {
        return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/Expenses/CreateListExpenses"))
    }
                
    func CreateexpenseslistData() {
        if let userInfo = self.appdelegate?.loadUserInfo() {
            createincomedatalistmodel.idmember = userInfo.idmember
        }
        self.dispatchGroup?.enter()
        CreateexpenseslistDataApi(data: createincomedatalistmodel)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
                print(resData)
                if resData.success == true {
//                    print("รายจ่าย add : " + "\(self.createincomedatalistmodel)")
                    self.dispatchGroup?.leave()
                    if resData.data.createSuccess == true {
                        let alert = UIAlertController(title: "บันทึกรายการสำเร็จ", message: "", preferredStyle: .alert)
                        let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in  let storyborad = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyborad.instantiateViewController(identifier: "Tabbar") as! Tabbar

            //            vc.product_data = select_data
//                            self.navigationController?.popViewController(animated: true)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                        alert.addAction(acceptAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    print("รายจ่าย  : " + "\(resData)" + "รายจ่าย add : " + "\(self.createincomedatalistmodel)")
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
//    MARK: - Delete Api
    func DelIncomeDataApi() -> Observable<DelResModel> {
        
        return apiClient.requestAPI(ApiRouter.Delete(urlApi: "/api/Incomes/DeleteIncome", param: ["id" : Delincomemodel.id.convertToString ?? "" ]))
    }
    
    func DelIncomeData() {
        self.dispatchGroup?.enter()
        DelIncomeDataApi()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
                print(resData)
                if resData.success == true {
//                    print("รายจ่าย add : " + "\(self.createincomedatalistmodel)")
                    self.dispatchGroup?.leave()
                    if resData.data.is_Deleted == true {
                        let alert = UIAlertController(title: "ลบรายการสำเร็จ", message: "", preferredStyle: .alert)
                        let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                            self.navigationController?.popToViewController(ofClass: Tabbar.self) }
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
    
    func DelExpensesDataApi() -> Observable<DelResModel> {
        let transID = dataExpensestoDel.transaction_id
        Delincomemodel.id = transID
        return apiClient.requestAPI(ApiRouter.Delete(urlApi: "/api/Expenses/DeleteExpenses", param: ["id" : Delincomemodel.id.convertToString ?? "" ]))
        }
        
        func DelExpensesData() {
            self.dispatchGroup?.enter()
            DelExpensesDataApi()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resData in
                    
                    print(resData)
                    if resData.success == true {
    //                    print("รายจ่าย add : " + "\(self.createincomedatalistmodel)")
                        self.dispatchGroup?.leave()
                        if resData.data.is_Deleted == true {
                            let alert = UIAlertController(title: "ลบรายการสำเร็จ", message: "", preferredStyle: .alert)
                            let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                                self.navigationController?.popToViewController(ofClass: Tabbar.self) }
                            alert.addAction(acceptAction)
                            self.present(alert, animated: true, completion: nil)
                        }
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
    func UpdateIncomeAPI(data : UpdateincomeModel) -> Observable<UpdateincomeRes> {
            return apiClient.requestAPI(ApiRouter.Patch(data: data.convertToData, urlApi:"/api/Incomes/UpdateIncome"))
        }
            
        func Updateincomedata() {
            print(Updateincomemodel)
            UpdateIncomeAPI(data: Updateincomemodel)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resData in
                    
                    print("********* Edit Report : \(resData) ***********")
                    if resData.success == true {
                        if resData.data.is_Updated == true {
                            let alert = UIAlertController(title: "บันทึกรายการสำเร็จ", message: "", preferredStyle: .alert)
                            let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
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
    
func UpdateExpensesAPI(data : UpdateExpensesModel) -> Observable<UpdateExpensesRes> {
            return apiClient.requestAPI(ApiRouter.Patch(data: data.convertToData, urlApi:"/api/Expenses/UpdateExpenses"))
        }
            
        func Updateexpensesdata() {
            UpdateExpensesAPI(data: Updateexpensesmodel)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resData in
                    
            if resData.success == true {
                if resData.data.is_Updated == true {
                    let alert = UIAlertController(title: "บันทึกรายการสำเร็จ", message: "", preferredStyle: .alert)
                    let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
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
