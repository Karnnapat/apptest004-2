//
//  ApiClient.swift
//  demoFirebase
//
//  Created by IT-EFW-65-03 on 3/11/2565 BE.
//

import Foundation
import RxSwift
import Alamofire

@objc public protocol ApiClientlDelegate: AnyObject {
    @objc func requestFinished(_ result:Any)
    @objc func requestFailed(_ error:Error)
}


class ApiClient {
    
    //let jsonCon : JsonConverter = JsonConverter.init()
    
    //    func getPosts(param: NSDictionary) -> Observable<ApiModel> {
    //        return requestVBApi(ApiRouter.PostVBWS(param: param))
    //    }
    
    var delegate: ApiClientlDelegate?
    var loadingView : LoadingOverlay = LoadingOverlay()
    
    //-------------------------------------------------------------------------------------------------
    //MARK: - The request function to get results in an Observable
    //    public func requestVBApi<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
    //        //        //Create an RxSwift observable, which will be the one to call the request when subscribed to
    //
    //        return Observable<T>.create { observer in
    //            //            //Trigger the HttpRequest using AlamoFire (AF)
    //
    //            let request = AF.request(urlConvertible).responseString(completionHandler: ({ (response: DataResponse<String, AFError>) in
    //                //Check the result from Alamofire's response and check if it's a success or a failure
    //                switch response.result {
    //                case .success(let value):
    //                    //Everything is fine, return the value in onNext
    //                    let dict : NSDictionary = self.jsonCon.jsontoDictionary(string: value) ?? NSDictionary()
    //                    let result : String =  dict["d"] as! String
    //                    if result != "" {
    //                        do {
    //                            let dataDecryptDecode = Data(base64Encoded: result, options: .ignoreUnknownCharacters)
    //                            let dataDes = Constants.cryptLib.decrypt(dataDecryptDecode, key:Constants.keySHA256(), iv: "")
    //                            if let dataDes {
    //                                let decoder = JSONDecoder()
    //
    //                                let apiModel = try decoder.decode(ApiModel.self, from: dataDes)
    //                                observer.onNext(apiModel as! T)
    //                                observer.onCompleted()
    //
    //                                self.delegate?.requestFinished(apiModel.data)
    //                            }
    //                        }
    //                        catch {
    //                            print("unable to convert data to JSON")
    //                        }
    //                    }
    //                case .failure(let error):
    //                    //Something went wrong, switch on the status code and return the error
    //                    switch response.response?.statusCode {
    //                    case 403:
    //                        observer.onError(ApiError.forbidden)
    //                    case 404:
    //                        observer.onError(ApiError.notFound)
    //                    case 409:
    //                        observer.onError(ApiError.conflict)
    //                    case 500:
    //                        observer.onError(ApiError.internalServerError)
    //                    default:
    //                        observer.onError(error)
    //                    }
    //
    //                    self.delegate?.requestFailed(error)
    //
    //                }
    //            }))
    //
    //            //Finally, we return a disposable to stop the request
    //            return Disposables.create {
    //                request.cancel()
    //            }
    //        }
    //    }
    
    public func requestAPI<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        //        //Create an RxSwift observable, which will be the one to call the request when subscribed to
        return Observable<T>.create { observer in
            //            //Trigger the HttpRequest using AlamoFire (AF)
            
            self.loadingView.showOverlay()
            
            let request = AF.request(urlConvertible).responseDecodable(completionHandler: ({ (response: DataResponse<T, AFError>) in
                //Check the result from Alamofire's response and check if it's a success or a failure
                switch response.result {
                case .success(let value):
                    //Everything is fine, return the value in onNext
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    //Something went wrong, switch on the status code and return the error
                    print("‼️ Status : \(response.response?.statusCode ?? 000) \n‼️ URL : \(response.response?.url?.absoluteString ?? "")" )
                    
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                        
                        #if DEBUG
                        if let decodedString = String(data: response.data!, encoding: .utf8) {
                            self.showErrorAlert(decodedString)
                        }
                        #else
                        self.showErrorAlert("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง")
                        #endif
                    case nil:
                        observer.onError(ApiError.internalFailed)
                        self.showErrorAlert("กรุณาตรวจสอบ อินเทอร์เน็ต ของท่านแล้วลองใหม่อีกครั้ง")
                    default:
                        observer.onError(error)
                    }
                }
                
                self.loadingView.hideOverlayView()
                
            }))
            
            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func showErrorAlert(_ message: String)  {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        guard let window = firstScene.windows.first else {
            return
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}
