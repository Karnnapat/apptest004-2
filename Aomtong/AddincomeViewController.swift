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
    public enum stateType {
        case delincome
        case delexpenses
        case Autosaveexpenses
        case Autosaveincome
        case income
        case expenses
    }
 
    var delState : stateType?
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
            
            unixTime = Int(unixTimestamp)
            createincomedatalistmodel.dateCreated = unixTime
        switch delState {
        case .delincome:
            Updateincomemodel.createdateTime = unixTime
        case .delexpenses:
            Updateexpensesmodel.createdateTime = unixTime
        case .Autosaveexpenses:
            break
        case .Autosaveincome:
            break
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
        handleDatetimePickerValueChange()
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
            btn_saveincomelist.backgroundColor = .FF_8686
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
            formatdate.locale = Locale(identifier: "th-TH")
            let selectedDay = formatdate.string(from: datetimepicker.date)
            let DayNow = formatdate.string(from: Date())
            if selectedDay < DayNow {
                self.createincomedatalistmodel.auto_schedule = 1
                self.btn_statusAutosave.text = "ไม่มี"
                self.btn_statusAutosave.textColor = .gray
                self.lb_Autosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                btn_SaveAuto.isEnabled = false
                btn_saveincomelist.isEnabled  = true
                btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
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
            
        }
    
//    MARK: - Back Button
    @IBAction func btn_back(_ sender: Any)
    {
//        let amount = String(datatoDel.amount)
        if btn_saveincomelist.isEnabled == false {
            self.navigationController?.popToViewController(ofClass: Tabbar.self)

        }else{
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
        result_TF.delegate = self
        result_TF.keyboardType = .decimalPad
        datetimepicker.calendar = Calendar(identifier: .gregorian)
        setupSegment()
        GettypeIncome()
        GettypeExpenses()
        GetCategoryIncome()
        GetCategoryExpenses()
        SaveAutoIncome()
        switch delState {
        case .delincome:
            lb_ShowTital.text = "แก้ไข"
            segment.selectedSegmentIndex = 0
            hideorshowline.isHidden =  false
            btn_DelData.isHidden = false
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
//            formatdate.locale = Locale(identifier: "th-TH")
            
            let ReDate = Double(datatoDel.timestamp ?? 0)
             ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())
            self.btn_statusAutosave.text = self.datatoDel.save_auto_name
            if self.datatoDel.save_auto_id != 1{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
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
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
//                datetimepicker.isEnabled = false
                btn_SaveAuto.isEnabled = false
            }else{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = false
                btn_SaveAuto.isEnabled = false
            }
            result_TF.text = self.datatoDel.amount
            Updateincomemodel.income_id = self.datatoDel.transaction_id
            handleDatetimePickerValueChange()
        case .delexpenses:
            lb_ShowTital.text = "แก้ไข"
            segment.selectedSegmentIndex = 1
            segment.selectedSegmentTintColor = .FF_8686
            btn_calculatornoac.backgroundColor = .FF_8686
            btn_saveincomelist.backgroundColor = .FF_8686
            hideorshowline.isHidden =  false
            btn_DelData.isHidden = false
            
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
//            formatdate.locale = Locale(identifier: "th-TH")
            
            let ReDate = Double(dataExpensestoDel.timestamp ?? 0)
             ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())
            self.btn_statusAutosave.text = self.dataExpensestoDel.save_auto_name
            if self.dataExpensestoDel.save_auto_id != 1{
//                self.datetimepicker.isEnabled = false
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
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
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
                self.btn_statusAutosave.textColor = .gray
                btn_SaveAuto.isEnabled = false
            }
            result_TF.text = self.dataExpensestoDel.amount
            Updateexpensesmodel.expenses_id = self.dataExpensestoDel.transaction_id
            handleDatetimePickerValueChange()
        case .Autosaveincome:
            lb_ShowTital.text = "แก้ไข"
            segment.selectedSegmentIndex = 0
            hideorshowline.isHidden =  false
            btn_DelData.isHidden = false
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
            let ReDate = Double(Autosavemodel.timestamp ?? 0)
             ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())
            self.btn_statusAutosave.text = self.Autosavemodel.save_auto_name
            if self.Autosavemodel.save_auto_id != 1{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
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
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
//                datetimepicker.isEnabled = false
                btn_SaveAuto.isEnabled = false
            }else{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = false
                btn_SaveAuto.isEnabled = false
            }
            handleDatetimePickerValueChange()
//            result_TF.text = self.datatoDel.amount
//            Updateincomemodel.income_id = self.datatoDel.transaction_id
        case .Autosaveexpenses:
            lb_ShowTital.text = "แก้ไข"
            segment.selectedSegmentIndex = 1
            segment.selectedSegmentTintColor = .FF_8686
            btn_calculatornoac.backgroundColor = .FF_8686
            btn_saveincomelist.backgroundColor = .FF_8686
            hideorshowline.isHidden =  false
            btn_DelData.isHidden = false
            
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
//            formatdate.locale = Locale(identifier: "th-TH")
            
            let ReDate = Double(Autosavemodel.timestamp ?? 0)
             ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())
            self.btn_statusAutosave.text = self.Autosavemodel.save_auto_name
            if self.Autosavemodel.save_auto_id != 1{
//                self.datetimepicker.isEnabled = false
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
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
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
                self.btn_statusAutosave.textColor = .gray
                btn_SaveAuto.isEnabled = false
            }
            handleDatetimePickerValueChange()
    case .income:
            lb_ShowTital.text = "แก้ไข"
            segment.selectedSegmentIndex = 0
            hideorshowline.isHidden =  false
            btn_DelData.isHidden = false
            let formatdate = DateFormatter()
            formatdate.dateFormat = "yyyy-MM-dd"
            formatdate.calendar = Calendar(identifier: .gregorian)
