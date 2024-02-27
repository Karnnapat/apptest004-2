//
//  Model.swift
//  apptest004
//
//  Created by Karnnapat Kamolwisutthipong on 26/12/2566 BE.
//

import Foundation

struct phoneNumber : Codable {
    var phone : String = ""
}

//MARK: - ResponseOTP

struct responseOTP : Codable {
    var message : String? = ""
    var success : Bool? = false
    var data    : otpSubDataResponse?
}

struct otpSubDataResponse : Codable {
    var sendTO             : String? = ""
    var refCode            : String? = ""
    var codeotp            : String? = ""
    var expired            : Int?    = 0
    var validateLegthPhone : Bool?
    var is_Duplicate       : Bool?
}
//MARK: - ConfirmOTP
struct ConfirmOTPModel : Codable {
    var phone   : String? = ""
    var refCode : String? = ""
    var otpCode : String? = ""
}

struct ComfirmOTPResponse : Codable {
    var message : String? = ""
    var success : Bool?
    var status  : Int? = 0
    var data    : SubComfirmOTPResponse?
}
struct SubComfirmOTPResponse : Codable {
    var is_Success : Bool? = false
    var message    : String? = ""
}

//MARK: - CreateAccount
struct CreateAccountModel : Codable {
    var phone    : String? = ""
    var username : String? = ""
    var password : String? = ""
}
//MARK: - LoginAccount
struct LoginAccountModel : Codable {
    var phone    : String? = ""
    var password : String? = ""
}
struct LoginAccountResponse : Codable {
    var message : String? = ""
    var success : Bool?
    var status  : Int? = 0
    var data    : SubLoginAccountResponse?
}
struct SubLoginAccountResponse : Codable {
    var idmember    : Int? = 0
    var username    : String? = ""
    var image       : String? = ""
    var is_Verified : Bool? = false
}

//MARK: - ForGetPINModel

struct ForGetPINModel : Codable {
    var phone : String? = ""
    var newPassword : String? = ""
}
struct ForGetPINResponse : Codable {
    var message : String? = ""
    var success : Bool?
    var status  : Int? = 0
    var data    : SubForGetPINResponse?
}
struct SubForGetPINResponse : Codable {
    var idmember   : Int? = 0
    var is_Seccess : Bool? = false
    var message    : String? = ""
}
//MARK: - OTPForGetPINModel

struct OTPForGetPINModel : Codable {
    var phone : String? = ""
}
struct OTPForGetPINResponse : Codable {
    var message : String? = ""
    var success : Bool?
    var status  : Int? = 0
    var data    : SubOTPForGetPINResponse?
}
struct SubOTPForGetPINResponse : Codable {
    var sendTO     : String? = ""
    var refCode    : String? = ""
    var codeotp    : String? = ""
    var expired    : Int? = 0
    var is_seccess : Bool? = false
}
//  MARK: - UserInfomationModel
struct UserInfomationModel : Codable {
    var idmember : Int? = 0
    var username : String? = ""
    var phone    : String? = ""
    var password : String? = ""
    var image    : String? = ""
}
//  MARK: - GetTypeIncomeModel
struct GetTypeIncomeResponse : Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : [SubGetTypeIncomeResponse]
}

struct SubGetTypeIncomeResponse : Codable {
    var id       : Int? = 0
    var type     : String? = ""
}
//  MARK: - GetCategoryIncomeModel
struct GetCateResponse: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : [SubGetCateResponse]
}

struct SubGetCateResponse : Codable {
    var id       : Int? = 0
    var category : String? = ""
    var image    : String? = ""
}

//  MARK: - AutoSaveResponseModel
struct AutoSaveResponse: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : [SubAutoSaveResponse]
}

struct SubAutoSaveResponse : Codable {
    var id       : Int? = 0
    var frequency : String? = ""
}

//  MARK: - CreateIncomeModel
struct CreateDatalistModel : Codable {
    var description : String? = ""
    var amount : Double? = 0.00
    var idmember : Int? = 0
    var dateCreated : Int? = 0
    var idcategory : Int? = 0
    var idtype : Int? = 0
    var auto_schedule : Int? = 0
}

