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
    
    var searchListArray = [SearchList]()
    var gpOffset: Int?
    
    init(response: NSDictionary, searchListArray: [SearchList]){
       
        let con = response["continue"] as? NSDictionary
        guard let continuteDict = con else{
            return
        }
        gpOffset = continuteDict["gpsoffset"] as? Int
        self.searchListArray = searchListArray
        let queryDict = response["query"] as? NSDictionary
        guard let query = queryDict else{
            return
        }
        let pagesArray = query["pages"] as? NSArray
        guard let pages = pagesArray else{
            return
        }
        self.searchListArray.removeAll()
        for page in pages{
            
            let page = page as! NSDictionary
            let pageId = page["pageid"] as? Int
            let ns = page["ns"] as? Int
            let title = page["title"] as? String
            let index = page["index"] as? Int
            let thumbnail = page["thumbnail"] as? NSDictionary
            let terms = page["terms"] as? NSDictionary
            
            var thumbnailObj: Thumbnail? = nil
            if let thumbnail = thumbnail{
                let source = thumbnail["source"] as? String
                let width = thumbnail["width"] as? Int
                let height = thumbnail["height"] as? Int
                thumbnailObj = Thumbnail.init(source: source, width: width, height: height)
            }
            
            var termsObj:Terms? = nil
            if let terms = terms{
                let description = terms["description"] as? NSArray
                termsObj = Terms.init(description: description)
            }
            
            let searchListObj = SearchList.init(pageId: pageId, ns: ns, title: title, index: index, thumbnail: thumbnailObj, terms: termsObj)
            self.searchListArray.append(searchListObj)
            
        }
    }
}
