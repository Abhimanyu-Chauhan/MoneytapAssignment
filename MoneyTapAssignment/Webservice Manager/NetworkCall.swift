//
//  NetworkCall.swift
//  Lottery
//
//  Created by Sakshi Jain on 12/04/17.
//  Copyright © 2017 compassites. All rights reserved.
//
import UIKit

typealias responseCompletion = (_ response: NSDictionary, _ status: Bool?) -> Void

let baseUrl = "https://en.wikipedia.org//w/api.php?"

public class NetworkCall: NSObject, URLSessionTaskDelegate {

    
    //MARK: GET Calls with base URL
    @discardableResult class func get(searchString:String, gpsoffset: Int,  completion: @escaping responseCompletion) -> URLSessionDataTask{
        
        var requestQueryItem = [URLQueryItem]()
        requestQueryItem = [(URLQueryItem(name: "action", value: "query")), (URLQueryItem(name: "format", value: "json")),(URLQueryItem(name: "prop", value: "pageimages|pageterms")), (URLQueryItem(name: "generator", value: "prefixsearch")), (URLQueryItem(name: "redirects", value: "1")), (URLQueryItem(name: "formatversion", value: "2")), (URLQueryItem(name: "piprop", value: "thumbnail")), (URLQueryItem(name: "pithumbsize", value: "50")), (URLQueryItem(name: "pilimit", value: "10")), (URLQueryItem(name: "wbptterms", value: "description")), (URLQueryItem(name: "gpssearch", value: searchString)), (URLQueryItem(name: "gpslimit", value: "10")), (URLQueryItem(name: "gpsoffset", value: "\(gpsoffset)"))]
        
        let getUrl: URLComponents! = NetworkCall.buildGetUrl(parameters: requestQueryItem)
        let request: NSMutableURLRequest = NSMutableURLRequest(url: getUrl.url!)
        request.httpMethod = "GET"
        
        return NetworkCall.sendRequest(request, completion: completion)
    }
    
    @discardableResult class func getWikiDetail(pageId:Int?, completion: @escaping responseCompletion) -> URLSessionDataTask{
        
        let pageId = String(format:"%d",pageId!)
        var requestQueryItem = [URLQueryItem]()
        requestQueryItem = [(URLQueryItem(name: "action", value: "query")), (URLQueryItem(name: "format", value: "json")),(URLQueryItem(name: "prop", value: "info")), (URLQueryItem(name: "pageids", value: pageId)), (URLQueryItem(name: "inprop", value: "url"))]
        
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
        let urlComponents: URLComponents! = URLComponents(string: baseUrl)
        return urlComponents
    }

    
    //MARK: Request Handler
    @discardableResult class func sendRequest(_ request:NSMutableURLRequest, completion:@escaping responseCompletion) -> URLSessionDataTask {
        
        if !(MTReachability.isNetworkConnected()) {
            DispatchQueue.main.async {
                print("No Internet Connection!")
                return
            }
        }
        
        let session: URLSession = URLSession.shared
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (response, urlResponse, error) in
            var responseDictionary = NSDictionary()
            //let httpResponse: HTTPURLResponse! = urlResponse as? HTTPURLResponse
            
            
            if let info = error as NSError? {
                if info.code == NSURLErrorTimedOut {
                    //ULUtility.sharedUtility.isRequestTimedOut = true
                }
            }
            if (response != nil) {
                do {
                    responseDictionary = try JSONSerialization.jsonObject(with: response!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    print(responseDictionary)
                } catch {
                    #if DEBUG
                    print("%@ has returned invalid data", request.url!.absoluteString)
                    print(error)
                    #endif
                }
                completion(responseDictionary, true)
//                if (200..<299).contains(httpResponse.statusCode) && !responseDictionary.keys.contains("error") {
//                    completion(responseDictionary, true)
//                }
            } else {
                completion(responseDictionary,false)
            }
        }
        task.resume()
        
        return task
    }

}

