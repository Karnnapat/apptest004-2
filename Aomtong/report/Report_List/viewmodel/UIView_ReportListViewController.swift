//
//  UIView_ReportListViewController.swift
//  Aomtung
//
//  Created by Karnnapat Kamolwisutthipong on 15/2/2567 BE.
//

import UIKit
import RxSwift

class UIView_ReportListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MMYYYY_dropdownDelegate {
   
    
    
    let contentView = UIView()
    
//    MARK: - Var
    var DateNow : String!
    var Week : String!
    var currentDate = Date()
    var calendar = Calendar.current
    let scrollView = UIScrollView()
    var appdelegate = UIApplication.shared.delegate as? AppDelegate
    var ReportSumarizemodel = GetReportModel()
    var FirstSunday :Date!
    var NewSunday :Date!
    var NewSaturday :Date!
    var startOfMonth :Date!
    var EndOfMonth :Date!
    var newstartOfMonth :Date!
    var startOfDate :Date!
    var newendOfDate :Date!
    var newstartOfDate :Date!
    var newendOfMonth :Date!
    var startOfYear :Date!
    var newstartOfYear :Date!
    var newendOfYear :Date!
    var strDate : String = ""

    @IBOutlet weak var Segment: UISegmentedControl!
    @IBOutlet weak var lb_showDate: UILabel!
//    @IBOutlet weak var btn_right: UIButton!
//    @IBOutlet weak var btn_left: UIButton!
    
    @IBOutlet weak var table_Report: UITableView!
    @IBOutlet weak var lb_UnStableIncome: UILabel!
    @IBOutlet weak var lb_StableIncome: UILabel!
    @IBOutlet weak var lb_totalIncome: UILabel!
    
    @IBOutlet weak var DropDown: UIButton!
    @IBOutlet weak var lb_UnNecessaryExpenses: UILabel!
    @IBOutlet weak var lb_NecessaryExpenses: UILabel!
    @IBOutlet weak var lb_totalExpenses: UILabel!

    @IBOutlet weak var LB_DatetimeTable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegment()
    }
    
    func inittableview(){
        if table_Report.delegate == nil{
            table_Report.delegate = self
            table_Report.dataSource = self
//            tableview.allowsSelection = false
            table_Report.separatorStyle = .none
            table_Report.reloadData()
        }else{
            table_Report.reloadData()
        }
    }
    
    func registercell(){
        table_Report.register(UINib(nibName: "TableViewCellforReportList", bundle: nil), forCellReuseIdentifier: "TableViewCellforReportList")
    }
//    MARK: - Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reportSulistmDataRes.first?.report_List_ALL.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellforReportList") as? TableViewCellforReportList else {return UITableViewCell()}
        switch reportSulistmDataRes.first?.report_List_ALL[indexPath.item].type_name {
        case "รายรับแน่นอน" :
            cell.lb_AccountType.textColor = ._064_F_6_C
            cell.lb_total.textColor = ._064_F_6_C
            cell.lb_total.text = "+ " + (self.reportSulistmDataRes.first?.report_List_ALL[indexPath.item].amount ?? "") + " ฿"
        case "รายรับไม่แน่นอน" :
            cell.lb_AccountType.textColor = ._6_DBAD_8
            cell.lb_total.textColor = ._6_DBAD_8
            cell.lb_total.text = "+ " + (self.reportSulistmDataRes.first?.report_List_ALL[indexPath.item].amount ?? "") + " ฿"
        case "รายจ่ายจำเป็น" :
            cell.lb_AccountType.textColor = .E_85757
            cell.lb_total.textColor = .E_85757
            cell.lb_total.text = "- " + (self.reportSulistmDataRes.first?.report_List_ALL[indexPath.item].amount ?? "") + " ฿"
        case "รายจ่ายไม่จำเป็น" :
            cell.lb_AccountType.textColor = .E_3_C_529
            cell.lb_total.textColor = .E_3_C_529
            cell.lb_total.text = "- " + (self.reportSulistmDataRes.first?.report_List_ALL[indexPath.item].amount ?? "") + " ฿"
        default:
            break
        }
        let time = Int((self.reportSulistmDataRes.first?.report_List_ALL[indexPath.item].timestamp)!)
        cell.lb_time.text = convertUnixTimestampToDateString(timestamp: TimeInterval(time))
        cell.lb_AccountType.text = self.reportSulistmDataRes.first?.report_List_ALL[indexPath.item].type_name
        cell.lb_DataType.text = self.reportSulistmDataRes.first?.report_List_ALL[indexPath.item].category_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "AddincomeViewController") as! AddincomeViewController
       
        switch reportSulistmDataRes.first?.report_List_ALL[indexPath.item].type_data {
        case "income" :
            vc.delState = .income
            vc.dataIncomeSumlist = reportSulistmDataRes.first?.report_List_ALL[indexPath.item] ?? InSubReportlistSummarizeRes()
//            vc.datatoDel = getreportRes.first?.report_month_list_income?.first?.report_List?[indexPath.row] ?? AllListReportInSubRes()
        case "expenses" :
            vc.delState = .expenses
            vc.dataExpensesSumlist = reportSulistmDataRes.first?.report_List_ALL[indexPath.item] ?? InSubReportlistSummarizeRes()
        
        default:
            break
        }
