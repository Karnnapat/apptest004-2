//
//  Calculator.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 7/1/2567 BE.
//

import UIKit

class Calculator: UIViewController {
    
    var first = ""
    var second = ""
    var function = ""
    var result = 0.00
    var totalResult = 0.00
    var userInput = ""
    var sum : [String] = [""]
    
    var addState : AddstateType?
    var actionAddCalHandler : ((Double) -> Void)?

    
    public enum AddstateType {
        case income
        case expenses
    }


    @IBOutlet weak var decimal: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBOutlet weak var calulatorDisplay: UILabel!
    @IBAction func clearbutton(_ sender: Any) {
        totalResult = 0.00
        first = ""
        second = ""
        function = ""
        userInput = ""
        result = 0.00
        calulatorDisplay.text = "0.00"
        sum = [""]
    }
    
    @IBAction func dividebutton(_ sender: Any) {
        if result == 0 {
            switch first {
            case "":
                function = "/"
                first = userInput
                userInput = ""
                break
            default:
                function = "/"
                userInput = ""
                break
            }
        }else{
            function = "/"
            first = String(result)
            second = userInput
            userInput = ""
        }
    }
    
    @IBAction func multiplybutton(_ sender: Any) {

        if result == 0 {
            switch first {
            case "":
                function = "*"
                first = userInput
                userInput = ""
                break
            default:
                function = "*"
                userInput = ""
                break
            }
        }else{
            function = "*"
            first = String(result)
            second = userInput
            userInput = ""
        }
    }
    
    @IBAction func minusbuuton(_ sender: Any) {
        if result == 0 {
            switch first {
            case "":
                function = "-"
                first = userInput
                userInput = ""
                break
            default:
                function = "-"
                userInput = ""
                break
            }
        }else{
            function = "-"
            first = String(result)
            second = userInput
            userInput = ""
        }
    }
    
    @IBAction func plusbutton(_ sender: Any) {
        if result == 0 {
            switch first {
            case "":
                function = "+"
                first = userInput
                userInput = ""
                break
            default:
                function = "+"
                userInput = ""
                break
            }
        }else{
            function = "+"
            first = String(result)
            second = userInput
            userInput = ""
        }
//        print("userInput  \(userInput)\n")
//        print("first  \(first)\n")

    }
    
    @IBAction func equalbutton(_ sender: Any) {
        second = userInput
        var firstinput = 0.00
        var secondinput = 0.00
        var doubleuserInput = 0.00
        
        firstinput = Double(first) ?? 0.00
        secondinput = Double(second) ?? 0.00
        doubleuserInput = Double(userInput) ?? 0.00
        
        switch function {
        case "+":
            result = firstinput + secondinput
            userInput = ""
            function = ""
            break
        case "-":
            result = firstinput - secondinput
            userInput = ""
            function = ""
            break
        case "*":
            result = firstinput * secondinput 
            userInput = ""
            function = ""
            break
        case "/":
            result = firstinput / secondinput  
            userInput = ""
            function = ""
            break
        default:
            result = doubleuserInput
            break
        }

        calulatorDisplay.text = String(result)
        print("result from equal  \(result)\n")
        print("userInput from equal \(userInput)\n")
        print("first from equal \(first)\n")

    }
    @IBAction func decimalbutton(_ sender: Any) {
          
        if  userInput.contains("."){
            calulatorDisplay.text = ""
            userInput += ""
            calulatorDisplay.text! += userInput
            
        }else{
            calulatorDisplay.text = ""
            userInput += "."
            calulatorDisplay.text! += userInput
        }
    }
    
    @IBAction func zerobutton(_ sender: Any) {
        calulatorDisplay.text = ""
        userInput += "0"
        calulatorDisplay.text! += userInput
    }
    
    @IBAction func onebutton(_ sender: Any) {
        calulatorDisplay.text = ""
        userInput += "1"
        calulatorDisplay.text! += userInput
    }
    @IBAction func twobutton(_ sender: Any) {
        calulatorDisplay.text = ""
        userInput += "2"
        calulatorDisplay.text! += userInput
    }
    
