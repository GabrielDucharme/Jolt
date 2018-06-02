//
//  Timer.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-02-11.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import Foundation

struct Session {
    
    let sessionLength: Int
    let createdOn: Date
    
    var dictionary:[String: Any] {
        return [
            "Session Length": sessionLength,
            "Created On": createdOn
        ]
    }
}

extension Session: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let sessionLength = dictionary["Session Length"] as? Int,
            let createdOn = dictionary["Created On"] as? Date
            else {
                print("Houston we have a problem")
                return nil
                
        }
        
        self.init(sessionLength: sessionLength, createdOn: createdOn)
        
    }
}