//        print("Collection view : " + "\(getreportRes[indexPath.row])")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    MARK: - convertUnix to String
    func convertUnixTimestampToDateString(timestamp: TimeInterval) -> String {
        // สร้าง Date จาก Unix timestamp
        let date = Date(timeIntervalSince1970: timestamp)

        // กำหนดรูปแบบของวันที่ที่คุณต้องการ
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"

         // เปลี่ยนรูปแบบตามความต้องการ

        // แปลง Date เป็นสตริงของวันที่
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
    
    func convertUnixTimestampToDateStringforDropDown(timestamp: TimeInterval) -> String {
        // สร้าง Date จาก Unix timestamp
        let date = Date(timeIntervalSince1970: timestamp)

        // กำหนดรูปแบบของวันที่ที่คุณต้องการ
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "th-TH")
        dateFormatter.dateFormat = "MMMM yyyy"

         // เปลี่ยนรูปแบบตามความต้องการ

        // แปลง Date เป็นสตริงของวันที่
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
    func convertUnixTimestampToDateStringforYear(timestamp: TimeInterval) -> String {
        // สร้าง Date จาก Unix timestamp
        let date = Date(timeIntervalSince1970: timestamp)

        // กำหนดรูปแบบของวันที่ที่คุณต้องการ
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "th-TH")
        dateFormatter.dateFormat = "yyyy"

         // เปลี่ยนรูปแบบตามความต้องการ

        // แปลง Date เป็นสตริงของวันที่
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
    
    
    //      MARK: - Segment
        func setupSegment(){
            Segment.selectedSegmentIndex = 0
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "dd MMMM yyyy"
            
            startOfDate = calendar.startOfDay(for: currentDate)
            DateNow = dateFormatter.string(from: Date())
            if let startdate = calendar.date(byAdding: DateComponents(hour: 7,second: 1),to: startOfDate),
               let endOfdate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate) {

                let startTimeStamp = startdate.timeIntervalSince1970
                let endTimeStamp = endOfdate.timeIntervalSince1970

                let startDate = Int(startTimeStamp)
                let endDate = Int(endTimeStamp)
                ReportSumarizemodel.start_timestamp = startDate
                ReportSumarizemodel.end_timestamp = endDate
                ReportSumarizemodel.datatype = "day"
                if let userInfo = self.appdelegate?.loadUserInfo() {
                    ReportSumarizemodel.idmember = userInfo.idmember
                }
                LB_DatetimeTable.text = dateFormatter.string(from: startdate)
                ReportSumarizeData()
                print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startDate))")
                print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endDate))")
            } else {
                print("ไม่สามารถคำนวณได้หลังการแปลง")
            }

        
            lb_showDate.text = DateNow
        }
    
    @IBAction func btn_left(_ sender: Any) {
        switch Segment.selectedSegmentIndex {
//       MARK: - Left Button Day
        case 0:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "dd MMMM yyyy"
//            let date = dateFormatter.date(from: DateNow) ?? Date()
//            let RewindSundayoneweek = calendar.date(byAdding: DateComponents(day: -1 ), to: date)!
            
            startOfDate = calendar.startOfDay(for: currentDate)
            if newstartOfDate == nil{
                if let startdate = calendar.date(byAdding: DateComponents(day: -1,hour: 7,second: 1),to: startOfDate),
                   let endOfdate = calendar.date(byAdding: DateComponents(day: 1, second: -2),to: startdate) {

                    let startTimeStamp = startdate.timeIntervalSince1970
                    let endTimeStamp = endOfdate.timeIntervalSince1970
                    newstartOfDate = startdate
                    newendOfDate = endOfdate
                    startOfDate = newstartOfDate
                    let startDate = Int(startTimeStamp)
                    let endDate = Int(endTimeStamp)
                    ReportSumarizemodel.start_timestamp = startDate
                    ReportSumarizemodel.end_timestamp = endDate
                    ReportSumarizemodel.datatype = "day"
                    if let userInfo = self.appdelegate?.loadUserInfo() {
                        ReportSumarizemodel.idmember = userInfo.idmember
                    }
                    lb_showDate.text = dateFormatter.string(from: newstartOfDate)
                    LB_DatetimeTable.text = dateFormatter.string(from: newstartOfDate)
                    ReportSumarizeData()
                    print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startDate))")
                    print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endDate))")
                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
            }else{
                if let startdate = calendar.date(byAdding: DateComponents(day: -1),to: newstartOfDate),
                let endOfdate = calendar.date(byAdding: DateComponents(day: -1), to: newendOfDate) {

                    let startTimeStamp = startdate.timeIntervalSince1970
                    let endTimeStamp = endOfdate.timeIntervalSince1970
                    newstartOfDate = startdate
                    newendOfDate = endOfdate
                    startOfDate = newstartOfDate
                    let startDate = Int(startTimeStamp)
                    let endDate = Int(endTimeStamp)
                    ReportSumarizemodel.start_timestamp = startDate
                    ReportSumarizemodel.end_timestamp = endDate
                    ReportSumarizemodel.datatype = "day"
                    if let userInfo = self.appdelegate?.loadUserInfo() {
                        ReportSumarizemodel.idmember = userInfo.idmember
                    }
                    lb_showDate.text = dateFormatter.string(from: newstartOfDate)
                    LB_DatetimeTable.text = dateFormatter.string(from: newstartOfDate)
                    ReportSumarizeData()
                    print("Unix timestamp เริ่มต้นของวัน (หลังการแปลง): \(Int(startDate))")
                    print("Unix timestamp สุดท้ายของวัน (หลังการแปลง): \(Int(endDate))")
                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
            }
//            print("Is Tapped")
//       MARK: - Left Button Week
        case 1:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "dd MMMM yyyy"
            
            if NewSunday == nil{
                let RewindSundayoneweek = calendar.date(byAdding: DateComponents(day: -7,hour: 7), to: FirstSunday)!
                let RewindSaturDayoneweek = calendar.date(byAdding: DateComponents(day: 7,second: -1), to: RewindSundayoneweek)!
                let Sunday = calendar.date(byAdding: DateComponents(hour: -7),to: NewSunday)
                let Sat = calendar.date(byAdding: DateComponents(hour: -7),to: NewSaturday)
                let FSunday = dateFormatter.string(from: Sunday!)
                let FSaturday = dateFormatter.string(from: Sat!)
                NewSunday = RewindSundayoneweek
                NewSaturday = RewindSaturDayoneweek
                FirstSunday = NewSunday

    //            DateNow = dateFormatter.string(from: Date())
                let startTimeStamp = NewSunday.timeIntervalSince1970
                let endTimeStamp = NewSaturday.timeIntervalSince1970
                print("Unix timestamp เริ่มต้นของสัปดาห์ (หลังการแปลง): \(Int(startTimeStamp))")
                print("Unix timestamp สุดท้ายของสัปดาห์ (หลังการแปลง): \(Int(endTimeStamp))")
                if let userInfo = self.appdelegate?.loadUserInfo() {
                    ReportSumarizemodel.idmember = userInfo.idmember
                }
                ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                ReportSumarizemodel.datatype = "week"

                lb_showDate.text = "\(FSunday) " + "- \(FSaturday)"
                LB_DatetimeTable.text = "\(FSunday) " + "- \(FSaturday)"
                ReportSumarizeData()
            }else{
                let RewindSundayoneweek = calendar.date(byAdding: DateComponents(day: -7), to: NewSunday)!
                let RewindSaturDayoneweek = calendar.date(byAdding: DateComponents(day: -7), to: NewSaturday)!
                
                let showUserFirstDayofweek = calendar.date(byAdding: DateComponents(day: 7,hour: -7), to: NewSunday)!
                let showUserEndDayofweek = calendar.date(byAdding: DateComponents(day: 7,hour: -7), to: NewSaturday)!
                
                let FSunday = dateFormatter.string(from: showUserFirstDayofweek)
                let FSaturday = dateFormatter.string(from: showUserEndDayofweek)

                NewSunday = RewindSundayoneweek
                NewSaturday = RewindSaturDayoneweek
                FirstSunday = NewSunday
                let startTimeStamp = NewSunday.timeIntervalSince1970
                let endTimeStamp = NewSaturday.timeIntervalSince1970
    //            DateNow = dateFormatter.string(from: Date())
                print("Unix timestamp เริ่มต้นของสัปดาห์ (หลังการแปลง): \(Int(startTimeStamp))")
                print("Unix timestamp สุดท้ายของสัปดาห์ (หลังการแปลง): \(Int(endTimeStamp))")
                if let userInfo = self.appdelegate?.loadUserInfo() {
                    ReportSumarizemodel.idmember = userInfo.idmember
                }
                ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                ReportSumarizemodel.datatype = "week"
                ReportSumarizeData()

                lb_showDate.text = "\(FSunday) " + "- \(FSaturday)"
                LB_DatetimeTable.text = "\(FSunday) " + "- \(FSaturday)"
            }
//       MARK: - Left Button Month
        case 2:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "MMMM yyyy"

            let strDate = dateFormatter.string(from: Date())
            let components = strDate.components(separatedBy: " ")

            let monthIndex = dateFormatter.monthSymbols.firstIndex(of: components[0])!
            let month = monthIndex + 1

            if let year = Int(components[1]) {
                let calendar = Calendar(identifier: .gregorian)
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = month
                dateComponents.day = 1
//                startOfMonth = calendar.date(from: dateComponents)!
                if newstartOfMonth == nil{
                    if let startdate = calendar.date(byAdding: DateComponents(month: -1 ,hour: 7,second: 1),to: startOfMonth),
                    let endOfMonth = calendar.date(byAdding: DateComponents(month: 1 ,minute: -1,second:  -1), to: startdate) {

                        let startTimeStamp = startdate.timeIntervalSince1970
                        let endTimeStamp = endOfMonth.timeIntervalSince1970
                        newstartOfMonth = startdate
                        EndOfMonth = endOfMonth
                        newendOfMonth = endOfMonth
                        startOfMonth = newstartOfMonth

//                        let startDate = Int(startTimeStamp)
//                        let endDate = Int(endTimeStamp)
                        lb_showDate.text = dateFormatter.string(from: startdate)
                        LB_DatetimeTable.text = dateFormatter.string(from: startdate)
                        if let userInfo = self.appdelegate?.loadUserInfo() {
                            ReportSumarizemodel.idmember = userInfo.idmember
                        }
                        ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                        ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                        ReportSumarizemodel.datatype = "month"
                        ReportSumarizeData()
                        print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startTimeStamp))")
                        print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endTimeStamp))")
                    } else {
                        print("ไม่สามารถคำนวณได้หลังการแปลง")
                    }
                }else{
                    newstartOfMonth = startOfMonth
                    if let startdate = calendar.date(byAdding: DateComponents(month: -1),to: newstartOfMonth),
                       let endOfMonth = calendar.date(byAdding: DateComponents(month: -1), to: newendOfMonth) {

                        let startTimeStamp = startdate.timeIntervalSince1970
                        let endTimeStamp = endOfMonth.timeIntervalSince1970
                        newstartOfMonth = startdate
                        newendOfMonth = endOfMonth
                        startOfMonth = newstartOfMonth

//                        let startDate = Int(startTimeStamp)
//                        let endDate = Int(endTimeStamp)
                        let strmonth = dateFormatter.string(from: newstartOfMonth)
                        if let userInfo = self.appdelegate?.loadUserInfo() {
                            ReportSumarizemodel.idmember = userInfo.idmember
                        }
                        ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                        ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                        ReportSumarizemodel.datatype = "month"
                        ReportSumarizeData()
                        lb_showDate.text = strmonth
                        LB_DatetimeTable.text = strmonth
                        print("newUnix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startTimeStamp))")
                        print("newUnix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endTimeStamp))")
                    } else {
                        print("ไม่สามารถคำนวณได้หลังการแปลง")
                    }
                }
            }
            
