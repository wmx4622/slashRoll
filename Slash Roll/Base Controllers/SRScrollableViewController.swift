//
//  ScrollableViewController.swift
//  Slash Roll
//
//  Created by Voxar on 16.12.21.
//

import UIKit
import SnapKit

class SRScrollableViewController: UIViewController {
    
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private(set) lazy var contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureController()
    }

    private func configureController() {

        self.view.addSubview(self.scrollView)

        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }

        self.scrollView.alwaysBounceVertical = true
        self.scrollView.addSubview(contentView)

        self.contentView.snp.makeConstraints { make in
            make.width.equalTo(self.view.safeAreaLayoutGuide.snp.width)
            make.edges.equalTo(self.scrollView.contentLayoutGuide)
        }
    }
}
