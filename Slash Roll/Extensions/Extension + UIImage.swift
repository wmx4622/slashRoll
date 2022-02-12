//
//  Extension + UIImage.swift
//  Slash Roll
//
//  Created by Voxar on 12.02.22.
//

import UIKit


extension UIImage {
    static func getImage(from color: UIColor, imageSize: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        return UIGraphicsImageRenderer(size: imageSize).image { rendererContext in
            color.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: imageSize))
        }
    }
}
