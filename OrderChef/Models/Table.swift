
import Foundation

class SortedTable {
	var type_name: String? = nil
	var type_id: Int? = nil
	var tables: [Table] = []
	
	init(res: [NSString: AnyObject]) {
		self.type_name = res["type_name"] as? String
		self.type_id = res["type_id"] as? Int
		
		var tables: [[NSString: AnyObject]]? = res["tables"] as? [[NSString: AnyObject]]
		
		if tables != nil {
			for table in tables! {
				self.tables.append(Table(res: table))
			}
		}
	}
}

class Table {
	var id: Int? = nil
	var name: String? = nil
	var table_number: String? = nil
	var location: String? = nil
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse (res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.name = res["name"] as? String
		self.table_number = res["manager"] as? String
		self.location = res["location"] as? String
	}
	
	func json() -> [NSObject: AnyObject] {
		var json: [NSObject: AnyObject] = [:]
		
		if self.id != nil { json["id"] = id }
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
					lists.append(SortedTable(res: j))
				}
			}
			
			callback(err: nil, list: lists)
		}, nil)
	}
	
	func getGroup(callback: (err: NSError?, group: OrderGroup?) -> Void) {
		doRequest(makeRequest("/tables/" + String(self.id!) + "/group", "GET"), { (err: NSError?, data: AnyObject?) -> Void in
			if err != nil {
				return callback(err: err, group: nil)
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
