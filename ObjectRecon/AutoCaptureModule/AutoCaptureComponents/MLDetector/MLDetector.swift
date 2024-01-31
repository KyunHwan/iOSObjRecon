//
//  MLDetector.swift
//  ObjectRecon
//
//  Created by Kyun Hwan  Kim on 1/29/24.
//

import SwiftUI
import Foundation
import Vision
import AVFoundation

class MLDetector {
    private var detectionOverlay: CALayer
    let rootLayer: CALayer
    
    private var requests = [VNRequest]()
    private var teethBox = CGRect()
    private var teethBoxConfidence: Float = 0.0
    private var teethConfidenceThreshold: Float = 0.8
    
    init() {}
    
    func initDetectionLayer() {
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        rootLayer.addSublayer(detectionOverlay)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
             
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    @discardableResult
    private func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "UpperTeethDetector", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        self.drawVisionRequestResults(results)
                    }
                })
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    private func drawVisionRequestResults(_ results: [Any]) {
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        let rootLayerBounds = rootLayer.bounds
        detectionOverlay.sublayers = nil // remove all the old recognized objects
        
        if results.isEmpty {
            self.teethBox = CGRect()
            self.teethBoxConfidence = 0.0
        }
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            let teethBox = objectObservation.boundingBox // normalized box !
            self.teethBox = teethBox
            self.teethBoxConfidence = objectObservation.confidence
            
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            
            let boundsWidth = rootLayerBounds.size.width
            let boundsHeight = rootLayerBounds.size.height
            
            let objectBounds = CGRect(x: teethBox.minX * boundsWidth,
                                      y: (1 - teethBox.minY - teethBox.height) * boundsHeight,
                                      width: teethBox.width * boundsWidth,
                                      height: teethBox.height * boundsHeight)
            
            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
            
            detectionOverlay.addSublayer(shapeLayer)
        }
        
        detectionOverlay.bounds = CGRect(x: 0.0, y: 0.0, width: rootLayerBounds.size.width, height: rootLayerBounds.size.height)
        detectionOverlay.position = CGPoint(x: rootLayerBounds.midX, y: rootLayerBounds.midY) // center the layer
        
        CATransaction.commit()
    }
    
    private func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
        shapeLayer.borderWidth = 2
        shapeLayer.borderColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
}
