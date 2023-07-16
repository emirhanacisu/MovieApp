//
//  MoviesTableViewCell.swift
//  MovieApp
//
//  Created by emirhan Acısu on 16.07.2023.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let posterImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.height(85)
        imageView.width(60)
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupContents() {
        contentView.addSubview(containerView)
        containerView.edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        containerView.addSubview(posterImageView)
        posterImageView.topToSuperview().constant = 8
        posterImageView.leadingToSuperview().constant = 8
        posterImageView.bottomToSuperview().constant = -8
        
        containerView.addSubview(stackView)
        stackView.topToSuperview().constant = 8
        stackView.leadingToTrailing(of: posterImageView).constant = 8
        stackView.bottomToSuperview(relation: .equalOrLess).constant = -8
        stackView.trailingToSuperview().constant = -8
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    func set(viewModel: MoviesTableViewCellModel?) {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        posterImageView.setImage(viewModel.poster)
    }
}
