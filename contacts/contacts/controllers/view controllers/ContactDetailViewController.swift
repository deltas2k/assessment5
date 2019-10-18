//
//  ContactDetailViewController.swift
//  contacts
//
//  Created by Matthew O'Connor on 10/18/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var contact: Contacts? {
        didSet {
            DispatchQueue.main.async {
                self.loadViewIfNeeded()
                self.updateViews()
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
            let number = phoneTextField.text,
            let email = emailTextField.text
            else {return}
        if let contact = contact {
            ContactsController.shared.updateContact(contact: contact, name: name, number: number, email: email) { (success) in
                if success {
                    contact.name = name
                    contact.number = number
                    contact.email = email
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            ContactsController.shared.createContact(name: name, number: number, email: email) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
        }
        
    }
    
    func updateViews() {
        if let contact = contact {
            nameTextField.text = contact.name
            phoneTextField.text = contact.number
            emailTextField.text = contact.email
        }
    }
    
}