    @IBAction func threebutton(_ sender: Any) {
        calulatorDisplay.text = ""
        userInput += "3"
        calulatorDisplay.text! += userInput
    }
    
    @IBAction func fourbutton(_ sender: Any) {
        calulatorDisplay.text = ""
        userInput += "4"
        calulatorDisplay.text! += userInput
    }
    
    @IBAction func fivebutton(_ sender: Any) {
        calulatorDisplay.text = ""
        userInput += "5"
        calulatorDisplay.text! += userInput
    }
    @IBAction func sixbutton(_ sender: Any) {
        calulatorDisplay.text = ""
        userInput += "6"
        calulatorDisplay.text! += userInput
    }
    @IBAction func sevenbutton(_ sender: Any) {
        calulatorDisplay.text = ""
        userInput += "7"
        calulatorDisplay.text! += userInput
    }
    @IBAction func eightbutton(_ sender: Any) {
        calulatorDisplay.text = ""
        userInput += "8"
        calulatorDisplay.text! += userInput
    }
    @IBAction func ninebutton(_ sender: Any) {
        calulatorDisplay.text = ""
        userInput += "9"
        calulatorDisplay.text! += userInput
    }
    @IBAction func doublezerobutton(_ sender: Any) {
        calulatorDisplay.text = ""
        userInput += "00"
        calulatorDisplay.text! += userInput
    }
    @IBAction func deletebutton(_ sender: Any) {
        if userInput != "" {
            userInput.removeLast()
            calulatorDisplay.text = userInput
        }else if first != ""{
            first.removeLast()
            calulatorDisplay.text = first
        }
        print("userInput  \(userInput)\n")
        print("first  \(first)")
    }
    
    
    @IBAction func btn_acceptincome(_ sender: Any) {
        
        
        switch addState {
        case .income:
            //            let storyborad = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyborad.instantiateViewController(identifier: "AddincomeViewController") as! AddincomeViewController
        if result > 0 {
            if result != 0 {
                actionAddCalHandler?(result)
                //                vc.CalculatorAddincome = result
            }else{
                if userInput != "" {
                    result = Double(userInput) ?? 0
                    actionAddCalHandler?(result)
                }else{
                    result = Double(first) ?? 0
                    actionAddCalHandler?(result)
                }
            }
        }else{
            if userInput != "" {
                result = Double(userInput) ?? 0
                actionAddCalHandler?(result)
            }else{
                result = Double(first) ?? 0
                actionAddCalHandler?(result)
            }
        }
            self.navigationController?.popViewController(animated: true)
//            self.navigationController?.pushViewController(vc, animated: true)
        case .expenses:
//            let storyborad = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyborad.instantiateViewController(identifier: "AddincomeViewController") as! AddincomeViewController
            if result > 0 {
                if result != 0 {
                    actionAddCalHandler?(result)
                    //                vc.CalculatorAddexpen = result
                }else{
                    if userInput != ""   {
                        result = Double(userInput) ?? 0
                        actionAddCalHandler?(result)
                    }else{
                        result = Double(first) ?? 0
                        actionAddCalHandler?(result)
                    }
                }
            }else{
                if userInput != "" {
                    result = Double(userInput) ?? 0
                    actionAddCalHandler?(result)
                }else{
                    result = Double(first) ?? 0
                    actionAddCalHandler?(result)
                }
            }
            self.navigationController?.popViewController(animated: true)

//            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let alert = UIAlertController(title: "เกิดข้อผิดพลาด", message: "กรุณาลองใหม่อีกครั้ง", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "ตกลง", style: .default) { (action) in
                self.dismiss(animated: true)
        }
            alert.addAction(acceptAction)
            self.present(alert, animated: true, completion: nil)

        }

//        let storyborad = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyborad.instantiateViewController(identifier: "AddincomeViewController") as! AddincomeViewController
//        vc.CalculatorAdd = result
//        
//        print(result)
            
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addCalAction(handleraddtotal: @escaping ((Double) -> Void)) {
        actionAddCalHandler = handleraddtotal
    }
    @IBAction func btn_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
