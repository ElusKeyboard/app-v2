
import Foundation

class SortedTable {
	var type_name: String? = nil
	var type_id: Int? = nil
	var tables: [Table] = []
	
	init(_response: [NSString: AnyObject]) {
		self.type_name = _response["type_name"] as? String
		self.type_id = _response["type_id"] as? Int
		
		var tables: [[NSString: AnyObject]]? = _response["tables"] as? [[NSString: AnyObject]]
		
		if tables != nil {
			for table in tables! {
				self.tables.append(Table(_response: table))
			}
		}
	}
}

class Table {
	var id: Int = 0
	var name: String? = nil
	var table_number: String? = nil
	var location: String? = nil
	
	init(){}
	
	init(_response: [NSString: AnyObject]) {
		self.parse(_response)
	}
	
	func parse (_response: [NSString: AnyObject]) {
		self.id = _response["id"] as Int
		self.name = _response["name"] as? String
		self.table_number = _response["manager"] as? String
		self.location = _response["location"] as? String
	}
	
	func json() -> [NSObject: AnyObject] {
		var json: [NSObject: AnyObject] = [:]
		
		json["id"] = id
		if self.name != nil { json["name"] = name }
		if self.table_number != nil { json["table_number"] = self.table_number }
		if self.location != nil { json["location"] = location }
		
		return json
	}
	
	class func getTableList(callback: (err: NSError?, list: [SortedTable]) -> Void) {
		doRequest(makeRequest("/tables/sorted", "GET"), { (err: NSError?, data: AnyObject?) -> Void in
			if err != nil {
				return callback(err: err, list: [])
			}
			
			var json: [[NSString: AnyObject]]? = data as? [[NSString: AnyObject]]
			var lists: [SortedTable] = []
			if json != nil {
				for j in json! {
					lists.append(SortedTable(_response: j))
				}
			}
			
			callback(err: nil, list: lists)
		}, nil)
	}
}
