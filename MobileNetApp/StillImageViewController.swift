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
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var top1ResultLabel: UILabel!
    @IBOutlet weak var top1ConfidenceLabel: UILabel!
    
    let imagePickerController = UIImagePickerController()
    
    let model = MobileNet() // MobileNetV2(), 
    var request: VNCoreMLRequest?
    var visionModel: VNCoreMLModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // image picker delegate setup
        imagePickerController.delegate = self
        
        // ML model setup
        setUpModel()
    }
    
    @IBAction func tapImport(_ sender: Any) {
        self.present(imagePickerController, animated: true)
    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        if let visionModel = try? VNCoreMLModel(for: model.model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .scaleFill
        } else {
            fatalError()
        }
    }
}

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

extension StillImageViewController {
    func predict(with url: URL) {
        guard let request = request else { fatalError() }
        
        // vision framework configures the input size of image following our model's input configuration automatically
        let handler = VNImageRequestHandler(url: url, options: [:])
        try? handler.perform([request])
    }
    
    // MARK: - Postprocessing
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
