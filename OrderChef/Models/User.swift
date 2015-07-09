
import Foundation

class User {
	var id: Int? = nil
	var name: String = ""
	var manager: Bool = false
	var passkey: NSString = "0000"
	var last_login: NSDate? = nil
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse (res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.name = res["name"] as! String
		self.manager = res["manager"] as! Bool
		
		let date: Int? = res["last_login"] as? Int
		if date != nil {
			self.last_login = NSDate(timeIntervalSince1970: NSTimeInterval(date! / 1000))
		}
	}
	
	class func find(_id: NSString, callback: (user: User?) -> Void) {
		doRequest(makeRequest("/user/" + (_id as String), nil), { (statusCode, data) in
			var json: [NSString: AnyObject] = data as! [NSString: AnyObject]
			var user = User(res: json)
			callback(user: user)
		}, nil)
	}
	
	func json() -> [NSObject: AnyObject] {
		var json: [NSObject: AnyObject] = [:]
		
		json["name"] = name
		if self.id != nil { json["id"] = self.id }
		json["manager"] = manager

		if self.last_login != nil {
			json["last_login"] = last_login!.timeIntervalSince1970 * 1000
		}
		
		return json
	}
}
