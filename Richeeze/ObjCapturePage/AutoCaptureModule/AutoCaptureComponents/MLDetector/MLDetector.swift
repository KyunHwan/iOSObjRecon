//
//  MLDetector.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/29/24.
//

import SwiftUI
import Foundation
import Vision

class MLDetector {
    private(set) var rootLayer: CALayer?
    private var detectionOverlay: CALayer
    
    private(set) var mlRequests: [VNRequest]
    @Published private(set) var objBoundingBox: CGRect
    @Published private(set) var detectionConfidence: Float
    
    init() {
        mlRequests = [VNRequest]()
        objBoundingBox = CGRect()
        detectionConfidence = 0.0
        
        self.rootLayer = nil
        self.detectionOverlay = CALayer()
    }
    
    static func createImageRequestHandler(cvPixelBuffer: CVPixelBuffer,
                                   orientation: CGImagePropertyOrientation,
                                   options: [VNImageOption : Any]) -> VNImageRequestHandler {
        VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, orientation: orientation, options: options)
    }
    
    func initRootLayer(with rootLayer: CALayer) {
        self.rootLayer = rootLayer
    }
    
    func startDetectionSession() {
        if let rootLayer = self.rootLayer {
            rootLayer.addSublayer(detectionOverlay)
        }
        setupVision()
    }
}

// MARK: Inference Helper Functions
extension MLDetector {
    /// Setup image processing procedure
    @discardableResult
    private func setupVision() -> NSError? {
        
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: MLDetectorConstants.modelFileName,
                                             withExtension: MLDetectorConstants.modelFileExtension) else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        self.drawVisionRequestResults(results)
                    }
                }
            })
            self.mlRequests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    /// Draw bounding boxes inside results
    private func drawVisionRequestResults(_ results: [Any]) {
        if let rootLayer = self.rootLayer {
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            
            let rootLayerBounds = rootLayer.bounds
            detectionOverlay.sublayers = nil // remove all the old recognized objects
            
            if results.isEmpty {
                self.objBoundingBox = CGRect()
                self.detectionConfidence = 0.0
            }
            else {
                for observation in results where observation is VNRecognizedObjectObservation {
                    guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                        continue
                    }
                    self.objBoundingBox = objectObservation.boundingBox // normalized box !
                    self.detectionConfidence = objectObservation.confidence
                    
                    let boundsWidth = rootLayerBounds.size.width
                    let boundsHeight = rootLayerBounds.size.height
                    
                    let objectBounds = CGRect(x: self.objBoundingBox.minX * boundsWidth,
                                              y: (1 - self.objBoundingBox.minY - self.objBoundingBox.height) * boundsHeight,
                                              width: self.objBoundingBox.width * boundsWidth,
                                              height: self.objBoundingBox.height * boundsHeight)
                    
                    let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
                    
                    detectionOverlay.addSublayer(shapeLayer)
                }
                
                detectionOverlay.bounds = CGRect(x: 0.0, y: 0.0, width: rootLayerBounds.size.width, height: rootLayerBounds.size.height)
                detectionOverlay.position = CGPoint(x: rootLayerBounds.midX, y: rootLayerBounds.midY) // center the layer
            }
            CATransaction.commit()
        }
        else {
            print("rootLayer is NIL!!!!")
        }
    }
    
    /// Bounding box drawing helper
    private func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = MLDetectorConstants.boundingBoxName
        shapeLayer.borderWidth = MLDetectorConstants.boundingBoxBorderWidth
        shapeLayer.borderColor = MLDetectorConstants.boundingBoxBorderColor
        shapeLayer.cornerRadius = MLDetectorConstants.cornerRadius
        return shapeLayer
    }
}

private struct MLDetectorConstants {
    // MARK: Detector
    static let modelFileName: String = "UpperTeethDetector"
    static let modelFileExtension: String = "mlmodelc"
    
    // MARK: Bounding Box Constants
    static let boundingBoxName: String = "Found Object"
    static let boundingBoxBorderWidth: CGFloat = 2
    static let boundingBoxBorderColor: CGColor? = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
    static let cornerRadius: CGFloat = 7
}
