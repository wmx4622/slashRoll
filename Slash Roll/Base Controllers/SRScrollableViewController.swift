//
//  ScrollableViewController.swift
//  Slash Roll
//
//  Created by Voxar on 16.12.21.
//

import UIKit
import SnapKit

class SRScrollableViewController: UIViewController {

    //MARK: - GUI varibles

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private(set) lazy var contentView = UIView()

    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureController()
    }
    //MARK: - Controller Cofiguration

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

    //MARK: - User Interaction

    func addKeyboardListener(lastViewFrame: CGRect) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:lastViewFrame:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

    @objc private func keyboardWillShow(notification: Notification, lastViewFrame: CGRect) {

        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        scrollView.contentInset.bottom = keyboardFrame.height
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
        scrollView.scrollRectToVisible(lastViewFrame.insetBy(dx: -8, dy: -8), animated: false)
        scrollView.keyboardDismissMode = .interactive
    }
}
