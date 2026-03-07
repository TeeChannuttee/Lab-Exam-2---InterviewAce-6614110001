import Flutter
import UIKit

/// Legacy image picker that uses UIImagePickerController instead of PHPicker
/// PHPicker (iOS 14+) is broken on iOS Simulator — opens but doesn't register taps
/// UIImagePickerController works perfectly on both Simulator and real devices
class LegacyImagePickerPlugin: NSObject, FlutterPlugin, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var pendingResult: FlutterResult?
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.interviewace/legacy_image_picker", binaryMessenger: registrar.messenger())
        let instance = LegacyImagePickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "pickImageFromGallery" {
            pickImage(result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func pickImage(result: @escaping FlutterResult) {
        pendingResult = result
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            result(FlutterError(code: "UNAVAILABLE", message: "Photo library not available", details: nil))
            return
        }
        
        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.mediaTypes = ["public.image"]
            
            guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
                result(FlutterError(code: "NO_VC", message: "No view controller", details: nil))
                return
            }
            
            // Find top-most presented VC
            var topVC = viewController
            while let presented = topVC.presentedViewController {
                topVC = presented
            }
            
            topVC.present(picker, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let imageUrl = info[.imageURL] as? URL {
                self.pendingResult?(imageUrl.path)
            } else if let image = info[.originalImage] as? UIImage {
                // Save to temp file
                let tempDir = NSTemporaryDirectory()
                let fileName = "picked_image_\(Int(Date().timeIntervalSince1970)).jpg"
                let filePath = (tempDir as NSString).appendingPathComponent(fileName)
                if let data = image.jpegData(compressionQuality: 0.9) {
                    try? data.write(to: URL(fileURLWithPath: filePath))
                    self.pendingResult?(filePath)
                } else {
                    self.pendingResult?(FlutterError(code: "SAVE_FAILED", message: "Could not save image", details: nil))
                }
            } else {
                self.pendingResult?(nil)
            }
            self.pendingResult = nil
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.pendingResult?(nil)
            self.pendingResult = nil
        }
    }
}
