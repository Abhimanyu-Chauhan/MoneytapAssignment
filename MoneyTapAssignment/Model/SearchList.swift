//
//  SearchList.swift
//  MoneyTapAssignment
//
//  Created by CE-367 on 7/22/18.
//  Copyright © 2018 CE-367. All rights reserved.
//

import UIKit

struct SearchList {
    
    let pageId: Int?
    let ns: Int?
    let title: String?
    let index: Int?
    let thumbnail: Thumbnail?
    let terms: Terms?
    
}


struct Thumbnail {

    let source: String?
    let width: Int?
    let height: Int?
}


struct Terms {
    let description: NSArray?
}


struct SearchListBase{
    
    var searchListArray = NSMutableArray()
    init(response: NSDictionary){
       
        let query = response[2] as! NSDictionary
        let pages = query["pages"] as! NSArray
        
        for page in pages{
            
            let page = page as! NSDictionary
            let pageId = page["pageid"] as? Int
            let ns = page["ns"] as? Int
            let title = page["title"] as? String
            let index = page["index"] as? Int
            let thumbnail = page["thumbnail"] as! NSDictionary
            let terms = page["terms"] as! NSDictionary
            
            let source = thumbnail["thumbnail"] as? String
            let width = thumbnail["width"] as? Int
            let height = thumbnail["height"] as? Int
            
            let thumbnailObj = Thumbnail.init(source: source, width: width, height: height)
            
            let description = terms["description"] as? NSArray
            let termsObj = Terms.init(description: description)
            
            let searchListObj = SearchList.init(pageId: pageId, ns: ns, title: title, index: index, thumbnail: thumbnailObj, terms: termsObj)
            
            searchListArray.add(searchListObj)
        }
    }
}
