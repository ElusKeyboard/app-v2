
import Foundation

class OrderGroup {
	var id: Int?
	
	var table: Table?
	var table_id: Int!
	
	var cleared: Bool = false
	var cleared_when: NSDate?
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.table_id = res["table_id"] as! Int
		self.cleared = res["cleared"] as! Bool
		
		let date: Int? = res["cleared_when"] as? Int
		if date != nil {
			self.cleared_when = NSDate(timeIntervalSince1970: NSTimeInterval(date! / 1000))
		}
		
		for t in storage.tables {
			if t.id != nil && t.id! == self.table_id {
				self.table = t
				break
			}
		}
	}
	
	func json() -> [NSString: AnyObject] {
		var json: [NSString: AnyObject] = [:]
		
		if self.id != nil { json["id"] = self.id }
		json["table_id"] = self.table_id
		json["cleared"] = self.cleared
		if self.cleared_when != nil {
			json["cleared"] = self.cleared_when!.timeIntervalSince1970
		}
		
		return json
	}
	
	func getOrders(callback: (err: NSError?, orders: [Order]) -> Void) {
		doRequest(makeRequest("/order-group/" + String(self.id!) + "/orders", "GET"), { (statusCode, data) in
			if statusCode >= 400 {
				return callback(err: makeNetworkError("Cannot get orders", statusCode), orders: [])
			}
			
			var json: [[NSString: AnyObject]]? = data as? [[NSString: AnyObject]]
			var orders: [Order] = []
			if json != nil {
				for j in json! {
					var o: Order = Order(res: j)
					o.group = self
					orders.append(o)
				}
			}
			
			callback(err: nil, orders: orders)
		}, nil)
	}
	
	func addOrder(order: Order, callback: (err: NSError?) -> Void) {
		doPostRequest(makeRequest("/order-group/" + String(self.id!) + "/orders", "POST"), { (statusCode, data) in
			var json: [NSString: AnyObject]? = data as? [NSString: AnyObject]
			if json != nil {
				order.parse(json!)
			}
			
			callback(err: statusCode >= 400 ? makeNetworkError("Cannot add order", statusCode) : nil)
		}, order.json())
	}
}
