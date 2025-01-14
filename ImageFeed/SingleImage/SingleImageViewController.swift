//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Olya on 04.11.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - Public Properties
    
    var imageUrl:URL?
    
    
    // MARK: - Private Properties
    
    // MARK: - Initializers
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showImage()
    }
    
    // MARK: - IB Actions
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didShareButtonTapped(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [imageUrl as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = max(hScale, vScale)  // Используем max, чтобы растянуть изображение на весь экран
        
        scrollView.minimumZoomScale = scale
        scrollView.maximumZoomScale = 1.25
        scrollView.zoomScale = scale  // Устанавливаем начальный масштаб
        
        let x = (scrollView.contentSize.width - visibleRectSize.width) / 2
        let y = (scrollView.contentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        
    }
    
    private func showImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                imageView.frame.size = imageResult.image.size
                scrollView.minimumZoomScale = 0.1
                scrollView.maximumZoomScale = 1.25
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(_):
                self.showError()
            }
        }
    }
    private func showError() {
            let alert = UIAlertController(title: "Что-то пошло не так. Попробовать еще раз?", message: "", preferredStyle: .alert)
            let actionDismiss = UIAlertAction(title: "Не надо", style: .default) { [weak self] _ in
                alert.dismiss(animated: true)
            }
            let actionRetry = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
                self?.showImage()
            }
            alert.addAction(actionDismiss)
            alert.addAction(actionRetry)
            present(alert, animated: true)
        }
    
}

// MARK: - Extensions

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
