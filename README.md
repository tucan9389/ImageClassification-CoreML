# MobileNetApp for iOS

![platform-ios](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![swift-version](https://img.shields.io/badge/swift-4-red.svg)
![lisence](https://img.shields.io/badge/license-MIT-black.svg)

![DEMO-CoreML](https://github.com/tucan9389/MobileNetApp-CoreML/raw/master/resource/MobileNet-CoreML-DEMO.gif?raw=true)

## Requirements

- Xcode 9.2+
- iOS 11.0+
- Swift 4

## Download model

- MobileNet model for Core ML(`MobileNet.mlmodel`)
  ☞ Download Core ML model on [Apple Developer Page](https://developer.apple.com/kr/machine-learning/build-run-models).

> **Source Link**
>
> https://github.com/tensorflow/models/blob/master/slim/nets/mobilenet_v1.md
>
> **Caffe Version**
>
> Converted from a Caffe version of the original MobileNet model.
> https://github.com/shicai/MobileNet-Caffe
>
> **Authors** 
>
> Original Paper Title: MobileNets: Efficient Convolutional Neural Networks for Mobile Vision Applications
> Authors: Andrew G. Howard, Menglong Zhu, Bo Chen, Dmitry Kalenichenko, Weijun Wang, Tobias Weyand, Marco Andreetto, Hartwig Adam
>
> Caffe version: Shicai Yang
>
> **License**
>
> Apache 2.0 
> http://www.apache.org/licenses/LICENSE-2.0

## Build & Run

### 1. Prerequisites

#### 1.1 Import pose estimation model

![모델 불러오기.png](https://github.com/tucan9389/MobileNetApp-CoreML/blob/master/resource/%EB%AA%A8%EB%8D%B8%20%EB%B6%88%EB%9F%AC%EC%98%A4%EA%B8%B0.png?raw=true)

Once you import the model, compiler generates model helper class on build path automatically. You can access the model through model helper class by creating an instance, not through build path.

#### 1.2 Add permission in info.plist for device's camera access

![prerequest_001_plist](/Users/canapio/Project/machine%20learning/MoT%20Labs/github_project/ml-ios-projects/PoseEstimation-CoreML/resource/prerequest_001_plist.png)

### 2. Dependencies

No external library yet.

### 3. Code

#### 3.1 Import Vision framework

```swift
import Vision
```

#### 3.2 Define properties for Core ML

```swift
// MARK - Core ML model
typealias ClassifierModel = MobileNet
var coremlModel: ClassifierModel? = nil

// MARK: - Vision Properties
var request: VNCoreMLRequest?
var visionModel: VNCoreMLModel?
```

#### 3.3 Configure and prepare the model

```swift
override func viewDidLoad() {
    super.viewDidLoad()

	if let visionModel = try? VNCoreMLModel(for: ClassifierModel().model) {
        self.visionModel = visionModel
        request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
        request?.imageCropAndScaleOption = .scaleFill
    } else {
        fatalError()
    }
}

func visionRequestDidComplete(request: VNRequest, error: Error?) { 
    /* ------------------------------------------------------ */
    /* something postprocessing what you want after inference */
    /* ------------------------------------------------------ */
}
```

#### 3.4 Inference 🏃‍♂️

```swift
guard let request = request else { fatalError() }
let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
try? handler.perform([request])
```