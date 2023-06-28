//
//  HTTPMethod.swift
//  MyLotto
//
//  Created by Luu Dinh Nam on 10/4/17.
//  Copyright © 2017 Luu Dinh Nam. All rights reserved.
//

import Foundation
enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
    var string:String{
        return self.rawValue
    }
}
