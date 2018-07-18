//
//  File.swift
//  News
//
//  Created by MacUser on 16.07.2018.
//  Copyright © 2018 MacUser. All rights reserved.
//

import UIKit
import CoreData
import AlamofireImage

class ViewArticle: UIViewController
{
    @IBOutlet weak var imageView:   UIImageView!
    @IBOutlet weak var textView:    UITextView!
    @IBOutlet weak var titleLabel:  UILabel!
    @IBOutlet weak var dateLabel:   UILabel!
    
    var article: Article!
    
    override func viewDidLoad()
    {
        imageView.af_setImage(withURL: URL(string: article.image!)!, placeholderImage: #imageLiteral(resourceName: "missing.png"))
        titleLabel.text = article.title
        dateLabel.text  = article.date
        textView.text   = article.body
    }
}
