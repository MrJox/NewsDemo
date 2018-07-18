//
//  UIImageViewFromUrl.swift
//  News
//
//  Created by MacUser on 17.07.2018.
//  Copyright © 2018 MacUser. All rights reserved.
//

import UIKit

class UIImageViewFromUrl: UIImageView
{
    private var url: URL!
    
    public func loadImageFromUrl(imageURL: String)
    {
        guard let url = URL(string: imageURL) else
        {
            print("Failed to load image")
            return
        }
        
        if (url != self.url)
        {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url)
                {
                    if let image = UIImage(data: data)
                    {
                        DispatchQueue.main.async { self?.image = image }
                    }
                }
            }
        }
        
    }
}