//       MARK: - Left Button Year
        case 3:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "yyyy"
            let calendar = Calendar.current
            let currentDate = Date()

            // ดึงวันแรกของปี
//            startOfYear = calendar.date(from: calendar.dateComponents([.year], from: calendar.startOfDay(for: currentDate)))
            if newstartOfYear == nil{
                if let startYear = calendar.date(byAdding: DateComponents(year: -1,hour: 7),to: startOfYear),
                   let endOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1,second: -1), to: startYear){

                    let startTimeStamp = startYear.timeIntervalSince1970
                    let endTimeStamp = endOfYear.timeIntervalSince1970
                    newstartOfYear = startYear
                    newendOfYear = endOfYear
                    startOfYear = newstartOfYear

    //                        let startDate = Int(startTimeStamp)
    //                        let endDate = Int(endTimeStamp)
                    let strYear = dateFormatter.string(from: newstartOfYear)
                    if let userInfo = self.appdelegate?.loadUserInfo() {
                        ReportSumarizemodel.idmember = userInfo.idmember
                    }
                    ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                    ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                    ReportSumarizemodel.datatype = "year"
                    ReportSumarizeData()
                    lb_showDate.text = strYear
                    LB_DatetimeTable.text = strYear
                    print("newUnix timestamp เริ่มต้นของปี (หลังการแปลง): \(Int(startTimeStamp))")
                    print("newUnix timestamp สุดท้ายของปี (หลังการแปลง): \(Int(endTimeStamp))")
                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
            }else{
                newstartOfYear = startOfYear
                if let startYear = calendar.date(byAdding: DateComponents(year: -1),to: newstartOfYear),
                   let endOfYear = calendar.date(byAdding: DateComponents(year: -1), to: newendOfYear){

                    let startTimeStamp = startYear.timeIntervalSince1970
                    let endTimeStamp = endOfYear.timeIntervalSince1970
                    newstartOfYear = startYear
                    newendOfYear = endOfYear
                    startOfYear = newstartOfYear

    //                        let startDate = Int(startTimeStamp)
    //                        let endDate = Int(endTimeStamp)
                    let strYear = dateFormatter.string(from: newstartOfYear)
                    if let userInfo = self.appdelegate?.loadUserInfo() {
                        ReportSumarizemodel.idmember = userInfo.idmember
                    }
                    ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                    ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                    ReportSumarizemodel.datatype = "year"
                    ReportSumarizeData()
                    lb_showDate.text = strYear
                    LB_DatetimeTable.text = strYear
                    print("newUnix timestamp เริ่มต้นของปี (หลังการแปลง): \(Int(startTimeStamp))")
                    print("newUnix timestamp สุดท้ายของปี (หลังการแปลง): \(Int(endTimeStamp))")
                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
            }

            
//            DateNow = dateFormatter.string(from: Date())
//            lb_Date.text = DateNow
        default:
            break
        }
    }
    
    @IBAction func btn_right(_ sender: Any) {
        switch Segment.selectedSegmentIndex {
//       MARK: - Right Button Day
        case 0:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "dd MMMM yyyy"
//            let RewindSundayoneweek = calendar.date(byAdding: DateComponents(day: -1 ), to: date)!
            
            startOfDate = calendar.startOfDay(for: currentDate)
            if newstartOfDate == nil{
                if let startdate = calendar.date(byAdding: DateComponents(day: 1,hour: 7,second: 1),to: startOfDate),
                   let endOfdate = calendar.date(byAdding: DateComponents(day: 1,hour: 7,second: 1),to: startdate) {

                    let startTimeStamp = startdate.timeIntervalSince1970
                    let endTimeStamp = endOfdate.timeIntervalSince1970
                    newstartOfDate = startdate
                    newendOfDate = endOfdate
                    startOfDate = newstartOfDate
                    let startDate = Int(startTimeStamp)
                    let endDate = Int(endTimeStamp)
                    ReportSumarizemodel.start_timestamp = startDate
                    ReportSumarizemodel.end_timestamp = endDate
                    ReportSumarizemodel.datatype = "day"
                    if let userInfo = self.appdelegate?.loadUserInfo() {
                        ReportSumarizemodel.idmember = userInfo.idmember
                    }
                    lb_showDate.text = dateFormatter.string(from: newstartOfDate)
                    LB_DatetimeTable.text = dateFormatter.string(from: newstartOfDate)
                    ReportSumarizeData()
                    print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startDate))")
                    print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endDate))")
                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
            }else{
                if let startdate = calendar.date(byAdding: DateComponents(day: 1),to: newstartOfDate),
                let endOfdate = calendar.date(byAdding: DateComponents(day: 1), to: newendOfDate) {

                    let startTimeStamp = startdate.timeIntervalSince1970
                    let endTimeStamp = endOfdate.timeIntervalSince1970
                    newstartOfDate = startdate
                    newendOfDate = endOfdate
                    startOfDate = newstartOfDate
                    let startDate = Int(startTimeStamp)
                    let endDate = Int(endTimeStamp)
                    ReportSumarizemodel.start_timestamp = startDate
                    ReportSumarizemodel.end_timestamp = endDate
                    ReportSumarizemodel.datatype = "day"
                    if let userInfo = self.appdelegate?.loadUserInfo() {
                        ReportSumarizemodel.idmember = userInfo.idmember
                    }
                    lb_showDate.text = dateFormatter.string(from: newstartOfDate)
                    LB_DatetimeTable.text = dateFormatter.string(from: newstartOfDate)
                    ReportSumarizeData()
                    print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startDate))")
                    print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endDate))")
                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
            }
