import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Register legacy image picker (UIImagePickerController) for Simulator compatibility
    LegacyImagePickerPlugin.register(with: self.registrar(forPlugin: "LegacyImagePickerPlugin")!)
    
    // Disable state restoration to prevent SIGABRT crash on iOS Simulator
    // The crash occurs in +[FlutterSharedApplication lastAppModificationTime]
    // when the app enters background and UIKit tries to save state
    #if targetEnvironment(simulator)
    UIApplication.shared.ignoreSnapshotOnNextApplicationLaunch()
    #endif
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Override BOTH secure and non-secure versions to prevent state restoration crash
  override func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
    return false
  }

  override func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
    return false
  }

  // Also handle the app entering background to prevent the crash
  override func applicationDidEnterBackground(_ application: UIApplication) {
    // Do NOT call super - this prevents FlutterAppDelegate from triggering
    // state restoration which crashes on Simulator with SIGABRT
  }
  
  override func applicationWillResignActive(_ application: UIApplication) {
    // Do NOT call super to prevent state save attempt
  }
}
