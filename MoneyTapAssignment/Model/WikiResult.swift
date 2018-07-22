//
//  WikiResult.swift
//  MoneyTapAssignment
//
//  Created by CE-367 on 7/22/18.
//  Copyright © 2018 CE-367. All rights reserved.
//

import UIKit

struct WikiResult {
    
    let pageid: Int?
    let fullurl: String?
    let editurl: String?
    let canonicalurl: String?
    
}

struct WikiResultBase{
    
    let wikiResult: WikiResult?
    
    init(response: NSDictionary, pageId: Int){
        
        let query = response["query"] as! NSDictionary
        let pages = query["pages"] as! NSDictionary
        let pageDetail = pages["\(pageId)"] as! NSDictionary
        let pageid = pageDetail["pageid"] as? Int
        let fullurl = pageDetail["fullurl"] as? String
        let editurl = pageDetail["editurl"] as? String
        let canonicalurl = pageDetail["canonicalurl"] as? String
        wikiResult = WikiResult.init(pageid: pageid, fullurl: fullurl, editurl: editurl, canonicalurl: canonicalurl)
        
    }
}
