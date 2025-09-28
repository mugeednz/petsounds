//
//  AnimatedWaveformView.swift
//  petSounds
//
//  Created by Müge Deniz on 12.02.2025.
//

import AVFoundation
import UIKit

class AnimatedWaveformView: UIView {
    @IBOutlet weak var annaunceLabel: UILabel!
    var waveformLayer = CAShapeLayer()
    var audioRecorder: AVAudioRecorder?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWaveform()
        startAudioMonitoring()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWaveform()
        startAudioMonitoring()
    }

    func setupWaveform() {
        waveformLayer.strokeColor = UIColor.white.cgColor
        waveformLayer.lineWidth = 4.0
        waveformLayer.fillColor = nil
        layer.addSublayer(waveformLayer)
    }

    func startAudioMonitoring() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
        try? audioSession.setActive(true)

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]

        audioRecorder = try? AVAudioRecorder(url: URL(fileURLWithPath: "/dev/null"), settings: settings)
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()

        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateWaveform), userInfo: nil, repeats: true)
    }

    @objc func updateWaveform() {
        audioRecorder?.updateMeters()
        let level = CGFloat(audioRecorder?.averagePower(forChannel: 0) ?? -60)
        drawWaveform(amplitude: max(5, (60 + level) * 2))
    }

    func drawWaveform(amplitude: CGFloat) {
        let path = UIBezierPath()
        let centerY = bounds.height / 2
        let width = bounds.width
        let segmentWidth: CGFloat = width / 15

        for i in 0..<15 {
            let height = amplitude * (CGFloat.random(in: 0.3...1.0))
            let x = CGFloat(i) * segmentWidth + segmentWidth / 2
            let y1 = centerY - height / 2
            let y2 = centerY + height / 2

            path.move(to: CGPoint(x: x, y: y1))
            path.addLine(to: CGPoint(x: x, y: y2))
        }

        waveformLayer.path = path.cgPath
    }
}
