//
//  StatefulView.swift
//  Movieable
//
//  Created by Duy Tran on 10/3/20.
//

import UIKit

final class StatefulView: UIView {
    
    // MARK: - UIs
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.tintColor = Asset.accentColor.color
        return view
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    private(set) lazy var actionButton: UIButton = {
        let view = UIButton()
        let halfPadding = padding / 2
        view.contentEdgeInsets = UIEdgeInsets(
            top: halfPadding,
            left: padding,
            bottom: halfPadding,
            right: padding)
        view.addTarget(
            self,
            action: #selector(actionButtonDidTap(sender:)),
            for: .touchUpInside)
        view.tintColor = Asset.accentColor.color
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        return view
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, imageView, actionButton])
        view.axis = .vertical
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Dependencies
    
    let padding: CGFloat
    
    var action: (() -> Void)?
    
    // MARK: - Init
    
    init(
        padding: CGFloat = 16,
        action: (() -> Void)? = nil) {
        self.padding = padding
        self.action = action
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        self.padding = 0
        self.action = nil
        super.init(coder: coder)
        setUp()
    }
    
    // MARK: - Public
    
    func configure(
        withTitle title: String,
        image: UIImage,
        actionTitle: String,
        action: (() -> Void)? = nil) {
        titleLabel.text = title
        titleLabel.isHidden = title.isEmpty
        imageView.image = image
        actionButton.setTitle(actionTitle, for: .normal)
        actionButton.isHidden = actionTitle.isEmpty
        self.action = action
    }
    
    // MARK: - Private
    
    private func setUp() {
        backgroundColor = .white
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: padding),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -padding),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -padding),
        ])
    }
    
    @objc private func actionButtonDidTap(sender: UIButton) {
        action?()
    }
    
    // MARK: - Ultilities
    
    static func loading(
        padding: CGFloat = 16,
        title: String = NSLocalizedString("A few seconds before happiness", comment: ""),
        image: UIImage = Asset.loading.image,
        actionTitle: String = "",
        action: (() -> Void)? = nil) -> StatefulView {
        let view = StatefulView(padding: padding, action: action)
        view.titleLabel.text = title
        view.imageView.image = image
        view.actionButton.setTitle(actionTitle, for: .normal)
        return view
    }
    
    static func empty(
        padding: CGFloat = 16,
        title: String = NSLocalizedString("Just me and you", comment: ""),
        image: UIImage = Asset.empty.image,
        actionTitle: String = NSLocalizedString("Reload", comment: ""),
        action: (() -> Void)? = nil) -> StatefulView {
        let view = StatefulView(padding: padding, action: action)
        view.titleLabel.text = title
        view.imageView.image = image
        view.actionButton.setTitle(actionTitle, for: .normal)
        return view
    }

    static func error(
        padding: CGFloat = 16,
        title: String = NSLocalizedString("Something went wrong", comment: ""),
        image: UIImage = Asset.error.image,
        actionTitle: String = NSLocalizedString("Retry", comment: ""),
        action: (() -> Void)? = nil) -> StatefulView {
        let view = StatefulView(padding: padding, action: action)
        view.titleLabel.text = title
        view.imageView.image = image
        view.actionButton.setTitle(actionTitle, for: .normal)
        return view
    }
}
