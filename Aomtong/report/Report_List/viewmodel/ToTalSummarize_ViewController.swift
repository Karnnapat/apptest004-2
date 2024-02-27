//
//  ToTalSummarize_ViewController.swift
//  Aomtung
//
//  Created by Karnnapat Kamolwisutthipong on 15/2/2567 BE.
//

import UIKit
import RxSwift
import Charts
class ToTalSummarize_ViewController: UIViewController, MMYYYY_dropdownDelegate {
    
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


    

    
//      MARK: - @IBOutlet
    
    @IBOutlet weak var View_Chart: UIView!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var Segment: UISegmentedControl!
    @IBOutlet weak var btn_Right: UIButton!
    @IBOutlet weak var lb_Date: UILabel!
    @IBOutlet weak var btn_Left: UIButton!
    
    @IBOutlet weak var lb_UnStableIncome: UILabel!
    @IBOutlet weak var lb_StableIncome: UILabel!
    @IBOutlet weak var lb_IncomeTotal: UILabel!
    @IBOutlet weak var lb_UnNecessaryExpenses: UILabel!
    @IBOutlet weak var lb_NecessaryExpenses: UILabel!
    @IBOutlet weak var lb_ExpensesTotal: UILabel!
    
    @IBOutlet weak var Dropdown: UIButton!
    
    //    @IBOutlet weak var barChartView: BarChartView!
    var barChartView: BarChartView = BarChartView()
    
//    MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegment()
        
//        setupBarChart()
        
//        btn_Left.addTarget(self, action: #selector(leftTapAction(_:)), for: .touchUpInside)
//        AllTapped()
    }
    override func viewDidAppear(_ animated: Bool) {
        ReportSumarizeData()
    }
//    MARK: - Chart
    func setupBarChart() {
        setupScrollView()
        barChartView.frame = CGRect(x: 0, y: 0, width: View_Chart.frame.width, height: View_Chart.frame.height)
        View_Chart.addSubview(barChartView)
        
//        scrollView.addSubview(barChartView)
//        let sortdata = reportforGraphDataRes.first?.dataOfList.map({$0.totalIncome})
//        let sortdata = reportforGraphDataRes.first?.dataOfList.filter({$0.totalIncome})
        let Dincometotal = self.reportforGraphDataRes?.dataOfList.compactMap { Double($0.totalIncome ?? "0.0") }
//        let incometotal = Double(Dincometotal)
        let Dexpensestotal = self.reportforGraphDataRes?.dataOfList.compactMap { Double($0.totalExpenses ?? "0.0") }
        let ranges = self.reportforGraphDataRes?.dataOfList.map({$0.number})
//        let ageRanges = [self.reportforGraphDataRes?.dataOfList.map({$0.number})]
//        let incomeData = [Dincometotal]
//        let expensesData = [Dexpensestotal]

        var barChartData: [BarChartDataEntry] = []

        for i in 0..<ranges!.count {
            let maleEntry = BarChartDataEntry(x: Double(i), y: Double(Dincometotal![i] ), data: "รายรับ")
            let femaleEntry = BarChartDataEntry(x: Double(i), y: Double(Dexpensestotal![i] ), data: "รายจ่าย")

            barChartData.append(maleEntry)
            barChartData.append(femaleEntry)
        }

        let maleDataSet = BarChartDataSet(entries: barChartData.filter { $0.data as! String == "รายรับ" }, label: "รายรับ")
//        maleDataSet.drawValuesEnabled = !Dincometotal!.contains(0)
        maleDataSet.setColor(._81_C_8_E_4)
        maleDataSet.valueTextColor = UIColor.black
        let femaleDataSet = BarChartDataSet(entries: barChartData.filter { $0.data as! String == "รายจ่าย" }, label: "รายจ่าย")
        femaleDataSet.valueTextColor = UIColor.black
        barChartView.legend.textColor = UIColor.black
//        maleDataSet.drawValuesEnabled = !Dexpensestotal!.contains(0)
        femaleDataSet.setColor(.FF_8686)
        let dataSets: [BarChartDataSet] = [maleDataSet, femaleDataSet]
        barChartView.xAxis.labelTextColor = UIColor.black
        barChartView.leftAxis.labelTextColor = UIColor.black
        barChartView.rightAxis.labelTextColor = UIColor.black

        let groupSpace = 0.3
        let barSpace = 0.04
        let barWidth = 0.3

        let groupCount = ranges!.count
        let barWidthTotal = Double(groupCount) * (barWidth + barSpace) + groupSpace

        let groupWidth = barWidthTotal / Double(groupCount)

        let finalChartData = BarChartData(dataSets: dataSets)
        finalChartData.barWidth = barWidth
        finalChartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)

        barChartView.data = finalChartData

        // กำหนดชื่อแกน X และแกน Y, และค่าบนแท่งต่าง ๆ ตามต้องการ
        if let nonOptionalAgeRanges = ranges!.compactMap({ $0 }) as? [String] {
            barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: nonOptionalAgeRanges)
        }
        barChartView.xAxis.granularity = 1.0
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false

