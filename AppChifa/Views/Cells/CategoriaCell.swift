//
//  CategoriaCell.swift
//  AppChifa
//
//  Created by XCODE on 26/04/26.
//

import UIKit

class CategoriaCell: UICollectionViewCell {
    private let imagenView = UIImageView()
    private let nombreLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurar()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); configurar() }
    
    private func configurar() {
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        layer.cornerRadius = 12
        
        imagenView.contentMode = .scaleAspectFill
        imagenView.clipsToBounds = true
        imagenView.layer.cornerRadius = 12
        imagenView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imagenView)
        
        nombreLabel.textColor = .white
        nombreLabel.font = .boldSystemFont(ofSize: 14)
        nombreLabel.textAlignment = .center
        nombreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nombreLabel)
        
        NSLayoutConstraint.activate([
            imagenView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imagenView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagenView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagenView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            nombreLabel.topAnchor.constraint(equalTo: imagenView.bottomAnchor, constant: 4),
            nombreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nombreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
        ])
    }
    
    func configure(with cat: Categoria) {
        nombreLabel.text = cat.nombre
        if let url = URL(string: cat.imagenUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let img = UIImage(data: data) {
                    DispatchQueue.main.async { self?.imagenView.image = img }
                }
            }.resume()
        }
    }
}
