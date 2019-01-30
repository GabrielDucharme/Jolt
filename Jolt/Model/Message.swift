//
//  Message.swift
//  Jolt
//
//  Created by Gabriel Ducharme on 2019-01-23.
//  Copyright © 2019 Gabriel Ducharme. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct Member {
    let name: String
    let color: UIColor
}

struct Message {
    let member: Member
    let text: String
    let messageId: String
}

extension Message: MessageType {
    var kind: MessageKind {
        return .text(text)
    }
    
    var sender: Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
}
