//
//  ViewController.swift
//  MobileNetApp
//
//  Created by GwakDoyoung on 28/05/2018.
//  Copyright © 2018 GwakDoyoung. All rights reserved.
//

import UIKit
import Vision

class LiveImageViewController: UIViewController {
    
    // MARK: - UI Properties
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var labelLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    @IBOutlet weak var inferenceLabel: UILabel!
    @IBOutlet weak var etimeLabel: UILabel!
    @IBOutlet weak var fpsLabel: UILabel!
    
    // MARK - Performance Measurement Property
    private let 👨‍🔧 = 📏()
    private var isInferencing = false
    
    let maf1 = MovingAverageFilter()
    let maf2 = MovingAverageFilter()
    let maf3 = MovingAverageFilter()
    
    // MARK - Core ML model
    // MobileNet(iOS11+), MobileNetV2(iOS11+), MobileNetV2FP16(iOS11.2+), MobileNetV2Int8LUT(iOS12+)
    // Resnet50(iOS11+), Resnet50FP16(iOS11.2+), Resnet50Int8LUT(iOS12+), Resnet50Headless(iOS11+)
    // SqueezeNet(iOS11+), SqueezeNetFP16(iOS11.2+), SqueezeNetInt8LUT(iOS12+)
    // OrientedImageClassifier
    let classificationModel = SqueezeNetInt8LUT()
    
    //11 Pro
    //XS
    //XS Max
    //XR
    //X
    //8
    //8+
    //7
    //6S+
    //6+
    
    //11 Pro
    //MobileNet           : 13 15 29
    //MobileNetV2         : 14 16 29
    //MobileNetV2FP16     : 14 15 29
    //MobileNetV2Int8LUT  : 14 15 29
    //Resnet50            : 20 22 29
    //Resnet50FP16        : 20 22 29
    //Resnet50Int8LUT     : 20 22 29
    //Resnet50Headless    : 13 14 29
    //SqueezeNet          : 12 14 29
    //SqueezeNetFP16      : 13 13 29
    //SqueezeNetInt8LUT   : 13 14 29
    //
    //XS
    //MobileNet           : 16 18 23
    //MobileNetV2         : 21 23 23
    //MobileNetV2FP16     : 20 24 23
    //MobileNetV2Int8LUT  : 21 23 23
    //Resnet50            : 27 30 23
    //Resnet50FP16        : 26 28 23
    //Resnet50Int8LUT     : 27 29 23
    //Resnet50Headless    : 18 19 23
    //SqueezeNet          : 17 18 23
    //SqueezeNetFP16      : 17 18 23
    //SqueezeNetInt8LUT   : 18 20 23
    //
    //XS Max
    //MobileNet           : 18 20 23
    //MobileNetV2         : 18 21 23
    //MobileNetV2FP16     : 19 21 23
    //MobileNetV2Int8LUT  : 21 23 23
    //Resnet50            : 25 28 23
    //Resnet50FP16        : 26 28 23
    //Resnet50Int8LUT     : 25 28 23
    //Resnet50Headless    : 13 13 23
    //SqueezeNet          : 17 18 23
    //SqueezeNetFP16      : 17 18 23
    //SqueezeNetInt8LUT   : 19 20 23
    //
    //XR
    //MobileNet           : 19 21 23
    //MobileNetV2         : 21 23 23
    //MobileNetV2FP16     : 20 23 23
    //MobileNetV2Int8LUT  : 20 22 23
    //Resnet50            : 26 29 23
    //Resnet50FP16        : 27 30 23
    //Resnet50Int8LUT     : 26 28 23
    //Resnet50Headless    : 18 18 23
    //SqueezeNet          : 18 20 23
    //SqueezeNetFP16      : 18 19 23
    //SqueezeNetInt8LUT   : 18 19 23
    //
    //X
    //MobileNet           : 33 35 23
    //MobileNetV2         : 46 48 20
    //MobileNetV2FP16     : 48 50 18
    //MobileNetV2Int8LUT  : 53 55 16
    //Resnet50            : 61 64 14
    //Resnet50FP16        : 64 66 14
    //Resnet50Int8LUT     : 60 63 15
    //Resnet50Headless    : 36 36 23
    //SqueezeNet          : 24 25 23
    //SqueezeNetFP16      : 24 26 23
    //SqueezeNetInt8LUT   : 27 29 23
    //
    //7+
    //MobileNet           : 43 46 20
    //MobileNetV2         : 64 67 13
    //MobileNetV2FP16     : 65 69 13
    //MobileNetV2Int8LUT  : 64 67 13
    //Resnet50            : 78 82 11
    //Resnet50FP16        : 75 78 11
    //Resnet50Int8LUT     : 77 80 11
    //Resnet50Headless    : 54 54 16
    //SqueezeNet          : 35 37 23
    //SqueezeNetFP16      : 36 38 22
    //SqueezeNetInt8LUT   : 34 37 23
    //
    //7
    //MobileNet           : 35 37 23
    //MobileNetV2         : 53 55 17
    //MobileNetV2FP16     : 57 60 15
    //MobileNetV2Int8LUT  : 53 56 16
    //Resnet50            : 63 66 14
    //Resnet50FP16        : 74 76 12
    //Resnet50Int8LUT     : 75 78 12
    //Resnet50Headless    : 53 54 17
    //SqueezeNet          : 29 31 23
    //SqueezeNetFP16      : 29 31 23
    //SqueezeNetInt8LUT   : 30 32 23
    
