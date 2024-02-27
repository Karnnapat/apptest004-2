//
//  Income_expensesType.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 15/1/2567 BE.
//

import UIKit

class IncomeType: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var list_Cell: UITableView!
    
    var actionHandler : ((SubGetTypeIncomeResponse) -> Void)?
    var getIncometype : [SubGetTypeIncomeResponse] = [SubGetTypeIncomeResponse]()
    
//  MARK: - viewdidload
    override func viewDidLoad() {
           super.viewDidLoad()
        inittable()
        registercell()
        
       }
    
    func inittable() {
        list_Cell.delegate = self
        list_Cell.dataSource = self
    }
    
    func registercell(){
        list_Cell.register(UINib(nibName: "Type_TCell", bundle: nil), forCellReuseIdentifier: "Type_TCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let restypedata = getIncometype[0].type
        return getIncometype.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Type_TCell") as? Type_TCell else {        return UITableViewCell()}
        let getIncometpye = getIncometype[indexPath.row].type
        cell.Type_list.text = getIncometpye
//        if indexPath.row == 0 {
//            cell.Type_list.text = "รายได้แน่นอน"
//        }else{
//            cell.Type_list.text = "รายได้ไม่แน่นอน"
//
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var str : String = ""
//        if indexPath.row == 0 {
//            str = "รายได้แน่นอน"
//        }else {
//            str = "รายได้ไม่แน่นอน"
//        }

        actionHandler?(getIncometype[indexPath.row])
        
        self.dismiss(animated: true)
        
    }
    
    func addAction(handler: @escaping ((SubGetTypeIncomeResponse) -> Void)) {
        actionHandler = handler
    }
}
