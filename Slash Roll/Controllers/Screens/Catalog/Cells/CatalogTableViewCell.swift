//
//  CatalogTableViewCell.swift
//  Slash Roll
//
//  Created by Voxar on 5.02.22.
//

import UIKit
import Firebase
import FirebaseUI

class CatalogTableViewCell: UITableViewCell, ReusableCell {

    private let placeholderImage: UIImage = UIImage(named: "placeholder") ?? UIImage()
    private let productImageSize: CGSize = CGSize(width: 60, height: 60)

    var productImage: UIImage {
        self.productImageView.image ?? self.placeholderImage
    }

    private lazy var productContainerView: UIView = {
        let productContainerView = UIView()
        productContainerView.backgroundColor = SRColors.whiteColor
        return productContainerView
    }()

    private lazy var productNameLabel: SRLabel = {
        let productName = SRLabel()
        return productName
    }()

    private lazy var countWeightLabel: SRLabel = {
        let productDescription = SRLabel()
        return productDescription
    }()

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = placeholderImage
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = productImageSize.height / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = SRColors.cherryLightColor.cgColor
        return imageView
    }()


    private lazy var productPriceLabel: SRLabel = {
        let productPriceLabel = SRLabel()
        return productPriceLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(productContainerView)
        productContainerView.addSubview(productNameLabel)
        productContainerView.addSubview(countWeightLabel)
        productContainerView.addSubview(productImageView)
        productContainerView.addSubview(productPriceLabel)
    }

    private func configureLayout() {
        productContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        productImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(8)
            make.height.width.equalTo(productImageSize)

        }

        productNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(productImageView.snp.trailing).offset(8)
        }

        productPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
        }

        countWeightLabel.snp.makeConstraints { make in
            make.leading.equalTo(productNameLabel.snp.leading)
            make.top.equalTo(productNameLabel.snp.bottom).offset(8)
        }
    }

    private func loadImage(product: SRProduct) {
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child(product.imageUrl)
        self.productImageView.sd_setImage(with: reference)
    }

    func setCell(product: SRProduct) {
        self.productImageView.image = self.placeholderImage
        self.productNameLabel.text = product.name
        self.countWeightLabel.text = "\(product.count) штук | \(product.weight) грамм"
        self.productPriceLabel.text = "Цена \(String(format: "%.2f", product.price)) руб."
        if !product.imageUrl.isEmpty {
            loadImage(product: product)
        }
    }
}
