//
//  NetworkCall.swift
//  Lottery
//
//  Created by Sakshi Jain on 12/04/17.
//  Copyright © 2017 compassites. All rights reserved.
//


#if DEBUG
let SERVER_BASE_URL = "http://54.169.105.141:8000/api/v1/"
#else
let SERVER_BASE_URL = "http://54.169.105.141:8000/api/v1/"
#endif

import UIKit


typealias responseCompletion = (_ response: Dictionary<String, AnyObject>?, _ status: Bool?) -> Void

enum eHTTPMethod
{
    case eHTTPMethodGET
    case eHTTPMethodPOST
    case eHTTPMethodPUT
    case eHTTPMethodDELETE
}

enum eWebRequestName
{
    case eRequestTypeLogin
    case eRequestTypeRegistration
    case eRequestTypeOTP
    case eRequestTypeForgotPassword
    case eRequestTypeProfile
    case eRequestCountryList
    case eRequestCreatePassword
    case eRequestRefreshToken
    case eRequestInterest
    case eRequestCampaignInfo
    case eRequestLogout
    case eRequestGetQuestion
}

/*
 'http_code' is '200' & 'success' is 'true' in case of success
 'http_code' is '422' & 'success' is 'false' in case of failre (ex: validation errors)
 'http_code' is '500'(series) & 'success' is 'false' in case of server side error (ex: exceptions)
 'http_code' is '401' (Unauthorized: Access is denied )
 'http_code' is '400' (Unauthorized: Access is denied )
 */

enum eStatusCode: Int
{
    case eRequestSuccess = 200
    case eRequestFailure = 422
    case eServerNotRespond = 500
    case eServerNotResponding = 599
    case eInvalidToken = 400
    case eInvalidTokenLimit = 499
}

var headerToken = ""

let ULBaseUrl = "https://en.wikipedia.org//w/api.php?"

public class NetworkCall: NSObject,URLSessionTaskDelegate {

    
    //MARK: GET Calls with base URL
    @discardableResult class func get(searchString:String, completion: @escaping responseCompletion) -> URLSessionDataTask{
        
        var requestQueryItem = [URLQueryItem]()
        requestQueryItem = [(URLQueryItem(name: "action", value: "query")), (URLQueryItem(name: "format", value: "json")),(URLQueryItem(name: "prop", value: "pageimages|pageterms")), (URLQueryItem(name: "generator", value: "prefixsearch")), (URLQueryItem(name: "redirects", value: "1")), (URLQueryItem(name: "formatversion", value: "2")), (URLQueryItem(name: "piprop", value: "thumbnail")), (URLQueryItem(name: "pithumbsize", value: "50")), (URLQueryItem(name: "pilimit", value: "10")), (URLQueryItem(name: "wbptterms", value: "description")), (URLQueryItem(name: "gpssearch", value: searchString)), (URLQueryItem(name: "gpslimit", value: "10"))]
        
        let getUrl: URLComponents! = NetworkCall.buildGetUrl(parameters: requestQueryItem)
        let request: NSMutableURLRequest = NSMutableURLRequest(url: getUrl.url!)
        request.httpMethod = "GET"
        
        return NetworkCall.sendRequest(request, completion: completion)
    }
    
    @discardableResult class func buildGetUrl(parameters: Array<URLQueryItem>?) -> URLComponents {
        var urlComponents: URLComponents! = NetworkCall.connectionUrlComponent()
        
        if parameters != nil {
            urlComponents.queryItems = parameters
        }
        print("urlComponents================= \(urlComponents)")
        return urlComponents
    }
    
    //MARK: URL Component Builder
    @discardableResult class func connectionUrlComponent() -> URLComponents {
        let urlComponents: URLComponents! = URLComponents(string: ULBaseUrl)
        return urlComponents
    }

    
    //MARK: Request Handler
    @discardableResult class func sendRequest(_ request:NSMutableURLRequest, completion:@escaping responseCompletion) -> URLSessionDataTask {
        
        if !(ULReachability.isNetworkConnected()) {
            DispatchQueue.main.async {
//                ULUtility.sharedUtility.hideActivityIndicator()
//                ULUtility.sharedUtility.ulAlertInstance.showAlert(NetworkError, completionHandler: {_ in})
            }
        }
//        if let cookie = ArchiveUtil.fetchCookie() {
//            var headers = HTTPCookie.requestHeaderFields(with: [cookie])
//            if let deviceToken = UserDefaults.standard.value(forKey: "Device_Token")  {
//                headers.updateValue(deviceToken as! String, forKey: "device-token")
//                headers.updateValue("iOS", forKey: "device-type")
//            }
//            request.allHTTPHeaderFields = headers
//        }
        //  request.timeoutInterval = 30.0
        
        let session: URLSession = URLSession.shared
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (response, urlResponse, error) in
            var responseDictionary = Dictionary<String, AnyObject>()
            let httpResponse: HTTPURLResponse! = urlResponse as? HTTPURLResponse
            
            if !(ULReachability.isNetworkConnected()) {
                return
            }
            
            if let info = error as NSError? {
                if info.code == NSURLErrorTimedOut {
                    //ULUtility.sharedUtility.isRequestTimedOut = true
                }
            }
            if (response != nil) {
                do {
                    responseDictionary = try JSONSerialization.jsonObject(with: response!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary as! [String : AnyObject]
                    print(responseDictionary)
                } catch {
                    #if DEBUG
                    print("%@ has returned invalid data", request.url!.absoluteString)
                    print(error)
                    #endif
                }
                
                if (200..<299).contains(httpResponse.statusCode) && !responseDictionary.keys.contains("error") {
                    completion(responseDictionary, true)
                } 
            } else {
                completion(responseDictionary,false)
            }
        }
        task.resume()
        
        return task
    }
}


