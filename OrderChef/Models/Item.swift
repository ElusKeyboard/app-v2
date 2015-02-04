
import Foundation

class Item {
	var id: Int? = nil
	
	var name: String = ""
	var description: String? = nil
	var price: Float = 0
	
	var category: Category! = nil
	var category_id: Int = 0
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.name = res["name"] as String
		self.description = res["description"] as? String
		let price: Float? = res["price"] as? Float
		if price != nil {
			self.price = price!
		}
		
		self.category_id = res["category_id"] as Int
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
		
		doPostRequest(makeRequest(url, self.id == nil ? "POST" : "PUT"), { (err: NSError?, data: AnyObject?) -> Void in
			if err != nil {
				return callback(err: err)
			}
			
			var json: [NSString: AnyObject]? = data as? [NSString: AnyObject]
			if json != nil {
				self.parse(json!)
			}
			
			callback(err: nil)
		}, self.json())
	}
	
	func remove(callback: (err: NSError?) -> Void) {
		doRequest(makeRequest("/item/" + String(self.id!), "DELETE"), { (err: NSError?, data: AnyObject?) -> Void in
			callback(err: err)
		}, nil)
	}
	
	class func getItems(callback: (err: NSError?, items: [Item]) -> Void) {
		doRequest(makeRequest("/items", "GET"), { (err: NSError?, data: AnyObject?) -> Void in
			if err != nil {
				return callback(err: err, items: [])
			}
			
			var json: [[NSString: AnyObject]]? = data as? [[NSString: AnyObject]]
			var items: [Item] = []
			if json != nil {
				for j in json! {
					items.append(Item(res: j))
				}
			}
			
			callback(err: nil, items: items)
		}, nil)
	}
}
