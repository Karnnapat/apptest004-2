//
//  Income_Expenses.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 3/1/2567 BE.
//

import UIKit

class Income_Expenses: UIViewController, list_ViewcontrollerModelDelegate {
    func setupsegment() {
        return print("this way")
    }
    
    @IBOutlet weak var lb_segmentnametotalSum: UILabel!
    @IBOutlet weak var lb_segmentnameList: UILabel!
    
    @IBOutlet weak var ViewDateSegment: UIView!
    @IBOutlet weak var segment_View: UIView!
    var view_segment_select : UIView!
    var lb_segment_select : UILabel!
    
    @IBOutlet weak var view_segment_Sselected: UIView!
    @IBOutlet weak var view_segment_selected: UIView!
    var reportListVC : UIView_ReportListViewController = UIView_ReportListViewController()
    var reportSummarizeVC : ToTalSummarize_ViewController = ToTalSummarize_ViewController()
    
    var DateNow : String!
    var Week : String!
    var currentDate = Date()
    var calendar = Calendar.current
    //    var ico_segment_select : UIImageView!
//    let Subview = UIView_ReportList()
    override func viewDidLoad() {
        super.viewDidLoad()
        view_segment_Sselected.isHidden = true

        // Add tap gesture recognizer to labelnum1
                let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(labelnum1Tapped))
        lb_segmentnameList.addGestureRecognizer(tapGesture1)
        lb_segmentnameList.isUserInteractionEnabled = true

                // Add tap gesture recognizer to labelnum2
                let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(labelnum2Tapped))
        lb_segmentnametotalSum.addGestureRecognizer(tapGesture2)
        lb_segmentnametotalSum.isUserInteractionEnabled = true
        
//        let SubViewReport = reportListVC.storyboard?.instantiateViewController(identifier: "UIView_ReportListViewController")as? UIView_ReportListViewController
        let storyboard = UIStoryboard(name: "report_Income-Expenses", bundle: nil)
         reportListVC = storyboard.instantiateViewController(withIdentifier: "UIView_ReportListViewController") as! UIView_ReportListViewController
        
        addChild(reportListVC)
        self.ViewDateSegment.addSubview(reportListVC.view)
        reportListVC.didMove(toParent: self)
        
        reportListVC.view.frame = CGRect(x: 0, y: 0, width: self.ViewDateSegment.frame.width, height: self.ViewDateSegment.frame.height)
        reportListVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]


        
//        let subview = UIView_ReportList(frame: ViewDateSegment.bounds)
//        reportListVC.view.frame = self.ViewDateSegment.bounds
////        reportListVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        reportListVC.view.backgroundColor = .yellow
//        self.ViewDateSegment.addSubview(reportListVC.view)
    }
    
    
    
    @objc func labelnum1Tapped() {
//        moveSelectedViewtoFlabel(under: lb_segmentnameList)
        view_segment_selected.isHidden = false
        view_segment_Sselected.isHidden = true
        lb_segmentnameList.textColor = ._81_C_8_E_4
        lb_segmentnametotalSum.textColor = ._545_F_71
        
        reportListVC.willMove(toParent: nil)
        reportListVC.view.removeFromSuperview()
        reportListVC.removeFromParent()

        let storyboard = UIStoryboard(name: "report_Income-Expenses", bundle: nil)
         reportListVC = storyboard.instantiateViewController(withIdentifier: "UIView_ReportListViewController") as! UIView_ReportListViewController
        
        addChild(reportListVC)
        self.ViewDateSegment.addSubview(reportListVC.view)
        reportListVC.didMove(toParent: self)
        
        reportListVC.view.frame = CGRect(x: 0, y: 0, width: self.ViewDateSegment.frame.width, height: self.ViewDateSegment.frame.height)
        reportListVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reportListVC.Segment.selectedSegmentIndex = 0

        
    }

   @objc func labelnum2Tapped() {
//       moveSelectedViewtoSlabel(under: lb_segmentnametotalSum)
       view_segment_selected.isHidden = true
       view_segment_Sselected.isHidden = false
       lb_segmentnameList.textColor = ._545_F_71
       lb_segmentnametotalSum.textColor = .FF_8686
       
//       reportSummarizeVC.willMove(toParent: nil)
//       reportSummarizeVC.view.removeFromSuperview()
//       reportSummarizeVC.removeFromParent()
       
       let storyboard = UIStoryboard(name: "report_Income-Expenses", bundle: nil)
       reportSummarizeVC = storyboard.instantiateViewController(withIdentifier: "ToTalSummarize_ViewController") as! ToTalSummarize_ViewController
       
       addChild(reportSummarizeVC)
       self.ViewDateSegment.addSubview(reportSummarizeVC.view)
       reportSummarizeVC.didMove(toParent: self)
       
       reportSummarizeVC.view.frame = CGRect(x: 0, y: 0, width: self.ViewDateSegment.frame.width, height: self.ViewDateSegment.frame.height)
       reportSummarizeVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//       reportSummarizeVC.btn_Left.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)

//       switch reportSummarizeVC.Segment.selectedSegmentIndex {
//       case 0:
//           let dateFormatter = DateFormatter()
//           dateFormatter.calendar = Calendar(identifier: .gregorian)
//           dateFormatter.locale = Locale(identifier: "th-TH")
//           dateFormatter.dateFormat = "dd MMMM yyyy"
//           DateNow = dateFormatter.string(from: Date())
//       case 1:
//           let dateFormatter = DateFormatter()
//           dateFormatter.calendar = Calendar(identifier: .gregorian)
//           dateFormatter.locale = Locale(identifier: "th-TH")
////           dateFormatter.dateFormat = "dd MMMM yyyy"
//           dateFormatter.dateFormat = "EEEE"
//           let currentDay = dateFormatter.string(from: currentDate)
//           let nextSunday = calendar.date(byAdding: .day, value: 1, to: currentDate)
//           let Sunday = dateFormatter.string(from: nextSunday ?? Date())
//           
//           let nextSaturday = calendar.date(byAdding: .day, value: 7, to: currentDate)
//           let Saturday = dateFormatter.string(from: nextSaturday ?? Date())
//           reportSummarizeVC.lb_Date.text = "\(Sunday)" + " - " + "\(Saturday)"
//       default:
//           break
//       }
       reportSummarizeVC.Segment.selectedSegmentIndex = 0
//       reportSummarizeVC.lb_Date.text = DateNow

   }
    

//    // ฟังก์ชันที่จะถูกเรียก
//    @objc func handleButtonTap() {
//        reportSummarizeVC.leftTapAction(self)
//    }

    
    //    MARK: - convertUnix to String
        func convertUnixTimestampToDateString(timestamp: TimeInterval) -> String {
            // สร้าง Date จาก Unix timestamp
            let date = Date(timeIntervalSince1970: timestamp)

            // กำหนดรูปแบบของวันที่ที่คุณต้องการ
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "th-TH")
            dateFormatter.dateFormat = "yyyy-MMMM-dd" // เปลี่ยนรูปแบบตามความต้องการ

            // แปลง Date เป็นสตริงของวันที่
            let dateString = dateFormatter.string(from: date)
            
            return dateString
        }
}