//        barChartView.highlightPerTapEnabled = false
        barChartView.highlightPerDragEnabled = false
        
        barChartView.data = finalChartData
        barChartView.chartDescription.text = "รายรับ รายจ่าย"
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
        if let startdate = calendar.date(byAdding: DateComponents(hour: 7),to: startOfDate),
           let endOfdate = calendar.date(byAdding: DateComponents(day: 1,second: -1),to: startdate) {

            let startTimeStamp = startdate.timeIntervalSince1970
            let endTimeStamp = endOfdate.timeIntervalSince1970
            startOfDate = startdate
            let startDate = Int(startTimeStamp)
            let endDate = Int(endTimeStamp)
            ReportSumarizemodel.start_timestamp = startDate
            ReportSumarizemodel.end_timestamp = endDate
            ReportSumarizemodel.datatype = "day"
            if let userInfo = self.appdelegate?.loadUserInfo() {
                ReportSumarizemodel.idmember = userInfo.idmember
            }
//            ReportForGraphData()
            ReportSumarizeData()
            print("Unix timestamp เริ่มต้นของวัน (หลังการแปลง): \(Int(startDate))")
            print("Unix timestamp สุดท้ายของวัน (หลังการแปลง): \(Int(endDate))")
        } else {
            print("ไม่สามารถคำนวณได้หลังการแปลง")
        }

    
        lb_Date.text = DateNow
    }
    
    @IBAction func didchangesegment(_ sender: UISegmentedControl){
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
                lb_Date.text = dateFormatter.string(from: (newstartOfDate ?? CurrentDate)! )
            }
            
            DateNow = dateFormatter.string(from: Date())
            if let startdate = calendar.date(byAdding: DateComponents(hour: 7),to: startOfDate),
               let endOfdate = calendar.date(byAdding: DateComponents(day : 1, second: -1),to: startdate) {

                let startTimeStamp = startdate.timeIntervalSince1970
                let endTimeStamp = endOfdate.timeIntervalSince1970

                let startDate = Int(startTimeStamp)
                let endDate = Int(endTimeStamp)
                lb_Date.text = dateFormatter.string(from: startdate)
                ReportSumarizemodel.start_timestamp = startDate
                ReportSumarizemodel.end_timestamp = endDate
                ReportSumarizemodel.datatype = "day"
                if let userInfo = self.appdelegate?.loadUserInfo() {
                    ReportSumarizemodel.idmember = userInfo.idmember
                }
                ReportSumarizeData()
                print("Unix timestamp เริ่มต้นของวัน (หลังการแปลง): \(Int(startDate))")
                print("Unix timestamp สุดท้ายของวัน (หลังการแปลง): \(Int(endDate))")
            } else {
                print("ไม่สามารถคำนวณได้หลังการแปลง")
            }

        

