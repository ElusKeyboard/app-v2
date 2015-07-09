
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
		self.name = res["name"] as! String
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
		
		doPostRequest(makeRequest(url, self.id == nil ? "POST" : "PUT"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot save table type", statusCode))
			}
			
			var json: [NSString: AnyObject]? = data as? [NSString: AnyObject]
			if json != nil {
				self.parse(json!)
			}
			
			callback(err: nil)
		}, self.json())
	}
	
	func remove(callback: (err: NSError?) -> Void) {
		doRequest(makeRequest("/config/table-type/" + String(self.id!), "DELETE"), { (statusCode, data) in
			callback(err: statusCode >= 400 ? makeNetworkError("Cannot remove table type", statusCode) : nil)
		}, nil)
	}
	
	class func getAll(callback: (err: NSError?, list: [TableType]) -> Void) {
		doRequest(makeRequest("/config/table-types", "GET"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot get table types", statusCode), list: [])
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
