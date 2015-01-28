
import Foundation

class TableType {
	var id: Int? = nil
	var name: String = ""
	
	var tables: [Table] = []
	
	init(){}
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse (res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.name = res["name"] as String
	}
	
	func json() -> [NSObject: AnyObject] {
		var json: [NSObject: AnyObject] = [:]
		
		if self.id != nil { json["id"] = id }
		json["name"] = name
		
		return json
	}
	
	func save(callback: (err: NSError?) -> Void) {
		var url = "/config/table-types"
		if self.id != nil {
			url = "/config/table-type/" + String(self.id!)
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
		doRequest(makeRequest("/config/table-type/" + String(self.id!), "DELETE"), { (err: NSError?, data: AnyObject?) -> Void in
			callback(err: err)
		}, nil)
	}
	
	class func getAll(callback: (err: NSError?, list: [TableType]) -> Void) {
		doRequest(makeRequest("/config/table-types", "GET"), { (err: NSError?, data: AnyObject?) -> Void in
			if err != nil {
				return callback(err: err, list: [])
			}
			
			var json: [[NSString: AnyObject]]? = data as? [[NSString: AnyObject]]
			var lists: [TableType] = []
			if json != nil {
				for j in json! {
					lists.append(TableType(res: j))
				}
			}
			
			callback(err: nil, list: lists)
		}, nil)
	}
}
