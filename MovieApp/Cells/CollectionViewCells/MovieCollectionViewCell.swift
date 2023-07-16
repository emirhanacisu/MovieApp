//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by emirhan Acısu on 16.07.2023.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    let posterImageView: CachedImageView = {
        let imageView = CachedImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.addSubview(posterImageView)
        posterImageView.edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    func set(viewModel: MovieCollectionViewCellModel?) {
        guard let viewModel = viewModel else { return }
        posterImageView.setImage(viewModel.poster)
    }
    
}
