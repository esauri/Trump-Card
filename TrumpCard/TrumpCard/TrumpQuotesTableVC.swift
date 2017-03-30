//
//  TrumpQuotesTableVC.swift
//  TrumpCard
//
//  Created by Erick Sauri on 12/10/16.
//  Copyright © 2016 Erick Sauri. All rights reserved.
//

import UIKit

class TrumpQuotesTableVC: UITableViewController {
    
    var pressConference = PressConference()
    
    // Create a front-end for choices
    var quotes: [Choice] {
        get {
            return self.pressConference.choices
        }
        set (val) {
            self.pressConference.choices = val
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of quotes
        return quotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "referencesCell", for: indexPath)
        let quote = quotes[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = quote.getResponse()
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected qoute
        let quote = quotes[indexPath.row]
        
        // Create a ViewController for the quote
        let quoteViewController = QuoteViewController(style: .grouped)
        
        // Pass in a title
        quoteViewController.title = quote.getResponse()
        
        // Pass in the quote
        quoteViewController.quote = quote
        
        // Push new View Controller
        navigationController?.pushViewController(quoteViewController, animated: true)
    }

    // If home button was clicked
    @IBAction func homeButtonClicked(_ sender: UIBarButtonItem) {
        // Show home view
        self.dismiss(animated: true, completion: nil)
    }
}
