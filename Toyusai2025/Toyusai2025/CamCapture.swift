//
//  CamCapture.swift
//  CameraTest
//
//  Created by ISHIGO Yusuke on 2025/05/15.
//

import UIKit
import AVFoundation
import CoreMedia

protocol CamCaptureDelegate: AnyObject
{
    func camCaptureDidCapture(image: UIImage)
    func camCaptureDidRecord(url: URL)
    func camCaptureDidOutputFrame(image: UIImage)
}

enum CamCaptureCaptureMode
{
    case photo
    case video
    case grayView
    case redView
    case greenView
    case blueView
}

class CamCapture: NSObject, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate
{
    private var captureSession: AVCaptureSession!
    
    private var dataOutput: AVCaptureOutput!
    
    private var videoConnection: AVCaptureConnection!

    var delegate: CamCaptureDelegate?
    
    private var isCapturing = false
    private(set) var isRecording = false
    
    var redThreshold: Float = 0.3
    var minRed: Float = 0.03
    
    var greenThreshold: Float = 0.3
    var minGreen: Float = 0.03
    
    var blueThreshold: Float = 0.3
    var minBlue: Float = 0.03

    
    private var _captureMode: CamCaptureCaptureMode = .photo
    var captureMode: CamCaptureCaptureMode {
        get {
            return _captureMode
        }
        set {
            _captureMode = newValue
            self.setupAVCapture(isFront: _isFront)
        }
    }
    
    private var _isFront = false
    var isFront : Bool {
        get {
            return _isFront
        }
        set {
            _isFront = newValue
            self.setupAVCapture(isFront: _isFront)
        }
    }
    
    private var _zoomFactor: CGFloat = 1.0
    var zoomFactor: CGFloat {
        get {
            return _zoomFactor
        }
        set {
            _zoomFactor = newValue
            self.setZoomFactor(factor: _zoomFactor)
        }
    }
    
    var flashMode: AVCaptureDevice.FlashMode = .off

    var _exposureAutoMode = false
    var exposureAutoMode: Bool {
        get {
            return _exposureAutoMode
        }
        set {
            _exposureAutoMode = newValue
            
            if (_exposureAutoMode)
            {
                self.resetExposureToAuto()
            }
        }
    }
    
    override init()
    {
        super.init()
        
        self.setupAVCapture(isFront: self.isFront)
    }
    
    deinit
    {
        self.disposeAVCapture()
    }
    
    /* -----------------------------------------------------
    * 初期化処理
    ------------------------------------------------------ */
    private func setupAVCapture(isFront: Bool)
    {
        self.disposeAVCapture()
        
        self.captureSession = AVCaptureSession()
        
        if let captureSession = self.captureSession
        {
            captureSession.beginConfiguration()
            
            captureSession.sessionPreset = .photo
            
            guard let input = self.captureDeviceInput(isFront: self.isFront) else
            {
                print("Failed: Get capture device input.")
                return
            }
            
            if (captureSession.canAddInput(input))
            {
                captureSession.addInput(input)
            }
            
            // 写真の場合
            if (self.captureMode == .photo)
            {
                self.dataOutput = self.capturePhotoOutput()
            }
            // 動画の場合
            else if (self.captureMode == .video)
            {
                self.dataOutput = self.captureVideoOutput()
            }
            
            else if (self.captureMode == .grayView)
            {
                let videoOutput = AVCaptureVideoDataOutput()
                videoOutput.videoSettings = [
                    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
                ]
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
                self.dataOutput = videoOutput
            }
            else if (self.captureMode == .redView)
            {
                let videoOutput = AVCaptureVideoDataOutput()
                videoOutput.videoSettings = [
                    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
                ]
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
                self.dataOutput = videoOutput
            }
            else if (self.captureMode == .greenView)
            {
                let videoOutput = AVCaptureVideoDataOutput()
                videoOutput.videoSettings = [
                    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
                ]
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
                self.dataOutput = videoOutput
            }
            else if (self.captureMode == .blueView)
            {
                let videoOutput = AVCaptureVideoDataOutput()
                videoOutput.videoSettings = [
                    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
                ]
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
                self.dataOutput = videoOutput
            }

            guard let dataOutput = self.dataOutput else
            {
                print("Failed: Get capture device output.")
                return
            }
            
            if (captureSession.canAddOutput(dataOutput))
            {
                captureSession.addOutput(dataOutput)
            }
            
            self.videoConnection = dataOutput.connection(with: .video)
            self.videoConnection.videoRotationAngle = 0
            
            captureSession.commitConfiguration()
            
            DispatchQueue.global(qos: .userInitiated).async
            {
                self.captureSession.startRunning()
            }
        }
    }
    
