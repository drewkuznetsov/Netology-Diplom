//
//  Profile+CoreDataProperties.swift
//  Diplom
//
//  Created by Андрей Кузнецов on 07.04.2022.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var login: String?
    @NSManaged public var password: String?
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var avatar: Photo?
    @NSManaged public var photos: [Photo]?// NSOrderedSet?
    @NSManaged public var posts: [Post]?

}

// MARK: Generated accessors for photos
extension Profile {

    @objc(insertObject:inPhotosAtIndex:)
    @NSManaged public func insertIntoPhotos(_ value: Photo, at idx: Int)

    @objc(removeObjectFromPhotosAtIndex:)
    @NSManaged public func removeFromPhotos(at idx: Int)

    @objc(insertPhotos:atIndexes:)
    @NSManaged public func insertIntoPhotos(_ values: [Photo], at indexes: NSIndexSet)

    @objc(removePhotosAtIndexes:)
    @NSManaged public func removeFromPhotos(at indexes: NSIndexSet)

    @objc(replaceObjectInPhotosAtIndex:withObject:)
    @NSManaged public func replacePhotos(at idx: Int, with value: Photo)

    @objc(replacePhotosAtIndexes:withPhotos:)
    @NSManaged public func replacePhotos(at indexes: NSIndexSet, with values: [Photo])

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSOrderedSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSOrderedSet)

}

// MARK: Generated accessors for posts
extension Profile {

    @objc(insertObject:inPostsAtIndex:)
    @NSManaged public func insertIntoPosts(_ value: Post, at idx: Int)

    @objc(removeObjectFromPostsAtIndex:)
    @NSManaged public func removeFromPosts(at idx: Int)

    @objc(insertPosts:atIndexes:)
    @NSManaged public func insertIntoPosts(_ values: [Post], at indexes: NSIndexSet)

    @objc(removePostsAtIndexes:)
    @NSManaged public func removeFromPosts(at indexes: NSIndexSet)

    @objc(replaceObjectInPostsAtIndex:withObject:)
    @NSManaged public func replacePosts(at idx: Int, with value: Post)

    @objc(replacePostsAtIndexes:withPosts:)
    @NSManaged public func replacePosts(at indexes: NSIndexSet, with values: [Post])

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: Post)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: Post)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSOrderedSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSOrderedSet)

}

extension Profile : Identifiable {

}
