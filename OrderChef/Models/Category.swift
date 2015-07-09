
import Foundation

class Category {
	var id: Int? = nil
	
	var name: String? = nil
	var description: String? = nil
	
	var items: [Item] = []
	
	init(){}
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.name = res["name"] as? String
		self.description = res["description"] as? String
	}
	
	func json() -> [NSString: AnyObject] {
		var json: [NSString: AnyObject] = [:]
		
		if self.id != nil { json["id"] = self.id }
		if self.name != nil { json["name"] = self.name }
		if self.description != nil { json["description"] = self.description }
		
		return json
	}
	
	func save(callback: (err: NSError?) -> Void) {
		var url = "/categories"
		if self.id != nil {
			url = "/categories/" + String(self.id!)
		}
		
		doPostRequest(makeRequest(url, self.id == nil ? "POST" : "PUT"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot save category", statusCode))
			}
			
			var json: [NSString: AnyObject]? = data as? [NSString: AnyObject]
			if json != nil {
				self.parse(json!)
			}
			
			callback(err: nil)
		}, self.json())
	}
	
	func remove(callback: (err: NSError?) -> Void) {
		doRequest(makeRequest("/category/" + String(self.id!), "DELETE"), { (statusCode, data) in
			callback(err: statusCode >= 400 ? makeNetworkError("Cannot remove category", statusCode) : nil)
		}, nil)
	}
	
	class func getCategories(callback: (err: NSError?, categories: [Category]) -> Void) {
		doRequest(makeRequest("/categories", "GET"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot get categories", statusCode), categories: [])
			}
			
			var json: [[NSString: AnyObject]]? = data as? [[NSString: AnyObject]]
			var categories: [Category] = []
			if json != nil {
				for j in json! {
					categories.append(Category(res: j))
				}
			}
			
			callback(err: nil, categories: categories)
		}, nil)
	}
}
