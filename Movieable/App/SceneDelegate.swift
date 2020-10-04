//
//  SceneDelegate.swift
//  Movieable
//
//  Created by Duy Tran on 10/2/20.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let appCoordinator = DefaultAppCoordinator(window: window)
        self.appCoordinator = appCoordinator
        appCoordinator.start()
    }
}

