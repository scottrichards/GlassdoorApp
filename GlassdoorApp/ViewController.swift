//
//  ViewController.swift
//  GlassdoorApp
//
//  Created by Scott Richards on 11/19/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var searchControl: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var searchTerm : String = ""
    
    
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

    func loadData() {
        
    }
    
    func doSearchWithTerm(term:String) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // DO SOmething here
        var cell = tableView.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath)
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

