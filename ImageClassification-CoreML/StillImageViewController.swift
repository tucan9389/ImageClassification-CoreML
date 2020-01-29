//
//  StillImageViewController.swift
//  MobileNetApp
//
//  Created by Doyoung Gwak on 20/07/2019.
//  Copyright © 2019 GwakDoyoung. All rights reserved.
//

import UIKit
import Vision

class StillImageViewController: UIViewController {
    
    // MARK: - UI Properties
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var top1ResultLabel: UILabel!
    @IBOutlet weak var top1ConfidenceLabel: UILabel!
    
    let imagePickerController = UIImagePickerController()
    
    // MARK - Core ML model
    // MobileNet(iOS11+), MobileNetV2(iOS11+), MobileNetV2FP16(iOS11.2+), MobileNetV2Int8LUT(iOS12+)
    // Resnet50(iOS11+), Resnet50FP16(iOS11.2+), Resnet50Int8LUT(iOS12+), Resnet50Headless(N/A)
    // SqueezeNet(iOS11+), SqueezeNetFP16(iOS11.2+), SqueezeNetInt8LUT(iOS12+)
    let classificationModel = MobileNetV2()
    
    // MARK: - Vision Properties
    var request: VNCoreMLRequest?
    var visionModel: VNCoreMLModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup ml model
        setUpModel()
        
        // image picker delegate setup
        imagePickerController.delegate = self
    }
    
    @IBAction func tapImport(_ sender: Any) {
        self.present(imagePickerController, animated: true)
    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        if let visionModel = try? VNCoreMLModel(for: classificationModel.model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .scaleFill
        } else {
            fatalError()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension StillImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let url = info[UIImagePickerControllerImageURL] as? URL {
            mainImageView.image = image
            self.predict(with: url)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Inference
extension StillImageViewController {
    // prediction
    func predict(with url: URL) {
        guard let request = request else { fatalError() }
        
        // vision framework configures the input size of image following our model's input configuration automatically
        let handler = VNImageRequestHandler(url: url)
        try? handler.perform([request])
    }
    
    // post-processing
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        print(request)
        
        if let result = request.results?.first as? VNClassificationObservation {
            top1ResultLabel.text = result.identifier
            top1ConfidenceLabel.text = "\(String(format: "%.2f", result.confidence * 100))%"
        } else {
            top1ResultLabel.text = "no result"
            top1ConfidenceLabel.text = "--%"
        }
    }
}
