//
//  ViewController.swift
//  MoneyTapAssignment
//
//  Created by CE-367 on 7/21/18.
//  Copyright © 2018 CE-367. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
   
    let searchController = UISearchController(searchResultsController: nil)
    var searchListArray = [SearchList]()
    var gpsoffset = 0
    var searchString = ""
    var searchListBase: SearchListBase?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSearchController(){
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        self.definesPresentationContext = true
        
    }
    
    func makeSearchCall(searchString: String, isPagination: Bool)
    {
        //Make a url request
        NetworkCall.get( searchString: searchString, gpsoffset: self.gpsoffset, completion: { [unowned self](_response: NSDictionary ,_status : Bool?) ->() in
            
            let searchListBase = SearchListBase(response: _response, searchListArray: self.searchListArray )
            
            if searchListBase.gpOffset != nil{
                self.searchListBase = searchListBase
                
                if isPagination{
                    self.searchListArray = self.searchListArray + searchListBase.searchListArray
                }
                else{
                    self.searchListArray = searchListBase.searchListArray
                }
            }
           
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let pages = searchListArray[indexPath.row]
        cell.titleLabel.text = pages.title
        
        if pages.terms?.description?.count != 0{
            
            let description = pages.terms?.description![0] as? String
            cell.descriptionLabel.text = description
            
        }
        
        if let thumbnailUrl = pages.thumbnail?.source{
            cell.thumbnailImageView.sd_setImage(with: URL(string: thumbnailUrl), placeholderImage: UIImage(named: "placeholder.png"))
        }
        
        if indexPath.row == searchListArray.count - 1{
            self.gpsoffset = (self.searchListBase?.gpOffset)!
            makeSearchCall(searchString: searchString, isPagination: true)
        }
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if !searchController.isActive {
            print("Cancelled")
            return
        }
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.gpsoffset = 0
            makeSearchCall(searchString: searchText, isPagination: false)
            searchString = searchText
        }
        else{
            searchString = ""
            searchListArray.removeAll()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let pages = searchListArray[indexPath.row]
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "WikiResultVC") as! WikiResultVC
        VC.pageId = pages.pageId
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
}

