//
//  LoginResponse.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    let usuario: Usuario
}
