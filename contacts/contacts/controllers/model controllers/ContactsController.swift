//
//  ContactsController.swift
//  contacts
//
//  Created by Matthew O'Connor on 10/18/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

class ContactsController {
    static let shared = ContactsController()
    
    var contact: [Contacts] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: -Create
    func createContact(name: String, number: String, email: String, completion: @escaping (Bool) -> Void) {
        let newContact = Contacts(name: name, number: number, email: email)
        let newRecord = CKRecord(contacts: newContact)
        privateDB.save(newRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = record,
                let savedContact = Contacts(ckRecord: record) else {completion(false);return}
            print("added contact successfully")
            self.contact.append(savedContact)
        }
    }
    
    //MARK: -Fetch
    func fetchContacts(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactStrings.recordKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let records = records else {completion(false);return }
            let contacts = records.compactMap{Contacts(ckRecord: $0)}
            self.contact = contacts
            completion(true)
        }
    }
    
    //MARK: -Update
    func updateContact(contact: Contacts, name: String, number: String, email: String, completion: @escaping (Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: [CKRecord(contacts: contact)], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.queuePriority = .high
        operation.completionBlock = {
            completion(true)
            print("contact updated successfully")
        }
        privateDB.add(operation)
    }

}
