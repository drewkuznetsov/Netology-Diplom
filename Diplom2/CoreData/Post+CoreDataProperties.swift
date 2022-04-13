//
//  Post+CoreDataProperties.swift
//  Diplom
//
//  Created by Андрей Кузнецов on 07.04.2022.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var title: String?
    @NSManaged public var postText: String?
    @NSManaged public var likes: Int64
    @NSManaged public var views: Int64
    @NSManaged public var date: Date?
    @NSManaged public var profile: Profile?
    @NSManaged public var photo: Photo?

}

extension Post : Identifiable {

}
