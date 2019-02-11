//
//  Habit.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-02-12.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import Foundation
import Firebase

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct Habit {
    
    let name: String
    let description: String
    let sessionLength: Int
    let createdOn: Timestamp
    let sessionCount: Int
    let totalTimeLogged: Int
    var joltCount: Int
    var archived: Bool
    
    var dictionary:[String: Any] {
        return [
            "Name": name,
            "Description": description,
            "Session Length": sessionLength,
            "Created On": createdOn,
            "Session Count": sessionCount,
            "Total Time Logged": totalTimeLogged,
            "Jolt Count": joltCount,
            "Archived": archived
        ]
    }
    
}

extension Habit: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        
        guard let name = dictionary["Name"] as? String else {
            print("Houston we have a problem with the name")
            return nil
        }
        
        guard let description = dictionary["Description"] as? String else {
            print("Houston we have a problem with the description")
            return nil
        }
        
        guard let sessionLength = dictionary["Session Length"] as? Int else {
            print("Houston we have a problem with the Session Length")
            return nil
        }
        
        guard let createdOn = dictionary["Created On"] as? Timestamp else {
            print("Houston we have a problem with Created On")
            return nil
        }
        
        guard let sessionCount = dictionary["Session Count"] as? Int else {
            print("Houston we have a problem with Session Count")
            return nil
        }
        
        guard let totalTimeLogged = dictionary["Total Time Logged"] as? Int else {
            print("Houston we have a problem with Total Time Logged")
            return nil
        }
        
        guard let joltCount = dictionary["Jolt Count"] as? Int else {
            print("Houston we have a problem with Jolt Count")
            return nil
        }
        
        guard let archived = dictionary["Archived"] as? Bool else {
            print("Houston we have a problem with archived")
            return nil
        }
        
        self.init(name: name, description: description, sessionLength: sessionLength, createdOn: createdOn, sessionCount: sessionCount, totalTimeLogged: totalTimeLogged, joltCount: joltCount, archived: archived)
        
    }
}
