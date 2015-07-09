
import Foundation

class ConfigModifierGroup {
	var id: Int? = nil

	var name: String!
	var choiceRequired: Bool = false

	var modifiers: [ConfigModifier] = []

	init(){}
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	init(name: String, choiceRequired: Bool) {
		self.name = name
		self.choiceRequired = choiceRequired
	}

	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.name = res["name"] as! String
		self.choiceRequired = res["choice_required"] as! Bool
	}

	func json() -> [NSString: AnyObject] {
		var json: [NSString: AnyObject] = [:]

		if self.id != nil { json["id"] = self.id }
		json["name"] = self.name
		json["choice_required"] = self.choiceRequired

		return json
	}

	func save(callback: (err: NSError?) -> Void) {
		var url = "/config/modifiers"
		if self.id != nil {
			url = "/config/modifier/" + String(self.id!)
		}

		doPostRequest(makeRequest(url, self.id == nil ? "POST" : "PUT"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot save modifier", statusCode))
			}

			var json: [NSString: AnyObject]? = data as? [NSString: AnyObject]
			if json != nil {
				self.parse(json!)
			}

			callback(err: nil)
		}, self.json())
	}

	func remove(callback: (err: NSError?) -> Void) {
		doRequest(makeRequest("/config/modifier/" + String(self.id!), "DELETE"), { (statusCode, data) in
			callback(err: statusCode >= 400 ? makeNetworkError("Cannot remove modifier", statusCode) : nil)
		}, nil)
	}

	func getModifiers(callback: (err: NSError?) -> Void) {
		if self.id == nil {
			return callback(err: nil)
		}
		
		var request = makeRequest("/config/modifier/" + String(self.id!) + "/items", "GET")
		doRequest(request, { (statusCode, data) in
			self.modifiers = []
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot get modifiers", statusCode))
			}

			var json: [[NSString: AnyObject]]? = data as? [[NSString: AnyObject]]
			if json != nil {
				for j in json! {
					self.modifiers.append(ConfigModifier(res: j))
				}
			}

			callback(err: nil)
		}, nil)
	}
	
	class func getModifiers(callback: (err: NSError?, modifiers: [ConfigModifierGroup]) -> Void) {
		doRequest(makeRequest("/config/modifiers", "GET"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot get modifiers", statusCode), modifiers: [])
			}
			
			var json: [[NSString: AnyObject]]? = data as? [[NSString: AnyObject]]
			var modifiers: [ConfigModifierGroup] = []
			if json != nil {
				for j in json! {
					modifiers.append(ConfigModifierGroup(res: j))
				}
			}
			
			callback(err: nil, modifiers: modifiers)
		}, nil)
	}
}

class ConfigModifier {
	var id: Int? = nil
	
	var name: String! = ""
	var price: Float! = 0
	var group_id: Int!
	
	init(){}
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.name = res["name"] as! String
		self.price = res["price"] as! Float
		self.group_id = res["group_id"] as! Int
	}
	
	func json() -> [NSString: AnyObject] {
		var json: [NSString: AnyObject] = [:]
		
		if self.id != nil { json["id"] = self.id }
		json["name"] = self.name
		json["price"] = self.price
		json["group_id"] = self.group_id
		
		return json
	}
	
	func save(callback: (err: NSError?) -> Void) {
		var url = "/config/modifier/" + String(self.group_id) + "/items"
		if self.id != nil {
			url = "/config/modifier/" + String(self.group_id) + "/item/" + String(self.id!)
		}
		
		doPostRequest(makeRequest(url, self.id == nil ? "POST" : "PUT"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot save modifier", statusCode))
			}
			
			var json: [NSString: AnyObject]? = data as? [NSString: AnyObject]
			if json != nil {
				self.parse(json!)
			}
			
			callback(err: nil)
		}, self.json())
	}
	
	func remove(callback: (err: NSError?) -> Void) {
		doRequest(makeRequest("/config/modifier/" + String(self.group_id) + "/item/" + String(self.id!), "DELETE"), { (statusCode, data) in
			callback(err: statusCode >= 400 ? makeNetworkError("Cannot remove modifier", statusCode) : nil)
		}, nil)
	}
}
