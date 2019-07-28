# ImageClassification-CoreML

![platform-ios](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![swift-version](https://img.shields.io/badge/swift-4-red.svg)
![lisence](https://img.shields.io/badge/license-MIT-black.svg)

![DEMO-CoreML](https://github.com/tucan9389/MobileNetApp-CoreML/raw/master/resource/MobileNet-CoreML-DEMO.gif?raw=true)

## Requirements

- Xcode 9.2+
- iOS 11.0+, 11.2+, 12.0+
- Swift 4

## Model

### Model Size, Minimum iOS Version, Download Link

| Model | Size<br>(MB) | Minimum<br>iOS Version | Download Link |
| ----: | :----: | :----: | ----- |
| MobileNet | 17.1 | iOS11 | [머신 러닝 - 모델 실행 - Apple Developer](https://developer.apple.com/kr/machine-learning/build-run-models) |
| MobileNetV2 | 24.7 | iOS11 | [Machine Learning - Models - Apple Developer](https://developer.apple.com/machine-learning/models) |
| MobileNetV2FP16 | 12.4 | iOS11.2 | [Machine Learning - Models - Apple Developer](https://developer.apple.com/machine-learning/models) |
| MobileNetV2Int8LUT | 6.3 | iOS12 | [Machine Learning - Models - Apple Developer](https://developer.apple.com/machine-learning/models) |
| Resnet50 | 102.6 | iOS11 | [Machine Learning - Models - Apple Developer](https://developer.apple.com/machine-learning/models) |
| Resnet50FP16 | 51.3 | iOS11.2 | [Machine Learning - Models - Apple Developer](https://developer.apple.com/machine-learning/models) |
| Resnet50Int8LUT | 25.7 | iOS12 | [Machine Learning - Models - Apple Developer](https://developer.apple.com/machine-learning/models) |
| Resnet50Headless | 94.4 | iOS11 | [Machine Learning - Models - Apple Developer](https://developer.apple.com/machine-learning/models) |
| SqueezeNet | 5 | iOS11 | [Machine Learning - Models - Apple Developer](https://developer.apple.com/machine-learning/models) |
| SqueezeNetFP16 | 2.5 | iOS11.2 | [Machine Learning - Models - Apple Developer](https://developer.apple.com/machine-learning/models) |
| SqueezeNetInt8LUT | 1.3 | iOS12 | [Machine Learning - Models - Apple Developer](https://developer.apple.com/machine-learning/models) |

### Infernece Time (ms)

| Model vs. Device | XS | XS<br>Max | XR | X | 7+ | 7 |
| ----: | :----: | :----: | :----: | :----: | :----: | :----: |
| MobileNet | 16 | 18 | 19 | 33 | 43 | 35 |
| MobileNetV2 | 21 | 18 | 21 | 46 | 64 | 53 |
| MobileNetV2FP16 | 20 | 19 | 20 | 48 | 65 | 57 |
| MobileNetV2Int8LUT | 21 | 21 | 20 | 53 | 64 | 53 |
| Resnet50 | 27 | 25 | 26 | 61 | 78 | 63 |
| Resnet50FP16 | 26 | 26 | 27 | 64 | 75 | 74 |
| Resnet50Int8LUT | 27 | 25 | 26 | 60 | 77 | 75 |
| Resnet50Headless | 18 | 13 | 18 | 36 | 54 | 53 |
| SqueezeNet | 17 | 17 | 18 | 24 | 35 | 29 |
| SqueezeNetFP16 | 17 | 17 | 18 | 24 | 36 | 29 |
| SqueezeNetInt8LUT | 18 | 19 | 18 | 27 | 34 | 30 |

### Total Time (ms)

| Model vs. Device | XS | XS<br>Max | XR | X | 7+ | 7 |
| ----: | :----: | :----: | :----: | :----: | :----: | :----: |
| MobileNet | 18 | 20 | 21 | 35 | 46 | 37 |
| MobileNetV2 | 23 | 21 | 23 | 48 | 67 | 55 |
| MobileNetV2FP16 | 24 | 21 | 23 | 50 | 69 | 60 |
| MobileNetV2Int8LUT | 23 | 23 | 22 | 55 | 67 | 56 |
| Resnet50 | 30 | 28 | 29 | 64 | 82 | 66 |
| Resnet50FP16 | 28 | 28 | 30 | 66 | 78 | 76 |
| Resnet50Int8LUT | 29 | 28 | 28 | 63 | 80 | 78 |
| Resnet50Headless | 19 | 13 | 18 | 36 | 54 | 54 |
| SqueezeNet | 18 | 18 | 20 | 25 | 37 | 31 |
| SqueezeNetFP16 | 18 | 18 | 19 | 26 | 38 | 31 |
| SqueezeNetInt8LUT | 20 | 20 | 19 | 29 | 37 | 32 |

### FPS

| Model vs. Device | XS | XS<br>Max | XR | X | 7+ | 7 |
| ----: | :----: | :----: | :----: | :----: | :----: | :----: |
| MobileNet | 23 | 23 | 23 | 23 | 20 | 23 |
| MobileNetV2 | 23 | 23 | 23 | 20 | 13 | 17 |
| MobileNetV2FP16 | 23 | 23 | 23 | 18 | 13 | 15 |
| MobileNetV2Int8LUT | 23 | 23 | 23 | 16 | 13 | 16 |
| Resnet50 | 23 | 23 | 23 | 14 | 11 | 14 |
| Resnet50FP16 | 23 | 23 | 23 | 14 | 11 | 12 |
| Resnet50Int8LUT | 23 | 23 | 23 | 15 | 11 | 12 |
| Resnet50Headless | 23 | 23 | 23 | 23 | 16 | 17 |
| SqueezeNet | 23 | 23 | 23 | 23 | 23 | 23 |
| SqueezeNetFP16 | 23 | 23 | 23 | 23 | 22 | 23 |
| SqueezeNetInt8LUT | 23 | 23 | 23 | 23 | 23 | 23 |


## Build & Run

### 1. Prerequisites

#### 1.1 Import the Core ML model

![모델 불러오기.png](resource/%EB%AA%A8%EB%8D%B8%20%EB%B6%88%EB%9F%AC%EC%98%A4%EA%B8%B0.png)

Once you import the model, compiler generates model helper class on build path automatically. You can access the model through model helper class by creating an instance, not through build path.

#### 1.2 Add permission in info.plist for device's camera access

![prerequest_001_plist](resource/prerequest_001_plist.png)

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
typealias ClassificationModel = MobileNet
var coremlModel: ClassificationModel? = nil

// MARK: - Vision Properties
var request: VNCoreMLRequest?
var visionModel: VNCoreMLModel?
```

#### 3.3 Configure and prepare the model

```swift
override func viewDidLoad() {
    super.viewDidLoad()

	if let visionModel = try? VNCoreMLModel(for: ClassificationModel().model) {
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
