
import UIKit

let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
let versionNumber = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as NSString
let mainColour = UIColor(red: 0.203, green: 0.444, blue: 0.768, alpha: 1.0)

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		
		styleApplication()
		
		readSettings()
		checkLoggedIn()
		
		setRootVC()
		
		return true
	}
	
	func applicationWillResignActive(application: UIApplication) {
		saveSettings()
	}
	
	func applicationWillTerminate(application: UIApplication) {
		saveSettings()
	}
	
	func setRootVC() {
		var rootVC: UIViewController!
		
		if storage.server_ip == nil {
			rootVC = ManagerConfigVC(nibName: "ManagerConfigVC", bundle: nil)
		} else {
			rootVC = TablesVC(nibName: "TablesVC", bundle: nil)
			rootVC = UINavigationController(rootViewController: rootVC)
		}
		
		window!.rootViewController = rootVC
		window!.makeKeyAndVisible()
	}
	
	func styleApplication() {
		var sharedApplication = UIApplication.sharedApplication()
		sharedApplication.statusBarStyle = .LightContent
		
		if iOS8 {
			UINavigationBar.appearance().translucent = false
		}
		
		UINavigationBar.appearance().barTintColor = mainColour
		UINavigationBar.appearance().tintColor = UIColor.whiteColor()
		
		//var shadow = NSShadow()
		//shadow.shadowColor = UIColor.blackColor()
		//shadow.shadowOffset = CGSizeMake(-1, 0)
		
		var attributes: [NSObject: AnyObject] = [
			NSForegroundColorAttributeName: UIColor.whiteColor(),
		//	NSFontAttributeName: UIFont(name: "OCRAStd", size: 16)!
		]
		
		UINavigationBar.appearance().titleTextAttributes = attributes
		UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: UIControlState.Normal)
	}
	
	class func makeFontAwesomeTextAttributesOfFontSize(size: CGFloat) -> [NSObject: AnyObject] {
		return [
			NSFontAttributeName: UIFont(name: "FontAwesome", size: size)!
		] as [NSObject: AnyObject]
	}
}
