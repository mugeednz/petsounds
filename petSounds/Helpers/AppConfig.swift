//
//  AppConfig.swift
//  petSounds
//
//  Created by Müge Deniz on 3.02.2025.
//

import Foundation
import UIKit
import AVFoundation

enum SoundType {
    case free
    case rewarded
    case premium
}
enum PetType {
    case dog
    case cat
}
enum CallType {
    case free
    case rewarded
    case premium
}
struct PetModel {
    var imageName: String
    var petType: PetType = .cat
    var soundName: String = ""
    var soundType: SoundType = .free
    var soundsStatusIcon: UIImage?
    var circleImage: String
}
struct Sound {
    var soundName: String = ""
}
struct CallModel {
    var petName: String
    var imageName: String
    var circleImage: String
    var petType: PetType = .cat
    var callType: CallType = .free
    var callStatusIcon: UIImage?
    var callVideo: String?
    var longSound: String?
}

struct AnimalWords: Decodable {
    var word: String
    var meaning: String
    var turkish: String?
    var feeling: String?
}

class AppConfig {
    
    static let pets: [PetModel] = [
        PetModel(imageName: "ic_first_dog", petType: .dog, soundName: "joyful_dog", soundType: .free, soundsStatusIcon: nil, circleImage: "dog_first_circle"),
        PetModel(imageName: "ic_second_dog", petType: .dog, soundName: "so_happy_dog", soundType: .premium, soundsStatusIcon: UIImage(named: "status_premium"), circleImage: "dog_second_circle"),
        PetModel(imageName: "ic_third_dog", petType: .dog, soundName: "come_here_dog", soundType: .premium, soundsStatusIcon: UIImage(named: "status_premium"), circleImage: "dog_third_circle"),
        PetModel(imageName: "ic_fourt_dog", petType: .dog, soundName: "lets_play_dog", soundType: .premium, soundsStatusIcon: UIImage(named: "status_premium"), circleImage: "dog_fourth_circle"),
        PetModel(imageName: "ic_fifth_dog", petType: .dog, soundName: "fifthDog", soundType: .premium, soundsStatusIcon: UIImage(named: "status_premium"), circleImage: "dog_fifth_circle"),
        PetModel(imageName: "ic_sixth_dog", petType: .dog, soundName: "sixthDog", soundType: .premium, soundsStatusIcon: UIImage(named: "status_premium"), circleImage: "dog_sixth_circle"),
        
        PetModel(imageName: "ic_first_cat", petType: .cat, soundName: "first", soundType: .free, soundsStatusIcon: nil, circleImage: "cat_first_circle"),
        PetModel(imageName: "ic_second_cat", petType: .cat, soundName: "second", soundType: .premium, soundsStatusIcon: UIImage(named: "status_premium"), circleImage: "cat_second_circle"),
        PetModel(imageName: "ic_third_cat", petType: .cat, soundName: "thirt", soundType: .free, soundsStatusIcon: nil, circleImage: "cat_thirt_circle"),
        PetModel(imageName: "ic_fourt_cat", petType: .cat, soundName: "fourth", soundType:.premium, soundsStatusIcon:UIImage(named: "status_premium"), circleImage: "cat_fourt_circle"),
        PetModel(imageName: "ic_fifth_cat", petType: .cat, soundName: "fifth", soundType: .premium, soundsStatusIcon: UIImage(named: "status_premium"), circleImage: "cat_fifth_circle"),
        PetModel(imageName: "ic_sixth_cat", petType: .cat, soundName: "sixth", soundType: .premium, soundsStatusIcon: UIImage(named: "status_premium"), circleImage: "cat_sixth_circle"),
        PetModel(imageName: "ic_seventh_cat", petType: .cat, soundName: "seventh", soundType: .premium, soundsStatusIcon: UIImage(named: "status_premium"), circleImage: "cat_seventh_circle"),
        PetModel(imageName: "ic_eighth_cat", petType: .cat, soundName: "eighth", soundType:.premium, soundsStatusIcon: UIImage(named: "status_premium"), circleImage: "cat_eight_circle")
    ]
    
    static let sound: [Sound] = [
        Sound(soundName: "clickSound")
    ]
    
    static let calls: [CallModel] = [
        CallModel(petName: "Golden", imageName: "golden", circleImage: "circle_golden", petType: .dog, callType: .premium, callStatusIcon: UIImage(named: "status_premium"), callVideo: "golden_video", longSound: "dogSoundfirst"),
        CallModel(petName: "Husky", imageName: "husky", circleImage: "circle_husky", petType: .dog, callType: .premium, callStatusIcon: UIImage(named: "status_premium"), callVideo: "husky_video", longSound: "dogSoundsecond"),
        CallModel(petName: "Pomeranian", imageName: "pomerian", circleImage: "circle_pomerian", petType: .dog, callType: .premium, callStatusIcon: UIImage(named: "status_premium"), callVideo: "pomeranian_video", longSound: "dogSoundthirt"),
        CallModel(petName: "Ragdoll", imageName: "ragdoll", circleImage: "circle_ragdoll", petType: .cat, callType: .premium, callStatusIcon: UIImage(named: "status_premium"), callVideo: "ragdoll_video", longSound: "catSoundthirt"),
        CallModel(petName: "British Shorthair", imageName: "britishshorthair", circleImage: "circle_britishshorthair", petType: .cat, callType: .premium, callStatusIcon: UIImage(named: "status_premium"), callVideo: "britishshorthaircat_video", longSound: "catSoundfirst"),
        CallModel(petName: "Litter British Shorthair", imageName: "litterbritish", circleImage: "circle_litterbritish", petType: .cat, callType: .premium, callStatusIcon: UIImage(named: "status_premium"), callVideo: "litterbritishshorthair_video", longSound: "catSoundsecond")
    ]
}

