
import Foundation

class Category {
	var id: Int? = nil
	
	var name: String? = nil
	var description: String? = nil
	
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
	
	class func getCategories(callback: (err: NSError?, categories: [Category]) -> Void) {
		doRequest(makeRequest("/categories", "GET"), { (err: NSError?, data: AnyObject?) -> Void in
			if err != nil {
				return callback(err: err, categories: [])
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
