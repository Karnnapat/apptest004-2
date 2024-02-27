//
//  ViewController.swift
//  apptest004
//
//  Created by Karnnapat Kamolwisutthipong on 21/12/2566 BE.
//

import UIKit
import RxSwift
import EGPieChart


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource , UICollectionViewDelegate, MMYYYY_dropdownDelegate ,EGPieChartDelegate{
    
    var pieIncome : CGFloat = 0.0
    var pieExpenses : CGFloat = 0.0
    var ReDateStr : String? = ""
    var dataType : String? = "income"
    var appdelegate = UIApplication.shared.delegate as? AppDelegate
    var AccountModel = CreateAccountModel()
    var reportsendModel = GetReportModel()
    var getreportRes : [SubGetReportRes] = [SubGetReportRes]()
    var startDate : Int = 0
    var endDate : Int = 0
    var dispatchGroup : DispatchGroup?
    var setDateRe : String? = ""
    var setDateUP : Date? = Date()


    @IBOutlet weak var simpleview: UIView!
    
    @IBOutlet weak var lb_expenses: UILabel!
    @IBOutlet weak var lb_total: UILabel!
    @IBOutlet weak var lb_income: UILabel!
    @IBOutlet weak var report_table: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var segmentview: UIView!
    
    var strDate : String = ""
//    MARK: - liftcycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        segment.selectedSegmentIndex = 0
        manageDataMonth()
        
        
        reportData()
//        report_table.reloadData()
//        URLSend()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        manageDataMonth()
        reportData()
//        report_table.reloadData()
    }
    
    
    func inittableview(){
        if report_table.delegate == nil{
            report_table.delegate = self
            report_table.dataSource = self
//            tableview.allowsSelection = false
            report_table.separatorStyle = .none
            report_table.reloadData()
        }else{
            report_table.reloadData()
        }
    }
    
    func registercell(){
        report_table.register(UINib(nibName: "Report_tbCell", bundle: nil), forCellReuseIdentifier: "Report_tbCell")
    }
//    MARK: - Segment
    @IBAction func didchangesegment(_ sender: UISegmentedControl) {
        report_table.reloadData()
//        if sender.selectedSegmentIndex == 0 {
//            segmentview.backgroundColor = .F_3_F_8_F_7
//            return 
//        }else if sender.selectedSegmentIndex == 1{
//            segmentview.backgroundColor = .F_3_F_8_F_7
//            return
//        }else{
//            return 
//        }
    }
    
//    MARK: - UItableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0 {
               return 1
        } else if segment.selectedSegmentIndex == 1 {
               return 1
           } else {
               // Handle other segments as needed
               return 0
           }
    }
    
