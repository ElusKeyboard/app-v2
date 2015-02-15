
import Foundation

class OrderItem {
	var id: Int? = nil
	
	var item: Item!
	var item_id: Int!
	
	var order_id: Int!
	var quantity: Int = 1
	var notes: String? = nil
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.item_id = res["item_id"] as Int
		self.quantity = res["quantity"] as Int
		self.order_id = res["order_id"] as Int
		self.notes = res["notes"] as? String
		
		for it in storage.items {
			if it.id! == self.item_id {
				self.item = it
				break
			}
		}
	}
	
	func json() -> [NSObject: AnyObject] {
		var json: [NSObject: AnyObject] = [:]
		
		json["id"] = self.id
		json["item_id"] = self.item_id
		json["order_id"] = self.order_id
		json["quantity"] = self.quantity
		json["notes"] = self.notes
		
		return json
	}
	
	func save(callback: (err: NSError?) -> Void) {
		var url = "/order/" + String(self.order_id) + "/item/" + String(self.id!)
		
		doPostRequest(makeRequest(url, "PUT"), { (err: NSError?, data: AnyObject?) -> Void in
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
		doRequest(makeRequest("/order/" + String(self.order_id) + "/item/" + String(self.id!), "DELETE"), { (err: NSError?, data: AnyObject?) -> Void in
			callback(err: err)
		}, nil)
	}
}
