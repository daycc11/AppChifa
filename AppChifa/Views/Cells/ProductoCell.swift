//
//  ProductoCell.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//
import UIKit

class ProductoCell: UITableViewCell {
    private let imgView = UIImageView()
    private let nombreLbl = UILabel()
    private let precioLbl = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurar()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); configurar() }
    
    private func configurar() {
        backgroundColor = .clear
        imgView.contentMode = .scaleAspectFill; imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 8; imgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imgView)
        
        nombreLbl.textColor = .white; nombreLbl.font = .boldSystemFont(ofSize: 16)
        nombreLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nombreLbl)
        
        precioLbl.textColor = UIColor(red: 0.6, green: 0, blue: 0.2, alpha: 1)
        precioLbl.font = .boldSystemFont(ofSize: 15)
        precioLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(precioLbl)
        
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imgView.widthAnchor.constraint(equalToConstant: 70),
            imgView.heightAnchor.constraint(equalToConstant: 70),
            nombreLbl.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 12),
            nombreLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nombreLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            precioLbl.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 12),
            precioLbl.topAnchor.constraint(equalTo: nombreLbl.bottomAnchor, constant: 6),
        ])
    }
    
    func configure(with prod: Producto) {
        nombreLbl.text = prod.nombre
        precioLbl.text = String(format: "S/ %.2f", prod.precio)
        if let url = URL(string: prod.imagenUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let img = UIImage(data: data) {
                    DispatchQueue.main.async { self?.imgView.image = img }
                }
            }.resume()
        }
    }
}
