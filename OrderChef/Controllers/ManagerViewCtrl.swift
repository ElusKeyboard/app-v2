class ManagerViewCtrl: WebViewCtrl {
	override func viewDidLoad() {
		if storage.server_ip != nil {
			super.urlToLoad = NSURL(string: storage.server_ip! + "/public/html/admin")
			println(storage.server_ip! + "/public/html/admin")
		}
		
		super.viewDidLoad()
		
		self.navigationItem.title = "Manager"
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " " + NSString.fontAwesomeIconStringForEnum(FAIcon.FATimes), style: UIBarButtonItemStyle.Plain, target: self, action: "closeView")
		self.navigationItem.leftBarButtonItem!.setTitleTextAttributes(AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20), forState: UIControlState.Normal)
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Core Settings", style: UIBarButtonItemStyle.Plain, target: self, action: "openConfig")
	}
	
	func closeView() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func openConfig() {
		self.navigationController!.pushViewController(MConfigViewCtrl(nibName: groupedTableNibName, bundle: nil), animated: true)
	}
}