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
    var logoCache : [String : NSData] = [String : NSData]()
    
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
        let apiURL = "http://api.glassdoor.com/api/api.htm?format=json&v=1&action=employers"
        
        var parameters : NSMutableDictionary = NSMutableDictionary()
        parameters["q"] = self.searchTerm
        parameters["t.k"] = Constants.API.Key
        parameters["t.p"] = Constants.API.ID
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
                if let logoURL = companyInfo?.logoURL {

                    if let url = URL(string: logoURL) {
                        do {
                            let data = try Data(contentsOf: url)
                            DispatchQueue.global().async {
                                    let image = UIImage(data: data)
                                    DispatchQueue.main.async {
                                        companyCell.logoImageView.image = image;
                                    }
                            }
                        } catch {
                            
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteClosure = { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            print("Delete closure called")
        }
        
        let moreClosure = { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            print("More closure called")
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: deleteClosure)
        let moreAction = UITableViewRowAction(style: .normal, title: "More", handler: moreClosure)
        
        return [deleteAction, moreAction]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // you need to override tableView:commitEditingStyle:forRowAtIndexPath:, even though you can leave it blank. If the method is not present, the actions won’t show up on swipe
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

