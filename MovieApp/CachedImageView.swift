//
//  CachedImageView.swift
//  MovieApp
//
//  Created by emirhan Acısu on 16.07.2023.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CachedImageView: UIImageView {

    private var imageURL: URL?

    func setImage(_ imageUrlString: String?) {
        guard let imageUrlString = imageUrlString,
              let imageUrl = URL(string: imageUrlString) else { return }

        imageURL = imageUrl
        image = nil

        if let imageFromCache = imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }

        URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }

            DispatchQueue.main.async(execute: {

                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    if self.imageURL == imageUrl {
                        self.image = imageToCache
                    }

                    imageCache.setObject(imageToCache, forKey: imageUrl as AnyObject)
                }
            })
        }).resume()
    }
}
