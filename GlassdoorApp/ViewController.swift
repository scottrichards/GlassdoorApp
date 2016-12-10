//
//  ViewController.swift
//  GlassdoorApp
//
//  Created by Scott Richards on 11/19/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var searchControl: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var searchTerm : String = ""
    var companies : [Company]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchControl.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func readCompanies(jsonArray: NSArray) -> [Company] {
        var result = [Company]()
        for json in jsonArray  {
            if let jsonDictionary = json as? NSDictionary {
                let company = Company(dict: jsonDictionary)
                result.append(company)
            }
        }
        return result
    }
    
    func loadData() {
        let manager = AFHTTPSessionManager()
        let apiURL = "http://api.glassdoor.com/api/api.htm?t.p=107440&t.k=jSi2H1hCmPS&userip=0.0.0.0&useragent=&format=json&v=1&action=employers"
        
        var parameters : NSMutableDictionary = NSMutableDictionary()
        parameters["q"] = self.searchTerm
//        parameters["k"] = Constants.API.Key
        manager.get(apiURL,
                    parameters: parameters,
                    progress: nil,
                    success: {(sessionTask : URLSessionDataTask, any : Any?) in
                        let anyObject = any as AnyObject
                        if let response = anyObject["response"] as? NSDictionary {
                            if let employers = response["employers"] as? NSArray {
                                self.companies = self.readCompanies(jsonArray: employers)
                                self.tableView.reloadData()
                            }
                            
                        }
                        print("SUCCESS: \(any)")},
                    failure: {(sessionTask : URLSessionDataTask?, error : Error) in
                        print("ERROR: \(error.localizedDescription)")
            })
    }
    
    func doSearchWithTerm(term:String) {
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let companyCount = companies?.count {
            count = companyCount
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // DO SOmething here
        let cell = tableView.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath)
        if (indexPath.row < (companies?.count)!) {
            
            let companyInfo = companies?[indexPath.row]
            if let companyCell = cell as? CompanyCell {
                companyCell.companyNameLabel.text = companyInfo?.name
                companyCell.ratingLabel.text = companyInfo?.rating
            }
        }
        return cell
    }
    
    //MARK: - UISearchBar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        if let searchBarText = searchControl.text {
            searchTerm = searchBarText
        }
        doSearchWithTerm(term:searchTerm)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = ""
        searchControl.resignFirstResponder()
        doSearchWithTerm(term:searchTerm)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTerm = searchText
    }
}