//       MARK: - Right Button Week
        case 1:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "dd MMMM yyyy"
            
            if NewSunday == nil{
                let RewindSundayoneweek = calendar.date(byAdding: DateComponents(day: 7, hour: 7), to: FirstSunday)!
                let RewindSaturDayoneweek = calendar.date(byAdding: DateComponents(day: 7,second: -1), to: RewindSundayoneweek)!
                
                let showUserFirstDayofweek = calendar.date(byAdding: DateComponents(day: 7), to: FirstSunday)!
                let showUserEndDayofweek = calendar.date(byAdding: DateComponents(day: 7,second: -1), to: showUserFirstDayofweek)!
                
                let FSunday = dateFormatter.string(from: showUserFirstDayofweek)
                let FSaturday = dateFormatter.string(from: showUserEndDayofweek)
                
                NewSunday = RewindSundayoneweek
                NewSaturday = RewindSaturDayoneweek
                FirstSunday = NewSunday
                
                let startTimeStamp = NewSunday.timeIntervalSince1970
                let endTimeStamp = NewSaturday.timeIntervalSince1970
                
                print("Unix timestamp เริ่มต้นของสัปดาห์ (หลังการแปลง): \(Int(startTimeStamp))")
                print("Unix timestamp สุดท้ายของสัปดาห์ (หลังการแปลง): \(Int(endTimeStamp))")
                if let userInfo = self.appdelegate?.loadUserInfo() {
                    ReportSumarizemodel.idmember = userInfo.idmember
                }
                ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                ReportSumarizemodel.datatype = "week"
                ReportSumarizeData()

                lb_showDate.text = "\(FSunday) " + "- \(FSaturday)"
                LB_DatetimeTable.text = "\(FSunday) " + "- \(FSaturday)"
            }else{
                let RewindSundayoneweek = calendar.date(byAdding: DateComponents(day: 7), to: NewSunday)!
                let RewindSaturDayoneweek = calendar.date(byAdding: DateComponents(day: 7), to: NewSaturday)!
                
                let showUserFirstDayofweek = calendar.date(byAdding: DateComponents(day: 7,hour: -7), to: NewSunday)!
                let showUserEndDayofweek = calendar.date(byAdding: DateComponents(day: 7,hour: -7), to: NewSaturday)!
                
                let FSunday = dateFormatter.string(from: showUserFirstDayofweek)
                let FSaturday = dateFormatter.string(from: showUserEndDayofweek)

                NewSunday = RewindSundayoneweek
                NewSaturday = RewindSaturDayoneweek
                FirstSunday = NewSunday
                let startTimeStamp = NewSunday.timeIntervalSince1970
                let endTimeStamp = NewSaturday.timeIntervalSince1970
                print("Unix timestamp เริ่มต้นของสัปดาห์ (หลังการแปลง): \(Int(startTimeStamp))")
                print("Unix timestamp สุดท้ายของสัปดาห์ (หลังการแปลง): \(Int(endTimeStamp))")
                if let userInfo = self.appdelegate?.loadUserInfo() {
                    ReportSumarizemodel.idmember = userInfo.idmember
                }
                ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                ReportSumarizemodel.datatype = "week"
                ReportSumarizeData()

                lb_showDate.text = "\(FSunday) " + "- \(FSaturday)"
                LB_DatetimeTable.text = "\(FSunday) " + "- \(FSaturday)"
                //            DateNow = dateFormatter.string(from: Date())
            }
