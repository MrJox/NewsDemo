//
//  ArticleRecord+CoreDataProperties.swift
//  News
//
//  Created by MacUser on 17.07.2018.
//  Copyright © 2018 MacUser. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var image: String?
    @NSManaged public var body:  String?
    @NSManaged public var date:  String?
    @NSManaged public var id:    Int32
    @NSManaged public var title: String?

}