//            testLeftTapAction()
//            AllTapped()
//       MARK: - Segment Week
        case 1:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "dd MMMM yyyy"
            
            let calendar = Calendar.current
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
                    lb_Date.text = "\(fSunday) - \(fSaturday)"

                    let startTimeStamp = FirstSunday!.timeIntervalSince1970
                    let endTimeStamp = firstOfEndWeek.timeIntervalSince1970
                    ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                    ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                }
            }else if FirstSunday != nil || NewSunday != nil{
                let Sunday = calendar.date(byAdding: DateComponents(hour: -7),to: NewSunday ?? FirstSunday)
                let Sat = calendar.date(byAdding: DateComponents(hour: -7),to: NewSaturday!)
                lb_Date.text = "\(dateFormatter.string(from: Sunday!))" + " - " + "\(dateFormatter.string(from: Sat!))"
                
                let startTimeStamp = FirstSunday.timeIntervalSince1970
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
                
                let startofmonth = calendar.date(from: dateComponents)!
                let startdateofmonth = calendar.date(byAdding: DateComponents(hour: 7,second: 1),to: startofmonth)
                if newstartOfMonth == nil || newstartOfMonth == startdateofmonth {
                    startOfMonth = calendar.date(from: dateComponents)!
                }else{
                    lb_Date.text = dateFormatter.string(from: newstartOfMonth)
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
                    ReportSumarizeData()
                    let taptocreatepinpage = UITapGestureRecognizer(target: self, action: #selector(DropDown))
                    Dropdown.addGestureRecognizer(taptocreatepinpage)
                    Dropdown.isUserInteractionEnabled = true


                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
            }
            

            DateNow = dateFormatter.string(from: Date())
            lb_Date.text = DateNow
//       MARK: - Segment Year
        case 3:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "yyyy"
            let calendar = Calendar.current
            let currentDate = Date()
            let startofyear = calendar.date(from: calendar.dateComponents([.year], from: calendar.startOfDay(for: currentDate)))
            let startyear = calendar.date(byAdding: DateComponents(hour: 7),to: startofyear!)
            // ดึงวันแรกของปี
            if newstartOfYear == nil || newstartOfYear == startyear{
                startOfYear = calendar.date(from: calendar.dateComponents([.year], from: calendar.startOfDay(for: currentDate)))
                if let startYear = calendar.date(byAdding: DateComponents(hour: 7),to: startOfYear),
                   let endOfYear = calendar.date(byAdding: DateComponents(year: 1,second: -1), to: startYear){
                    
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
                    ReportSumarizeData()
                    let taptocreatepinpage = UITapGestureRecognizer(target: self, action: #selector(DropDown))
                    Dropdown.addGestureRecognizer(taptocreatepinpage)
                    Dropdown.isUserInteractionEnabled = true

                    lb_Date.text = strYear
                    print("newUnix timestamp เริ่มต้นของปี (หลังการแปลง): \(Int(startTimeStamp))")
                    print("newUnix timestamp สุดท้ายของปี (หลังการแปลง): \(Int(endTimeStamp))")
                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
//                DateNow = dateFormatter.string(from: Date())
//                lb_Date.text = DateNow
            }else{
                let startTimeStamp = newstartOfYear.timeIntervalSince1970
                let endTimeStamp = newendOfYear.timeIntervalSince1970
                ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                ReportSumarizemodel.datatype = "year"
                ReportSumarizeData()
                let taptocreatepinpage = UITapGestureRecognizer(target: self, action: #selector(DropDown))
                Dropdown.addGestureRecognizer(taptocreatepinpage)
                Dropdown.isUserInteractionEnabled = true

                lb_Date.text = dateFormatter.string(from: newstartOfYear)
            }
        default:
            break
        }
    }
//      MARK: -
    
//    MARK: - Scrollview
    func setupScrollView() {
            // สร้าง UIScrollView
        scrollView.frame = View_Chart?.bounds ?? CGRect.zero
        scrollView.contentSize = CGSize(width: 1000, height: View_Chart?.bounds.height ?? 0)
            // เพิ่ม UIScrollView เข้าไปในหน้าจอ
            MainView?.addSubview(scrollView)
            // สร้าง UIRefreshControl
//            let refreshControl = UIRefreshControl()
//            refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
//
//            // กำหนด refreshControl ให้กับ UIScrollView
//            scrollView.refreshControl = refreshControl
//
//            // สร้างข้อมูลใน UIScrollView (เป็นตัวอย่าง)
//
//            // กำหนด contentInset เพื่อป้องกันการบังหน้าจอหลัก
//            scrollView.contentInset = UIEdgeInsets(top: refreshControl.frame.size.height, left: 0, bottom: 0, right: 0)
        }
    
//    @objc func refreshData(_ sender: UIRefreshControl) {
//            // ทำงานที่ต้องการทำในการรีเฟรช
//            // ...
//            // เมื่อเสร็จสิ้นการรีเฟรช
//            ReportSumarizeData()
//            sender.endRefreshing()
//        }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: scrollView)

        // ตรวจสอบว่าถ้าย้ายไปทางซ้ายหรือขวามากเกินไป ก็สามารถทำเงื่อนไขตรงนี้ตามต้องการ

        // ย้าย contentOffset ของ scrollView
        scrollView.contentOffset.x -= translation.x

        // รีเซ็ต translation เพื่อป้องกันการสะสมค่าการย้าย
        sender.setTranslation(.zero, in: scrollView)
    }

    
//    MARK: - Tapped
    @IBAction func btnTapped(_ sender: UIButton) {
        leftTapAction(sender)
    }

    
    @IBAction func leftTapAction(_ sender: Any) {
        switch Segment.selectedSegmentIndex {
//       MARK: - Left Button Day
        case 0:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "dd MMMM yyyy"
//            let RewindSundayoneweek = calendar.date(byAdding: DateComponents(day: -1 ), to: date)!
            
            startOfDate = calendar.startOfDay(for: currentDate)
            if newstartOfDate == nil{
                if let startdate = calendar.date(byAdding: DateComponents(day: -1, hour: 7,second: 1),to: startOfDate),
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
                    lb_Date.text = dateFormatter.string(from: newstartOfDate)
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
                    lb_Date.text = dateFormatter.string(from: newstartOfDate)
                    ReportSumarizeData()
                    print("Unix timestamp เริ่มต้นของวัน (หลังการแปลง): \(Int(startDate))")
                    print("Unix timestamp สุดท้ายของวัน (หลังการแปลง): \(Int(endDate))")
                } else {
                    print("ไม่สามารถคำนวณได้หลังการแปลง")
                }
            }
//       MARK: - Left Button Week
        case 1:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "dd MMMM yyyy"
            
            if NewSunday == nil{
                let RewindSundayoneweek = calendar.date(byAdding: DateComponents(day: -7,hour: 7), to: FirstSunday)!
                let RewindSaturDayoneweek = calendar.date(byAdding: DateComponents(day: 7,second: -1), to: RewindSundayoneweek)!
               
                NewSunday = RewindSundayoneweek
                NewSaturday = RewindSaturDayoneweek
                let Sunday = calendar.date(byAdding: DateComponents(hour: -7),to: NewSunday)
                let Sat = calendar.date(byAdding: DateComponents(hour: -7),to: NewSaturday)
                let FSunday = dateFormatter.string(from: Sunday!)
                let FSaturday = dateFormatter.string(from: Sat!)
                FirstSunday = NewSunday
    //            DateNow = dateFormatter.string(from: Date())
                let startTimeStamp = NewSunday.timeIntervalSince1970
                let endTimeStamp = NewSaturday.timeIntervalSince1970
                print("Unix timestamp เริ่มต้นของสัปดาห์ (หลังการแปลง): \(Int(startTimeStamp))")
                print("Unix timestamp สุดท้ายของสัปดาห์ (หลังการแปลง): \(Int(endTimeStamp))")
                if let userInfo = self.appdelegate?.loadUserInfo() {
                    ReportSumarizemodel.idmember = userInfo.idmember
                }
                FirstSunday = NewSunday
                ReportSumarizemodel.start_timestamp = Int(startTimeStamp)
                ReportSumarizemodel.end_timestamp = Int(endTimeStamp)
                ReportSumarizemodel.datatype = "week"

                lb_Date.text = "\(FSunday) " + "- \(FSaturday)"
                ReportSumarizeData()
            }else{
                let RewindSundayoneweek = calendar.date(byAdding: DateComponents(day: -7), to: NewSunday)!
                let RewindSaturDayoneweek = calendar.date(byAdding: DateComponents(day: -7), to: NewSaturday)!
                
                let showUserFirstDayofweek = calendar.date(byAdding: DateComponents(day: -7,hour: -7), to: NewSunday)!
                let showUserEndDayofweek = calendar.date(byAdding: DateComponents(day: -7,hour: -7), to: NewSaturday)!
                
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

                lb_Date.text = "\(FSunday) " + "- \(FSaturday)"
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
                        newendOfMonth = endOfMonth
                        startOfMonth = newstartOfMonth
//                        let startDate = Int(startTimeStamp)
//                        let endDate = Int(endTimeStamp)
                        lb_Date.text = dateFormatter.string(from: startdate)
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
                        lb_Date.text = strmonth
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
                    lb_Date.text = strYear
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
                    lb_Date.text = strYear
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
//        Segment.isUserInteractionEnabled = true // เปิดใช้งานการรับอีเวนต์จาก Segment อีกครั้ง
    }
    

    
    @IBAction func rightTapAction(_ sender: Any) {
        switch Segment.selectedSegmentIndex {
//       MARK: - Right Button Day
        case 0:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "dd MMMM yyyy"
//            let date = dateFormatter.date(from: DateNow) ?? Date()
//            let RewindSundayoneweek = calendar.date(byAdding: DateComponents(day: -1 ), to: date)!
            
            startOfDate = calendar.startOfDay(for: currentDate)
            if newstartOfDate == nil{
                if let startdate = calendar.date(byAdding: DateComponents(day: 1, hour: 7,second: 1),to: startOfDate),
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
                    lb_Date.text = dateFormatter.string(from: newstartOfDate)
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
                    lb_Date.text = dateFormatter.string(from: newstartOfDate)
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

                lb_Date.text = "\(FSunday) " + "- \(FSaturday)"
                

    //            DateNow = dateFormatter.string(from: Date())
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

                lb_Date.text = "\(FSunday) " + "- \(FSaturday)"
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

                        lb_Date.text = dateFormatter.string(from: startdate)
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

                        lb_Date.text = strmonth
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

                    lb_Date.text = strYear
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

                    lb_Date.text = strYear
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
    
    func testLeftTapAction() {
        leftTapAction(self)
    }
    
//    MARK: - DropDown
    @objc func DropDown() {
        if Segment.selectedSegmentIndex == 2 {
            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyborad.instantiateViewController(identifier: "MMYYYY_dropdown") as! MMYYYY_dropdown
            
            if let presentationController = vc.presentationController as? UISheetPresentationController {
                presentationController.detents = [.custom { context in 400}]
            }
            vc.delegate = self
            vc.strDate = strDate
            vc.TypeState = .month_summarize
            vc.addsendstartUnixAction(handlerstartUnixtime: {Unixtime in
                let dateFormatterforDrop = DateFormatter()
                dateFormatterforDrop.calendar = Calendar(identifier: .gregorian)
                dateFormatterforDrop.locale = Locale(identifier: "th-TH")
                dateFormatterforDrop.dateFormat = "MMMM yyyy"
                let Stringdate = self.convertUnixTimestampToDateStringforDropDown(timestamp: TimeInterval(Unixtime))
                let StringSMonths = dateFormatterforDrop.date(from: Stringdate)
                let StringSMonth = StringSMonths
                self.lb_Date.text = dateFormatterforDrop.string(from: StringSMonth ?? Date())
                self.startOfMonth = StringSMonths
                self.ReportSumarizemodel.start_timestamp = Unixtime
                self.ReportSumarizemodel.datatype = "month"
                if let userInfo = self.appdelegate?.loadUserInfo() {
                    self.ReportSumarizemodel.idmember = userInfo.idmember
                }
//                self.reportsendModel.start_timestamp = self.startDate
                
            })
            vc.addsendendUnixAction(handlerendUnixtime: {Unixtime in
//                let dateFormatter = DateFormatter()
//                dateFormatter.calendar = Calendar(identifier: .gregorian)
//                dateFormatter.locale = Locale(identifier: "th-TH")
//                dateFormatter.dateFormat = "MMMM-yyyy"
//                let Stringdate = self.convertUnixTimestampToDateString(timestamp: TimeInterval(Unixtime))
//                self.EndOfMonth = dateFormatter.date(from: Stringdate)
//                self.ReportSumarizemodel.end_timestamp = Unixtime
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
            vc.TypeState = .year_summarize
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


                
                self.lb_Date.text = dateFormatterforDrop.string(from: StringSMonth ?? Date())
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
    
//      MARK: - AlmoFire API
        let apiClient : ApiClient = ApiClient()
        private let disposeBag = DisposeBag()
        var reportSumDataRes : [SubReportSumRes] = [SubReportSumRes]()
        var reportforGraphDataRes : SubGraphGRes?


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
                        self.lb_IncomeTotal.text = self.reportSumDataRes.first?.total_income
                        self.lb_StableIncome.text = self.reportSumDataRes.first?.total_Income_Certain
                        self.lb_UnStableIncome.text = self.reportSumDataRes.first?.total_Income_Uncertain
                        self.lb_ExpensesTotal.text = self.reportSumDataRes.first?.total_expenses
                        self.lb_NecessaryExpenses.text = self.reportSumDataRes.first?.total_Expenses_Necessary
                        self.lb_UnNecessaryExpenses.text = self.reportSumDataRes.first?.total_Expenses_Unnecessary
                        self.ReportForGraphData()
//                        self.setupBarChart()
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
        func ReportForGraphDataApi(data : GetReportModel) -> Observable<ReportGraphRes> {
            return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/Report/ReportListGraph"))
        }
                    
        func ReportForGraphData() {
            if let userInfo = self.appdelegate?.loadUserInfo() {
                ReportSumarizemodel.idmember = userInfo.idmember
            }
//            self.dispatchGroup?.enter()
            ReportForGraphDataApi(data: ReportSumarizemodel)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resData in
                    
                    if resData.success == true {
//                        self.dispatchGroup?.leave()
                        self.reportforGraphDataRes = resData.data
//                        self.lb_IncomeTotal.text = self.reportSumDataRes.first?.total_income
//                        self.lb_StableIncome.text = self.reportSumDataRes.first?.total_Income_Certain
//                        self.lb_UnStableIncome.text = self.reportSumDataRes.first?.total_Income_Uncertain
//                        self.lb_ExpensesTotal.text = self.reportSumDataRes.first?.total_expenses
//                        self.lb_NecessaryExpenses.text = self.reportSumDataRes.first?.total_Expenses_Necessary
//                        self.lb_UnNecessaryExpenses.text = self.reportSumDataRes.first?.total_Expenses_Unnecessary
                        
                        self.setupBarChart()
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