//       MARK: - Right Button Month
        case 2:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "MMMM yyyy"

            let strDate = dateFormatter.string(from: Date())
            let components = strDate.components(separatedBy: " ")

            let monthIndex = dateFormatter.monthSymbols.firstIndex(of: components[0])!
            let month = monthIndex + 1

            if let year = Int(components[1]) {
                let calendar = Calendar(identifier: .gregorian)
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = month
                dateComponents.day = 1
//                startOfMonth = calendar.date(from: dateComponents)!
                if newstartOfMonth == nil{
                    if let startdate = calendar.date(byAdding: DateComponents(month: 1 ,hour: 7,minute:1 ,second: 1),to: startOfMonth),
                    let endOfMonth = calendar.date(byAdding: DateComponents(month: 1 ,minute: -1,second: -2), to: startdate) {

                        let startTimeStamp = startdate.timeIntervalSince1970
                        let endTimeStamp = endOfMonth.timeIntervalSince1970
                        newstartOfMonth = startdate
                        newendOfMonth = endOfMonth
                        startOfMonth = newstartOfMonth

//                        let startDate = Int(startTimeStamp)
//                        let endDate = Int(endTimeStamp)
                        if let userInfo = self.appdelegate?.loadUserInfo() {
                            ReportSumarizemodel.idmember = userInfo.idmember
                        }
                        ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                        ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                        ReportSumarizemodel.datatype = "month"
                        ReportSumarizeData()

                        lb_showDate.text = dateFormatter.string(from: startdate)
                        LB_DatetimeTable.text = dateFormatter.string(from: startdate)
                        print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startTimeStamp))")
                        print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endTimeStamp))")
                    } else {
                        print("ไม่สามารถคำนวณได้หลังการแปลง")
                    }
                }else{
                    newstartOfMonth = startOfMonth
                    if let startdate = calendar.date(byAdding: DateComponents(month: 1),to: newstartOfMonth),
                       let endOfMonth = calendar.date(byAdding: DateComponents(month: 1), to: newendOfMonth) {

                        let startTimeStamp = startdate.timeIntervalSince1970
                        let endTimeStamp = endOfMonth.timeIntervalSince1970
                        newstartOfMonth = startdate
                        newendOfMonth = endOfMonth
                        startOfMonth = newstartOfMonth

//                        let startDate = Int(startTimeStamp)
//                        let endDate = Int(endTimeStamp)
                        let strmonth = dateFormatter.string(from: newstartOfMonth)
                        if let userInfo = self.appdelegate?.loadUserInfo() {
                            ReportSumarizemodel.idmember = userInfo.idmember
                        }
                        ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                        ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                        ReportSumarizemodel.datatype = "month"
                        ReportSumarizeData()

                        lb_showDate.text = strmonth
                        LB_DatetimeTable.text = strmonth
                        print("NewUnix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startTimeStamp))")
                        print("NewUnix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endTimeStamp))")
                    } else {
                        print("ไม่สามารถคำนวณได้หลังการแปลง")
                    }
                }
            }
//       MARK: - Right Button Year
        case 3:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "yyyy"
            let calendar = Calendar.current
            let currentDate = Date()

            // ดึงวันแรกของปี

//            startOfYear = calendar.date(from: calendar.dateComponents([.year], from: calendar.startOfDay(for: currentDate)))
            if newstartOfYear == nil{
                if let startYear = calendar.date(byAdding: DateComponents(year: 1,hour: 7),to: startOfYear),
                   let endOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1,second: -1), to: startYear){

                    let startTimeStamp = startYear.timeIntervalSince1970
                    let endTimeStamp = endOfYear.timeIntervalSince1970
                    newstartOfYear = startYear
                    newendOfYear = endOfYear
                    startOfYear = newstartOfYear
    //                        let startDate = Int(startTimeStamp)
    //                        let endDate = Int(endTimeStamp)
                    let strYear = dateFormatter.string(from: newstartOfYear)
                    if let userInfo = self.appdelegate?.loadUserInfo() {
                        ReportSumarizemodel.idmember = userInfo.idmember
                    }
                    ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                    ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                    ReportSumarizemodel.datatype = "year"
                    ReportSumarizeData()
                    lb_showDate.text = strYear
                    LB_DatetimeTable.text = strYear
                    print("newUnix timestamp เริ่มต้นของปี (หลังการแปลง): \(Int(startTimeStamp))")
                    print("newUnix timestamp สุดท้ายของปี (หลังการแปลง): \(Int(endTimeStamp))")
                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
            }else{
                newstartOfYear = startOfYear
                if let startYear = calendar.date(byAdding: DateComponents(year: 1),to: newstartOfYear),
                   let endOfYear = calendar.date(byAdding: DateComponents(year: 1), to: newendOfYear){

                    let startTimeStamp = startYear.timeIntervalSince1970
                    let endTimeStamp = endOfYear.timeIntervalSince1970
                    newstartOfYear = startYear
                    newendOfYear = endOfYear
                    startOfYear = newstartOfYear
    //                        let startDate = Int(startTimeStamp)
    //                        let endDate = Int(endTimeStamp)
                    let strYear = dateFormatter.string(from: newstartOfYear)
                    if let userInfo = self.appdelegate?.loadUserInfo() {
                        ReportSumarizemodel.idmember = userInfo.idmember
                    }
                    ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                    ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                    ReportSumarizemodel.datatype = "year"
                    ReportSumarizeData()
                    lb_showDate.text = strYear
                    LB_DatetimeTable.text = strYear
                    print("newUnix timestamp เริ่มต้นของปี (หลังการแปลง): \(Int(startTimeStamp))")
                    print("newUnix timestamp สุดท้ายของปี (หลังการแปลง): \(Int(endTimeStamp))")
                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
            }

        default:
            break
        }
    }
