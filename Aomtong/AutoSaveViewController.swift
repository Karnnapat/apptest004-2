//
//  AutoSaveViewController.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 4/1/2567 BE.
//

import UIKit
import RxSwift
import DropDown

class AutoSaveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var appdelegate = UIApplication.shared.delegate as? AppDelegate
    var Autosavemodel : [SubAutoSaveRes] = [SubAutoSaveRes]()
    var memId = AutoSaveModel()


    let myDropDown = DropDown()
    let OptionsValuesArray = ["ทั้งหมด", "ทุกวัน", "ทุกสัปดาห์", "ทุกเดือน", "ทุก 3 เดือน"]
    
    @IBOutlet weak var lb_DropDownSelected: UILabel!
    @IBOutlet weak var btn_DropDown: UIButton!
    @IBOutlet weak var DropdownView: UIView!
    @IBOutlet weak var AutoSaveRe_CV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        
        myDropDown.anchorView = DropdownView
        myDropDown.dataSource = OptionsValuesArray
        
        myDropDown.backgroundColor = .FFFFFF
        myDropDown.layer.cornerRadius = 5
        myDropDown.layer.borderWidth = 1
        myDropDown.borderColor = ._545_F_71
        myDropDown.textColor = ._545_F_71
        myDropDown.bottomOffset = CGPoint(x: 0, y: (myDropDown.anchorView?.plainView.bounds.height)!)
        myDropDown.topOffset = CGPoint(x: 0, y: -(myDropDown.anchorView?.plainView.bounds.height)!)
        
        myDropDown.direction = .bottom
        myDropDown.selectionAction = { (index: Int , item: String) in
            self.lb_DropDownSelected.text = self.OptionsValuesArray[index]
            self.AutoSaveRe_CV.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CreatelistData(actionHandler: {
            print("")
        })
    }
    func initcollectionview() {
        AutoSaveRe_CV.delegate = self
        AutoSaveRe_CV.dataSource = self
    }
    
    func registerCell() {
        AutoSaveRe_CV.register(UINib(nibName: "ReportAutoSave_CV", bundle: nil), forCellWithReuseIdentifier: "ReportAutoSave_CV")

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if lb_DropDownSelected.text == "ทั้งหมด" {
            return Autosavemodel.count
        }else {
            let sortdata = Autosavemodel.filter({$0.save_auto_name == lb_DropDownSelected.text})
            return sortdata.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportAutoSave_CV", for: indexPath)as? ReportAutoSave_CV else {return UICollectionViewCell()}
        var sortdata : SubAutoSaveRes?
        
        if lb_DropDownSelected.text == "ทั้งหมด" {
            sortdata = Autosavemodel[indexPath.row]
        }else {
            sortdata = Autosavemodel.filter({$0.save_auto_name == lb_DropDownSelected.text})[indexPath.row]
        }
        
        let ReDate = Double(sortdata?.timestamp ?? 0)
        let ReDateStr = convertUnixTimestampToDateString(timestamp: ReDate)

        cell.lb_Type.text = sortdata?.type_name
        cell.lb_amount.text = sortdata?.amount
        cell.lb_cat.text = sortdata?.category_name
        cell.lb_AutoSave.text = sortdata?.save_auto_name
        cell.lb_Date.text = ReDateStr
        switch sortdata?.type_name {
        case "รายรับแน่นอน" :
            cell.lb_Type.textColor = ._064_F_6_C
            cell.lb_amount.textColor = ._064_F_6_C
        case "รายจ่ายจำเป็น" :
            cell.lb_Type.textColor = .E_85757
            cell.lb_amount.textColor = .E_85757
        case "รายรับไม่แน่นอน" :
            cell.lb_Type.textColor = ._6_DBAD_8
            cell.lb_amount.textColor = ._6_DBAD_8
        case "รายจ่ายไม่จำเป็น" :
            cell.lb_Type.textColor = .E_3_C_529
            cell.lb_amount.textColor = .E_3_C_529
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyborad.instantiateViewController(identifier: "AddincomeViewController") as! AddincomeViewController
        collectionView.tag = indexPath.row
        switch Autosavemodel[indexPath.row].dataType {
        case "income" :
            vc.delState = .Autosaveincome
            vc.Autosavemodel = Autosavemodel[indexPath.row]
//            vc.datatoDel = getreportRes.first?.report_month_list_income?.first?.report_List?[indexPath.row] ?? AllListReportInSubRes()

        case "expenses" :
            vc.delState = .Autosaveexpenses
            vc.Autosavemodel = Autosavemodel[indexPath.row]

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
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" // เปลี่ยนรูปแบบตามความต้องการ

            // แปลง Date เป็นสตริงของวันที่
            let dateString = dateFormatter.string(from: date)

            return dateString
        }
        
    @IBAction func isTappedbtn_DropDown(_ sender: Any) {
        
        myDropDown.show()
        }

    
//    MARK: - ApiClient
    let apiClient : ApiClient = ApiClient()
    private let disposeBag = DisposeBag()
    
        func AutoSaveDataApi(data : AutoSaveModel) -> Observable<AutoSaveRes> {
            return apiClient.requestAPI(ApiRouter.Post(data: data.convertToData, urlApi:"/api/Report/GetListAuto"))
        }
                    
    func CreatelistData(actionHandler : @escaping (() -> Void)) {
            if let userInfo = self.appdelegate?.loadUserInfo() {
                memId.idmember = userInfo.idmember ?? 0
            }
            AutoSaveDataApi(data: memId)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { resData in
                    if resData.success == true{
                        self.Autosavemodel = resData.data ?? []
                        self.initcollectionview()
                        self.AutoSaveRe_CV.reloadData()
                    }else{
                        let alert = UIAlertController(title: "เกิดข้อผิดพลากขึ้น", message: "ขออภัยเกิดข้อผิดพลาด", preferredStyle: .alert)
                        let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                            self.dismiss(animated: true)
                    }
                        alert.addAction(acceptAction)
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
                }).disposed(by: disposeBag)
        }
}
