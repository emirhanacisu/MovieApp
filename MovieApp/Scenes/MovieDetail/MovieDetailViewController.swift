//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by emirhan Acısu on 16.07.2023.
//

import UIKit

class MovieDetailViewController: BaseViewController {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let posterImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.height(180)
        imageView.width(120)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var viewModel: MovieDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPosterImageView()
        setupStackView()
        configureViews()
    }
    
    private func setupPosterImageView() {
        view.addSubview(posterImageView)
        posterImageView.topToSuperview(usingSafeArea: true).constant = 16
        posterImageView.centerXToSuperview()
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.topToBottom(of: posterImageView).constant = 28
        stackView.leadingToSuperview().constant = 16
        stackView.trailingToSuperview().constant = -16
        stackView.bottomToSuperview(relation: .equalOrLess).constant = -20
    
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func configureViews() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        posterImageView.setImage(viewModel.imageUrl)
    }
    
}
