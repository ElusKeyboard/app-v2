
import Foundation

class OrderGroup {
	var id: Int? = nil
	var table_id: Int? = nil
	var cleared: Bool = false
	var cleared_when: NSDate? = nil
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.table_id = res["table_id"] as? Int
		self.cleared = res["cleared"] as Bool
		
		let date: Int? = res["cleared_when"] as? Int
		if date != nil {
			self.cleared_when = NSDate(timeIntervalSince1970: NSTimeInterval(date! / 1000))
		}
	}
	
	func json() -> [NSString: AnyObject] {
		var json: [NSString: AnyObject] = [:]
		
		if self.id != nil { json["id"] = self.id }
		if self.table_id != nil { json["table_id"] = self.table_id }
		json["cleared"] = self.cleared
		if self.cleared_when != nil {
			json["cleared"] = self.cleared_when!.timeIntervalSince1970
		}
		
		return json
	}
	
	func getOrders(callback: (err: NSError?, orders: [Order]) -> Void) {
		doRequest(makeRequest("/order-groups/" + String(self.id!) + "/orders", "GET"), { (err: NSError?, data: AnyObject?) -> Void in
			if err != nil {
				return callback(err: err, orders: [])
			}
			
			var json: [[NSString: AnyObject]]? = data as? [[NSString: AnyObject]]
			var orders: [Order] = []
			if json != nil {
				for j in json! {
					orders.append(Order(res: j))
				}
			}
			
			callback(err: nil, orders: orders)
		}, nil)
	}
}
