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
    let joltImage: String?

    
    var dictionary:[String: Any] {
        return [
            "Note": note,
            "Created On": createdOn,
            "Image Url": joltImage
        ]
    }
    
}

extension Jolt: DocumentSerializable {
    init?(dictionary: [String : Any]) {
      guard let note = dictionary["Note"] as? String,
            let createdOn = dictionary["Created On"] as? Date,
            let joltImage = dictionary["Image Url"] as? String
            else {return nil}
        
        self.init(note: note, createdOn: createdOn, joltImage: joltImage)
        
    }
}
