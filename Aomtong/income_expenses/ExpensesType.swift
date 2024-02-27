//
//  ExpensesType.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 15/1/2567 BE.
//

import UIKit

class ExpensesType: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var actionHandler : ((SubGetTypeIncomeResponse) -> Void)?
    var getExpensestype : [SubGetTypeIncomeResponse] = [SubGetTypeIncomeResponse]()
    
    @IBOutlet weak var Expenses_list: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        inittable()
        registercell()
        Expenses_list.backgroundColor = .white
    }
    func inittable() {
        Expenses_list.delegate = self
        Expenses_list.dataSource = self
    }
    
    func registercell(){
        Expenses_list.register(UINib(nibName: "Type_TCell", bundle: nil), forCellReuseIdentifier: "Type_TCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getExpensestype.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Type_TCell") as? Type_TCell else {        return UITableViewCell()}
        let ExpensesType = getExpensestype[indexPath.row].type
        cell.Type_list.text = ExpensesType
//        if indexPath.row == 0 {
//            cell.Type_list.text = "รายจ่ายแน่นอน"
//        }else{
//            cell.Type_list.text = "รายจ่ายไม่แน่นอน"
//
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var ExpenType : String = ""
//        if indexPath.row == 0 {
//            ExpenType = "รายจ่ายจำเป็น"
//        }else {
//            ExpenType = "รายจ่ายไม่จำเป็น"
//        }
        actionHandler?(getExpensestype[indexPath.row])
        self.dismiss(animated: true)
        
    }
    
    func addExpenAction(handlerExpen: @escaping ((SubGetTypeIncomeResponse) -> Void)) {
        actionHandler = handlerExpen
    }
    
    @IBAction func BTn_Accept(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
