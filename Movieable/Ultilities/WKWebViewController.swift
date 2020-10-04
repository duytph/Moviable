//
//  WKWebViewController.swift
//  Movieable
//
//  Created by Duy Tran on 10/5/20.
//

import UIKit
import WebKit

final class WKWebViewController: UIViewController {
    
    // MARK: - UIs

    private(set) lazy var webView = WKWebView()
    
    // MARK: - Dependencies

    let request: URLRequest?
    let htmlString: String?
    
    // MARK: - Init

    init(
        request: URLRequest? = nil,
        htmlString: String? = nil) {
        self.request = request
        self.htmlString = htmlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.request = nil
        self.htmlString = nil
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle

    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let request = self.request {
            webView.load(request)
        } else if let htmlString = htmlString {
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let navigationController = self.navigationController else { return }

        navigationController.setNavigationBarHidden(false, animated: true)

        if navigationController.viewControllers.count == 1 {
            let title = NSLocalizedString("Close", comment: "")
            let button = UIBarButtonItem(
                title: title,
                style: .done,
                target: self,
                action: #selector(closeButtonDidTap))
            button.tintColor = Asset.accentColor.color
            navigationItem.leftBarButtonItem = button
        }
    }
    
    // MARK: - Private
    
    @objc private func closeButtonDidTap() {
        dismiss(animated: true, completion: nil)
    }
}
