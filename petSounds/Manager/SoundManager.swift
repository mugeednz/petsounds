//
//  SoundManager.swift
//  petSounds
//
//  Created by Müge Deniz on 4.02.2025.
//

import Foundation
import AVFAudio

class SoundManager {
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?
    private var unlockedRewardedSounds: [String] = []
    private var premiumSounds: [String] = []

    func isSoundAvailable(_ sound: PetModel) -> Bool {
        switch sound.soundType {
        case .free:
            return true
        case .rewarded:
            return unlockedRewardedSounds.contains(sound.soundName)
        case .premium:
            return premiumSounds.contains(sound.soundName)
        }
    }

    func unlockRewardedSound(_ sound: PetModel) {
        if sound.soundType == .rewarded && !unlockedRewardedSounds.contains(sound.soundName) {
            unlockedRewardedSounds.append(sound.soundName)
        }
    }

    func purchasePremiumSound(_ sound: PetModel) {
        if sound.soundType == .premium && !premiumSounds.contains(sound.soundName) {
            premiumSounds.append(sound.soundName)
        }
    }
    func playSound(named soundName: String) {
           guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }
           do {
               audioPlayer = try AVAudioPlayer(contentsOf: url)
               audioPlayer?.play()
           } catch {
               print("Ses çalınamadı: \(error)")
           }
       }
       
       func stopAllSounds() {
           audioPlayer?.stop()
           audioPlayer = nil
       }
}
