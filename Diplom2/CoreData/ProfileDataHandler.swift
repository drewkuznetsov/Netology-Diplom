//
//  ProfileDataHandler.swift
//  Diplom
//
//  Created by Андрей Кузнецов on 07.04.2022.
//

import UIKit
import CoreData

class ProfileDataHandler {
    
    var managedContext: NSManagedObjectContext!
    
    func setManagedContext(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func addProfile(login: String, password: String, name: String, status: String, image: UIImage) {
        
        guard let profileEntity = NSEntityDescription.entity(forEntityName: "Profile", in: self.managedContext)
        else { return }
        
        let profile = Profile(entity: profileEntity, insertInto: self.managedContext)
        profile.login = login
        profile.password = password
        profile.name = name
        profile.status = status
        
        guard let photoEntity = NSEntityDescription.entity(forEntityName: "Photo", in: self.managedContext)
        else {
            print("Error - cannot load photo entity")
            saveManagedContext()
            return
        }
        
        let photo = Photo(entity: photoEntity, insertInto: self.managedContext)
        photo.name = name
        photo.imageData = image.pngData()
        photo.profile = profile
        profile.avatar = photo
        profile.addToPhotos(photo)
        
        guard let postEntity = NSEntityDescription.entity(forEntityName: "Post", in: self.managedContext)
        else {
            print("Error - cannot load post entity")
            saveManagedContext()
            return
        }
        
        let post = Post(entity: postEntity, insertInto: self.managedContext)
        post.profile = profile
        post.photo = photo
        post.title = name
        post.postText = status
        post.likes = 0
        post.views = 0
        
        profile.addToPosts(post)
        
        saveManagedContext()

    }
    
    func saveManagedContext() {
        
        do {
            try managedContext.save()
        } catch {
            print("Save profile error.")
        }
        
    }
     
    func loadProfile(by login: String) -> Profile? {
        
        let profileRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        profileRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Profile.login), login)
        
        do{
            let profiles = try managedContext.fetch(profileRequest)
            return profiles.first
        } catch {
            print("No results for \(login)")
        }
        
        return nil
    }
    
//    func deleteProfile(by login: String) {
//
//        let profileRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
//        profileRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Profile.login), login)
//
//
//
//        do{
//            let profiles = try managedContext.fetch(profileRequest)
//                managedContext.delete(profiles.first!)
//
//        } catch {
//            print("No results for \(login)")
//        }
//
//
//    }
//
    func addPhotoToProfile(photoImage: UIImage, photoName: String, profile: Profile) {
        
        guard let photoEntity = NSEntityDescription.entity(forEntityName: "Photo", in: self.managedContext)
        else {
            print("Error - cannot load photo entity")
            saveManagedContext()
            return
        }
        
        let photo = Photo(entity: photoEntity, insertInto: self.managedContext)
        photo.name = photoName
        photo.imageData = photoImage.pngData()
        photo.profile = profile
        profile.addToPhotos(photo)
        
        saveManagedContext()
    }
    
    func addPostToProfile(postTitle: String, postText: String, postPhoto: UIImage, profile: Profile) {
        
        guard let photoEntity = NSEntityDescription.entity(forEntityName: "Photo", in: self.managedContext)
        else {
            print("Error - cannot load photo entity")
            saveManagedContext()
            return
        }
        
        let photo = Photo(entity: photoEntity, insertInto: self.managedContext)
        photo.name = postTitle
        photo.imageData = postPhoto.pngData()
        photo.profile = profile
        profile.addToPhotos(photo)
        
        guard let postEntity = NSEntityDescription.entity(forEntityName: "Post", in: self.managedContext)
        else {
            print("Error - cannot load post entity")
            saveManagedContext()
            return
        }
        
        let post = Post(entity: postEntity, insertInto: self.managedContext)
        
        post.title = postTitle
        post.photo = photo
        post.postText = postText
        post.likes = 0
        post.views = 0
        post.profile = profile
        
        profile.addToPosts(post)
        
        saveManagedContext()
    }
    
    func loadPosts() -> [Post] {
        
        var posts = [Post]()
        
        let postRequest: NSFetchRequest<Post> = Post.fetchRequest()
        
        do{
            let fetchPosts = try managedContext.fetch(postRequest)
            posts = fetchPosts
        } catch {
            print("No results")
        }
        return posts
    }
    
    func deletePost(post: Post, profile: Profile) {
        
        guard let index = profile.posts?.firstIndex(of: post)
        else { return }
        
        profile.replacePosts(at: index, with: post)
        
        self.saveManagedContext()
        
        managedContext.delete(post)
        self.saveManagedContext()
    }
    