struct CreateDatalistRes: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : SubCreateDatalistRes
}

struct SubCreateDatalistRes : Codable {
    var create_success   : Bool? = false
}

struct CreateExpensesDatalistRes: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : SubCreateExpensesDatalistRes
}

struct SubCreateExpensesDatalistRes : Codable {
    var createSuccess   : Bool? = false
}
//  MARK: - getReport
//struct ReportSumModel : Codable {
//    var datatype          : String? = ""
//    var idmember          : Int? = 0
//    var start_timestamp   : Int? = 0
//    var end_timestamp     : Int? = 0
//}

struct ReportSumRes: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : [SubReportSumRes]
}

struct SubReportSumRes : Codable {
    var titie_Number                : String? = ""
    var total_income                : String? = ""
    var total_expenses              : String? = ""
    var total_Expenses_Necessary    : String? = ""
    var total_Expenses_Unnecessary  : String? = ""
    var total_Income_Certain        : String? = ""
    var total_Income_Uncertain      : String? = ""
}
//MARK: - for Graph
struct ReportGraphRes: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : SubGraphGRes
}

struct SubGraphGRes : Codable {
    var numberDayOf           : String? = ""
    var dataOfList            : [InSubGraphGRes]
}
struct InSubGraphGRes : Codable {
    var number                : String? = ""
    var totalIncome           : String? = ""
    var totalExpenses         : String? = ""
}
//         MARK: - ReportSummarizeRes
struct ReportlistSummarizeRes: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : [SubReportlistSummarizeRes]
}

struct SubReportlistSummarizeRes : Codable {
    var dataList_Of                      : String? = ""
    var number_type                      : String? = ""
    var report_List_ALL            : [InSubReportlistSummarizeRes]
}
struct InSubReportlistSummarizeRes : Codable {
    var type_data                : String? = ""
    var transaction_id                : Int? = 0
    var description           : String? = ""
    var amount         : String? = ""
    var timestamp         : Int? = 0
    var category_id         : Int? = 0
    var category_name         : String? = ""
    var type_id         : Int? = 0
    var type_name         : String? = ""
    var save_auto_id         : Int? = 0
    var save_auto_name         : String? = ""
    var currency_symbol         : String? = ""
    var symbol_math         : String? = ""
}

//  MARK: - getReport
struct GetReportRes: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : [SubGetReportRes]
}

struct  GetReportModel: Codable {
    var datatype : String? = ""
    var idmember   : Int? = 0
    var start_timestamp   : Int? = 0
    var end_timestamp   : Int? = 0
}

struct SubGetReportRes : Codable {
    var totalIncome   : String? = ""
    var totalExpenses   : String? = ""
    var totalBalance   : String? = ""
    var report_month_list_income   : [InSubGetReportincomeRes]?
    var report_month_list_Expenses   : [InSubGetReportExpensesRes]?
}

struct InSubGetReportincomeRes : Codable {
    var month                    : String? = ""
    var total_Income_Certain     : String? = ""
    var total_Income_Uncertain   : String? = ""
    var report_List              : [AllListReportInSubRes]?
}

struct InSubGetReportExpensesRes : Codable {
    var month   : String? = ""
    var total_Expenses_Necessary   : String? = ""
    var total_Expenses_Unnecessary   : String? = ""
    var report_List   : [AllListReportInSubRes]?
}

struct AllListReportInSubRes : Codable {
    var type_data   : String? = ""
    var transaction_id   : Int = 0
    var description   : String? = ""
    var amount   : String? = ""
    var timestamp   : Int? = 0
    var category_id   : Int? = 0
    var category_name   : String? = ""
    var type_id   : Int? = 0
    var type_name   : String? = ""
    var save_auto_id   : Int? = 0
    var save_auto_name   : String? = ""
    var currency_symbol   : String? = ""
    var symbol_math   : String? = ""
}
//  MARK: - Del Data
struct DelModel: Codable {
    var id  : Int = 0
}

