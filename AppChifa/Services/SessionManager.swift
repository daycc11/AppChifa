//
//  SessionManager.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//
import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    var token: String?
    var usuario: Usuario?
    
    var isAdmin: Bool {
        return usuario?.rol == "admin"
    }
    
    func cerrarSesion() {
        token = nil
        usuario = nil
    }
}
