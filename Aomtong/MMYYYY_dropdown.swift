//
//  MMYYYY_dropdown.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 3/1/2567 BE.
//

import UIKit

public protocol MMYYYY_dropdownDelegate {
    func clickSelectDatePicker(Date : String)
}

class MMYYYY_dropdown: UIViewController {
    
    @IBOutlet weak var MonthYearPicker: UIPickerView!
    @IBOutlet weak var MMYYYY_lb: UILabel!
    @IBOutlet weak var btn_acceptdate: UIButton!
    
    var delegate : MMYYYY_dropdownDelegate?
    var months : [String] = ["มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]
    var years  : [String] = []
    var actionstartdate : ((Int) -> Void)?
    var actionsendenddate : ((Int) -> Void)?


    var Tapselectdata: String = ""
    var strDate : String = ""
    var StartdateUnix : Int = 0
    var EnddateUnix : Int = 0
    
    var TypeState : stateType?
    
    public enum stateType {
        case Income
        case Expenses
        case month_list
        case year_list
        case month_summarize
        case year_summarize
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        MonthYearPicker.delegate = self
        MonthYearPicker.dataSource = self
        manageCalendar()
        switch TypeState {
        case .Income:
            if strDate != "" {
                let date = strDate.split(separator: " ")
                let year = String(Int(date[1])!)
                MonthYearPicker.selectRow(months.firstIndex(of: String(date[0])) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: year) ?? 0, inComponent: 1, animated: false)
            }else {
                MonthYearPicker.selectRow(months.firstIndex(of: String(Date().month)) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: String(Date().year)) ?? 0, inComponent: 1, animated: false)
            }
        case .Expenses:
            if strDate != "" {
                let date = strDate.split(separator: " ")
                let year = String(Int(date[1])!)
                MonthYearPicker.selectRow(months.firstIndex(of: String(date[0])) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: year) ?? 0, inComponent: 1, animated: false)
            }else {
                MonthYearPicker.selectRow(months.firstIndex(of: String(Date().month)) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: String(Date().year)) ?? 0, inComponent: 1, animated: false)
            }
        case .month_list:
            if strDate != "" {
                let date = strDate.split(separator: " ")
                let year = String(Int(date[1])!)
                MonthYearPicker.selectRow(months.firstIndex(of: String(date[0])) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: year) ?? 0, inComponent: 1, animated: false)
            }else {
                MonthYearPicker.selectRow(months.firstIndex(of: String(Date().month)) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: String(Date().year)) ?? 0, inComponent: 1, animated: false)
            }
        case .year_list:
            if strDate != "" {
                let date = strDate.split(separator: " ")
                let year = String(Int(date[0])!)
//                MonthYearPicker.selectRow(months.firstIndex(of: String(date[0])) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: year) ?? 0, inComponent: 0, animated: false)
            }else {
//                MonthYearPicker.selectRow(months.firstIndex(of: String(Date().month)) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: String(Date().year)) ?? 0, inComponent: 0, animated: false)
            }
        case .month_summarize:
            if strDate != "" {
                let date = strDate.split(separator: " ")
                let year = String(Int(date[1])!)
                MonthYearPicker.selectRow(months.firstIndex(of: String(date[0])) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: year) ?? 0, inComponent: 1, animated: false)
            }else {
                MonthYearPicker.selectRow(months.firstIndex(of: String(Date().month)) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: String(Date().year)) ?? 0, inComponent: 1, animated: false)
            }
        case .year_summarize:
            if strDate != "" {
                let date = strDate.split(separator: " ")
                let year = String(Int(date[0])!)
//                MonthYearPicker.selectRow(months.firstIndex(of: String(date[0])) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: year) ?? 0, inComponent: 0, animated: false)
            }else {
//                MonthYearPicker.selectRow(months.firstIndex(of: String(Date().month)) ?? 0, inComponent: 0, animated: false)
                MonthYearPicker.selectRow(years.firstIndex(of: String(Date().year)) ?? 0, inComponent: 0, animated: false)
            }
        default:
            break
        }
        
        MMYYYY_lb.text = "เลือกเดือน"
        
        switch TypeState {
        case .Income:
            btn_acceptdate.backgroundColor = ._81_C_8_E_4
        case .Expenses:
            btn_acceptdate.backgroundColor = .FF_8686
        case .month_list:
            btn_acceptdate.backgroundColor = ._81_C_8_E_4
        case .month_summarize:
            btn_acceptdate.backgroundColor = .FF_8686
        case .year_list:
            btn_acceptdate.backgroundColor = ._81_C_8_E_4
        case .year_summarize:
            btn_acceptdate.backgroundColor = .FF_8686
        default:
            btn_acceptdate.backgroundColor = ._81_C_8_E_4
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btn_AcceptDateaction(_ sender: Any) {
        self.delegate?.clickSelectDatePicker(Date: strDate)
        self.dismiss(animated: true)
    }
    
    func manageCalendar() {
        let calendar = Calendar(identifier: .gregorian)
        
        let dateNow = Date()
        var components = DateComponents()
        
        components.calendar = calendar
        
        components.year = -20
        let minYear = calendar.date(byAdding: components, to: dateNow) ?? Date()
        
        components.year = 20
        let maxYear = calendar.date(byAdding: components, to: dateNow) ?? Date()
        
        let formatyear = DateFormatter()
        formatyear.dateFormat = "yyyy"
        formatyear.locale = Locale(identifier: "en-GB")
        let strMinYear = formatyear.string(from: minYear)
        let strMaxYear = formatyear.string(from: maxYear)
        
        years = (Int(strMinYear)!...Int(strMaxYear)!).map{ String($0)}
    }
}

