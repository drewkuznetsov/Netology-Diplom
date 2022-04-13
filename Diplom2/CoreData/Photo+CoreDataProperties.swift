//
//  Photo+CoreDataProperties.swift
//  Diplom
//
//  Created by Андрей Кузнецов on 07.04.2022.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var profile: Profile?

}

extension Photo : Identifiable {

}