    // MARK: - Vision Properties
    var request: VNCoreMLRequest?
    var visionModel: VNCoreMLModel?
    
    // MARK: - AV Properties
    var videoCapture: VideoCapture!
    
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup ml model
        setUpModel()
        
        // setup camera
        setUpCamera()
        
        // setup delegate for performance measurement
        👨‍🔧.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        if let visionModel = try? VNCoreMLModel(for: classificationModel.model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .centerCrop
        } else {
            fatalError()
        }
    }
    
    
    // MARK: - 초기 세팅
    
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 50
        videoCapture.setUp(sessionPreset: .vga640x480) { success in
            
            if success {
                // UI에 비디오 미리보기 뷰 넣기
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // 초기설정이 끝나면 라이브 비디오를 시작할 수 있음
                self.videoCapture.start()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
}

// MARK: - VideoCaptureDelegate
extension LiveImageViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?/*, timestamp: CMTime*/) {
        
        // the captured image from camera is contained on pixelBuffer
        if !self.isInferencing, let pixelBuffer = pixelBuffer {
            self.isInferencing = true
            
            // start of measure
            self.👨‍🔧.🎬👏()
            
            // start predict
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
}

// MARK: - Inference
extension LiveImageViewController {
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        guard let request = request else { fatalError() }
        // vision framework configures the input size of image following our model's input configuration automatically
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        // middle of measure
        self.👨‍🔧.🏷(with: "endInference")
        
        // 메인큐에서 결과 출력
        if let classificationResults = request.results as? [VNClassificationObservation] {
            showClassificationResult(results: classificationResults)
        } else if let mlFeatureValueResults = request.results as? [VNCoreMLFeatureValueObservation] {
            showCustomResult(results: mlFeatureValueResults)
        }
        
        DispatchQueue.main.sync {
            // end of measure
            self.👨‍🔧.🎬🤚()
            
            self.isInferencing = false
        }
    }
    
//    func predict(with pixelBuffer: CVPixelBuffer) {
//        if let output: MobileNetV2Output = try? MobileNetV2().prediction(image: pixelBuffer) {
//            let predictedLabelText = output.classLabel
//            let predictedConfidence = output.classLabelProbs[predictedLabelText] ?? -100.0
//            print("\(predictedLabelText), \(predictedConfidence * 100) %")
//        }
//    }

    func showClassificationResult(results: [VNClassificationObservation]) {
        guard let result = results.first else {
            showFailResult()
            return
        }
        
        showResults(objectLabel: result.identifier, confidence: result.confidence)
    }
    
    func showCustomResult(results: [VNCoreMLFeatureValueObservation]) {
        guard results.first != nil else {
            showFailResult()
            return
        }
        
        showFailResult() // TODO
    }
    
    func showFailResult() {
        DispatchQueue.main.sync {
            self.labelLabel.text = "n/a result"
            self.confidenceLabel.text = "-- %"
        }
    }
    
    func showResults(objectLabel: String, confidence: VNConfidence) {
        DispatchQueue.main.sync {
            self.labelLabel.text = objectLabel
            self.confidenceLabel.text = "\(round(confidence * 100)) %"
        }
    }
}

// MARK: - 📏(Performance Measurement) Delegate
extension LiveImageViewController: 📏Delegate {
    func updateMeasure(inferenceTime: Double, executionTime: Double, fps: Int) {
        self.maf1.append(element: Int(inferenceTime*1000.0))
        self.maf2.append(element: Int(executionTime*1000.0))
        self.maf3.append(element: fps)
        
        self.inferenceLabel.text = "inference: \(self.maf1.averageValue) ms"
        self.etimeLabel.text = "execution: \(self.maf2.averageValue) ms"
        self.fpsLabel.text = "fps: \(self.maf3.averageValue)"
    }
}

class MovingAverageFilter {
    private var arr: [Int] = []
    private let maxCount = 10
    
    public func append(element: Int) {
        arr.append(element)
        if arr.count > maxCount {
            arr.removeFirst()
        }
    }
    
    public var averageValue: Int {
        guard !arr.isEmpty else { return 0 }
        let sum = arr.reduce(0) { $0 + $1 }
        return Int(Double(sum) / Double(arr.count))
    }
}
