//
//  User.swift
//  Yonder
//
//  Created by Felix Wong on 2023-05-30.
//

import Foundation

//codable protocol allows us to take incoming raw json data and map it to a data object. so we manipulate the data to conform to either the applications needs or tot he databases needs.
struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullName: "Oliver Sanchez", email: "Oli@example.com")
}
