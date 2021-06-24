//
//  ImageResizer.swift
//  algolia
//
//  Created by Min Kim on 2/4/20.
//  Copyright © 2020 grailed. All rights reserved.
//

import UIKit

final class ImageResizer {
    private static let cdnURLString = "https://cdn.fs.grailed.com/AJdAgnqCST4iPtnUxiGtTz"

    static func resizedURL(for url: URL, withWidth width: CGFloat) -> URL? {
        let paramString = "/resize=width:\(Int(width)),fit:crop/output=format:jpg,compress:true,quality:95/"
        let fullString = self.cdnURLString + paramString + url.absoluteString
        return URL(string: fullString)
    }
}
