//
//  ContactsListTableViewController.swift
//  contacts
//
//  Created by Matthew O'Connor on 10/18/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class ContactsListTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchContacts()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
    }

    func fetchContacts () {
        ContactsController.shared.fetchContacts { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ContactsController.shared.contact.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath)

        let contact = ContactsController.shared.contact[indexPath.row]
        cell.textLabel?.text = contact.name

        return cell
    }
    

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let destinationVC = segue.destination as? ContactDetailViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row {
                let contact = ContactsController.shared.contact[selectedRow]
                destinationVC.contact = contact
            }
            
        }
    }
    

}