//    MARK: - Segment
    
    @IBAction func DidChangeSegment(_ sender: Any) {
        switch Segment.selectedSegmentIndex {
//       MARK: - Segment Day

        case 0:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "dd MMMM yyyy"
            
            let CurrentDates = calendar.startOfDay(for: currentDate)
            let CurrentDate = calendar.date(byAdding: DateComponents(hour: 7),to: CurrentDates)
            if startOfDate == nil || startOfDate == CurrentDate{
                startOfDate = calendar.startOfDay(for: currentDate)
            }else{
                lb_showDate.text = dateFormatter.string(from: (newstartOfDate ?? CurrentDate)! )
            }
            DateNow = dateFormatter.string(from: Date())
            if let startdate = calendar.date(byAdding: DateComponents(hour: 7,second: 1),to: startOfDate),
               let endOfdate = calendar.date(byAdding: DateComponents(day : 1, second: -1),to: startdate) {

                let startTimeStamp = startdate.timeIntervalSince1970
                let endTimeStamp = endOfdate.timeIntervalSince1970

                let startDate = Int(startTimeStamp)
                let endDate = Int(endTimeStamp)
                lb_showDate.text = dateFormatter.string(from: startdate)
                ReportSumarizemodel.start_timestamp = startDate
                ReportSumarizemodel.end_timestamp = endDate
                ReportSumarizemodel.datatype = "day"
                if let userInfo = self.appdelegate?.loadUserInfo() {
                    ReportSumarizemodel.idmember = userInfo.idmember
                }
                
                ReportSumarizeData()
                print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startDate))")
                print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endDate))")
            } else {
                print("ไม่สามารถคำนวณได้หลังการแปลง")
            }

        
//            lb_showDate.text = DateNow
//            LB_DatetimeTable.text = DateNow

//            testLeftTapAction()
//            AllTapped()
//       MARK: - Segment Week
        case 1:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "dd MMMM yyyy"
            
            let calendar = Calendar.current
//            var dateComponents = DateComponents()
            // กำหนดเดือนปัจจุบัน
            let currentDate = Date()
            
            let startofweek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
            
            var dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startofweek)
            dateComponents.weekday = calendar.firstWeekday
            dateComponents.weekday = 2
//            dateComponents.weekdayOrdinal = 1
            let date = calendar.date(from: dateComponents)!
            if FirstSunday == nil {
                if let firstSunday = calendar.date(byAdding: DateComponents(hour: 7), to: date) {
                    FirstSunday = firstSunday

                    let firstOfEndWeek = calendar.date(byAdding: DateComponents(day: 7, second: -1), to: FirstSunday)!
                    let SfirstOfEndWeek = calendar.date(byAdding: DateComponents(day: 7, second: -1), to: date)!

                    let Sunday = dateFormatter.string(from: FirstSunday)
                    let Saturday = dateFormatter.string(from: firstOfEndWeek)
                    let fSunday = dateFormatter.string(from: date)
                    let fSaturday = dateFormatter.string(from: SfirstOfEndWeek)
                    lb_showDate.text = "\(fSunday) - \(fSaturday)"

                    let startTimeStamp = FirstSunday!.timeIntervalSince1970
                    let endTimeStamp = firstOfEndWeek.timeIntervalSince1970
                    ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                    ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                }
            }else if FirstSunday != nil || NewSunday != nil || NewSaturday != nil{
                let Sunday = calendar.date(byAdding: DateComponents(hour: -7),to: NewSunday ?? FirstSunday)
                let Sat = calendar.date(byAdding: DateComponents(hour: -7),to: NewSaturday ?? Date())
                lb_showDate.text = "\(dateFormatter.string(from: Sunday!))" + " - " + "\(dateFormatter.string(from: Sat!))"
                NewSunday = Sunday
                NewSaturday = Sat
                let startTimeStamp = NewSunday.timeIntervalSince1970
                let endTimeStamp = NewSaturday.timeIntervalSince1970
                ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
            }
            
            // หาวันที่เริ่มต้นของสัปดาห์ (วันอาทิตย์)
//            dateComponents.weekday = calendar.component(.weekday, from: currentDate)
//            let startOfWeek = calendar.date(byAdding: dateComponents, to: currentDate)!
//            let StartWeek = dateFormatter.string(from: startOfWeek)
//
//            // กำหนดวันที่เริ่มต้นและสิ้นสุดของสัปดาห์
//            dateComponents.day = 6
//            let endOfWeek = calendar.date(byAdding: dateComponents, to: startOfWeek)!
//            let EndWeek = dateFormatter.string(from: endOfWeek)
            if let userInfo = self.appdelegate?.loadUserInfo() {
                ReportSumarizemodel.idmember = userInfo.idmember
            }
            ReportSumarizemodel.datatype = "week"
            ReportSumarizeData()

