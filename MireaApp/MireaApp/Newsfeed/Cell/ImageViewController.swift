//
//  ImageViewController.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 12.10.2022.
//

import UIKit

class ImageViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    } ()
    
    private lazy var imageViewForZoom: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.addSubview(scrollView)
        scrollView.addSubview(imageViewForZoom)
        setScrollView()
        makeConstraints()
    }
    
    func setImage(stringUrl: String) {
        guard let url = URL(string: stringUrl) else {return}
        imageViewForZoom.sd_setImage(with: url, completed: nil)
    }
}

extension ImageViewController {
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageViewForZoom.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageViewForZoom.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.5),
            imageViewForZoom.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageViewForZoom.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    private func setScrollView() {
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = imageViewForZoom.image!.size
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageViewForZoom
    }
}