extension MMYYYY_dropdown : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100.0
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch TypeState {
        case .Income:
            return 2
        case .Expenses:
            return 2
        case .month_list:
            return 2
        case .month_summarize:
            return 2
        case .year_list:
            return 1
        case .year_summarize:
            return 1
        default:
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch TypeState {
        case .Income:
            switch component {
            case 0:
                return months.count
            case 1:
                return years.count
            default:
                return 0
            }
        case .Expenses:
            switch component {
            case 0:
                return months.count
            case 1:
                return years.count
            default:
                return 0
            }
        case .month_list:
            switch component {
            case 0:
                return months.count
            case 1:
                return years.count
            default:
                return 0
            }
        case .month_summarize:
            switch component {
            case 0:
                return months.count
            case 1:
                return years.count
            default:
                return 0
            }
        case .year_list:
            switch component {
//            case 0:
//                return months.count
            case 0:
                return years.count
            default:
                return 0
            }
        case .year_summarize:
            switch component {
//            case 0:
//                return months.count
            case 0:
                return years.count
            default:
                return 0
            }
        default:
            switch component {
            case 0:
                return months.count
            case 1:
                return years.count
            default:
                return 0
            }
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var text : String = ""
        
        switch TypeState {
        case .Income:
            switch component {
            case 0: text = "\(months[row])"
            case 1: text = "\(years[row])"
            default:
                break
            }
        case .Expenses:
            switch component {
            case 0: text = "\(months[row])"
            case 1: text = "\(years[row])"
            default:
                break
            }
        case .month_list:
            switch component {
            case 0: text = "\(months[row])"
            case 1: text = "\(years[row])"
            default:
                break
            }
        case .month_summarize:
            switch component {
            case 0: text = "\(months[row])"
            case 1: text = "\(years[row])"
            default:
                break
            }
        case .year_list:
            switch component {
//            case 0: text = "\(months[row])"
            case 0: text = years[row]
            default:
                break
            }
        case .year_summarize:
            switch component {
//            case 0: text = "\(months[row])"
            case 0: text = "\(years[row])"
            default:
                break
            }
        default:
            break
        }
        
        
        var label = view as? UILabel
        if (view == nil) {
            label = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
            label?.textColor = UIColor.black
            label?.text = text
            label?.textAlignment = .center
        }
        return label ?? UIView()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        

        switch TypeState {
        case .Income:
            let year_temp : Int = Int(years[pickerView.selectedRow(inComponent: 1)]) ?? 0
            let year = year_temp
    //        let month : Int = pickerView.selectedRow(inComponent: 0)
            strDate = "\((months[pickerView.selectedRow(inComponent: 0)])) \(year)"
            
    //        แปลงเป็นunix
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "th-th")
            dateFormatter.dateFormat = "MMMM yyyy"
            if let date = dateFormatter.date(from: strDate) {
                // ทำการแปลงเดือนและปีเป็น Date object
                    let components = strDate.components(separatedBy: " ")
                    if components.count == 2, let monthIndex = dateFormatter.monthSymbols.firstIndex(of: components[0]) {
                        let month = monthIndex + 1
                        if let year = Int(components[1]) {
                            let calendar = Calendar(identifier: .gregorian)
                            var dateComponents = DateComponents()
                            dateComponents.year = year
                            dateComponents.month = month
                            dateComponents.day = 1
                            let Setup = calendar.date(from: dateComponents) ?? Date()
    //                        if let startOfMonth = calendar.date(from: dateComponents),
                            if let startOfMonth = calendar.date(byAdding: DateComponents(hour: 7,second: 1), to: Setup),
                                let endOfMonth = calendar.date(byAdding: DateComponents(month: 1,minute: -1,second: -1), to: startOfMonth) {

                                let startTimeStamp = startOfMonth.timeIntervalSince1970
                                let endTimeStamp = endOfMonth.timeIntervalSince1970
                                
                                StartdateUnix = Int(startTimeStamp)
                                EnddateUnix = Int(endTimeStamp)
                                actionstartdate?(StartdateUnix)
                                actionsendenddate?(EnddateUnix)
                                print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startTimeStamp))")
                                print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endTimeStamp))")
                            } else {
                                print("ไม่สามารถคำนวณได้หลังการแปลง")
                            }
                        }
                    }

            } else {
                print("ไม่สามารถแปลงวันที่ได้")
            }
        case .Expenses:
            let year_temp : Int = Int(years[pickerView.selectedRow(inComponent: 1)]) ?? 0
            let year = year_temp
    //        let month : Int = pickerView.selectedRow(inComponent: 0)
            strDate = "\((months[pickerView.selectedRow(inComponent: 0)])) \(year)"
            
    //        แปลงเป็นunix
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "th-th")
            dateFormatter.dateFormat = "MMMM yyyy"
            
            if let date = dateFormatter.date(from: strDate) {
                // ทำการแปลงเดือนและปีเป็น Date object
                    let components = strDate.components(separatedBy: " ")
                    if components.count == 2, let monthIndex = dateFormatter.monthSymbols.firstIndex(of: components[0]) {
                        let month = monthIndex + 1
                        if let year = Int(components[1]) {
                            let calendar = Calendar(identifier: .gregorian)
                            var dateComponents = DateComponents()
                            dateComponents.year = year
                            dateComponents.month = month
                            dateComponents.day = 1
                            let Setup = calendar.date(from: dateComponents) ?? Date()
    //                        if let startOfMonth = calendar.date(from: dateComponents),
                            if let startOfMonth = calendar.date(byAdding: DateComponents(hour: 7,second: 1), to: Setup),
                                let endOfMonth = calendar.date(byAdding: DateComponents(month: 1,minute: -1,second: -1), to: startOfMonth) {

                                let startTimeStamp = startOfMonth.timeIntervalSince1970
                                let endTimeStamp = endOfMonth.timeIntervalSince1970
                                
                                StartdateUnix = Int(startTimeStamp)
                                EnddateUnix = Int(endTimeStamp)
                                actionstartdate?(StartdateUnix)
                                actionsendenddate?(EnddateUnix)
                                print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startTimeStamp))")
                                print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endTimeStamp))")
                            } else {
                                print("ไม่สามารถคำนวณได้หลังการแปลง")
                            }
                        }
                    }

            } else {
                print("ไม่สามารถแปลงวันที่ได้")
            }
        case .month_list:
            let year_temp : Int = Int(years[pickerView.selectedRow(inComponent: 1)]) ?? 0
            let year = year_temp
    //        let month : Int = pickerView.selectedRow(inComponent: 0)
            strDate = "\((months[pickerView.selectedRow(inComponent: 0)])) \(year)"
            
    //        แปลงเป็นunix
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "th-th")
            dateFormatter.dateFormat = "MMMM yyyy"
            if let date = dateFormatter.date(from: strDate) {
                // ทำการแปลงเดือนและปีเป็น Date object
                    let components = strDate.components(separatedBy: " ")
                    if components.count == 2, let monthIndex = dateFormatter.monthSymbols.firstIndex(of: components[0]) {
                        let month = monthIndex + 1
                        if let year = Int(components[1]) {
                            let calendar = Calendar(identifier: .gregorian)
                            var dateComponents = DateComponents()
                            dateComponents.year = year
                            dateComponents.month = month
                            dateComponents.day = 1
                            let Setup = calendar.date(from: dateComponents) ?? Date()
    //                        if let startOfMonth = calendar.date(from: dateComponents),
                            if let startOfMonth = calendar.date(byAdding: DateComponents(hour: 7,second: 1), to: Setup),
                                let endOfMonth = calendar.date(byAdding: DateComponents(month: 1,minute: -1,second: -1), to: startOfMonth) {

                                let startTimeStamp = startOfMonth.timeIntervalSince1970
                                let endTimeStamp = endOfMonth.timeIntervalSince1970
                                
                                StartdateUnix = Int(startTimeStamp)
                                EnddateUnix = Int(endTimeStamp)
                                actionstartdate?(StartdateUnix)
                                actionsendenddate?(EnddateUnix)
                                print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startTimeStamp))")
                                print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endTimeStamp))")
                            } else {
                                print("ไม่สามารถคำนวณได้หลังการแปลง")
                            }
                        }
                    }

            } else {
                print("ไม่สามารถแปลงวันที่ได้")
            }
        case .month_summarize:
            let year_temp : Int = Int(years[pickerView.selectedRow(inComponent: 1)]) ?? 0
            let year = year_temp
    //        let month : Int = pickerView.selectedRow(inComponent: 0)
            strDate = "\((months[pickerView.selectedRow(inComponent: 0)])) \(year)"
            
    //        แปลงเป็นunix
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "th-th")
            dateFormatter.dateFormat = "MMMM yyyy"
            
            if let date = dateFormatter.date(from: strDate) {
                // ทำการแปลงเดือนและปีเป็น Date object
                    let components = strDate.components(separatedBy: " ")
                    if components.count == 2, let monthIndex = dateFormatter.monthSymbols.firstIndex(of: components[0]) {
                        let month = monthIndex + 1
                        if let year = Int(components[1]) {
                            let calendar = Calendar(identifier: .gregorian)
                            var dateComponents = DateComponents()
                            dateComponents.year = year
                            dateComponents.month = month
                            dateComponents.day = 1
                            let Setup = calendar.date(from: dateComponents) ?? Date()
    //                        if let startOfMonth = calendar.date(from: dateComponents),
                            if let startOfMonth = calendar.date(byAdding: DateComponents(hour: 7,second: 1), to: Setup),
                                let endOfMonth = calendar.date(byAdding: DateComponents(month: 1,minute: -1,second: -1), to: startOfMonth) {

                                let startTimeStamp = startOfMonth.timeIntervalSince1970
                                let endTimeStamp = endOfMonth.timeIntervalSince1970
                                
                                StartdateUnix = Int(startTimeStamp)
                                EnddateUnix = Int(endTimeStamp)
                                actionstartdate?(StartdateUnix)
                                actionsendenddate?(EnddateUnix)
                                print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startTimeStamp))")
                                print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endTimeStamp))")
                            } else {
                                print("ไม่สามารถคำนวณได้หลังการแปลง")
                            }
                        }
                    }

            } else {
                print("ไม่สามารถแปลงวันที่ได้")
            }
        case .year_list:
            let year_temp: Int = Int(years[pickerView.selectedRow(inComponent: 0)]) ?? 0
            let Stringyear = String(year_temp)
            
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "yyyy"
            
            let YearDate = dateFormatter.date(from: Stringyear)
            let calendar = Calendar.current

            // ดึงวันแรกของปี
            let startofyear = calendar.date(from: calendar.dateComponents([.year], from: calendar.startOfDay(for: YearDate!)))
            let startyear = calendar.date(byAdding: DateComponents(hour: 7),to: startofyear!)

            // กำหนดเดือนแรกของปี (มกราคม)
