//
//  PhotoCell.swift
//  ImageClassification-CoreML
//
//  Created by Doyoung Gwak on 2020/01/27.
//  Copyright © 2020 GwakDoyoung. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    
    var localIdentifier: String?
    var orientationClassificationResult: OrientationClassificationResult? {
        didSet {
            var color = UIColor.clear
            if orientationClassificationResult == nil {
                bottomLabel?.text = "classifying..."
            } else {
                var labelText = ""
                if let symbol = orientationClassificationResult?.symbol { labelText += symbol }
                if let confidence = orientationClassificationResult?.confidence { labelText += " (\(String(format: "%2d", Int(confidence * 100)))%)" }
                bottomLabel?.text = labelText
                if orientationClassificationResult?.symbol != "↑" && orientationClassificationResult?.symbol != "X" {
                    color = .orange
                }
            }
            
            bottomLabel?.backgroundColor = color
            bgView?.layer.borderColor = color.cgColor
        }
    }
    
    @IBOutlet weak var bgView: UIView?
    @IBOutlet weak var photoImageView: UIImageView?
    @IBOutlet weak var bottomLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoImageView?.contentMode = .scaleAspectFill
        bgView?.layer.borderWidth = 5
        bgView?.layer.masksToBounds = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        orientationClassificationResult = nil
    }
}
