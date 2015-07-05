
import Foundation
import MapKit

let kISODateFormat = "YYYY-MM-dd\'T\'HH:mm:ss.SSS\'Z\'"
let kNetworkDomainError = "Invalid Response"

var storage: SharedStorage = SharedStorage()
var currentUser: User?
var sessionCookie: String?
var queueRequests: Bool = false
var queuedRequests: [Request] = []

class Request: NSObject {
	var request: NSMutableURLRequest
	var callback: (err: NSError?, data: AnyObject?) -> Void
	var body: NSData?
	
	init(request: NSMutableURLRequest, callback: (err: NSError?, data: AnyObject?) -> Void, body: NSData?) {
		self.request = request
		self.callback = callback
		self.body = body
		
		super.init()
	}
}

func makeRequest (endpoint: String, method: String?) -> NSMutableURLRequest {
	var base = "/api"
	if storage.server_ip != nil {
		base = storage.server_ip! + base
	} else {
		// so that NSURL unwrap doesn't crash the app
		base = "http://127.0.0.1:3000" + base
		
		println("storage -> server_ip property nil!")
	}
	
	var request = NSMutableURLRequest(URL: NSURL(string: base + endpoint)!)
	request.setValue("application/json", forHTTPHeaderField: "Accept")
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	if sessionCookie != nil {
		request.setValue(sessionCookie, forHTTPHeaderField: "Cookie")
	}
	
	request.HTTPShouldHandleCookies = true
	
	if method == nil {
		request.HTTPMethod = "GET"
	} else {
		request.HTTPMethod = method!
	}
	
	return request
}

func readSettings () -> Bool {
	var docDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
	
	var err: NSError?
	var contents = NSData(contentsOfFile: docDir + "/settings.json", options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
	
	if err != nil {
		return false
	}
	
	var settings: [String: AnyObject]? = NSJSONSerialization.JSONObjectWithData(contents!, options: NSJSONReadingOptions(0), error: &err) as? [String: AnyObject]
	if err != nil || settings == nil {
		return false
	}
	
	storage.venue_name = settings!["venue_name"] as? String
	storage.server_ip = settings!["server_ip"] as? String
	
	return true
}

func saveSettings () -> Bool {
	var settings: [String: AnyObject] = [:]
	settings["sessionCookie"] = sessionCookie
	settings["venue_name"] = storage.venue_name
	settings["server_ip"] = storage.server_ip
	
	var docDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
	
	var err: NSError?
	var jsonData = NSJSONSerialization.dataWithJSONObject(settings, options: NSJSONWritingOptions.allZeros, error: &err)
	
	if err != nil {
		return false
	}
	
	jsonData?.writeToFile(docDir + "/settings.json", options: NSDataWritingOptions.AtomicWrite, error: &err)
	if err != nil {
		return false
	}
	
	return true
}

func checkLoggedIn () {
	if currentUser != nil {
		queueRequests = false
		queueRequests = false // true
	}
}

func unqueueRequests() {
	for req in queuedRequests {
		if sessionCookie != nil {
			req.request.setValue(sessionCookie, forHTTPHeaderField: "Cookie")
		}
		
		doRequest(req.request, req.callback, req.body)
	}
	
	queuedRequests = []
}

func doPostRequest (request: NSMutableURLRequest, callback: (err: NSError?, data: AnyObject?) -> Void, body: [NSObject: AnyObject]) {
	var err: NSError?
	let data = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: &err)
	
	doRequest(request, callback, data)
}

func callInMainThread (err: NSError?, data: AnyObject?, callback: (err: NSError?, data: AnyObject?) -> Void) {
	dispatch_async(dispatch_get_main_queue(), { () -> Void in
		UIApplication.sharedApplication().networkActivityIndicatorVisible = false
		callback(err:err, data: data)
	})
}

func doRequest (request: NSMutableURLRequest, callback: (err: NSError?, data: AnyObject?) -> Void, body: NSData?) -> NSURLSessionDataTask? {
	if queueRequests {
		var req: Request! = Request(request: request, callback: callback, body: body)
		queuedRequests.append(req)
		
		return nil
	}
	
	if body != nil {
		request.HTTPBody = body
	}
	
	UIApplication.sharedApplication().networkActivityIndicatorVisible = true
	let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData!, res: NSURLResponse!, err) -> Void in
		if err != nil {
			callInMainThread(err, nil, callback)
			return
		}
		
		var httpRes = res as! NSHTTPURLResponse
		var cookie = httpRes.allHeaderFields["set-cookie"] as? String
		if cookie != nil {
			sessionCookie = cookie!.componentsSeparatedByString(";")[0] as String
		}
		
		var statusCode = httpRes.statusCode
		if statusCode >= 400 {
			callInMainThread(NSError(domain: kNetworkDomainError, code: 0, userInfo: nil), nil, callback)
			
			return
		}
		
		var jsonData: NSData = (NSString(data: data
			, encoding: NSUTF8StringEncoding)!).dataUsingEncoding(NSUTF8StringEncoding)!
		var e: NSError? = nil
		
		var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(0), error: &e)
		if e != nil {
			callInMainThread(err, nil, callback)
			
			return
		}
		
		callInMainThread(nil, json, callback)
	}
	
	task.resume()
	
	return task
}