    /* -----------------------------------------------------
    * 終了処理
    ------------------------------------------------------ */
    private func disposeAVCapture()
    {
        self.isCapturing = false
        
        guard let captureSession = self.captureSession else { return }
        
        if (!self.captureSession.isRunning)
        {
            return
        }
        
        if (self.isRecording)
        {
            self.stopRecording()
        }

        DispatchQueue.global(qos: .userInitiated).sync {
            captureSession.stopRunning()
        }
        
        captureSession.beginConfiguration()
        
        for output in captureSession.outputs
        {
            captureSession.removeOutput(output)
        }
        
        for input in captureSession.inputs
        {
            captureSession.removeInput(input)
        }
        
        captureSession.commitConfiguration()
        
        self.dataOutput = nil
    }
    
    /* -----------------------------------------------------
    * プレビューレイヤーの取得
    ------------------------------------------------------ */
    func previewLayer(frame:CGRect) -> AVCaptureVideoPreviewLayer?
    {
        guard let captureSession = self.captureSession else { return nil }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.connection?.videoRotationAngle = 90
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = frame
        
        // フロントカメラの場合は反転する
        if (self.isFront)
        {
            previewLayer.setAffineTransform(CGAffineTransform(scaleX: -1.0, y: 1.0))
        }
        
        return previewLayer
    }
    
    /* -----------------------------------------------------
    * 静止画の撮影
    ------------------------------------------------------ */
    func capture()
    {
        guard let dataOutput = self.dataOutput as? AVCapturePhotoOutput else { return }

        if (self.isCapturing) { return }
        if (self.captureMode != .photo) { return }

        self.isCapturing = true
        
        let settings = AVCapturePhotoSettings()
        
        if (dataOutput.supportedFlashModes.contains(.on))
        {
            settings.flashMode = self.flashMode
        }
        
        dataOutput.capturePhoto(with: settings, delegate: self)
    }
    
    /* -----------------------------------------------------
    * 動画の録画開始
    ------------------------------------------------------ */
    func startRecording(url:URL)
    {
        guard let dataOutput = self.dataOutput as? AVCaptureMovieFileOutput else { return }
        if (self.isRecording) { return }
        if (self.captureMode != .video) { return }
        
        dataOutput.startRecording(to: url, recordingDelegate: self)
        
        self.isRecording = true
    }
    
    /* -----------------------------------------------------
    * 動画の録画終了
    ------------------------------------------------------ */
    func stopRecording()
    {
        guard let dataOutput = self.dataOutput as? AVCaptureMovieFileOutput else { return }
        if (!self.isRecording) { return }
        if (self.captureMode != .video) { return }

        dataOutput.stopRecording()
    }
    
    /* -----------------------------------------------------
    * 露出の変更
    ------------------------------------------------------ */
    func setExposure(iso:Float, duration:CMTime)
    {
        guard let deviceInput = self.captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        
        let device = deviceInput.device
        
        let minISO = device.activeFormat.minISO
        let maxISO = device.activeFormat.maxISO
        
        do {
            try device.lockForConfiguration()
            device.setExposureModeCustom(duration: duration, iso: max(minISO, min(iso, maxISO)))
            device.unlockForConfiguration()
        }
        catch {
            print("Failed: setExposure")
        }
    }
    
