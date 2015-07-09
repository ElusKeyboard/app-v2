
import Foundation

class Item {
	var id: Int? = nil
	
	var name: String = ""
	var description: String? = nil
	var price: Float = 0
	
	var category: Category! = nil
	var category_id: Int = 0
	
	var modifiers: [Int] = []
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.name = res["name"] as! String
		self.description = res["description"] as? String
		let price: Float? = res["price"] as? Float
		if price != nil {
			self.price = price!
		}
		
		self.category_id = res["category_id"] as! Int
	}
	
	func json() -> [NSString: AnyObject] {
		var json: [NSString: AnyObject] = [:]
		
		if self.id != nil { json["id"] = self.id }
		json["name"] = self.name
		if self.description != nil { json["description"] = self.description }
		json["price"] = self.price
		json["category_id"] = self.category_id
		
		return json
	}
	
	func save(callback: (err: NSError?) -> Void) {
		var url = "/items"
		if self.id != nil {
			url = "/item/" + String(self.id!)
		}
		
		doPostRequest(makeRequest(url, self.id == nil ? "POST" : "PUT"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot save item", statusCode))
			}
			
			var json: [NSString: AnyObject]? = data as? [NSString: AnyObject]
			if json != nil {
				self.parse(json!)
			}
			
			callback(err: nil)
		}, self.json())
	}
	
	func remove(callback: (err: NSError?) -> Void) {
		doRequest(makeRequest("/item/" + String(self.id!), "DELETE"), { (statusCode, data) in
			callback(err: statusCode >= 400 ? makeNetworkError("Cannot delete item", statusCode) : nil)
		}, nil)
	}
	
	func getModifiers(callback: (err: NSError?) -> Void) {
		doRequest(makeRequest("/item/" + String(self.id!) + "/modifiers", "GET"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot get modifiers for item", statusCode))
			}
			
			var json: [Int]? = data as? [Int]
			if json != nil {
				self.modifiers = json!
			}
			
			callback(err: nil)
		}, nil)
	}
	
	func setModifiers(callback: (err: NSError?) -> Void) {
		doRequest(makeRequest("/item/" + String(self.id!) + "/modifiers", "DELETE"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot set modifiers", statusCode))
			}
			
			var numCalled = 0
			var didErr: NSError? = nil
			for modifier in self.modifiers {
				doPostRequest(makeRequest("/item/" + String(self.id!) + "/modifiers", "POST"), { (statusCode, data) in
					if statusCode >= 400 {
						didErr = makeNetworkError("Cannot set modifier", statusCode)
					}
					
					if ++numCalled >= self.modifiers.count {
						callback(err: didErr)
					}
				}, ["modifier_group_id": modifier])
			}
			
			if self.modifiers.count == 0 {
				callback(err: nil)
			}
		}, nil)
	}
	
	class func getItems(callback: (err: NSError?, items: [Item]) -> Void) {
		doRequest(makeRequest("/items", "GET"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot get items", statusCode), items: [])
			}
			
			var json: [[NSString: AnyObject]]? = data as? [[NSString: AnyObject]]
			var items: [Item] = []
			if json != nil {
				for j in json! {
					var item = Item(res: j)
					item.getModifiers({ (err: NSError?) -> Void in
					})
					items.append(item)
				}
			}
			
			callback(err: nil, items: items)
		}, nil)
	}
}
