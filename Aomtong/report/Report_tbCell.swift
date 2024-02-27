//
//  Report_tbCell.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 4/1/2567 BE.
//

import UIKit
import EGPieChart

class Report_tbCell: UITableViewCell, EGPieChartDelegate {
    
    @IBOutlet weak var lb_reporttype: UILabel!
    
    @IBOutlet weak var colorDataType2: UIView!
    @IBOutlet weak var colorDatatype1: UIView!
    @IBOutlet weak var lb_datatype2: UILabel!
    @IBOutlet weak var lb_datatype1: UILabel!
    @IBOutlet weak var pieChartView: EGPieChartView!
    //    @IBOutlet weak var pieChartView: EGPieChartView!
    @IBOutlet weak var lb_reportnone: UILabel!
    @IBOutlet weak var CV_inTBReport: UICollectionView!
    @IBOutlet weak var tb_intbReport: UITableView!
    @IBOutlet weak var lb_data: UILabel!
    @IBOutlet weak var btn_dropdownnonaction: UIButton!
    @IBAction func btn_dropdown(_ sender: Any) {
//        let storyborad = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyborad.instantiateViewController(identifier: "MMYYYY_dropdown") as! MMYYYY_dropdown
//
//        if let presentationController = vc.presentationController as? UISheetPresentationController {
//                  presentationController.detents = [.custom { context in 500}, .medium(), .large()]
//              }
//        self.present(vc, animated: true)
    }

    @IBOutlet weak var Report_CV: UIView!
    @IBOutlet weak var MMYYYY_Dropdown: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func animationDidStart() {
        print(#function)
    }
    
    func animationDidStop() {
        print(#function)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func registercell(){
//        tb_intbReport.register(UINib(nibName: "Table_list2", bundle: nil), forCellReuseIdentifier: "Table_list2")
        CV_inTBReport.register(UINib(nibName: "Report_CV", bundle: nil), forCellWithReuseIdentifier: "Report_CV")
        
    }
}
