//
//  Contacts.swift
//  contacts
//
//  Created by Matthew O'Connor on 10/18/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

struct ContactStrings {
    static let nameKey = "name"
    static let numberKey = "number"
    static let emailKey = "email"
    static let recordKey = "contact"
}


class Contacts {
    var name: String
    var number: Int
    var email: String
    let ckRecordID: CKRecord.ID
    
    init(name: String, number: Int, email: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.number = number
        self.email = email
        self.ckRecordID = ckRecordID
    }
    
}

extension Contacts {
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[ContactStrings.nameKey] as? String,
            let number = ckRecord[ContactStrings.numberKey] as? Int,
            let email = ckRecord[ContactStrings.emailKey] as? String
            else {return nil}
        self.init(name: name, number: number, email: email, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init (contacts: Contacts) {
        self.init(recordType: ContactStrings.recordKey, recordID: contacts.ckRecordID)
        setValue(contacts.name, forKey: ContactStrings.nameKey)
        setValue(contacts.number, forKey: ContactStrings.numberKey)
        setValue(contacts.email, forKey: ContactStrings.emailKey)
    }
}
