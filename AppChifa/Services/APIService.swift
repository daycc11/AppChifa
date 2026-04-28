//
//  APIService.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import Foundation
class APIService {
    static let shared = APIService()
    
    // CAMBIA ESTA URL POR LA DE TU API
    private let baseURL = "https://ruined-unaired-clergyman.ngrok-free.dev/api"
    
    // MARK: - Request genérico
    private func request<T: Codable>(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        
        if let token = SessionManager.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Sin datos"]))) }
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
    
    // MARK: - AUTH
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        request(endpoint: "auth/login", method: "POST",
                body: ["email": email, "password": password],
                responseType: LoginResponse.self, completion: completion)
    }
    
    func register(data: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/register") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        req.httpBody = try? JSONSerialization.data(withJSONObject: data)
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }; return
            }
            let httpResponse = response as? HTTPURLResponse
            let body = String(data: data ?? Data(), encoding: .utf8) ?? ""
            
            DispatchQueue.main.async {
                if httpResponse?.statusCode == 200 {
                    completion(.success(body))
                } else {
                    completion(.failure(NSError(domain: "", code: httpResponse?.statusCode ?? 400,
                        userInfo: [NSLocalizedDescriptionKey: body])))
                }
            }
        }.resume()
    }

    
    // MARK: - CATEGORIAS
    func getCategorias(completion: @escaping (Result<[Categoria], Error>) -> Void) {
        request(endpoint: "categorias", responseType: [Categoria].self, completion: completion)
    }
    
    func createCategoria(data: [String: Any], completion: @escaping (Result<[String: String], Error>) -> Void) {
        request(endpoint: "categorias", method: "POST", body: data,
                responseType: [String: String].self, completion: completion)
    }
    
    func updateCategoria(id: String, data: [String: Any], completion: @escaping (Result<[String: String], Error>) -> Void) {
        request(endpoint: "categorias/\(id)", method: "PUT", body: data,
                responseType: [String: String].self, completion: completion)
    }
    
    func deleteCategoria(id: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        request(endpoint: "categorias/\(id)", method: "DELETE",
                responseType: [String: String].self, completion: completion)
    }
    
    // MARK: - PRODUCTOS
    func getProductos(completion: @escaping (Result<[Producto], Error>) -> Void) {
        request(endpoint: "productos", responseType: [Producto].self, completion: completion)
    }
    
    func getProductosByCategoria(categoriaId: String, completion: @escaping (Result<[Producto], Error>) -> Void) {
        request(endpoint: "productos/categoria/\(categoriaId)",
                responseType: [Producto].self, completion: completion)
    }
    
    func getProducto(id: String, completion: @escaping (Result<Producto, Error>) -> Void) {
        request(endpoint: "productos/\(id)", responseType: Producto.self, completion: completion)
    }
    
    func createProducto(data: [String: Any], completion: @escaping (Result<[String: String], Error>) -> Void) {
        request(endpoint: "productos", method: "POST", body: data,
                responseType: [String: String].self, completion: completion)
    }
    
    func updateProducto(id: String, data: [String: Any], completion: @escaping (Result<[String: String], Error>) -> Void) {
        request(endpoint: "productos/\(id)", method: "PUT", body: data,
                responseType: [String: String].self, completion: completion)
    }
    
    func deleteProducto(id: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        request(endpoint: "productos/\(id)", method: "DELETE",
                responseType: [String: String].self, completion: completion)
    }
    
    // MARK: - PEDIDOS
    func crearPedido(data: [String: Any], completion: @escaping (Result<PedidoResponse, Error>) -> Void) {
        request(endpoint: "pedidos", method: "POST", body: data,
                responseType: PedidoResponse.self, completion: completion)
    }
    
    func getPedidosByUsuario(usuarioId: String, completion: @escaping (Result<[Pedido], Error>) -> Void) {
        request(endpoint: "pedidos/usuario/\(usuarioId)",
                responseType: [Pedido].self, completion: completion)
    }
    
    func getAllPedidos(completion: @escaping (Result<[Pedido], Error>) -> Void) {
        request(endpoint: "pedidos", responseType: [Pedido].self, completion: completion)
    }
    
    func cambiarEstadoPedido(id: String, estado: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        request(endpoint: "pedidos/\(id)/estado", method: "PATCH",
                body: ["estado": estado],
                responseType: [String: String].self, completion: completion)
    }
}
