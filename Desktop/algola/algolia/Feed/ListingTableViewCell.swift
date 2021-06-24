//
//  ListingTableViewCell.swift
//  algolia
//
//  Created by Adam Fraser on 2/6/19.
//  Copyright © 2019 grailed. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var listingImage: UIImageView!

    func configure(listing: Listing) {
        titleLabel.text = listing.title
        guard
            let photoURL = URL(string: listing.photo.url),
            let resizedURL = ImageResizer.resizedURL(for: photoURL, withWidth: listingImage.frame.width * UIScreen.main.scale)
            else { return }

        URLSession.shared.dataTask(with: resizedURL) { data, response, error in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async() {
                self.listingImage.image = image
            }
        }.resume()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        listingImage.image = nil
    }
}