//            AllTapped()
//       MARK: - Segment Month

        case 2:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "MMMM yyyy"

            let stringDate = dateFormatter.string(from: Date())
            let components = stringDate.components(separatedBy: " ")

            let monthIndex = dateFormatter.monthSymbols.firstIndex(of: components[0])!
            let month = monthIndex + 1

            if let year = Int(components[1]) {
                let calendar = Calendar(identifier: .gregorian)
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = month
                dateComponents.day = 1
                let startofmonth = calendar.date(from: dateComponents)!
                let startdateofmonth = calendar.date(byAdding: DateComponents(hour: 7,second: 1),to: startofmonth)
                if newstartOfMonth == nil || newstartOfMonth == startdateofmonth {
                    startOfMonth = calendar.date(from: dateComponents)!
                }else{
                    lb_showDate.text = dateFormatter.string(from: newstartOfMonth)
                }
                if let startdate = calendar.date(byAdding: DateComponents(hour: 7,second: 1),to: startOfMonth),
                let endOfMonth = calendar.date(byAdding: DateComponents(month: 1 ,minute: -1,second:  -1), to: startdate) {

                    let startTimeStamp = startdate.timeIntervalSince1970
                    let endTimeStamp = endOfMonth.timeIntervalSince1970

                    let startDate = Int(startTimeStamp)
                    let endDate = Int(endTimeStamp)

                    print("Unix timestamp เริ่มต้นของเดือน (หลังการแปลง): \(Int(startDate))")
                    print("Unix timestamp สุดท้ายของเดือน (หลังการแปลง): \(Int(endDate))")
                    if let userInfo = self.appdelegate?.loadUserInfo() {
                        ReportSumarizemodel.idmember = userInfo.idmember
                    }
                    ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                    ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                    ReportSumarizemodel.datatype = "month"
                    lb_showDate.text = dateFormatter.string(from: startdate)
                    LB_DatetimeTable.text = dateFormatter.string(from: startdate)
                    
                    if newstartOfMonth == nil || newstartOfMonth == startdateofmonth {
                        let DateString = dateFormatter.string(from: startdate)
                        strDate = DateString
                    }else{
                        let DateString = dateFormatter.string(from: newstartOfMonth)
                        strDate = DateString
                    }
                    
                        
                    
                    let taptocreatepinpage = UITapGestureRecognizer(target: self, action: #selector(Dropdown))
                    DropDown.addGestureRecognizer(taptocreatepinpage)
                    DropDown.isUserInteractionEnabled = true
                    
                    ReportSumarizeData()

                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
            }
            

//       MARK: - Segment Year
        case 3:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "yyyy"
            let calendar = Calendar.current
            let currentDate = Date()

            // ดึงวันแรกของปี
            let startofyear = calendar.date(from: calendar.dateComponents([.year], from: calendar.startOfDay(for: currentDate)))
            let startyear = calendar.date(byAdding: DateComponents(hour: 7),to: startofyear!)
            // ดึงวันแรกของปี
            if newstartOfYear == nil || newstartOfYear == startyear{
                startOfYear = calendar.date(from: calendar.dateComponents([.year], from: calendar.startOfDay(for: currentDate)))
                
                if let startYear = calendar.date(byAdding: DateComponents(hour: 7),to: startOfYear),
                   let endOfYear = calendar.date(byAdding: DateComponents(year: 1, second: -1), to: startYear){
                    
                    let startTimeStamp = startYear.timeIntervalSince1970
                    let endTimeStamp = endOfYear.timeIntervalSince1970
                    newstartOfYear = startYear
                    newendOfYear = endOfYear
                    //                        let startDate = Int(startTimeStamp)
                    //                        let endDate = Int(endTimeStamp)
                    let strYear = dateFormatter.string(from: newstartOfYear)
                    if let userInfo = self.appdelegate?.loadUserInfo() {
                        ReportSumarizemodel.idmember = userInfo.idmember
                    }
                    ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                    ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                    ReportSumarizemodel.datatype = "year"
                    
                    let taptocreatepinpage = UITapGestureRecognizer(target: self, action: #selector(Dropdown))
                    DropDown.addGestureRecognizer(taptocreatepinpage)
                    DropDown.isUserInteractionEnabled = true

                    ReportSumarizeData()
                    lb_showDate.text = strYear
                    LB_DatetimeTable.text = strYear
                    
                    print("newUnix timestamp เริ่มต้นของปี (หลังการแปลง): \(Int(startTimeStamp))")
                    print("newUnix timestamp สุดท้ายของปี (หลังการแปลง): \(Int(endTimeStamp))")
                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
                DateNow = dateFormatter.string(from: Date())
                lb_showDate.text = DateNow
                
            }else{
                let startTimeStamp = newstartOfYear.timeIntervalSince1970
                let endTimeStamp = newendOfYear.timeIntervalSince1970
                ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                ReportSumarizemodel.datatype = "year"
                
                let taptocreatepinpage = UITapGestureRecognizer(target: self, action: #selector(Dropdown))
                DropDown.addGestureRecognizer(taptocreatepinpage)
                DropDown.isUserInteractionEnabled = true

                ReportSumarizeData()
                lb_showDate.text = dateFormatter.string(from: newstartOfYear)
            }
//            if newstartOfYear == nil{
//                
//            }else{
//                lb_showDate.text = dateFormatter.string(from: newstartOfYear)
//            }
        default:
            break
        }
    }
//    MARK: - DropDown
    @objc func Dropdown() {
        if Segment.selectedSegmentIndex == 2 {
            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyborad.instantiateViewController(identifier: "MMYYYY_dropdown") as! MMYYYY_dropdown
            
            if let presentationController = vc.presentationController as? UISheetPresentationController {
                presentationController.detents = [.custom { context in 400}]
            }
            vc.delegate = self
            vc.strDate = strDate
            vc.TypeState = .month_list
            vc.addsendstartUnixAction(handlerstartUnixtime: {Unixtime in
                let dateFormatterforDrop = DateFormatter()
                dateFormatterforDrop.calendar = Calendar(identifier: .gregorian)
                dateFormatterforDrop.locale = Locale(identifier: "th-TH")
                dateFormatterforDrop.dateFormat = "MMMM yyyy"
                let Stringdate = self.convertUnixTimestampToDateStringforDropDown(timestamp: TimeInterval(Unixtime))
                let StringSMonths = dateFormatterforDrop.date(from: Stringdate)
                let StringSMonth = StringSMonths
                self.lb_showDate.text = dateFormatterforDrop.string(from: StringSMonth ?? Date())
                self.startOfMonth = StringSMonths
                self.ReportSumarizemodel.start_timestamp = Unixtime
                self.ReportSumarizemodel.datatype = "month"
                if let userInfo = self.appdelegate?.loadUserInfo() {
                    self.ReportSumarizemodel.idmember = userInfo.idmember
                }
//                self.reportsendModel.start_timestamp = self.startDate
                
            })
            vc.addsendendUnixAction(handlerendUnixtime: {Unixtime in
                let dateFormatter = DateFormatter()
                dateFormatter.calendar = Calendar(identifier: .gregorian)
                dateFormatter.locale = Locale(identifier: "th-TH")
                dateFormatter.dateFormat = "MMMM-yyyy"
                let Stringdate = self.convertUnixTimestampToDateString(timestamp: TimeInterval(Unixtime))
                self.EndOfMonth = dateFormatter.date(from: Stringdate)
                self.ReportSumarizemodel.end_timestamp = Unixtime
//                self.endDate = Unixtime
//                self.reportsendModel.end_timestamp = self.endDate
                
            })
            
            self.present(vc, animated: true)
        }else if Segment.selectedSegmentIndex == 3 {
            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyborad.instantiateViewController(identifier: "MMYYYY_dropdown") as! MMYYYY_dropdown
            
            if let presentationController = vc.presentationController as? UISheetPresentationController {
                presentationController.detents = [.custom { context in 400}]
            }
            vc.delegate = self
            vc.strDate = strDate
            vc.TypeState = .year_list
            vc.addsendstartUnixAction(handlerstartUnixtime: {Unixtime in
                let dateFormatterforDrop = DateFormatter()
                dateFormatterforDrop.calendar = Calendar(identifier: .gregorian)
                dateFormatterforDrop.locale = Locale(identifier: "th-TH")
                dateFormatterforDrop.dateFormat = "yyyy"
                
                let calendar = Calendar.current
                
                let Stringdate = self.convertUnixTimestampToDateStringforYear(timestamp: TimeInterval(Unixtime))
                let StringSMonths = dateFormatterforDrop.date(from: Stringdate)
                let StringSMonth = StringSMonths
                
                let startofyear = calendar.date(from: calendar.dateComponents([.year], from: calendar.startOfDay(for: StringSMonth!)))
                let startyear = calendar.date(byAdding: DateComponents(hour: 7),to: startofyear!)
                
                let endOfYear = calendar.date(byAdding: DateComponents(year: 1, second: -1), to: startyear!)
                
                let startTimeStamp = startyear!.timeIntervalSince1970
                let endTimeStamp = endOfYear!.timeIntervalSince1970


                
                self.lb_showDate.text = dateFormatterforDrop.string(from: StringSMonth ?? Date())
                self.startOfYear = StringSMonths
                self.ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                self.ReportSumarizemodel.end_timestamp = Int(endTimeStamp)

                self.ReportSumarizemodel.datatype = "year"
                if let userInfo = self.appdelegate?.loadUserInfo() {
                    self.ReportSumarizemodel.idmember = userInfo.idmember
                }
//                self.reportsendModel.start_timestamp = self.startDate
                
            })
            vc.addsendendUnixAction(handlerendUnixtime: {Unixtime in
//                let dateFormatter = DateFormatter()
//                dateFormatter.calendar = Calendar(identifier: .gregorian)
//                dateFormatter.locale = Locale(identifier: "th-TH")
//                dateFormatter.dateFormat = "yyyy"
//                let Stringdate = self.convertUnixTimestampToDateStringforYear(timestamp: TimeInterval(Unixtime))
//                self.EndOfMonth = dateFormatter.date(from: Stringdate)
//                self.ReportSumarizemodel.end_timestamp = Unixtime
//                self.endDate = Unixtime
//                self.reportsendModel.end_timestamp = self.endDate
                
            })
            
            self.present(vc, animated: true)
        }

        
    }
    func clickSelectDatePicker(Date: String) {
        
        strDate = Date
        self.ReportSumarizeData()

    }
//      MARK: - AlmoFire API
    let apiClient : ApiClient = ApiClient()
    private let disposeBag = DisposeBag()
    var reportSumDataRes : [SubReportSumRes] = [SubReportSumRes]()
    var reportSulistmDataRes : [SubReportlistSummarizeRes] = [SubReportlistSummarizeRes]()


//      MARK: - Add list
    func ReportSumarizeDataApi(data : GetReportModel) -> Observable<ReportSumRes> {
        return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/Report/ReportSummary"))
    }
                
    func ReportSumarizeData() {
        if let userInfo = self.appdelegate?.loadUserInfo() {
            ReportSumarizemodel.idmember = userInfo.idmember
        }
//            self.dispatchGroup?.enter()
        ReportSumarizeDataApi(data: ReportSumarizemodel)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
            if resData.success == true {
//                        self.dispatchGroup?.leave()
                self.reportSumDataRes = resData.data
                self.lb_totalIncome.text = self.reportSumDataRes.first?.total_income
                self.lb_StableIncome.text = self.reportSumDataRes.first?.total_Income_Certain
                self.lb_UnStableIncome.text = self.reportSumDataRes.first?.total_Income_Uncertain
                self.lb_totalExpenses.text = self.reportSumDataRes.first?.total_expenses
                self.lb_NecessaryExpenses.text = self.reportSumDataRes.first?.total_Expenses_Necessary
                self.lb_UnNecessaryExpenses.text = self.reportSumDataRes.first?.total_Expenses_Unnecessary
                self.ReportlistSumarizeData()
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
    
func ReportlistSumarizeDataApi(data : GetReportModel) -> Observable<ReportlistSummarizeRes> {
        return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/Report/ReportListSummary"))
    }
                
    func ReportlistSumarizeData() {
        if let userInfo = self.appdelegate?.loadUserInfo() {
            ReportSumarizemodel.idmember = userInfo.idmember
        }
//            self.dispatchGroup?.enter()
        ReportlistSumarizeDataApi(data: ReportSumarizemodel)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { resData in
                
            if resData.success == true {
//                        self.dispatchGroup?.leave()
                self.reportSulistmDataRes = resData.data
                self.registercell()
                self.inittableview()

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
