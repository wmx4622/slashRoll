//
//  ReusableCellProtocol.swift
//  Slash Roll
//
//  Created by Voxar on 5.02.22.
//

import UIKit


protocol ReusableCell: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableCell where Self: UIView {
    static var reuseIdentifier: String { String(describing: Self.self) }
}
