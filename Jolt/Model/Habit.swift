//
//  Habit.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-02-12.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct Habit {
    
    let name: String
    let description: String
    let sessionLength: Int
    let createdOn: Date
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
        guard let name = dictionary["Name"] as? String,
        let description = dictionary["Description"] as? String,
        let sessionLength = dictionary["Session Length"] as? Int,
        let createdOn = dictionary["Created On"] as? Date,
        let sessionCount = dictionary["Session Count"] as? Int,
        let totalTimeLogged = dictionary["Total Time Logged"] as? Int,
        let joltCount = dictionary["Jolt Count"] as? Int,
        let archived = dictionary["Archived"] as? Bool
            else {
                print("Houston we have a problem")
                return nil
                
        }
        
        self.init(name: name, description: description, sessionLength: sessionLength, createdOn: createdOn, sessionCount: sessionCount, totalTimeLogged: totalTimeLogged, joltCount: joltCount, archived: archived)
        
    }
}
