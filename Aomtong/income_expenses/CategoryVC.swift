//
//  CategoryVC.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 10/1/2567 BE.
//

import UIKit

class CategoryVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
   
    var getIncomeCat : [SubGetCateResponse] = [SubGetCateResponse]()
    var actionIncomeCatHandler : ((SubGetCateResponse) -> Void)?

    @IBOutlet weak var CategoryCollectionview: UICollectionView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initcollectionview()
        registercell()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true

    }
    
    func initcollectionview(){
        CategoryCollectionview.delegate = self
        CategoryCollectionview.dataSource = self
    }

    func registercell(){
        
        CategoryCollectionview.register(UINib(nibName: "Cells", bundle: nil), forCellWithReuseIdentifier: "CategoryCV_cell")
    }
    
    // MARK: - collectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getIncomeCat.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCV_cell", for: indexPath) as? CategoryCV_cell else {return UICollectionViewCell()}
        let CateIncomeData = getIncomeCat[indexPath.row].category
        let cateExpensesimg = getIncomeCat[indexPath.row].image
        cell.img_Category.image = UIImage(named: cateExpensesimg ?? "")
        cell.lb_Category.text = CateIncomeData
//        if indexPath.row == 0 {
//            cell.img_Category.image = UIImage(named: "type1category1")
////            cell.lb_Category.text = "เงินเดือน"
//        }else if indexPath.row == 1 {
//            cell.img_Category.image = UIImage(named: "type1category2")
////            cell.lb_Category.text = "รายได้พิเศษ"
//            
//        }else if indexPath.row == 2 {
//            cell.img_Category.image = UIImage(named: "type1category3")
////            cell.lb_Category.text = "รายได้จากธุรกิจ"
//
//        }else if indexPath.row == 3 {
//            cell.img_Category.image = UIImage(named: "type1category4")
////            cell.lb_Category.text = "การทำธุรกรรม"
//
//        }else if indexPath.row == 4 {
//            cell.img_Category.image = UIImage(named: "type1category5")
////            cell.lb_Category.text = "ค่าเช่า"
//
//        }else if indexPath.row == 5 {
//            cell.img_Category.image = UIImage(named: "type1category6")
////            cell.lb_Category.text = "ครอบครัวช่วยเหลือ"
//
//        }else if indexPath.row == 6 {
//            cell.img_Category.image = UIImage(named: "type1category7")
////            cell.lb_Category.text = "ค่าขนม"
//            
//        }else if indexPath.row == 7 {
//            cell.img_Category.image = UIImage(named: "type1category8")
////            cell.lb_Category.text = "ค่าล่วงเวลา & โบนัส"
//
//        }else if indexPath.row == 8 {
//            cell.img_Category.image = UIImage(named: "type1category9")
////            cell.lb_Category.text = "สินทรัพย์"
//
//        }else if indexPath.row == 9 {
//            cell.img_Category.image = UIImage(named: "type1category10")
////            cell.lb_Category.text = "ของขวัญ"
//
//        }else if indexPath.row == 10 {
//            cell.img_Category.image = UIImage(named: "type1category11")
////            cell.lb_Category.text = "ดอกเบี้ย/เงินปันผล"
//
//        }else if indexPath.row == 11 {
//            cell.img_Category.image = UIImage(named: "type1category12")
////            cell.lb_Category.text = "อื่นๆ"
//
//        }else {
//            cell.img_Category.isHidden = true
//            cell.lb_Category.isHidden = true
//        }
        
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var catstr : String = ""
//        if indexPath.row == 0 {
//            catstr = "เงินเดือน"
//        }else if indexPath.row == 1 {
//            catstr = "รายได้พิเศษ"
//        }else if indexPath.row == 2 {
//            catstr = "รายได้จากธุรกิจ"
//        }else if indexPath.row == 3 {
//            catstr = "การทำธุรกรรม"
//        }else if indexPath.row == 4 {
//            catstr = "ค่าเช่า"
//        }else if indexPath.row == 5 {
//            catstr = "ครอบครัวช่วยเหลือ"
//        }else if indexPath.row == 6 {
//            catstr = "ค่าขนม"
//        }else if indexPath.row == 7 {
//            catstr = "ค่าล่วงเวลา & โบนัส"
//        }else if indexPath.row == 8 {
//            catstr = "สินทรัพย์"
//        }else if indexPath.row == 9 {
//            catstr = "ของขวัญ"
//        }else if indexPath.row == 10 {
//            catstr = "ดอกเบี้ย/เงินปันผล"
//        }else{
//            catstr = "อื่นๆ"
//        }
        
        actionIncomeCatHandler?(getIncomeCat[indexPath.row])
//        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addCatIncomeAction(handlerIncomeCat: @escaping ((SubGetCateResponse) -> Void)) {
        actionIncomeCatHandler = handlerIncomeCat
    }
//  MARK: - TapAction
    
    @IBAction func BackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
