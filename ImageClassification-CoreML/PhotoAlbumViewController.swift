//
//  PhotoAlbumViewController.swift
//  ImageClassification-CoreML
//
//  Created by Doyoung Gwak on 2020/01/27.
//  Copyright © 2020 GwakDoyoung. All rights reserved.
//

import UIKit
import Photos
import Vision

class OrientationClassifier {
    let classificationModel = RotationClassifier_twoclass()
    var visionModel: VNCoreMLModel?
    var request: VNCoreMLRequest?
    var completion: VNRequestCompletionHandler?
    init() {
        guard let visionModel = try? VNCoreMLModel(for: classificationModel.model) else { return }
        self.visionModel = visionModel
        request = VNCoreMLRequest(model: visionModel, completionHandler: completionHandler)
        request?.imageCropAndScaleOption = .centerCrop
    }
    
    func completionHandler(_ request: VNRequest, error: Error?) {
        completion?(request, error)
    }
    
    func predict(with image: UIImage, completionHandler: VNRequestCompletionHandler? = nil) {
        guard
            let request = request,
            let cgImage = image.cgImage else { return }
        completion = completionHandler
        //let imageOrientation = image.imageOrientation
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}

enum OrientationClassificationResult {
    case portrait(confidence: Float)
    case landscapeLeft(confidence: Float)
    case landscapeRight(confidence: Float)
    case upsideDown(confidence: Float)
    case none
    
    init(label: String, confidence: Float) {
        if label == "portrait" {
            self = .portrait(confidence: confidence)
        } else if label == "landscape-left" {
            self = .landscapeLeft(confidence: confidence)
        } else if label == "landscape-right" {
            self = .landscapeRight(confidence: confidence)
        } else if label == "upside-down" {
            self = .upsideDown(confidence: confidence)
        } else {
            self = .none
        }
    }
    
    var symbol: String {
        switch self {
        case .portrait(_):
            return "↑"
        case .landscapeLeft(_):
            return "→"
        case .landscapeRight(_):
            return "←"
        case .upsideDown(_):
            return "↓"
        default:
            return "X"
        }
    }
    
    var confidence: Float? {
        switch self {
        case .portrait(let confidence):
            return confidence
        case .landscapeLeft(let confidence):
            return confidence
        case .landscapeRight(let confidence):
            return confidence
        case .upsideDown(let confidence):
            return confidence
        default:
            return nil
        }
    }
}

class PhotoAlbumViewController: UICollectionViewController {

    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 5,
        minimumInteritemSpacing: 2,
        minimumLineSpacing: 3,
        sectionInset: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    )
    
    var fetchResult: PHFetchResult<PHAsset>?
    let imageManager = PHImageManager()
    lazy var requestOptions: PHImageRequestOptions = {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        return requestOptions
    }()
    lazy var requestOptionsInPrediction: PHImageRequestOptions = {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        return requestOptions
    }()
    
    // core ml
    var classifiedResults: [String: OrientationClassificationResult] = [:]
    let classifier = OrientationClassifier()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collection view
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        // photo album
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        // coreml model
        classifyForAllPhotoAsynchronously()
    }
}

extension PhotoAlbumViewController {
    func classifyForAllPhotoAsynchronously() {
        DispatchQueue(label: "com.tucan9389.classification", qos: .utility).async { [weak self] in
            self?.classifyForAllPhoto()
        }
    }
    
    func classifyForAllPhoto() {
        guard let totalNumberOfAssets = fetchResult?.count else { return }
        
        var indexOfClassificaitonProcess = 0
        fetchResult?.enumerateObjects({ [weak self] (asset, offset, _) in
            guard let self = self else { return }
            var photoImage: UIImage?
            if asset.mediaSubtypes == .photoScreenshot {
                let orientationResult = OrientationClassificationResult.none
                self.classifiedResults[asset.localIdentifier] = orientationResult
                indexOfClassificaitonProcess += 1
                
                DispatchQueue.main.async {
                    self.updateCellIfVisible(asset: asset, orientationResult: orientationResult)
                    self.title = "\(indexOfClassificaitonProcess)/\(totalNumberOfAssets)"
                }
                return
            }
            self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 299, height: 299), contentMode: PHImageContentMode.aspectFit, options: self.requestOptionsInPrediction) { (image, _) in
                photoImage = image
            }
            if let photoImage = photoImage {
                self.classifier.predict(with: photoImage) { (request, _) in
                    guard let result = request.results?.first as? VNClassificationObservation else { return }
                    let label = result.identifier
                    let confidence = result.confidence
                    
                    // print(label, confidence)
                    let orientationResult = OrientationClassificationResult(label: label, confidence: confidence)
                    self.classifiedResults[asset.localIdentifier] = orientationResult
                    indexOfClassificaitonProcess += 1
                    
                    DispatchQueue.main.async {
                        self.updateCellIfVisible(asset: asset, orientationResult: orientationResult)
                        self.title = "\(indexOfClassificaitonProcess)/\(totalNumberOfAssets)"
                    }
                }
            }
        })
    }
}

// MARK: - CollectionView
extension PhotoAlbumViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "DummyCell", for: indexPath)
        }
        
        cell.photoImageView?.backgroundColor = UIColor.orange
        cell.photoImageView?.image = nil
        cell.bottomLabel?.text = ""
        
        let asset = fetchResult?.object(at: indexPath.item)
        cell.localIdentifier = asset?.localIdentifier
        
        if let asset = asset {
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 299, height: 299), contentMode: PHImageContentMode.aspectFit, options: requestOptions) { (image, _) in
                if cell.localIdentifier == asset.localIdentifier {
                    cell.photoImageView?.image = image
                }
            }
            
            cell.orientationClassificationResult = classifiedResults[asset.localIdentifier]
        }

        return cell
    }
    
    func updateCellIfVisible(asset: PHAsset, orientationResult: OrientationClassificationResult) {
        if let visibleCells = self.collectionView?.visibleCells,
            let indexPathsForVisibleItems = self.collectionView?.indexPathsForVisibleItems {
            for (cell, indexPath) in zip(visibleCells, indexPathsForVisibleItems) {
                if self.fetchResult?.object(at: indexPath.item).localIdentifier == asset.localIdentifier {
                    guard let cell = cell as? PhotoCell else { continue }
                    cell.orientationClassificationResult = orientationResult
                }
            }
        }
    }
}

class ColumnFlowLayout: UICollectionViewFlowLayout {

    let cellsPerRow: Int

    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth + 22)
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}