//            formatdate.locale = Locale(identifier: "th-TH")
            
            let ReDate = Double(dataIncomeSumlist.timestamp ?? 0)
             ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            let DayNow = formatdate.string(from: Date())
            self.btn_statusAutosave.text = self.dataIncomeSumlist.save_auto_name
            if self.dataIncomeSumlist.save_auto_id != 1{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
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
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
//                datetimepicker.isEnabled = false
                btn_SaveAuto.isEnabled = false
            }else{
                self.btn_statusAutosave.textColor = .gray
                self.img_Asave.image = UIImage(named: "graysaveauto")
                self.AoSOptions.image = UIImage(named: "grayopions")
                self.img_calendar.image = UIImage(named: "graycalendar")
                self.img_Ots.image = UIImage(named: "grayopions")
                self.lb_date.textColor = .gray
                self.lb_Autosave.textColor = .gray
//                datetimepicker.isEnabled = false
                btn_SaveAuto.isEnabled = false
            }
            Updateincomemodel.income_id = self.dataIncomeSumlist.transaction_id ?? 0
    case .expenses:
                    lb_ShowTital.text = "แก้ไข"
                    segment.selectedSegmentIndex = 1
                    segment.selectedSegmentTintColor = .FF_8686
                    btn_calculatornoac.backgroundColor = .FF_8686
                    btn_saveincomelist.backgroundColor = .FF_8686
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
                    if self.dataExpensesSumlist.save_auto_id != 1{
                        self.datetimepicker.isEnabled = false
                        self.btn_statusAutosave.textColor = .gray
                        self.img_Asave.image = UIImage(named: "graysaveauto")
                        self.AoSOptions.image = UIImage(named: "grayopions")
                        self.img_calendar.image = UIImage(named: "graycalendar")
                        self.img_Ots.image = UIImage(named: "grayopions")
                        self.lb_date.textColor = .gray
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
                        self.img_calendar.image = UIImage(named: "graycalendar")
                        self.img_Ots.image = UIImage(named: "grayopions")
                        self.lb_date.textColor = .gray
                        self.lb_Autosave.textColor = .gray
                        self.btn_statusAutosave.textColor = .gray
                        btn_SaveAuto.isEnabled = false
                    }
//            result_TF.text = self.dataExpensestoDel.amount
//            Updateexpensesmodel.expenses_id = self.dataExpensestoDel.transaction_id
            handleDatetimePickerValueChange()
        default:
            lb_ShowTital.text = "เพิ่มรายการ"
            segment.selectedSegmentIndex = 0
            view_Del.isHidden = true
            hideorshowline.isHidden =  true
            btn_DelData.isHidden = true
            handleDatetimePickerValueChange()
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        AllTap()
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
            btn_saveincomelist.backgroundColor = ._81_C_8_E_4
            if segment.selectedSegmentIndex == 0{
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
                    createincomedatalistmodel.auto_schedule = self.datatoDel.save_auto_id
                }else{
                    self.AutoSaveIncome = "ไม่มี"
                }
//                Updateincomemodel.amount = CalculatorAddincome
                Updateincomemodel.createdateTime = self.datatoDel.timestamp ?? 0
                IncomeTap()
            }
            handleDatetimePickerValueChange()
        case .delexpenses :
            segment.selectedSegmentTintColor = .FF_8686
            btn_calculatornoac.backgroundColor = .FF_8686
            btn_saveincomelist.backgroundColor = .FF_8686
            segment.selectedSegmentIndex = 1
            if segment.selectedSegmentIndex == 1{
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
        }
            handleDatetimePickerValueChange()
        case .Autosaveincome:
            segment.selectedSegmentIndex = 0
            segment.selectedSegmentTintColor = ._81_C_8_E_4
            btn_calculatornoac.backgroundColor = ._81_C_8_E_4
            btn_saveincomelist.backgroundColor = ._81_C_8_E_4
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
                    self.createincomedatalistmodel.auto_schedule = self.Autosavemodel.save_auto_id
                }else{
                    self.AutoSaveIncome = "ไม่มี"
                    createincomedatalistmodel.auto_schedule = 1
                }