//    func printPosts() {
//
//        let postRequest: NSFetchRequest<Post> = Post.fetchRequest()
//
//        do{
//            let posts = try managedContext.fetch(postRequest)
//            for post in posts {
//                print(post.title, post.postText)
//            }
//        } catch {
//            print("No results")
//        }
//    }
}

var profileDataHandler = ProfileDataHandler()

extension ProfileDataHandler {
    
    func fillData() {
        
        let email0 = "d@m.r"
        let email1 = "2d@g.com"
        let email2 = "noodle@gm.ru"
        let email3 = "murdoc@ya.ru"
        let email4 = "rus@ml.co.uk"
        
        let profileRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
 
        do{
            let profiles = try managedContext.fetch(profileRequest)
            if profiles.count != 0 { return }
        } catch {
            print("Can not fetch profiles. Line 215")
        }
        
        self.addProfile(login: email0, password: "12345678", name: "Damon Albarn", status: "Just a genius!", image: UIImage(named: "d - a") ?? UIImage())
        guard let profile0 = self.loadProfile(by: email0) else { return }
        
        self.addPostToProfile(
            postTitle: "Damon Albarn",
            postText: "Damon Albarn born 23 March 1968) is an English musician and singer, best known as the frontman and primary lyricist of the rock band Blur and as the co-founder, lead vocalist, instrumentalist and primary songwriter of the virtual band Gorillaz.",
            postPhoto: UIImage(named: "d - p1") ?? UIImage(),
            profile: profile0)
        
        self.addPostToProfile(
            postTitle: "Gorillaz",
            postText: "Albarn and Jamie Hewlett met in 1990 when Coxon, a fan of Hewlett's work, asked him to interview Blur.The interview was published in Deadline magazine, home of Hewlett's comic strip, Tank Girl. Hewlett initially thought Albarn was arsey, a wanker and despite becoming one of the band's acquaintances, Hewlett often did not get on with its members, especially after he started going out with Coxon's ex-girlfriend, Jane Olliver. Nonetheless, Albarn and Hewlett started sharing a flat on Westbourne Grove in London in 1997.Hewlett had recently broken up with Olliver and Albarn was also at the end of his highly publicised relationship with Frischmann.",
            postPhoto: UIImage(named: "d - p2") ?? UIImage(),
            profile: profile0)
        
        self.addPostToProfile(
            postTitle: "The Good, the Bad & the Queen",
            postText: "In May 2006, NME reported that Albarn was working with Danger Mouse on his first solo album, with the group billed as the Good, the Bad & the Queen.It featured Paul Simonon, Simon Tong and Tony Allen. The album was awarded Best Album at the 2007 MOJO Awards on 18 June.",
            postPhoto: UIImage(named: "d - p3") ?? UIImage(),
            profile: profile0)
        
        self.addPostToProfile(
            postTitle: "Rocket Juice and the Moon",
            postText: "Rocket Juice & the Moon is the title of Albarn's side-project featuring Red Hot Chili Peppers bassist Flea and afrobeat legend Tony Allen. Albarn has stated that he is not responsible for the name; someone in Lagos did the sleeve design and that was the name it was given. Albarn has claimed that he is content with the outcome, as trying to come up with band names is difficult for him. The band performed together for the first time on 28 October 2011 in Cork, Ireland, as part of the annual Cork Jazz Festival. They performed under the moniker Another Honest Jon's Chop Up!. Their debut album was released on 26 March 2012.",
            postPhoto: UIImage(named: "d - p4") ?? UIImage(),
            profile: profile0)
        
        for i in 1...15 {
            
            let photoName = "d - \(i)"
            
            self.addPhotoToProfile(
                photoImage: UIImage(named: photoName)!,
                photoName: "Damo Albarn - \(photoName)",
                profile: profile0)
        }
        
        
        self.addProfile(login: email1, password: "12345678", name: "2D", status: "Singing and plaing guitare!!", image: UIImage(named: "2d - a")!)
        
        guard let profile1 = self.loadProfile(by: email1) else { return }
        
        self.addPostToProfile(
            postTitle: "Stuart Harold 2D Pot is a fictional English singer",
            postText: "2D was loosely based on Chris Gentry from the Britpop band Menswear and a mutual friend of Jamie Hewlett and Damon Albarn named Stuart Lowbridge, who has worked as a stage engineer for Albarn since the early days of his career. Before co-creating Gorillaz, Hewlett originally had the idea of forming a cartoon band called Sour Grapes with Gentry and Graham Coxon of Albarn's other band Blur. ",
            postPhoto: UIImage(named: "2d - p1") ?? UIImage(),
            profile: profile1)
        
        self.addPostToProfile(
            postTitle: "While 2-D's singing voice is provided by Gorillaz co-creator Damon Albarn",
            postText: "his speaking voice is provided by actor and comedian Kevin Bishop. Albarn has claimed that 2-D's singing voice was developed from a vocal effect produced by equipment in his studio that he has said is not Auto-Tune, but it was an early form of synthetic voice. Gorillaz engineer Stephen Sedgewick says of the effect, The main lo-fi telephone-like effect is the typical 2-D sound...",
            postPhoto: UIImage(named: "2d - p2") ?? UIImage(),
            profile: profile1)
        
        self.addPostToProfile(
            postTitle: "Fictional history",
            postText: "Stuart Pot was born on 23 May 1978 to David and Rachel Pot. The original surname of Stuart's father was Tusspot, but he legally changed it to Pot, shortly before Stuart was born. His father, David, works as a mechanic and as a fairgrounds worker, while his mother, Rachel, works as a nurse. He was born in Crawley, West Sussex, England and attended St Wilfrid's Catholic School. When he was 11 years old, Stuart was involved in an accident where he fell from a tree and hit his head. This caused all his natural brown hair to shed, until it eventually grew back in a deep azure blue color. The accident also caused him to experience frequent migraines, for which his mother supplied him with painkillers",
            postPhoto: UIImage(named: "2d - p3") ?? UIImage(),
            profile: profile1)
        
        self.addPostToProfile(
            postTitle: "Physical appearance",
            postText: "2-Ds physique is tall and skinny; his hands and feet are large and he has long limbs, with his height standing at 62. The character has pale skin and spiky azure blue hair. Thereafter, he is also depicted with a notable lack of visible pupils in his eyes due to the blood leakage from his hyphema;[40] while his eyes can range from black to white, they predominately remained black throughout the first four phases.",
            postPhoto: UIImage(named: "2d - p4") ?? UIImage(),
            profile: profile1)
        
        for i in 1...15 {
            
            let photoName = "2d - \(i)"
            
            self.addPhotoToProfile(
                photoImage: UIImage(named: photoName)!,
                photoName: "2D - \(photoName)",
                profile: profile1)
        }
        
        self.addProfile(login: email2, password: "12345678", name: "Noodle", status: "Playing Guitare and Fighting!", image: UIImage(named: "n - a") ?? UIImage())
        
        guard let profile2 = self.loadProfile(by: email2) else { return }
        
        self.addPostToProfile(
            postTitle: "Noodle is a fictional Japanese musician, singer",
            postText: "She provides the lead guitar, as well as some occasional lead and backing vocals for the band.[1] Like all other band members of Gorillaz, she was created in 1998 by Damon Albarn and Jamie Hewlett. Noodle has been voiced by Japanese-English actress Haruka Kuroda, singer-songwriter Miho Hatori of trip-hop group Cibo Matto,[4][5] and Japanese-English actress Haruka Abe.",
            postPhoto: UIImage(named: "n - p1") ?? UIImage(),
            profile: profile2)
        
        self.addPostToProfile(
            postTitle: "Characterization",
            postText: "Noodle was originally conceptualised by co-creator Jamie Hewlett as an adolescent white girl named Paula Cracker, but co-creator Damon Albarn noted that the character was too similar to the characters that Hewlett is typically known for drawing, and recommended that he attempt to create something different. Taking Albarn's advice, Hewlett designed an illustration of a 10-year-old Japanese girl named Noodle",
            postPhoto: UIImage(named: "n - p2") ?? UIImage(),
            profile: profile2)
        
        self.addPostToProfile (
            postTitle: "Fictional history",
            postText: "Noodle first came to Gorillaz in 1998 shortly after their original guitarist and 2-D's ex-girlfriend Paula Cracker was removed from the band’s lineup for having an affair with Murdoc Niccals in the bathroom of Gorillaz' fictional headquarters at Kong Studios. As a result, the band was left without a guitarist, which led them to run an advertisement in a newspaper in search of a new one. Later the same day, a FedEx crate arrived at Kong Studios, and a Japanese girl leaped out and began playing a very loud solo on her guitar. After shredding on her guitar, she spoke a single word to the trio; Noodle, which would then become her nickname.",
         postPhoto: UIImage(named: "n - p3") ?? UIImage(),
         profile: profile2)
        
        self.addPostToProfile(
            postTitle: "Physical appearance",
            postText: "Noodle is a short and thin Japanese woman with short hair and almond-shaped eyes. Her skin generally has a warm olive tone and she tends to wear a small amount of makeup, which usually consists of painted fingernails and eye shadow. Noodle's hair is short and its colour is generally either dark purple or black, but she has occasionally dyed her hair, such as in the music video for Tranz",
            postPhoto: UIImage(named: "n - p4") ?? UIImage(),
            profile: profile2)
        
        for i in 1...15 {
            
            let photoName = "n - \(i)"
            
            self.addPhotoToProfile(
                photoImage: UIImage(named: photoName)!,
                photoName: "Noodle - \(photoName)",
                profile: profile2)
        }
        
        self.addProfile(login: email3, password: "12345678", name: "Murdoc Niccals", status: "Playing bass and using drugs!", image: UIImage(named: "m - a")!)
        
        guard let profile3 = self.loadProfile(by: email3) else { return }
    
        self.addPostToProfile(
            postTitle: "Characterization",
            postText: "Murdoc is based on The Rolling Stones guitarist Keith Richards, Victor Frankenstein, and Creeper from Scooby-Doo.[8][9] In particular, he was inspired by a photograph of The Rolling Stones taken in 1968 by photographer David Bailey.[10][11] His wardrobe and fashion is inspired by that of Black Sabbath's Ozzy Osbourne",
            postPhoto: UIImage(named: "m - p1") ?? UIImage(),
            profile: profile3)
        
        self.addPostToProfile(
            postTitle: "Fictional history",
            postText: " the Gorillaz backstory, Murdoc's family, his father Sebastian especially, was frequently abusive towards him, and his father often exploited him by forcing him to perform at local pub talent shows against his will for money. His distinct nose shape is said to be the result of frequent physical abuse from family and peers that he was the victim of since his childhood.",
            postPhoto: UIImage(named: "m - p2") ?? UIImage(),
            profile: profile3)
        
        self.addPostToProfile(
            postTitle: "Physical appearance",
            postText: "Murdoc is based on Keith Richards of The Rolling Stones. As such, he has a similar hairstyle and facial features. Murdoc is designed as having distinct sickly green colored skin, and is often illustrated with yellow colored eyes, sometimes being depicted with a red pupil in his right eye. He also has a misshapen nose and sharp, sometimes yellow teeth and a large grin. He has a black mop top that covers a portion of his face and hides his eyebrows. His eyebrows have sometimes been visible in artwork since Humanz in 2017. ",
            postPhoto: UIImage(named: "m - p3") ?? UIImage(),
            profile: profile3)
        
        self.addPostToProfile(
            postTitle: "Personality",
            postText: "Murdoc has been frequently depicted as the perpetuator of constant physical and psychological abuse towards Gorillaz bandmate 2-D, although this abuse appears to have stopped in recent years. Murdoc's personality is defined by pride, depravity, sadism, cynicism, and misanthropy, and he's been shown to be consistently rude and sarcastic towards the people around him. ",
            postPhoto: UIImage(named: "m - p4") ?? UIImage(),
            profile: profile3)

    
        
        for i in 1...15 {
            
            let photoName = "m - \(i)"
            
            self.addPhotoToProfile(
                photoImage: UIImage(named: photoName) ?? UIImage(),
                photoName: "Murdoc Niccals - \(photoName)",
                profile: profile3)
        }
        
        self.addProfile(login: email4, password: "12345678", name: "Russel Hobbs", status: "member of Gorillaz", image: UIImage(named: "r - a")!)
        
        guard let profile4 = self.loadProfile(by: email4) else { return }
        
        self.addPostToProfile(
            postTitle: "Characterization",
            postText: "Russel Hobbs was originally conceptualized by Jamie Hewlett and Damon Albarn in 1998 as a metafictional representation of the hip hop aspects of Gorillaz, embodying the spirit of the bands' collaborations with various rappers over the years.",
            postPhoto: UIImage(named: "r - p1") ?? UIImage(),
            profile: profile4)
        self.addPostToProfile(
            postTitle: "Fictional history",
        
            postText: "During this encounter, Russel heard the Miles Davis song It Never Entered My Mind playing. Terrified, Russel closed his eyes and held tightly onto his blanket, and once he opened them, everything appeared to be back to normal, and he was with his parents on a train back home. Russel speculates that this may have been his first encounter with the Grim Reaper, who he would encounter multiple times later in his life. ",
            postPhoto: UIImage(named: "r - p2") ?? UIImage(),
            profile: profile4)
        
        self.addPostToProfile(
            postTitle: "Physical appearance",
            postText: "Russel is a heavy set African American character known for his large size and considerable weight. His height is 5 feet 9 inches tall, or 1.75 meters. According to an episode of MTV Cribs featuring Gorillaz, Russel is revealed to weigh 340 lbs, or 145.5 kg. In Plastic Beach, he grew to be the size of a giant after consuming radioactive material in the ocean.",
            postPhoto: UIImage(named: "r - p3") ?? UIImage(),
            profile: profile4)
        
        self.addPostToProfile(
            postTitle: "Role in Gorillaz",
            postText: "Russel is Gorillaz' drummer. He (and the rest of Gorillaz) can play other instruments, but he usually sticks to percussion. He was not present for the recording of the album Plastic Beach, with Murdoc replacing him with a drum machine for the album.[28] He has been the in-universe selector of the collaborators for the band since Humanz in 2017.",
            postPhoto: UIImage(named: "r - p4") ?? UIImage(),
            profile: profile4)

        for i in 1...15 {
            
            let photoName = "r - \(i)"
            
            
            self.addPhotoToProfile(
                photoImage: UIImage(named: photoName)!,
                photoName: "Russel Hobbs - \(photoName)",
                profile: profile4)
        }
    }
        
}
