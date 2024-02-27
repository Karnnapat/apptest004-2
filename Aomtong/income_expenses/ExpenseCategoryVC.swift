//
//  ExpenseCategoryVC.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 16/1/2567 BE.
//

import UIKit

class ExpenseCategoryVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var actionExpenCatHandler : ((SubGetCateResponse) -> Void)?
    var CatExpenses : [SubGetCateResponse] = [SubGetCateResponse]()

    @IBOutlet weak var expenseCategory_list: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initcollectionview()
        registercell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true

    }
    
    func initcollectionview(){
        expenseCategory_list.delegate = self
        expenseCategory_list.dataSource = self
    }
    
    func registercell(){
        
        expenseCategory_list.register(UINib(nibName: "Cells", bundle: nil), forCellWithReuseIdentifier: "CategoryCV_cell")
    }
//    MARK: - collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CatExpenses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCV_cell", for: indexPath) as? CategoryCV_cell else {return UICollectionViewCell()}
        let cateExpensesData = CatExpenses[indexPath.row].category
        let cateExpensesimg = CatExpenses[indexPath.row].image
        cell.lb_Category.text = cateExpensesData
        cell.img_Category.image = UIImage(named: cateExpensesimg ?? "")
//        if indexPath.row == 0 {
//            cell.img_Category.image = UIImage(named: "type2category1")
////            cell.lb_Category.text = "ชอปปิ้ง"
//        }else if indexPath.row == 1 {
//            cell.img_Category.image = UIImage(named: "type2category2")
////            cell.lb_Category.text = "อาหาร & เครื่องดื่ม"
//            
//        }else if indexPath.row == 2 {
//            cell.img_Category.image = UIImage(named: "type2category3")
////            cell.lb_Category.text = "ค่าเดินทาง"
//
//        }else if indexPath.row == 3 {
//            cell.img_Category.image = UIImage(named: "type2category4")
////            cell.lb_Category.text = "ค่าชำระบิล"
//
//        }else if indexPath.row == 4 {
//            cell.img_Category.image = UIImage(named: "type2category5")
////            cell.lb_Category.text = "ค่าโทรศัพท์"
//
//        }else if indexPath.row == 5 {
//            cell.img_Category.image = UIImage(named: "type2category6")
////            cell.lb_Category.text = "สัตว์เลี้ยง"
//
//        }else if indexPath.row == 6 {
//            cell.img_Category.image = UIImage(named: "type2category7")
////            cell.lb_Category.text = "สุขภาพ"
//            
//        }else if indexPath.row == 7 {
//            cell.img_Category.image = UIImage(named: "type2category8")
////            cell.lb_Category.text = "ความงาม"
//
//        }else if indexPath.row == 8 {
//            cell.img_Category.image = UIImage(named: "type2category9")
////            cell.lb_Category.text = "การศึกษา"
//
//        }else if indexPath.row == 9 {
//            cell.img_Category.image = UIImage(named: "type2category10")
////            cell.lb_Category.text = "ค่าประกัน"
//
//        }else if indexPath.row == 10 {
//            cell.img_Category.image = UIImage(named: "type2category11")
////            cell.lb_Category.text = "การลงทุน"
//
//        }else if indexPath.row == 11 {
//            cell.img_Category.image = UIImage(named: "type2category12")
////            cell.lb_Category.text = "บันเทิง"
//
//        }else if indexPath.row == 12 {
//            cell.img_Category.image = UIImage(named: "type2category13")
////            cell.lb_Category.text = "ภาษี & ค่าธรรมเนียม"
//
//        }else if indexPath.row == 13 {
//            cell.img_Category.image = UIImage(named: "type2category14")
////            cell.lb_Category.text = "ของใช้ในบ้าน"
//
//        }else if indexPath.row == 14 {
//            cell.img_Category.image = UIImage(named: "type2category15")
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
//            catstr = "ชอปปิ้ง"
//        }else if indexPath.row == 1 {
//            catstr = "อาหาร & เครื่องดื่ม"
//        }else if indexPath.row == 2 {
//            catstr = "ค่าเดินทาง"
//        }else if indexPath.row == 3 {
//            catstr = "ค่าชำระบิล"
//        }else if indexPath.row == 4 {
//            catstr = "ค่าโทรศัพท์"
//        }else if indexPath.row == 5 {
//            catstr = "สัตว์เลี้ยง"
//        }else if indexPath.row == 6 {
//            catstr = "สุขภาพ"
//        }else if indexPath.row == 7 {
//            catstr = "ความงาม"
//        }else if indexPath.row == 8 {
//            catstr = "การศึกษา"
//        }else if indexPath.row == 9{
//            catstr = "ค่าประกัน"
//        }else if indexPath.row == 10 {
//            catstr = "การลงทุน"
//        }else if indexPath.row == 11 {
//            catstr = "บันเทิง"
//        }else if indexPath.row == 12 {
//            catstr = "ภาษี & ค่าธรรมเนียม"
//        }else if indexPath.row == 13 {
//            catstr = "ของใช้ในบ้าน"
//        }else{
//            catstr = "อื่นๆ"
//
//        }
        
        actionExpenCatHandler?(self.CatExpenses[indexPath.row])
//        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addCatExpenAction(handlerExpenCat: @escaping ((SubGetCateResponse) -> Void)) {
        actionExpenCatHandler = handlerExpenCat
    }
    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
