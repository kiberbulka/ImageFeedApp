//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Olya on 07.03.2025.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}
