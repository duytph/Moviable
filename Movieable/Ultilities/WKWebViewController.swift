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
    
    private(set) lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.navigationDelegate = self
        return view
    }()
    
    private(set) lazy var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Dependencies
    
    let request: URLRequest?
    let htmlString: String?
    
    private(set) var estimatedProgressObservation: NSKeyValueObservation?
    
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
        super.loadView()
        
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress) { [weak self] (webView: WKWebView, _) in
            guard let self = self else { return }
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
        
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
    
    @objc func closeButtonDidTap() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - WKNavigationDelegate

extension WKWebViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}
