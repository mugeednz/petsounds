//
//  VideoCallViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 7.02.2025.
//
import UIKit
import AVFoundation
import AudioToolbox

class VideoCallViewController: UIViewController {
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    var selectedCall: CallModel?
    var callVideo: String?
    var isCameraOn: Bool = true
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var isMuted: Bool = false
    var audioPlayer: AVAudioPlayer?
    var player: AVQueuePlayer?
    var looper: AVPlayerLooper?
    var playerLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.setupVideo()
        }
        playLongSound()
        pageDesign()
        if AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) == nil {
            cameraButton.isHidden = true
        }
    }
    
    // MARK: -Video-
    func setupVideo() {
        guard let videoName = selectedCall?.callVideo, !videoName.isEmpty else {
            print("Video adı eksik veya geçersiz.")
            return
        }
        
        if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            let playerItem = AVPlayerItem(url: url)
            player = AVQueuePlayer(playerItem: playerItem)
            looper = AVPlayerLooper(player: player!, templateItem: playerItem) 

            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = videoView.bounds
            playerLayer?.videoGravity = .resizeAspectFill
            videoView.layer.insertSublayer(playerLayer ?? AVPlayerLayer(), at: 0)
            
            player?.play()
        } else {
            print("Video dosyası bulunamadı: \(videoName)")
        }
    }
    
    func setupCameraView() {
        cameraView.layer.cornerRadius = 10
        cameraView.layer.masksToBounds = true
        view.addSubview(cameraView)
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .medium
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("Kamera bulunamadı.")
            return
        }
        
        if let captureSession = captureSession, captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.frame = cameraView.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer!)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }
    // MARK: -Sound-
    func playLongSound() {
        guard let soundFile = selectedCall?.longSound, let soundURL = Bundle.main.url(forResource: soundFile, withExtension: "mp3") else {
            print("Uzun ses dosyası bulunamadı!")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Uzun ses çalınırken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    // MARK: -Camera-
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCameraView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { response in
                if response {
                    DispatchQueue.main.async {
                        self.setupCameraView()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showPermissionAlert()
                    }
                }
            }
        case .denied:
            showPermissionAlert()
        case .restricted:
            showPermissionAlert()
        @unknown default:
            break
        }
    }
    
    func showPermissionAlert() {
        let alert = UIAlertController(title: "Kamera İzni", message: "Kamera erişimi için izin veriniz.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        self.present(alert, animated: true)
    }
    
    // MARK: -Design-
    func pageDesign() {
        guard let superview = view else { return }

        videoView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: superview.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }

    // MARK: -Actions-
    @IBAction func cameraButtonAction() {
        guard let captureSession = captureSession else { return }
        
        if isCameraOn {
            captureSession.stopRunning()
            cameraButton.setImage(UIImage(named: "closedCamera_button"), for: .normal)
            cameraView?.isHidden = true
        } else {
            captureSession.startRunning()
            cameraButton.setImage(UIImage(named: "videoCall_button"), for: .normal)
            cameraView?.isHidden = false
        }
        
        isCameraOn.toggle()
    }
    
    @IBAction func declineButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func voiceButtonAction() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat)
            try audioSession.setActive(true)
            
            if isMuted {
                try audioSession.setMode(.default)
                voiceButton.setImage(UIImage(named: "voice_close"), for: .normal)
                audioPlayer?.stop()
            } else {
                try audioSession.setMode(.voiceChat)
                voiceButton.setImage(UIImage(named: "voice_button"), for: .normal)
                
                if let soundFile = selectedCall?.longSound,
                   let soundURL = Bundle.main.url(forResource: soundFile, withExtension: "mp3") {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                        audioPlayer?.numberOfLoops = -1
                        audioPlayer?.play()
                    } catch {
                        print("Uzun ses çalınırken hata oluştu: \(error.localizedDescription)")
                    }
                }
            }
            isMuted.toggle()
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
}

