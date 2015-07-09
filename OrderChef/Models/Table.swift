
import Foundation

class Table {
	var id: Int?
	var name: String = ""
	var table_number: String?
	var location: String?
	var table_type_id: Int = 0
	var table_type: TableType?
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse (res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.name = res["name"] as! String
		self.table_number = res["table_number"] as? String
		self.location = res["location"] as? String
		self.table_type_id = res["type_id"] as! Int
	}
	
	func json() -> [NSObject: AnyObject] {
		var json: [NSObject: AnyObject] = [:]
		
		if self.id != nil { json["id"] = self.id }
		json["name"] = self.name
		if self.table_number != nil { json["table_number"] = self.table_number }
		if self.location != nil { json["location"] = self.location }
		json["type_id"] = self.table_type_id
		
		return json
	}
	
	func save(callback: (err: NSError?) -> Void) {
		var url = "/tables"
		if self.id != nil {
			url = "/table/" + String(self.id!)
		}
		
		doPostRequest(makeRequest(url, self.id == nil ? "POST" : "PUT"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot save table", statusCode))
			}
			
			var json: [NSString: AnyObject]? = data as? [NSString: AnyObject]
			if json != nil {
				self.parse(json!)
			}
			
			callback(err: nil)
		}, self.json())
	}
	
	func remove(callback: (err: NSError?) -> Void) {
		doRequest(makeRequest("/table/" + String(self.id!), "DELETE"), { (statusCode, data) in
			callback(err: statusCode >= 400 ? makeNetworkError("Cannot remove table", statusCode) : nil)
		}, nil)
	}
	
	class func getAll(callback: (err: NSError?, list: [Table]) -> Void) {
		doRequest(makeRequest("/tables", "GET"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot get tables", statusCode), list: [])
			}
			
			var json: [[NSString: AnyObject]]? = data as? [[NSString: AnyObject]]
			var list: [Table] = []
			if json != nil {
				for j in json! {
					list.append(Table(res: j))
				}
			}
			
			callback(err: nil, list: list)
		}, nil)
	}
	
	func getGroup(callback: (err: NSError?, group: OrderGroup?) -> Void) {
		doRequest(makeRequest("/table/" + String(self.id!) + "/group", "GET"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot get group for table", statusCode), group: nil)
			}
			
			var json: [NSString: AnyObject]? = data as? [NSString: AnyObject]
			var group: OrderGroup? = nil
			if json != nil {
				group = OrderGroup(res: json!)
			}
			
			callback(err: nil, group: group)
		}, nil)
	}
}
