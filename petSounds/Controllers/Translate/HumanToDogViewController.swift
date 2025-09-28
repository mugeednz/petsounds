//
//  HumanToDogViewController.swift
//  petSounds
//
//  Created by Müge Deniz on 12.02.2025.
//

import UIKit
import AVFoundation
import Speech

class HumanToDogViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var waveView: AnimatedWaveformView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var humanImageView: UIImageView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cleanButton: UIButton!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var topImageView: UIImageView!
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    var translatedText: String = ""
    var isRecording = false
    var selectedPet: String  = "dog"
    var selectedHuman = true
    var isHumanToPet = true
    var isCameraOn = false
    var supportedLanguages = ["en-US", "tr-TR", "ru-RU", "de-DE", "es-ES", "pt-PT", "fr-FR", "it-IT"]
    var currentLanguageIndex = 0
    private var cameraSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelDesign()
        updatePetImage()
        waveView.isHidden = true
        if !isSmallScreenDevice() {
            waveView.isHidden = true
        }
        requestSpeechAuthorization()
        cameraButton.isHidden = !isCameraActive()
        startCamera()
        updateModeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isHidden = !isCameraActive()
    }
    
    private func isCameraActive() -> Bool {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            return false
        }
        return true
    }
    
    // MARK: -Small Device Feature-
    private func isSmallScreenDevice() -> Bool {
        let smallScreenModels = ["iPhone SE", "iPhone 5s", "iPhone 5", "iPhone SE (3rd generation)"]
        let deviceModel = UIDevice.current.name
        return smallScreenModels.contains(where: deviceModel.contains)
    }

    
    // MARK: -Camera-
    
    private func startCamera() {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Ön kamera bulunamadı.")
            cameraButton.isHidden = true
            return
        }
        
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession,
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            return
        }
        
        captureSession.addInput(videoInput)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        cameraView.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
        isCameraOn = true
        cameraButton.isHidden = !isCameraActive()
    }
    
    
    private func stopCamera() {
        captureSession?.stopRunning()
        captureSession = nil
        isCameraOn = false
    }
    
    // MARK: -Recording-
    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("Konuşma tanıma izni verildi.")
                default:
                    print("Konuşma tanıma izni verilmedi.")
                    self.translateButton.isEnabled = false
                    self.showPermissionAlert()
                }
            }
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "İzin Gerekli",
            message: "Lütfen Ayarlar'dan konuşma tanıma izni verin.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
        
        cameraButton.isHidden = !isCameraActive()
        cleanButton.isHidden = true
    }
    
    private func startRecording(for languageCode: String) {
        
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))
        
        guard let speechRecognizer = speechRecognizer else {
            return
        }
        
        if !speechRecognizer.isAvailable {
            print("Konuşma tanıma mevcut değil.")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.translatedText = result.bestTranscription.formattedString
                self.translationLabel.text = self.translatedText
                self.translationLabel.numberOfLines = 2
                
                self.labelDesign()
            }
            
            if error != nil || result?.isFinal == true {
                self.stopRecording()
                self.restoreUI()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            recognitionRequest.append(buffer)
        }
        
        do {
            try audioEngine.start()
            isRecording = true
            print("Kayıt başlatıldı.")
        } catch {
            print("Ses motoru başlatılamadı: \(error.localizedDescription)")
        }
    }
    
    private func restoreUI() {
        
        DispatchQueue.main.async {
            let defaultImage = UIImage(named: "blue_voiceButton")
            self.translateButton.setImage(defaultImage, for: .normal)
            self.translationLabel.isHidden = (self.selectedPet == "dog" || self.selectedPet == "cat")
        }
        UIView.animate(withDuration: 0.3) {
            self.cameraButton.isHidden = !self.isCameraActive()
            self.cleanButton.isHidden = false
            self.switchButton.isHidden = false
            self.humanImageView.isHidden = false
            self.petImageView.isHidden = false
            self.waveView.isHidden = true
        }
    }
    
    func updatePetImage() {
        if selectedPet == "cat" {
            petImageView.image = UIImage(named: "small_catTranslate")
            centerImageView.image = UIImage(named: "bigCatChoices")
            titleLabel.text = "humantocat_title".translate()
        } else {
            petImageView.image = UIImage(named: "small_translateDog")
            centerImageView.image = UIImage(named: "translate_dog")
            titleLabel.text = "humantodog_title".translate()
        }
    }
    
    // MARK: -Design-
    func labelDesign() {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.strokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.attributedText = NSAttributedString(string: "HUMAN TO DOG", attributes: strokeTextAttributes)
        
        let translationTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.translationStrokeColor,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .font: UIFont(name: "Baloo-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        translationLabel.adjustsFontSizeToFitWidth = true
        translationLabel.attributedText = NSAttributedString(
            string: translationLabel.text?.uppercased() ?? "",
            attributes: translationTextAttributes
        )
    }
    
    private func updateModeUI() {
        UIView.animate(withDuration: 0.4) {
            let tempImage = self.humanImageView.image
            self.humanImageView.image = self.petImageView.image
            self.petImageView.image = tempImage
            
            if self.isHumanToPet {
                self.centerImageView.image = UIImage(named: "ic_humanBig")
                self.humanImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.petImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            } else {
                self.centerImageView.image = UIImage(named: (self.selectedPet == "dog") ? "translate_dog" : "bigCatChoices")
                self.petImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.humanImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
    
    // MARK: -Actions-
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchButtonAction() {
        isHumanToPet.toggle()
        updateModeUI()
        
        centerImageView.image = isHumanToPet ? UIImage(named: "ic_humanBig") : UIImage(named: (self.selectedPet == "dog") ? "translate_dog" : "bigCatChoices")
    }
    
    @IBAction func cameraButtonAction() {
        if isCameraOn {
            stopCamera()
        } else {
            startCamera()
        }
    }
    @IBAction func cleanButtonAction() {
        translationLabel.text = ""
        
        cameraButton.isHidden = !isCameraActive()
        cleanButton.isHidden = false
        switchButton.isHidden = false
        humanImageView.isHidden = false
        petImageView.isHidden = false
        waveView.isHidden = true
    }
    
    @IBAction func translateButtonAction() {
        if isRecording {
            stopRecording()
            
            let defaultImage = UIImage(named: "translate_Button")
            translateButton.setImage(defaultImage, for: .normal)
            
            UIView.animate(withDuration: 0.2) {
                self.cameraButton.isHidden = !self.isCameraActive()
                self.cleanButton.isHidden = false
                self.switchButton.isHidden = false
                self.humanImageView.isHidden = false
                self.petImageView.isHidden = false
                if !self.isSmallScreenDevice() {
                    self.waveView.isHidden = true
                } else {
                    self.waveView.isHidden = true
                }
                self.centerImageView.transform = .identity
            }
            
            DispatchQueue.main.async {
                if self.isHumanToPet {
                    self.translationLabel.isHidden = false
                    self.translationLabel.text = " ..."
                } else if self.selectedPet == "dog" || self.selectedPet == "cat" {
                    self.translationLabel.isHidden = true
                } else {
                    self.translationLabel.isHidden = false
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if GlobalHelper.isPremiumActive() {
                    self.navigateToTranslateViewController()
                } else {
                    GlobalHelper.openSubs(vC: self)
                }
            }
        } else {
            let currentLocale = Locale.current
            let languageCode = currentLocale.identifier
            
            let workingImage = UIImage(named: "working_Button")
            translateButton.setImage(workingImage, for: .normal)
            
            UIView.animate(withDuration: 0.2) {
                self.cameraButton.isHidden = true
                self.cleanButton.isHidden = true
                self.switchButton.isHidden = true
                self.humanImageView.isHidden = true
                self.petImageView.isHidden = true
                if !self.isSmallScreenDevice() {
                        self.waveView.isHidden = false
                          }
                self.centerImageView.transform = CGAffineTransform(translationX: 0, y: -50)
            }
            
            startRecording(for: languageCode)
        }
    }
    
    private func navigateToTranslateViewController() {
        GlobalHelper.pushController(id: "TranslateViewController", self) { vc in
            if let translateVC = vc as? TranslateViewController {
                translateVC.selectedPet = self.selectedPet
                translateVC.selectedHuman = self.isHumanToPet
            }
        }
    }
}