//                Updateincomemodel.amount = CalculatorAddincome
                Updateincomemodel.createdateTime = self.Autosavemodel.timestamp ?? 0
                IncomeTap()
            }
            handleDatetimePickerValueChange()
        case .Autosaveexpenses:
            segment.selectedSegmentTintColor = .FF_8686
            btn_calculatornoac.backgroundColor = .FF_8686
            btn_saveincomelist.backgroundColor = .FF_8686
            segment.selectedSegmentIndex = 1
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
        }
            handleDatetimePickerValueChange()
    case .income:
                segment.selectedSegmentTintColor = ._81_C_8_E_4
                btn_calculatornoac.backgroundColor = ._81_C_8_E_4
                btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                segment.selectedSegmentIndex = 0
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
            }
            handleDatetimePickerValueChange()
    case .expenses:
                segment.selectedSegmentTintColor = .FF_8686
                btn_calculatornoac.backgroundColor = .FF_8686
                btn_saveincomelist.backgroundColor = .FF_8686
                segment.selectedSegmentIndex = 1
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
            }
            handleDatetimePickerValueChange()
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
            handleDatetimePickerValueChange()
        }
        
    }
    
    @IBAction func didchangesegment(_ sender: UISegmentedControl) {
       
//        if sender.selectedSegmentIndex == 0 {
//            segment.selectedSegmentTintColor = ._81_C_8_E_4
//            btn_calculatornoac.backgroundColor = ._81_C_8_E_4
//            btn_saveincomelist.backgroundColor = ._81_C_8_E_4
            
            switch delState {
            case .delincome:
                segment.selectedSegmentIndex = 0
//                if segment.selectedSegmentIndex == 0{
//                    
//                    segment.selectedSegmentTintColor = ._81_C_8_E_4
//                    btn_calculatornoac.backgroundColor = ._81_C_8_E_4
//                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
//                    
//                    let deldate = Double(datatoDel.timestamp ?? 0)
//                    let date = Date(timeIntervalSince1970: deldate)
//                    datetimepicker.date = date
//                    self.lb_SelectedType.text = self.datatoDel.type_name
//                    self.lb_SelectedCategory.text = self.datatoDel.category_name
//                    if self.datatoDel.description != ""{
//                        self.lb_NoteAdded.text = self.datatoDel.description
//                    }else{
//                        self.lb_NoteAdded.text = "ไม่มี"
//                    }
//                    if self.datatoDel.save_auto_name != ""{
//                        self.btn_statusAutosave.text = self.datatoDel.save_auto_name
//                    }else{
//                        self.btn_statusAutosave.text = "ไม่มี"
//                    }
//                    if result_TF.text != "0.0" {
//                        btn_saveincomelist.backgroundColor = ._81_C_8_E_4
//                        btn_saveincomelist.isEnabled = true
//            //            createincomedatalistmodel.amount = CalculatorAddincome
//                    }else if result_TF.text == "0.0"{
//                        btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                        btn_saveincomelist.isEnabled = false
//                    }
//                    IncomeTap()
//                }else if segment.selectedSegmentIndex == 1{
//                    segment.selectedSegmentTintColor = .FF_8686
//                    btn_calculatornoac.backgroundColor = .FF_8686
//                    btn_saveincomelist.backgroundColor = .FF_8686
//                    self.lb_SelectedType.text = "เลือก"
//                    self.lb_SelectedType.textColor = .FF_8686
//                    self.lb_NoteAdded.text = "ไม่มี"
//                    self.lb_SelectedAutoSave.text = "ไม่มี"
//                    self.lb_SelectedCategory.text = "เลือก"
//                    self.lb_SelectedCategory.textColor = .FF_8686
//                    self.result_TF.text = "0.00"
//                    if result_TF.text != "0.0" {
//                        btn_saveincomelist.backgroundColor = .FF_8686
//                        btn_saveincomelist.isEnabled = true
//            //            createincomedatalistmodel.amount = CalculatorAddincome
//                    }else if result_TF.text == "0.0"{
//                        btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                        btn_saveincomelist.isEnabled = false
//                    }
//                    datetimepicker.date = Date()
//                }
            case .delexpenses :
                segment.selectedSegmentIndex = 1
//                if segment.selectedSegmentIndex == 0{
//                segment.selectedSegmentTintColor = ._81_C_8_E_4
//                btn_calculatornoac.backgroundColor = ._81_C_8_E_4
//                btn_saveincomelist.backgroundColor = ._81_C_8_E_4
//                    
//                self.lb_SelectedType.text = "เลือก"
//                self.lb_SelectedType.textColor = .FF_8686
//                self.lb_NoteAdded.text = "ไม่มี"
//                self.lb_SelectedAutoSave.text = "ไม่มี"
//                self.lb_SelectedCategory.text = "เลือก"
//                self.lb_SelectedCategory.textColor = .FF_8686
//                self.result_TF.text = "0.00"
//                    if result_TF.text != "0.0" {
//                        btn_saveincomelist.backgroundColor = ._81_C_8_E_4
//                        btn_saveincomelist.isEnabled = true
//            //            createincomedatalistmodel.amount = CalculatorAddincome
//                    }else if result_TF.text == "0.0"{
//                        btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                        btn_saveincomelist.isEnabled = false
//                    }
//                datetimepicker.date = Date()
//            }else if segment.selectedSegmentIndex == 1{
//                segment.selectedSegmentTintColor = .FF_8686
//                btn_calculatornoac.backgroundColor = .FF_8686
//                btn_saveincomelist.backgroundColor = .FF_8686
//                let deldate = Double(dataExpensestoDel.timestamp ?? 0)
//                let date = Date(timeIntervalSince1970: deldate)
//                datetimepicker.date = date
//                self.lb_SelectedType.text = self.dataExpensestoDel.type_name
//                self.lb_SelectedCategory.text = self.dataExpensestoDel.category_name
//                if self.dataExpensestoDel.description != ""{
//                    self.lb_NoteAdded.text = self.dataExpensestoDel.description
//                }else{
//                    self.lb_NoteAdded.text = "ไม่มี"
//                }
//                if self.dataExpensestoDel.save_auto_name != ""{
//                    self.btn_statusAutosave.text = self.dataExpensestoDel.save_auto_name
//                }else{
//                    self.btn_statusAutosave.text = "ไม่มี"
//                }
//                result_TF.text = self.dataExpensestoDel.amount
//                if result_TF.text != "0.0" {
//                    btn_saveincomelist.backgroundColor = .FF_8686
//                    btn_saveincomelist.isEnabled = true
//        //            createincomedatalistmodel.amount = CalculatorAddincome
//                }else if result_TF.text == "0.0"{
//                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                    btn_saveincomelist.isEnabled = false
//                }
//                ExpenseTap()
//            }
            case .Autosaveincome:
                segment.selectedSegmentIndex = 0
            case .Autosaveexpenses:
                segment.selectedSegmentIndex = 1
            case .income:
                            segment.selectedSegmentIndex = 1
            case .expenses:
                            segment.selectedSegmentIndex = 1
            default:
                if segment.selectedSegmentIndex == 0{
                    segment.selectedSegmentTintColor = ._81_C_8_E_4
                    btn_calculatornoac.backgroundColor = ._81_C_8_E_4
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4

                    self.lb_SelectedType.text = self.Incometype
                    self.lb_SelectedCategory.text = self.IncomeCat
                    self.lb_NoteAdded.text = self.IncomeNote
                    self.btn_statusAutosave.text = self.AutoSaveIncome
                    let result = String(CalculatorAddincome)
                    result_TF.text = result
                    if result_TF.text != "0.0" {
                        btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                        btn_saveincomelist.isEnabled = true
            //            createincomedatalistmodel.amount = CalculatorAddincome
                    }else if result_TF.text == "0.0"{
                        btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                        btn_saveincomelist.isEnabled = false
                    }
                    IncomeTap()
                }else if segment.selectedSegmentIndex == 1{
                    segment.selectedSegmentTintColor = .FF_8686
                    btn_calculatornoac.backgroundColor = .FF_8686
                    btn_saveincomelist.backgroundColor = .FF_8686
                    self.lb_SelectedType.text = self.expensetype
                    self.lb_SelectedCategory.text = self.ExpenCat
                    self.lb_NoteAdded.text = self.ExpenNote
                    self.btn_statusAutosave.text = self.AutoSaveExpen
                    let result = String(CalculatorAddexpen)
                    result_TF.text = result
                    if result_TF.text != "0.0" {
                        btn_saveincomelist.backgroundColor = .FF_8686
                        btn_saveincomelist.isEnabled = true
            //            createincomedatalistmodel.amount = CalculatorAddincome
                    }else if result_TF.text == "0.0"{
                        btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                        btn_saveincomelist.isEnabled = false
                    }
                    ExpenseTap()
                }
            }

            return
//        }else if sender.selectedSegmentIndex == 1{
////            segment.selectedSegmentTintColor = .FF_8686
////            btn_calculatornoac.backgroundColor = .FF_8686
//            switch delState {
//            case .delexpenses:
//                self.lb_SelectedType.text = self.dataExpensestoDel.type_name
//                self.lb_SelectedCategory.text = self.dataExpensestoDel.category_name
//                if self.dataExpensestoDel.description != ""{
//                    self.lb_NoteAdded.text = self.dataExpensestoDel.description
//                }else{
//                    self.lb_NoteAdded.text = "ไม่มี"
//                }
//                if self.dataExpensestoDel.save_auto_name != ""{
//                    self.btn_statusAutosave.text = self.dataExpensestoDel.save_auto_name
//                }else{
//                    self.btn_statusAutosave.text = "ไม่มี"
//                }            
//                ExpenseTap()
//
//            case .delincome :
//                break
//            case nil:
//                self.lb_SelectedType.text = self.expensetype
//                self.lb_SelectedCategory.text = self.ExpenCat
//                self.lb_NoteAdded.text = self.ExpenNote
//                self.btn_statusAutosave.text = self.AutoSaveExpen
//                let result = String(CalculatorAddexpen)
//                result_TF.text = result
//            }
//            
//            if result_TF.text != "0.0" {
//                btn_saveincomelist.backgroundColor = .FF_8686
//                btn_saveincomelist.isEnabled = true
//    //            createincomedatalistmodel.amount = CalculatorAddincome
//            }else if result_TF.text == "0.0"{
//                btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
//                btn_saveincomelist.isEnabled = false
//            }
//            return
//        }else{
//            return
//        }
    }
    