struct DelResModel: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : SubDel
}
struct SubDel: Codable {
    var is_Deleted  : Bool? = false
}

struct DelAccountResModel: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : SubDelAccount
}
struct SubDelAccount: Codable {
    var is_seccess  : Bool? = false
}
//  MARK: - UpDate Income Data
struct UpdateincomeModel: Codable {
    var income_id  : Int = 0
    var type_id  : Int = 0
    var category_id  : Int = 0
    var description  : String = ""
    var amount  : Double = 0.00
    var createdateTime  : Int = 0
    var auto_schedule  : Int = 0
}

struct UpdateincomeRes: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : SubUpdateincomeRes
}
struct SubUpdateincomeRes: Codable {
    var income_id  : Int? = 0 //trans id
    var type_id  : Int? = 0
    var type_name  : String? = ""
    var category_id  : Int? = 0
    var category_name  : String? = ""
    var description  : String? = ""
    var amount  : String? = ""
    var save_auto_id  : Int? = 0
    var save_auto_name  : String? = ""
    var createdateTime  : Int? = 0
    var is_Updated  : Bool? = false
}
//  MARK: - UpDate Expenses Data
struct UpdateExpensesModel: Codable {
    var expenses_id  : Int = 0
    var type_id  : Int = 0
    var category_id  : Int = 0
    var description  : String = ""
    var amount  : Double = 0
    var createdateTime  : Int = 0
    var auto_schedule  : Int = 0
}

struct UpdateExpensesRes: Codable {
    var message  : String? = ""
    var success  : Bool? = false
    var status   : Int? = 0
    var data     : SubUpdateExpensesRes
}
struct SubUpdateExpensesRes: Codable {
    var expenses_id  : Int? = 0 //trans id
    var type_id  : Int? = 0
    var type_name  : String? = ""
    var category_id  : Int? = 0
    var category_name  : String? = ""
    var description  : String? = ""
    var amount  : String? = ""
    var save_auto_id  : Int? = 0
    var save_auto_name  : String? = ""
    var createdateTime  : Int? = 0
    var is_Updated  : Bool? = false
}

//  MARK: - AutoSave
struct AutoSaveModel: Codable {
    var idmember  : Int = 0
}

struct AutoSaveRes: Codable{
    var message : String? = ""
    var success : Bool? = false
    var status : Int? = 0
    var data : [SubAutoSaveRes]?
}


struct SubAutoSaveRes: Codable {
    var dataType : String? = ""
    var transaction_id  : Int? = 0 //trans id
    var description  : String? = ""
    var amount  : String? = ""
    var timestamp  : Int? = 0
    var category_id  : Int? = 0
    var category_name  : String? = ""
    var type_id  : Int? = 0
    var type_name  : String? = ""
    var save_auto_id  : Int? = 0
    var save_auto_name  : String? = ""
    var currency_symbol  : String? = ""
    var symbol_math  : String? = ""
}

//  MARK: - Edit Username
struct EditUsernameModel: Codable {
    var idmember  : Int = 0
    var name      : String = ""
}

struct EditUsernameRes: Codable{
    var message : String? = ""
    var success : Bool? = false
    var status : Int? = 0
    var data : SubEditUsername?
}

struct SubEditUsername: Codable{
    var is_Reseted : Bool? = false
}

//  MARK: - Edit Phone Number
struct EditPhonenumModel: Codable {
    var idmember  : Int = 0
    var phone      : String = ""
}

struct EditPhonenumRes: Codable{
    var message : String? = ""
    var success : Bool? = false
    var status : Int? = 0
    var data : SubEditPhonenum?
}

struct SubEditPhonenum: Codable{
    var phone        : String = ""
    var is_Seccess   : Bool? = false
    var message      : String = ""
}


//  MARK: - Date
public struct Months {
    var months    : String = ""
}

public struct MMYYYY {
    var years    : String = ""
    var MperY    : [Months]
}

public struct UserData {
    var User_id    : String = ""
    var phone      : String = ""
    var PIN        : String = ""
}
