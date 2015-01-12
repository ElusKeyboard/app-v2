
import UIKit

let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		
		styleApplication()
		
		readSettings()
		checkLoggedIn()
		
//		var rootVC = SetupVC(nibName: "SetupVC", bundle: nil)
		var rootVC = TablesVC(nibName: "TablesVC", bundle: nil)
		var navVC = UINavigationController(rootViewController: rootVC)
		
		window!.rootViewController = navVC
		window!.makeKeyAndVisible()
		
		return true
	}
	
	func applicationWillResignActive(application: UIApplication) {
		saveSettings()
	}
	
	func applicationWillTerminate(application: UIApplication) {
		saveSettings()
	}
	
	func styleApplication() {
		var sharedApplication = UIApplication.sharedApplication()
		sharedApplication.statusBarStyle = .LightContent
		
		if iOS8 {
			UINavigationBar.appearance().translucent = false
		}
		
		UINavigationBar.appearance().barTintColor = UIColor(red: 207/255, green: 0, blue: 20/255, alpha: 0.0)
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
