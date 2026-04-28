//
//  Usuario.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation

struct Usuario: Codable {
    var id: String?
    var nombre: String
    var email: String
    var rol: String
    var telefono: String
    var direccion: String?
    var tipoDocumento: String?
    var numeroDocumento: String?
    
    enum CodingKeys: String, CodingKey {
        case id, nombre, email, rol, telefono, direccion, tipoDocumento, numeroDocumento
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        nombre = try container.decodeIfPresent(String.self, forKey: .nombre) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        rol = try container.decodeIfPresent(String.self, forKey: .rol) ?? "cliente"
        telefono = try container.decodeIfPresent(String.self, forKey: .telefono) ?? ""
        direccion = try container.decodeIfPresent(String.self, forKey: .direccion)
        tipoDocumento = try container.decodeIfPresent(String.self, forKey: .tipoDocumento)
        numeroDocumento = try container.decodeIfPresent(String.self, forKey: .numeroDocumento)
    }
}
