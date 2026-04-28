//
//  AdminProductoCell.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//
import UIKit

class AdminProductoCell: UITableViewCell {
    private let nombreLbl = UILabel()
    private let precioLbl = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurar()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); configurar() }
    
    private func configurar() {
        backgroundColor = .clear
        nombreLbl.textColor = .white; nombreLbl.font = .boldSystemFont(ofSize: 15)
        nombreLbl.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview(nombreLbl)
        precioLbl.textColor = .lightGray; precioLbl.font = .systemFont(ofSize: 14)
        precioLbl.translatesAutoresizingMaskIntoConstraints = false; contentView.addSubview(precioLbl)
        NSLayoutConstraint.activate([
            nombreLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nombreLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            precioLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            precioLbl.topAnchor.constraint(equalTo: nombreLbl.bottomAnchor, constant: 4),
        ])
    }
    func configure(with p: Producto) {
        nombreLbl.text = p.nombre; precioLbl.text = "S/ \(String(format: "%.2f", p.precio)) — Stock: \(p.cantidad)"
    }
}