//    MARK: - UItableview
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Report_tbCell") as? Report_tbCell else {return UITableViewCell()}
        cell.pieChartView.delegate = self
        cell.CV_inTBReport.backgroundColor = .clear
        cell.CV_inTBReport.tag = indexPath.row
        cell.CV_inTBReport.register(UINib(nibName: "Report_CV", bundle: nil), forCellWithReuseIdentifier: "Report_CV")
        cell.CV_inTBReport.dataSource = self
        cell.CV_inTBReport.delegate = self
        
        if segment.selectedSegmentIndex == 0 {
            DispatchQueue.global().async{
                Thread.sleep(forTimeInterval: 0)
                DispatchQueue.main.async{
                    let NoStringCertain = String((self.getreportRes.first?.report_month_list_income.first?.total_Income_Certain!.filter { $0.isNumber || $0 == "."}) ?? "")
                    let NoStringUnCertain = String((self.getreportRes.first?.report_month_list_income.first?.total_Income_Uncertain!.filter { $0.isNumber || $0 == "."})!)
                    
                    let Certain = NumberFormatter().number(from: NoStringCertain)
                    let Uncertain =  NumberFormatter().number(from: NoStringUnCertain)
                    let certain = CGFloat(truncating: Certain ?? 0)
                    let uncertain = CGFloat(truncating: Uncertain ?? 0)
//                    self.pieIncome =  totalincome
//                    self.pieExpenses =  totalexpenses
                    let testDataArr: [CGFloat] = [certain, uncertain]
                    var datas = [EGPieChartData]()
                    for i in 0..<testDataArr.count {
                        let data = EGPieChartData(value: testDataArr[i],
                                                  content: "")
                        datas.append(data)
                    }
                    let dataSource = EGPieChartDataSource(datas: datas)
                    dataSource.setAllValueFont(.systemFont(ofSize: 11))
                    dataSource.setAllValueTextColor(UIColor.black)
                    
                    let colors: [UIColor] = [._064_F_6_C, ._6_DBAD_8]
    //                let colors: [UIColor] = [.red]
                    dataSource.fillColors = colors
                    cell.pieChartView.dataSource = dataSource
                    cell.pieChartView.animate(1.5)
                    
                    cell.pieChartView.frame = CGRect(x: self.view.center.x - self.view.frame.width / 2, y: self.view.center.y - self.view.frame.width / 2, width: self.view.frame.width, height: self.view.frame.width)
                    cell.pieChartView.outerRadius = self.view.frame.width / 2.0 - 120.0

                }
            }
            dataType = "income"
//            segmentview.backgroundColor = UIColor.E_2_E_2_E_2
//            segmentview.backgroundColor = UIColor.F_3_F_8_F_7
            segment.selectedSegmentTintColor = ._81_C_8_E_4
            cell.lb_datatype2.text = "รายรับแน่นอน"
            cell.lb_datatype1.text = "รายรับไม่แน่นอน"
            cell.colorDataType2.backgroundColor = ._064_F_6_C
            cell.colorDatatype1.backgroundColor = ._6_DBAD_8
            cell.lb_reporttype.text = "รายการย้อนหลัง"
            cell.MMYYYY_Dropdown.text = strDate
            if getreportRes.first?.report_month_list_income.first?.report_List?.count == 0 {
                cell.CV_inTBReport.isHidden = true
                cell.lb_reportnone.isHidden = false
                cell.CV_inTBReport.backgroundColor = .clear
            }else{
                cell.CV_inTBReport.isHidden = false
                cell.lb_reportnone.isHidden = true
                cell.CV_inTBReport.backgroundColor = .clear
            }
            cell.CV_inTBReport.reloadData()
            let taptocreatepinpage = UITapGestureRecognizer(target: self, action: #selector(Dropdown))
            cell.btn_dropdownnonaction.addGestureRecognizer(taptocreatepinpage)
            cell.btn_dropdownnonaction.isUserInteractionEnabled = true
            } else if segment.selectedSegmentIndex == 1 {
                DispatchQueue.global().async{
                    Thread.sleep(forTimeInterval: 0)
                    DispatchQueue.main.async{
                        
                        let Necessary = String((self.getreportRes.first?.report_month_list_Expenses.first?.total_Expenses_Necessary!.filter { $0.isNumber || $0 == "."}) ?? "")
                        let Unnecessary = String((self.getreportRes.first?.report_month_list_Expenses.first?.total_Expenses_Unnecessary!.filter { $0.isNumber || $0 == "."})!)
                        
//                        let Necessary = NumberFormatter().number(from: self.getreportRes.first?.report_month_list_Expenses?.first?.total_Expenses_Necessary ?? "")
//                        let Unnecessary =  NumberFormatter().number(from: self.getreportRes.first?.report_month_list_Expenses?.first?.total_Expenses_Unnecessary ?? "")
                        let NoStringCertain = NumberFormatter().number(from: Necessary)
                        let NoStringUncertain =  NumberFormatter().number(from: Unnecessary)
                        let necessary = CGFloat(truncating: NoStringCertain ?? 0)
                        let unnecessary = CGFloat(truncating: NoStringUncertain ?? 0)

//                        let necessary = CGFloat(truncating: Necessary ?? 0)
//                        let unnecessary = CGFloat(truncating: Unnecessary ?? 0)
//                        self.pieIncome =  necessary
//                        self.pieExpenses =  unnecessary
                        let testDataArr: [CGFloat] = [necessary, unnecessary]
                        var datas = [EGPieChartData]()
                        for i in 0..<testDataArr.count {
                            let data = EGPieChartData(value: testDataArr[i],
                                                      content: "")
                            datas.append(data)
                        }
                        let dataSource = EGPieChartDataSource(datas: datas)
                        dataSource.setAllValueFont(.systemFont(ofSize: 11))
                        dataSource.setAllValueTextColor(UIColor.black)
                        
                        let colors: [UIColor] = [.E_85757, .F_8_ED_75]
        //                let colors: [UIColor] = [.red]
                        dataSource.fillColors = colors
                        cell.pieChartView.dataSource = dataSource
                        cell.pieChartView.animate(1.5)
                        
                        cell.pieChartView.frame = CGRect(x: self.view.center.x - self.view.frame.width / 2, y: self.view.center.y - self.view.frame.width / 2, width: self.view.frame.width, height: self.view.frame.width)
                        cell.pieChartView.outerRadius = self.view.frame.width / 2.0 - 120.0

                    }
                }
                dataType = "expenses"
                cell.lb_datatype2.text = "รายจ่ายจำเป็น"
                cell.lb_datatype1.text = "รายจ่ายไม่จำเป็น"
                cell.colorDataType2.backgroundColor = .E_85757
                cell.colorDatatype1.backgroundColor = .F_8_ED_75
//                segmentview.backgroundColor = UIColor.red
                segment.selectedSegmentTintColor = .FF_8686
                cell.lb_reporttype.text = "รายการย้อนหลัง"
                cell.MMYYYY_Dropdown.text = strDate
                if getreportRes.first?.report_month_list_Expenses.first?.report_List?.count == 0 {
                    cell.CV_inTBReport.isHidden = true
                }else{
                    cell.CV_inTBReport.isHidden = false
                }
                cell.CV_inTBReport.reloadData()

            } else {
                // Handle other segments as needed
            }
        
        cell.pieChartView.drawOutsideValues = true
        cell.pieChartView.line1AnglarOffset = 0.2
        cell.pieChartView.line1Persentage = 0.95
        cell.pieChartView.line1Lenght = 20
        cell.pieChartView.line2Length = 15
        cell.pieChartView.rotation = 270

        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0 {
            return getreportRes.first?.report_month_list_income.first?.report_List?.count ?? 0
        }else if segment.selectedSegmentIndex == 1{
            return getreportRes.first?.report_month_list_Expenses.first?.report_List?.count ?? 0
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "AddincomeViewController") as! AddincomeViewController
        collectionView.tag = indexPath.row
        switch segment.selectedSegmentIndex {
        case 0 :
            vc.delState = .delincome
            vc.datatoDel = getreportRes.first?.report_month_list_income.first?.report_List?[indexPath.row] ?? AllListReportInSubRes()
        case 1 :
            vc.delState = .delexpenses
            vc.dataExpensestoDel = getreportRes.first?.report_month_list_Expenses.first?.report_List?[indexPath.row] ?? AllListReportInSubRes()
        
        default:
            break
        }
//        print("Collection view : " + "\(getreportRes[indexPath.row])")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Report_CV", for: indexPath)as? Report_CV else {return UICollectionViewCell()}

//        let Totaldata = getreportRes.first
//        let catname = [expenses?.category_name]
//        print(catname)
        lb_total.text = getreportRes.first?.totalBalance
        lb_income.text = getreportRes.first?.totalIncome
        lb_expenses.text = getreportRes.first?.totalExpenses
        if segment.selectedSegmentIndex == 0 {
            let income = getreportRes.first?.report_month_list_income.first?.report_List?[indexPath.item]
            let ReDate = Double(income?.timestamp ?? 0)
            let ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            cell.lb_CatReport.text = income?.category_name
            cell.lb_DataType.text = income?.type_name
            cell.lb_reportTotal.text = "+" + "\(income?.amount ?? "")" + "฿"
            cell.lb_DateTimeReport.text = ReDateStr
            switch income?.type_name {
            case "รายรับแน่นอน":
                cell.lb_DataType.textColor = ._064_F_6_C
                cell.lb_reportTotal.textColor = ._064_F_6_C
            case "รายรับไม่แน่นอน":
                cell.lb_DataType.textColor = ._6_DBAD_8
                cell.lb_reportTotal.textColor = ._6_DBAD_8
            default:
                break
            }
            
        }else if segment.selectedSegmentIndex == 1 {
            let expenses = getreportRes.first?.report_month_list_Expenses.first?.report_List?[indexPath.item]
            let ReDate = Double(expenses?.timestamp ?? 0)
            let ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)
            cell.lb_CatReport.text = expenses?.category_name
            cell.lb_DataType.text = expenses?.type_name
            cell.lb_reportTotal.text = "-" + "\(expenses?.amount ?? "")" + "฿"
            cell.lb_DateTimeReport.text = ReDateStr
            switch expenses?.type_name {
            case "รายจ่ายจำเป็น":
                cell.lb_DataType.textColor = .E_85757
                cell.lb_reportTotal.textColor = .E_85757
            case "รายจ่ายไม่จำเป็น":
                cell.lb_DataType.textColor = .E_3_C_529
                cell.lb_reportTotal.textColor = .E_3_C_529
            default:
                break
            }
        }
        return cell
    }
    
    
