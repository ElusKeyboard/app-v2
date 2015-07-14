import WebKit

class WebViewCtrl: UIViewController, WKNavigationDelegate {
	var webView: WKWebView!
	var displayProgress = true
	var urlToLoad: NSURL?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.webView = WKWebView()
		self.webView.opaque = false
		self.webView.backgroundColor = UIColor.clearColor()
		self.webView.scrollView.indicatorStyle = .White
		
		self.view.addSubview(self.webView)
		
		if self.urlToLoad != nil {
			self.webView.loadRequest(NSURLRequest(URL: self.urlToLoad!))
		}
		
		SVProgressHUD.showProgress(0.0, status: "Loading..")
	}
	
	func updateProgress() {
		if self.webView.loading == false || self.displayProgress == false {
			SVProgressHUD.dismiss()
			return
		}
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(50 * NSEC_PER_MSEC)), dispatch_get_main_queue()) { () -> Void in
			SVProgressHUD.showProgress(Float(self.webView.estimatedProgress), status: "Loading..")
			self.updateProgress()
			
			return
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.displayProgress = true
		self.webView.navigationDelegate = self
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.webView.stopLoading()
		
		self.displayProgress = false
		self.webView.navigationDelegate = nil
		SVProgressHUD.dismiss()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		self.webView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)
	}
	
	// MARK: WKNavigationDelegate
	
	func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		self.updateProgress()
	}
	
	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		SVProgressHUD.dismiss()
	}
}