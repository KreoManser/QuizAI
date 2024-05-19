import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	var wasPlaying = Bool()
	private let blurView = UIVisualEffectView(frame: UIScreen.main.bounds)

	enum ShortcutItemType: String {
		case QRCode
	}
	
	static var windowReference: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		
		if #available(iOS 13, *) {}
		else {
			let sideVolumeTheme: SideVolumeHUD.Option.Theme = UserDefaultsManager.darkThemeSwitchIsOn ? .dark : .light
			SideVolumeHUD.shared.setup(withOptions: [.animationStyle(.slideLeftRight), .theme(sideVolumeTheme)])
		}
		
		self.setupURLCache()
		self.loadConfigFiles()
		self.preferLargeTitles()
		self.setupAppShorcuts(for: application)
		self.setupPrivacyFeatures()
		
		return true
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		guard QuestionsAppOptions.privacyFeaturesEnabled else { return }
		self.blurView.isHidden = false
		self.window?.bringSubviewToFront(blurView)
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		
		if self.wasPlaying {
			AudioSounds.bgMusic?.play()
		}
		
		self.window?.dontInvertIfDarkModeIsEnabled()
		
		if QuestionsAppOptions.privacyFeaturesEnabled {
			self.blurView.isHidden = true
		}
	}
	
	@available(iOS 9.0, *)
	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		
		if let itemType = ShortcutItemType(rawValue: shortcutItem.type) {
		
			switch itemType {
			
			case .QRCode:
				
				if let questionsVC = window?.rootViewController?.presentedViewController as? QuestionsViewController {
					questionsVC.performSegue(withIdentifier: "unwindToMainMenu", sender: self)
				}

                if (window?.rootViewController == nil) {
					
					let storyboard = UIStoryboard(name: "Main", bundle: nil)
					if let viewController = storyboard.instantiateViewController(withIdentifier: "mainViewController") as? MainViewController {
						
						let navController = UINavigationController(rootViewController: viewController)
						if #available(iOS 13.0, *) {
							navController.navigationBar.prefersLargeTitles = true
						}
						
						window?.rootViewController?.present(navController, animated: false)
						
						viewController.performSegue(withIdentifier: "QRScannerVC", sender: self)
					}
				}
			}
		}
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		
		if AudioSounds.bgMusic?.isPlaying ?? false {
			AudioSounds.bgMusic?.pause()
			wasPlaying = true
		}
		else {
			wasPlaying = false
		}
		
		guard DataStoreArchiver.shared.save() else { print("Error saving settings"); return }
		
		self.window?.dontInvertIfDarkModeIsEnabled()
	}
	
	// - MARK: Convenience
	
	private func setupURLCache() {
		URLCache.shared.diskCapacity = 150 * 1024 * 1024
		URLSession.shared.configuration.requestCachePolicy = .returnCacheDataElseLoad
	}

	private func loadConfigFiles() {
		if #available(iOS 11, *) {
			if let settingsData = try? Data(contentsOf: URL(fileURLWithPath: DataStoreArchiver.path)),
				let mySettings = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(settingsData) as? DataStoreArchiver {
				DataStoreArchiver.shared = mySettings
			}
		} else {
			if let mySettings = NSKeyedUnarchiver.unarchiveObject(withFile: DataStoreArchiver.path) as? DataStoreArchiver {
				DataStoreArchiver.shared = mySettings
			}
		}
	}
	
	private func preferLargeTitles() {
		let navController = window?.rootViewController as? UINavigationController
		if #available(iOS 13.0, *) {
			navController?.navigationBar.prefersLargeTitles = true
		}
	}
	
	private func setupAppShorcuts(for application: UIApplication) {
        let readQRCode = UIMutableApplicationShortcutItem(type: ShortcutItemType.QRCode.rawValue,
            localizedTitle: L10n.HomeQuickActions_ScanQR,
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(templateImageName: "QRCodeIcon")
        )
		application.shortcutItems = [readQRCode]
	}
	
	private func setupWindow() {
		AppDelegate.windowReference = self.window
		self.window?.dontInvertIfDarkModeIsEnabled()
	}
	
	private func setupPrivacyFeatures() {
		if QuestionsAppOptions.privacyFeaturesEnabled {
			self.setupBlurView()
		}
	}
	
	private func setupBlurView() {
		self.blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.blurView.effect = UserDefaultsManager.darkThemeSwitchIsOn ? UIBlurEffect(style: .dark) : UIBlurEffect(style: .light)
		self.blurView.isHidden = true
		self.window?.addSubview(blurView)
	}
}