//    MARK: - func Get data
    
    @objc func handleTap() {
            view.endEditing(true)
        }
    @objc func CategoryTap() {
        result_TF.endEditing(true)
        let storyborad = UIStoryboard(name: "Options", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "CategoryVC") as! CategoryVC
        vc.getIncomeCat = self.getincomeCatRes
        vc.addCatIncomeAction(handlerIncomeCat: {Catincome in
            self.IncomeCat = Catincome.category
            self.lb_SelectedCategory.text = Catincome.category
            self.createincomedatalistmodel.idcategory = Catincome.id
            switch self.delState {
            case .delincome:
                self.Updateincomemodel.category_id =  self.createincomedatalistmodel.idcategory ?? 0
                if self.Updateincomemodel.category_id != self.datatoDel.category_id{
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
                if self.Updateincomemodel.category_id != self.Autosavemodel.category_id{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .income:
                self.Updateincomemodel.category_id =  self.createincomedatalistmodel.idcategory ?? 0
                if self.Updateincomemodel.category_id != self.dataIncomeSumlist.category_id{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            default:
                self.createincomedatalistmodel.idcategory = Catincome.id
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
                if self.Updateexpensesmodel.category_id != self.dataExpensestoDel.category_id{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .Autosaveexpenses:
                self.Updateexpensesmodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
                if self.Updateexpensesmodel.category_id != self.Autosavemodel.category_id{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .Autosaveexpenses:
                self.Updateexpensesmodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
                if self.Updateexpensesmodel.category_id != self.dataExpensesSumlist.category_id{
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
                if self.Updateincomemodel.description != self.datatoDel.description{
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
                if self.Updateincomemodel.description != self.Autosavemodel.description{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .income:
                self.Updateincomemodel.description = self.createincomedatalistmodel.description ?? "ไม่มี"
                if self.Updateincomemodel.description != self.dataIncomeSumlist.description{
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
                if self.Updateexpensesmodel.description != self.dataExpensestoDel.description{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .Autosaveexpenses:
                self.Updateexpensesmodel.description = self.createincomedatalistmodel.description ?? "ไม่มี"
                if self.Updateexpensesmodel.description != self.Autosavemodel.description{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .expenses:
                self.Updateexpensesmodel.description = self.createincomedatalistmodel.description ?? "ไม่มี"
                if self.Updateexpensesmodel.description != self.dataExpensesSumlist.description{
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
                if self.Updateincomemodel.type_id != self.datatoDel.type_id{
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
                if self.Updateincomemodel.type_id != self.Autosavemodel.type_id{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .income:
                self.Updateincomemodel.type_id = self.createincomedatalistmodel.idtype ?? 0
                if self.Updateincomemodel.type_id != self.dataIncomeSumlist.type_id{
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
                if self.Updateexpensesmodel.type_id != self.dataExpensestoDel.type_id{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .Autosaveexpenses:
                self.Updateexpensesmodel.type_id = self.createincomedatalistmodel.idtype ?? 0
                if self.Updateexpensesmodel.type_id != self.Autosavemodel.type_id{
                    self.btn_saveincomelist.isEnabled = true
                    self.btn_saveincomelist.backgroundColor = .FF_8686
                }else{
                    self.btn_saveincomelist.isEnabled = false
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }
            case .Autosaveexpenses:
                self.Updateexpensesmodel.type_id = self.createincomedatalistmodel.idtype ?? 0
                if self.Updateexpensesmodel.type_id != self.dataExpensesSumlist.type_id{
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
            self.createincomedatalistmodel.auto_schedule = incomeautosave.id ?? 0
            
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
                if self.Updateincomemodel.auto_schedule != self.datatoDel.save_auto_id{
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
            case .delexpenses:
                break
            case .Autosaveincome:
                self.Updateincomemodel.auto_schedule = incomeautosave.id ?? 0
                self.btn_statusAutosave.text = self.AutoSaveIncome
                if self.Updateincomemodel.auto_schedule != self.Autosavemodel.save_auto_id{
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
            case .income:
                self.Updateincomemodel.auto_schedule = incomeautosave.id ?? 0
                self.btn_statusAutosave.text = self.AutoSaveIncome
                if self.Updateincomemodel.auto_schedule != self.dataIncomeSumlist.save_auto_id{
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
                if self.Updateexpensesmodel.auto_schedule != self.dataExpensestoDel.save_auto_id{
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
                if self.Updateexpensesmodel.auto_schedule != self.Autosavemodel.save_auto_id{
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
                if self.Updateexpensesmodel.auto_schedule != self.dataExpensesSumlist.save_auto_id{
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
            Updateexpensesmodel.createdateTime = self.Autosavemodel.timestamp ?? 0
            Updateexpensesmodel.auto_schedule = self.createincomedatalistmodel.auto_schedule ?? 0
            Updateexpensesdata()
        case .delexpenses:
            Updateexpensesmodel.expenses_id = self.dataExpensestoDel.transaction_id
            Updateexpensesmodel.type_id = self.createincomedatalistmodel.idtype ?? 0
            Updateexpensesmodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
            Updateexpensesmodel.description = self.createincomedatalistmodel.description ?? ""
            Updateexpensesmodel.amount = self.createincomedatalistmodel.amount ?? 0.00
            Updateexpensesmodel.createdateTime = self.dataExpensestoDel.timestamp ?? 0
            Updateexpensesmodel.auto_schedule = self.createincomedatalistmodel.auto_schedule ?? 0
            Updateexpensesdata()
        case .expenses:
            Updateexpensesmodel.expenses_id = self.dataExpensesSumlist.transaction_id ?? 0
            Updateexpensesmodel.type_id = self.createincomedatalistmodel.idtype ?? 0
            Updateexpensesmodel.category_id = self.createincomedatalistmodel.idcategory ?? 0
            Updateexpensesmodel.description = self.createincomedatalistmodel.description ?? ""
            Updateexpensesmodel.amount = self.createincomedatalistmodel.amount ?? 0.00
            Updateexpensesmodel.createdateTime = self.dataExpensesSumlist.timestamp ?? 0
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
                    if self.result_TF.text != "0.0" {
                        self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                        self.btn_saveincomelist.isEnabled = true
                        self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
                    }else if self.result_TF.text == "0.0"{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                        self.btn_saveincomelist.isEnabled = false
                        self.createincomedatalistmodel.amount = self.CalculatorAddincome
                    }
                }
            case .Autosaveincome:
                if self.result_TF.text == self.Autosavemodel.amount{
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    if self.result_TF.text != "0.0" {
                        self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                        self.btn_saveincomelist.isEnabled = true
                        self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
                    }else if self.result_TF.text == "0.0"{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                        self.btn_saveincomelist.isEnabled = false
                        self.createincomedatalistmodel.amount = self.CalculatorAddincome
                    }
                }
            case .income:
                if self.result_TF.text == self.dataIncomeSumlist.amount{
                    self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                }else{
                    if self.result_TF.text != "0.0" {
                        self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                        self.btn_saveincomelist.isEnabled = true
                        self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
                    }else if self.result_TF.text == "0.0"{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                        self.btn_saveincomelist.isEnabled = false
                        self.createincomedatalistmodel.amount = self.CalculatorAddincome
                    }
                }
            default:
                if self.result_TF.text != "0.0" {
                    self.btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                    self.btn_saveincomelist.isEnabled = true
                    self.createincomedatalistmodel.amount = Double(self.result_TF.text ?? "")
                }else if self.result_TF.text == "0.0"{
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
            vc.addCalAction(handleraddtotal: { addresult in
                self.CalculatorAddexpen = addresult
    //            self.createincomedatalistmodel.amount = addresult
                self.result_TF.text = String(self.CalculatorAddexpen)
                switch self.delState {
                case .delexpenses:
                    if self.result_TF.text == self.datatoDel.amount{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    }else{
                        if self.result_TF.text != "0.0" {
                            self.btn_saveincomelist.backgroundColor = .FF_8686
                            self.btn_saveincomelist.isEnabled = true
                            self.createincomedatalistmodel.amount = self.CalculatorAddexpen
                            self.Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
                        }else if self.result_TF.text == "0.0"{
                            self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                            self.btn_saveincomelist.isEnabled = false
                        }
                    }
                case .Autosaveexpenses:
                    if self.result_TF.text == self.Autosavemodel.amount{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    }else{
                        if self.result_TF.text != "0.0" {
                            self.btn_saveincomelist.backgroundColor = .FF_8686
                            self.btn_saveincomelist.isEnabled = true
                            self.createincomedatalistmodel.amount = self.CalculatorAddexpen
                            self.Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
                        }else if self.result_TF.text == "0.0"{
                            self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                            self.btn_saveincomelist.isEnabled = false
                        }
                    }
                case .expenses:
                    if self.result_TF.text == self.dataExpensesSumlist.amount{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    }else{
                        if self.result_TF.text != "0.0" {
                            self.btn_saveincomelist.backgroundColor = .FF_8686
                            self.btn_saveincomelist.isEnabled = true
                            self.createincomedatalistmodel.amount = self.CalculatorAddexpen
                            self.Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
                        }else if self.result_TF.text == "0.0"{
                            self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                            self.btn_saveincomelist.isEnabled = false
                        }
                    }
                default:
                    if self.result_TF.text != "0.0" {
                        self.btn_saveincomelist.backgroundColor = .FF_8686
                        self.btn_saveincomelist.isEnabled = true
                        self.createincomedatalistmodel.amount = self.CalculatorAddexpen
                        self.Updateincomemodel.amount = self.createincomedatalistmodel.amount ?? 0.00
                    }else if self.result_TF.text == "0.0"{
                        self.btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                        self.btn_saveincomelist.isEnabled = false
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
            self.dismiss(animated: true)
        }
        alert.addAction(acceptDelAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        }
    
    
//    MARK: - Tap func
    func AllTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    func ExpenseTap(){
        
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
    
//    MARK: - escaping
    func sendreportidAction(handlersendreport: @escaping ((Any) -> Void)) {
        sendreport = handlersendreport
    }
    
//    MARK: - textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if segment.selectedSegmentIndex == 0 {
            switch delState {
            case .delincome:
                if CalculatorAddincome == 0.0 {
                    let filteredString = datatoDel.amount!.filter { $0.isNumber || $0 == "."}
                    textField.text = String(filteredString)
                    let doubleTF = Double(textField.text ?? "")
                    CalculatorAddincome = doubleTF ?? 0
                }else if CalculatorAddincome != 0.0{
                    textField.text = String(CalculatorAddincome)
                }
            case .delexpenses:
                break
            case .Autosaveincome:
                let filteredString = Autosavemodel.amount!.filter { $0.isNumber || $0 == "."}
                textField.text = String(filteredString)
                let doubleTF = Double(textField.text ?? "")
                CalculatorAddincome = doubleTF ?? 0
            case .income:
                let filteredString = dataIncomeSumlist.amount!.filter { $0.isNumber || $0 == "."}
                textField.text = String(filteredString)
                let doubleTF = Double(textField.text ?? "")
                CalculatorAddincome = doubleTF ?? 0
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
//                textField.text = datatoDel.amount
//                let doubleTF = Double(textField.text ?? "")
//                CalculatorAddincome = doubleTF ?? 0
                break
            case .delexpenses:
                let filteredString = dataExpensestoDel.amount!.filter { $0.isNumber || $0 == "."}
                textField.text = String(filteredString)
                let doubleTF = Double(textField.text ?? "")
                CalculatorAddexpen = doubleTF ?? 0
            case .Autosaveexpenses:
                let filteredString = Autosavemodel.amount!.filter { $0.isNumber || $0 == "."}
                textField.text = String(filteredString)
                let doubleTF = Double(textField.text ?? "")
                CalculatorAddincome = doubleTF ?? 0
            case .expenses:
                let filteredString = dataExpensesSumlist.amount!.filter { $0.isNumber || $0 == "."}
                textField.text = String(filteredString)
                let doubleTF = Double(textField.text ?? "")
                CalculatorAddincome = doubleTF ?? 0
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
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddincome
                Updateincomemodel.amount = createincomedatalistmodel.amount ?? 0.00
            }else if segment.selectedSegmentIndex == 1 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddexpen)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
            }
        case .delexpenses:
            if segment.selectedSegmentIndex == 0 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddincome
                Updateincomemodel.amount = createincomedatalistmodel.amount ?? 0.00
            }else if segment.selectedSegmentIndex == 1 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddexpen)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
            }
        case .Autosaveexpenses:
            if segment.selectedSegmentIndex == 0 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddincome
                Updateincomemodel.amount = createincomedatalistmodel.amount ?? 0.00
            }else if segment.selectedSegmentIndex == 1 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddexpen)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
            }
        case .expenses:
            if segment.selectedSegmentIndex == 0 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddincome
                Updateincomemodel.amount = createincomedatalistmodel.amount ?? 0.00
            }else if segment.selectedSegmentIndex == 1 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddexpen)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
            }
        case .Autosaveincome:
            if segment.selectedSegmentIndex == 0 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddincome
                Updateincomemodel.amount = createincomedatalistmodel.amount ?? 0.00
            }else if segment.selectedSegmentIndex == 1 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddexpen)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
            }
        case .income:
            if segment.selectedSegmentIndex == 0 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddincome
                Updateincomemodel.amount = createincomedatalistmodel.amount ?? 0.00
            }else if segment.selectedSegmentIndex == 1 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddexpen)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddexpen
                Updateexpensesmodel.amount = createincomedatalistmodel.amount ?? 0.00
            }

        default:
            if segment.selectedSegmentIndex == 0 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddincome)
                default:
                    CalculatorAddincome = Double(Updatetotal) ?? 0
                }
                createincomedatalistmodel.amount = CalculatorAddincome
            }else if segment.selectedSegmentIndex == 1 {
                switch Double(Updatetotal) {
                case 0:
                    textField.text = String(CalculatorAddexpen)
                default:
                    CalculatorAddexpen = Double(Updatetotal) ?? 0
                }
                   createincomedatalistmodel.amount = CalculatorAddexpen
            }
        }
        
    }
        return Updatetotal.unicodeScalars.count <= 13
        }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if segment.selectedSegmentIndex == 0{
            switch delState {
            case .delincome:
                if result_TF.text == self.datatoDel.amount{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = false
                }else{
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                    btn_saveincomelist.isEnabled = true
//                    CalculatorAddincome = Double(result_TF.text ?? "") ?? 0
//                    createincomedatalistmodel.amount = CalculatorAddincome
                }
            case .delexpenses:
                break
            case .Autosaveexpenses:
                if result_TF.text == self.Autosavemodel.amount{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = false
                }else{
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                    btn_saveincomelist.isEnabled = true
                }
            case .Autosaveincome:
                if result_TF.text == self.Autosavemodel.amount{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = false
                }else{
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                    btn_saveincomelist.isEnabled = true
//                    CalculatorAddincome = Double(result_TF.text ?? "") ?? 0
//                    createincomedatalistmodel.amount = CalculatorAddincome
                }
            case .expenses:
                if result_TF.text == self.dataExpensesSumlist.amount{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = false
                }else{
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                    btn_saveincomelist.isEnabled = true
                }
            case .income:
                if result_TF.text == self.dataIncomeSumlist.amount{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.isEnabled = false
                }else{
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                    textField.text = formattedNumber
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                    btn_saveincomelist.isEnabled = true
//                    CalculatorAddincome = Double(result_TF.text ?? "") ?? 0
//                    createincomedatalistmodel.amount = CalculatorAddincome
                }
            default:
                if result_TF.text != "0.0" {
                    btn_saveincomelist.backgroundColor = ._81_C_8_E_4
                    btn_saveincomelist.isEnabled = true
                }else if result_TF.text == "0.0"{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    btn_saveincomelist.isEnabled = false
                }
                let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddincome))
                textField.text = formattedNumber
                
            }
        }else{
            switch delState {
            case .delincome:
                break
            case .delexpenses:
                if result_TF.text == self.dataExpensestoDel.amount{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    btn_saveincomelist.isEnabled = false
                }else{
                    btn_saveincomelist.backgroundColor = .FF_8686
                    btn_saveincomelist.isEnabled = true
//                    createincomedatalistmodel.amount = CalculatorAddexpen
                }
                let formattedNumber = numberFormatter.string(from: NSNumber(value: CalculatorAddexpen))
                textField.text = formattedNumber

            case .Autosaveexpenses:
                if result_TF.text == self.Autosavemodel.amount{
                    btn_saveincomelist.backgroundColor = .C_4_C_6_C_9
                    btn_saveincomelist.isEnabled = false
                }else{
                    btn_saveincomelist.backgroundColor = .FF_8686
                    btn_saveincomelist.isEnabled = true
//                    createincomedatalistmodel.amount = CalculatorAddexpen
                }
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
