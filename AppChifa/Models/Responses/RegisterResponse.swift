//
//  RegisterResponse.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation

struct RegisterResponse: Codable {
    let message: String
    let errors: [String: [String]]?
    
    var esExitoso: Bool { errors == nil }
    
    var mensajeError: String {
        guard let errors = errors else { return "" }
        return errors.values.flatMap { $0 }.joined(separator: "\n")
    }
    
    init(message: String, errors: [String: [String]]? = nil) {
        self.message = message
        self.errors = errors
    }
    
    init(from decoder: Decoder) throws {
        // Caso 1: La API devuelve un string simple
        if let container = try? decoder.singleValueContainer(),
           let msg = try? container.decode(String.self) {
            message = msg
            errors = nil
            return
        }
        // Caso 2: La API devuelve errores de validación
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errors = try container.decodeIfPresent([String: [String]].self, forKey: .errors)
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? "Error de validación"
    }
    
    enum CodingKeys: String, CodingKey {
        case message, errors
    }
}

