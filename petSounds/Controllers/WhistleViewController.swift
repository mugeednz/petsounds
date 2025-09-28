//
//  WhistleViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 5.02.2025.
//

import UIKit
import AVFoundation

class WhistleViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var highWhistleButton: UIButton!
    @IBOutlet weak var lowWhistleButton: UIButton!
    @IBOutlet weak var mediumWhistleButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var selectionhighImage: UIImageView!
    @IBOutlet weak var selectionMediumImage: UIImageView!
    @IBOutlet weak var selectionLowImage: UIImageView!
    @IBOutlet weak var hzLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var hzSlider: UISlider!
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var whistleStackView: UIStackView!
    @IBOutlet weak var topImageView: UIImageView!
    
    let maxFreePlays = 5
    var audioEngine: AVAudioEngine?
    var sourceNode: AVAudioSourceNode?
    var sampleRate: Double = 44100
    var selectedFrequency: Double = 13125
    var theta: Double = 0.0
    var isPlaying = false
    var currentWhistleType: WhistleType = .medium
    enum WhistleType {
        case high, medium, low
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "playCount")
        setupSlider()
        addLabels()
        updateWhistleSelection(type: .medium, shouldPlay: false)
        
        if UserDefaults.standard.object(forKey: "remainingPlays") == nil {
            UserDefaults.standard.set(maxFreePlays, forKey: "remainingPlays")
        }
        
        let playLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        playButton.addGestureRecognizer(playLongPressGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stopWhistleOnTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: -Limits-
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        let generator = UIImpactFeedbackGenerator(style: .medium)

        switch sender.state {
        case .began:
            if !isPlaying {
                if !GlobalHelper.isPremiumActive() && shouldBlockPlay() {
                    navigateToPremium()
                    return
                }
                
                playFrequency(frequency: selectedFrequency)
                isPlaying = true
                generator.impactOccurred()
            }
        case .ended, .cancelled:
            stopFrequency()
            isPlaying = false
            generator.impactOccurred()
        default:
            break
        }
    }
    
    func shouldBlockPlay() -> Bool {
        let playCountKey = "playCount"
        let remainingPlaysKey = "remainingPlays"

        if UserDefaults.standard.integer(forKey: remainingPlaysKey) <= 0 {
            return true
        }

        let remainingPlays = UserDefaults.standard.integer(forKey: remainingPlaysKey)
        UserDefaults.standard.set(remainingPlays - 1, forKey: remainingPlaysKey)
        UserDefaults.standard.synchronize()

        return false
    }

    func navigateToPremium() {
        GlobalHelper.openSubs(vC: self)
    }
    
    func playFrequency(frequency: Double) {
        stopFrequency()
        audioEngine = AVAudioEngine()
        let engine = audioEngine!
        
        sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let bufferPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let thetaIncrement = 2.0 * .pi * frequency / self.sampleRate
            
            for frame in 0..<Int(frameCount) {
                let value = Float(sin(self.theta)) * 0.5
                self.theta += thetaIncrement
                if self.theta > 2.0 * .pi { self.theta -= 2.0 * .pi }
                
                for buffer in bufferPointer {
                    buffer.mData?.assumingMemoryBound(to: Float.self)[frame] = value
                }
            }
            return noErr
        }
        
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)
        engine.attach(sourceNode!)
        engine.connect(sourceNode!, to: engine.mainMixerNode, format: format)
        
        do {
            try engine.start()
        } catch {
            print("Ses motoru başlatılamadı: \(error.localizedDescription)")
        }
    }
    
    func stopFrequency() {
        audioEngine?.stop()
        audioEngine = nil
        sourceNode = nil
    }
    
    func setupSlider() {
        hzSlider.minimumValue = 5000
        hzSlider.maximumValue = 21000
        hzSlider.value = 13125
        hzSlider.setMinimumTrackImage(UIImage(named: "slider_max"), for: .normal)
        hzSlider.setMaximumTrackImage(UIImage(named: "slider_min"), for: .normal)
        hzSlider.setThumbImage(UIImage(named: "slider_custom_thumb"), for: .normal)
    }
    
    @objc func stopWhistleOnTap() {
        stopFrequency()
        isPlaying = false
    }
    
    // MARK: - Label Design -
    func addLabels() {
        hzLabel.text = "\(Int(hzSlider.value)) Hz"
        hzLabel.font = .boldSystemFont(ofSize: 16)
        hzLabel.textColor = .white
        
        minLabel.text = "5000Hz"
        minLabel.font = .systemFont(ofSize: 14)
        minLabel.textColor = .white
        
        maxLabel.text = "21000Hz"
        maxLabel.font = .systemFont(ofSize: 14)
        maxLabel.textColor = .white
        
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .bold)
        ]
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.attributedText = NSAttributedString(string: "whistle_title".translate(), attributes: strokeTextAttributes)
        
        let buttonTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        buttonLabel.adjustsFontSizeToFitWidth = true
        buttonLabel.attributedText = NSAttributedString(string: "hold_to_play_sound".translate(), attributes: buttonTextAttributes)
        
    }
    
    func updateWhistleSelection(type: WhistleType, shouldPlay: Bool = false) {
        selectionhighImage.isHidden = true
        selectionMediumImage.isHidden = true
        selectionLowImage.isHidden = true
        
        var newImage: UIImage?
        
        switch type {
        case .high:
            selectedFrequency = 16000
            selectionhighImage.isHidden = false
            newImage = UIImage(named: "orangebig_whistle")
        case .medium:
            selectedFrequency = 9000
            selectionMediumImage.isHidden = false
            newImage = UIImage(named: "purplebig_whistle")
        case .low:
            selectedFrequency = 5000
            selectionLowImage.isHidden = false
            newImage = UIImage(named: "bluebig_whistle")
        }
        
        UIView.transition(with: bigImage, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.bigImage.image = newImage
        }, completion: nil)
        
        if shouldPlay {
            stopFrequency()
            playFrequency(frequency: selectedFrequency)
        }
    }
    
    // MARK: - Animation -
    func animateButtonPress(_ button: UIButton) {
        UIView.animate(withDuration: 0.15, animations: {
            button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                button.transform = .identity
            }
        }
    }
    
    //MARK: -Actions-
    @IBAction func backButtonAction() {
        dismiss(animated: true)
        stopFrequency()
    }
    @IBAction func highButtonAction() {
        animateButtonPress(highWhistleButton)
        updateWhistleSelection(type: .high, shouldPlay: false)
    }
    
    @IBAction func mediumButtonAction() {
        animateButtonPress(mediumWhistleButton)
        updateWhistleSelection(type: .medium, shouldPlay: false)
    }
    
    @IBAction func lowButtonAction() {
        animateButtonPress(lowWhistleButton)
        updateWhistleSelection(type: .low, shouldPlay: false)
    }
    
    @IBAction func newSliderValue(_ sender: UISlider) {
        let roundedValue = round(Double(sender.value) / 1000) * 1000
        selectedFrequency = roundedValue
        
        UIView.transition(with: hzLabel, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.hzLabel.text = "\(Int(self.selectedFrequency)) Hz"
        }, completion: nil)
        
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
}
