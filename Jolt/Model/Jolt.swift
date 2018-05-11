//
//  Jolt.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2018-02-12.
//  Copyright © 2018 Gabriel Ducharme. All rights reserved.
//

import Foundation

struct Jolt {
    
    let note: String
    let createdOn: Date

    
    var dictionary:[String: Any] {
        return [
            "Note": note,
            "Created On": createdOn,
        ]
    }
    
}

extension Jolt: DocumentSerializable {
    init?(dictionary: [String : Any]) {
      guard let note = dictionary["Note"] as? String,
            let createdOn = dictionary["Created On"] as? Date
            else {return nil}
        
        self.init(note: note, createdOn: createdOn)
        
    }
}