    /* -----------------------------------------------------
    * ズームの変更
    ------------------------------------------------------ */
    func setZoomFactor(factor: CGFloat)
    {
        guard let deviceInput = self.captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        
        let device = deviceInput.device
        
        do {
            try device.lockForConfiguration()
            
            let zoom = max(1.0, min(factor, device.activeFormat.videoMaxZoomFactor))
            device.videoZoomFactor = zoom
            
            device.unlockForConfiguration()
        }
        catch {
            print("Failed: setZoomFactor")
        }
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?)
    {
        guard let imageData = photo.fileDataRepresentation() else
        {
            self.isCapturing = false
            return
        }
        
        if let img = UIImage(data: imageData)
        {
            self.delegate?.camCaptureDidCapture(image: img)
        }
        
        self.isCapturing = false
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?)
    {
        self.delegate?.camCaptureDidRecord(url: outputFileURL)
        
        self.isRecording = false
    }

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        // CMSampleBuffer → CIImage
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

        var processedImage: CIImage = ciImage


        if self.captureMode == .grayView{
            if let filter = CIFilter(name: "CIColorControls") {
                filter.setValue(ciImage, forKey: kCIInputImageKey)
                filter.setValue(0.0, forKey: kCIInputSaturationKey)
                processedImage = filter.outputImage ?? ciImage
            }
        }

        else if self.captureMode == .redView {
            let kernelString = """
            kernel vec4 isolateColor(__sample image) {
                float colorScore = image.r - max(image.g, image.b);
                if (colorScore > \(redThreshold) && image.r > \(minRed)) {
                    return image;
                }
                float gray = (image.r + image.g + image.b) / 3.0;
                return vec4(gray, gray, gray, 1.0);
            }
            """

            if let kernel = CIColorKernel(source: kernelString), let output = kernel.apply(extent: ciImage.extent, arguments: [ciImage])
            {
                processedImage = output
            }
        }
        
        else if self.captureMode == .greenView {
            let kernelString = """
            kernel vec4 isolateColor(__sample image) {
                float colorScore = image.g - max(image.r, image.b);
                if (colorScore > \(greenThreshold) && image.g > \(minGreen)) {
                    return image;
                }
                float gray = (image.r + image.g + image.b) / 3.0;
                return vec4(gray, gray, gray, 1.0);
            }
            """

            if let kernel = CIColorKernel(source: kernelString), let output = kernel.apply(extent: ciImage.extent, arguments: [ciImage])
            {
                processedImage = output
            }
        }
        
        else if self.captureMode == .blueView {
            let kernelString = """
            kernel vec4 isolateColor(__sample image) {
                float colorScore = image.b - max(image.r, image.g);
                if (colorScore > \(blueThreshold) && image.b > \(minBlue)) {
                    return image;
                }
                float gray = (image.r + image.g + image.b) / 3.0;
                return vec4(gray, gray, gray, 1.0);
            }
            """

            if let kernel = CIColorKernel(source: kernelString), let output = kernel.apply(extent: ciImage.extent, arguments: [ciImage])
            {
                processedImage = output
            }
        }

        // UIImage に変換して delegate に送信
        DispatchQueue.main.async
        {
            self.delegate?.camCaptureDidOutputFrame(image: UIImage(ciImage: processedImage))
        }
    }


    
    private func resetExposureToAuto()
    {
        guard let deviceInput = self.captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        
        let device = deviceInput.device
        
        do {
            try device.lockForConfiguration()
            device.exposureMode = .continuousAutoExposure
            device.unlockForConfiguration()
        }
        catch {
            print("Failed: resetExposureToAuto")
        }
    }
    
    private func captureDeviceInput(isFront: Bool) -> AVCaptureDeviceInput?
    {
        let position = self.isFront ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back

        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                          for: .video,
                                                          position: position) else
        {
            print("ERROR: Missing camera.")
            return nil
        }
        
        let deviceInut = try? AVCaptureDeviceInput(device: captureDevice)
        return deviceInut
    }
    
    private func capturePhotoOutput() -> AVCapturePhotoOutput?
    {
        let dataOutput = AVCapturePhotoOutput()
        
        return dataOutput
    }
    
    private func captureVideoOutput() -> AVCaptureMovieFileOutput?
    {
        let videoDataOutput = AVCaptureMovieFileOutput()
        
        return videoDataOutput
    }
}
