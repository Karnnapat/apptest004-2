//
//  IncomeAutoSave.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 16/1/2567 BE.
//

import UIKit

class IncomeAutoSave: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var SaveAuto : [SubAutoSaveResponse] = [SubAutoSaveResponse]()
    var AutosaveactionHandler : ((SubAutoSaveResponse) -> Void)?


    @IBOutlet weak var TB_AutoSaveOptions: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inittable()
        registercell()
    }
    
    func inittable() {
        TB_AutoSaveOptions.delegate = self
        TB_AutoSaveOptions.dataSource = self
    }
    
    func registercell(){
        TB_AutoSaveOptions.register(UINib(nibName: "Type_TCell", bundle: nil), forCellReuseIdentifier: "Type_TCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SaveAuto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Type_TCell") as? Type_TCell else {        return UITableViewCell()}
        let saveautoData = SaveAuto[indexPath.row].frequency
        cell.Type_list.text = saveautoData
//        if indexPath.row == 0 {
//            cell.Type_list.text = "ไม่มี"
//        }else if indexPath.row == 1{
//            cell.Type_list.text = "ทุกวัน"
//        }else if indexPath.row == 2{
//            cell.Type_list.text = "ทุกสัปดาห์"
//        }else if indexPath.row == 3{
//            cell.Type_list.text = "ทุกเดือน"
//        }else{
//            cell.Type_list.text = "ทุก 3 เดือน"
//        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var Autosavetx : String = ""
//        if indexPath.row == 0 {
//            Autosavetx = "ไม่มี"
//        }else if indexPath.row == 1{
//            Autosavetx = "ทุกวัน"
//        }else if indexPath.row == 2{
//            Autosavetx = "ทุกสัปดาห์"
//        }else if indexPath.row == 3{
//            Autosavetx = "ทุกเดือน"
//        }else {
//            Autosavetx = "ทุก 3 เดือน"
//        }
        AutosaveactionHandler?(SaveAuto[indexPath.row])
        self.dismiss(animated: true)
        
    }
    
    func addautosaveincomeAction(handlerautosave: @escaping ((SubAutoSaveResponse) -> Void)) {
        AutosaveactionHandler = handlerautosave
    }
}

