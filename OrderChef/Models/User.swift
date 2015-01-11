
import Foundation

class User {
	var id: Int = 0
	var name: String = ""
	var manager: Bool = false
	var passkey: NSString = "0000"
	var last_login: NSDate? = nil
	
	init(){}
	
	init(_response: [NSString: AnyObject]) {
		self.parse(_response)
	}
	
	func parse (_response: [NSString: AnyObject]) {
		self.id = _response["id"] as Int
		self.name = _response["name"] as String
		self.manager = _response["manager"] as Bool
		
		let date: Int? = _response["last_login"] as? Int
		if date != nil {
			self.last_login = NSDate(timeIntervalSince1970: NSTimeInterval(date! / 1000))
		}
	}
	
	class func find(_id: NSString, callback: (user: User?) -> Void) {
		doRequest(makeRequest("/user/"+_id, nil), { (err: NSError?, data: AnyObject?) -> Void in
			var json: [NSString: AnyObject] = data as [NSString: AnyObject]
			var user = User(_response: json)
			callback(user: user)
		}, nil)
	}
	
	func json() -> [NSObject: AnyObject] {
		var json: [NSObject: AnyObject] = [:]
		
		json["name"] = name
		json["id"] = id
		json["manager"] = manager
		json["passkey"] = passkey
		if self.last_login != nil {
			json["last_login"] = last_login!.timeIntervalSince1970 * 1000
		}
		
		return json
	}
}
