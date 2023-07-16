//
//  BaseViewController.swift
//  MovieApp
//
//  Created by emirhan Acısu on 16.07.2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    private let loadingBlockView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func showLoading() {
        view.addSubview(loadingBlockView)
        loadingBlockView.edgesToSuperview()
        
        loadingBlockView.addSubview(indicator)
        indicator.centerInSuperview()
        indicator.startAnimating()
    }
    
    func hideLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.loadingBlockView.removeFromSuperview()
        })
    }
    
    func presentErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