//    MARK: - convertUnix to String
    func convertUnixTimestampToDateString(timestamp: TimeInterval) -> String {
        // สร้าง Date จาก Unix timestamp
        let date = Date(timeIntervalSince1970: timestamp)

        // กำหนดรูปแบบของวันที่ที่คุณต้องการ
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" // เปลี่ยนรูปแบบตามความต้องการ

        // แปลง Date เป็นสตริงของวันที่
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
   

//    MARK: - Tapaction
    @objc func Dropdown() {
        if segment.selectedSegmentIndex == 0 {
            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyborad.instantiateViewController(identifier: "MMYYYY_dropdown") as! MMYYYY_dropdown
            
            if let presentationController = vc.presentationController as? UISheetPresentationController {
                presentationController.detents = [.custom { context in 400}]
            }
            vc.delegate = self
            vc.strDate = strDate
            vc.TypeState = .Income
            vc.addsendstartUnixAction(handlerstartUnixtime: {Unixtime in
                self.startDate = Unixtime
                self.reportsendModel.start_timestamp = self.startDate
                
            })
            vc.addsendendUnixAction(handlerendUnixtime: {Unixtime in
                self.endDate = Unixtime
                self.reportsendModel.end_timestamp = self.endDate
                
            })
            
            self.present(vc, animated: true)
        }else if segment.selectedSegmentIndex == 1 {
            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyborad.instantiateViewController(identifier: "MMYYYY_dropdown") as! MMYYYY_dropdown
            
            if let presentationController = vc.presentationController as? UISheetPresentationController {
                presentationController.detents = [.custom { context in 400}]
            }
            vc.delegate = self
            vc.strDate = strDate
            vc.TypeState = .Expenses
            vc.addsendstartUnixAction(handlerstartUnixtime: {Unixtime in
                self.startDate = Unixtime
                self.reportsendModel.start_timestamp = self.startDate
                
            })
            vc.addsendendUnixAction(handlerendUnixtime: {Unixtime in
                self.endDate = Unixtime
                self.reportsendModel.end_timestamp = self.endDate
                
            })
            
            self.present(vc, animated: true)
        }
        
    }
    
    func clickSelectDatePicker(Date: String) {
        strDate = Date
        
        reportData()
        print(strDate)
    }

//    MARK: - Calendar
    
    func manageDataMonth() {
        let formatdate = DateFormatter()
        formatdate.dateFormat = "MMMM"
        formatdate.calendar = Calendar(identifier: .gregorian)
        formatdate.locale = Locale(identifier: "th-TH")
        
        let month = formatdate.string(from: Date())
        formatdate.dateFormat = "YYYY"
        formatdate.calendar = Calendar(identifier: .gregorian)
        formatdate.locale = Locale(identifier: "th-TH")
        let year = formatdate.string(from: Date())
        let thaiYear = (Int(year) ?? 0)
        let date = "\(month) \(thaiYear)"
        strDate = date
//        print(strDate)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "th-th")
        dateFormatter.dateFormat = "MMMM yyyy"

        if dateFormatter.date(from: strDate) != nil {
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
                        if let startdate = calendar.date(byAdding: DateComponents(hour: 7,second: 1), to: Setup),
//                           MARK: -แก้เวลา
                           let endOfMonth = calendar.date(byAdding: DateComponents(month: 1 ,minute: -1,second:  -1), to: startdate) {

                            let startTimeStamp = startdate.timeIntervalSince1970
                            let endTimeStamp = endOfMonth.timeIntervalSince1970
                            
                            startDate = Int(startTimeStamp)
                            endDate = Int(endTimeStamp)
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
        
        
    }
    //MARK: - AlmoFire API
        let apiClient : ApiClient = ApiClient()
        private let disposeBag = DisposeBag()

    func getreportDataApi() -> Observable<GetReportRes> {
        if let userInfo = self.appdelegate?.loadUserInfo() {
            if userInfo.idmember != 0 {
                reportsendModel.idmember = userInfo.idmember
            }
        }
        return apiClient.requestAPI(ApiRouter.Get(urlApi: "/api/Report/GetListReportMonth", param: ["datatype" : dataType ?? "income", "idmember" : reportsendModel.idmember?.convertToString ?? 0, "start_timestamp" : startDate.convertToString ?? "", "end_timestamp" : endDate.convertToString ?? ""]))
    }

        func reportData() {
    //        otpforgetpinmodel.phone = phonesend
            
            self.dispatchGroup?.enter()
            getreportDataApi()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resData in
                    
    //                print(resData)
                    if resData.success == true {
                        self.getreportRes = resData.data
                        self.registercell()
                        self.inittableview()
                        self.report_table.reloadData()
                        if let cell = self.report_table.dequeueReusableCell(withIdentifier: "Report_tbCell") as? Report_tbCell {
                            cell.CV_inTBReport.reloadData()
                        }
                        self.lb_total.text = self.getreportRes.first?.totalBalance
                        self.lb_income.text = self.getreportRes.first?.totalIncome
                        self.lb_expenses.text = self.getreportRes.first?.totalExpenses
                        print("Report : Data " + "\(self.getreportRes)")
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
            self.dispatchGroup?.leave()
        }
        
// MARK: - Pie Chart
    func animationDidStart() {
        print(#function)
    }
    
    func animationDidStop() {
        print(#function)
    }
    
}

