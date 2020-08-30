//
//  Usuario.swift
//  Snapchat
//
//  Created by Sergio Roberto dos Santos Junior on 11/07/20.
//  Copyright © 2020 Sergio Roberto dos Santos Junior. All rights reserved.
//

import Foundation

class Usuario {
    
    var email: String
    var nome: String
    var uid: String
    
    init(email: String, nome: String, uid: String) {
        self.email = email
        self.nome = nome
        self.uid = uid
    }
}