//            let startOfMonth = Calendar.current.date(from: DateComponents(year: year)) ?? Date()

            // กำหนดเดือนสุดท้ายของปี (ธันวาคม)
            let endOfMonth = Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: startyear!) ?? Date()

            let startTimeStamp = startyear!.timeIntervalSince1970
            let endTimeStamp = endOfMonth.timeIntervalSince1970

            StartdateUnix = Int(startTimeStamp)
            EnddateUnix = Int(endTimeStamp)

            actionstartdate?(StartdateUnix)
            actionsendenddate?(EnddateUnix)

        case .year_summarize:
            let year_temp: Int = Int(years[pickerView.selectedRow(inComponent: 0)]) ?? 0
            let Stringyear = String(year_temp)
            
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "yyyy"
            
            let YearDate = dateFormatter.date(from: Stringyear)
            let calendar = Calendar.current

            // ดึงวันแรกของปี
            let startofyear = calendar.date(from: calendar.dateComponents([.year], from: calendar.startOfDay(for: YearDate!)))
            let startyear = calendar.date(byAdding: DateComponents(hour: 7),to: startofyear!)

            // กำหนดเดือนแรกของปี (มกราคม)
//            let startOfMonth = Calendar.current.date(from: DateComponents(year: year)) ?? Date()

            // กำหนดเดือนสุดท้ายของปี (ธันวาคม)
            let endOfMonth = Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: startyear!) ?? Date()

            let startTimeStamp = startyear!.timeIntervalSince1970
            let endTimeStamp = endOfMonth.timeIntervalSince1970

            StartdateUnix = Int(startTimeStamp)
            EnddateUnix = Int(endTimeStamp)

            actionstartdate?(StartdateUnix)
            actionsendenddate?(EnddateUnix)



        default:
            break
        }
        
        
    }
//    end picker
    func addsendstartUnixAction(handlerstartUnixtime: @escaping ((Int) -> Void)) {
        actionstartdate = handlerstartUnixtime
    }
    func addsendendUnixAction(handlerendUnixtime: @escaping ((Int) -> Void)) {
        actionsendenddate = handlerendUnixtime
    }
    
}
