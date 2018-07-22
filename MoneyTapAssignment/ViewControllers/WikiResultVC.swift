//
//  WikiResultVC.swift
//  MoneyTapAssignment
//
//  Created by CE-367 on 7/22/18.
//  Copyright © 2018 CE-367. All rights reserved.
//

import UIKit

class WikiResultVC: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {

    var pageId: Int?
    var wikiResult: WikiResult?
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.scrollView.delegate = self
        self.webView.scrollView.showsHorizontalScrollIndicator = false
        webView.delegate = self
        // Do any additional setup after loading the view.
        self.getWikiPageUrl()
    }
    
    func getWikiPageUrl(){
        
        NetworkCall.getWikiDetail( pageId: pageId, completion: {[unowned self] (_response: NSDictionary ,_status : Bool?) ->() in
            
            let wiki = WikiResultBase.init(response: _response, pageId: self.pageId!)
            self.wikiResult = wiki.wikiResult
            
            DispatchQueue.main.async {
                if let url = URL(string: (self.wikiResult?.fullurl!)!) {
                    let request = URLRequest(url: url)
                    self.webView.loadRequest(request)
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) // show indicator
    {
        activityIndicator.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) // hide indicator
    {
        activityIndicator.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        activityIndicator.stopAnimating()
    }

}
