
import Foundation

class OrderItem {
	var id: Int? = nil
	
	var item: Item!
	var item_id: Int!
	
	var order_id: Int!
	var notes: String? = nil
	
	var modifiers: [OrderItemModifier] = []
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.item_id = res["item_id"] as! Int
		self.order_id = res["order_id"] as! Int
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
	
	func getModifiers(callback: (err: NSError?) -> Void) {
		doRequest(makeRequest("/order/" + String(self.order_id) + "/item/" + String(self.id!) + "/modifiers", "GET"), { (err: NSError?, data: AnyObject?) -> Void in
			if err != nil {
				return callback(err: err)
			}
			
			var json: [[NSString: AnyObject]]? = data as? [[NSString: AnyObject]]
			if json != nil {
				self.modifiers = []
				for j in json! {
					var modifier = OrderItemModifier(res: j)
					modifier.order_id = self.order_id
					self.modifiers.append(modifier)
				}
			}
			
			callback(err: nil)
		}, nil)
	}
}

class OrderItemModifier {
	var id: Int? = nil
	
	var order_id: Int!
	var order_item_id: Int!
	var modifier_group_id: Int!
	var modifier_id: Int!
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.order_item_id = res["order_item_id"] as! Int
		self.modifier_group_id = res["modifier_group_id"] as! Int
		self.modifier_id = res["modifier_id"] as! Int
	}
	
	func json() -> [NSObject: AnyObject] {
		var json: [NSObject: AnyObject] = [:]
		
		json["id"] = self.id
		json["order_item_id"] = self.order_item_id
		json["modifier_group_id"] = self.modifier_group_id
		json["modifier_id"] = self.modifier_id
		
		return json
	}
	
	func save(callback: (err: NSError?) -> Void) {
		if self.id != nil {
			callback(err: nil)
			return
		}
		
		let order_id = String(self.order_id)
		let order_item_id = String(self.order_item_id)
		var url = "/order/" + order_id + "/item/" + order_item_id + "/modifiers"
		
		doPostRequest(makeRequest(url, "POST"), { (err: NSError?, data: AnyObject?) -> Void in
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
		doRequest(makeRequest("/order/" + String(self.order_id) + "/item/" + String(self.order_item_id) + "/modifier/" + String(self.id!), "DELETE"), { (err: NSError?, data: AnyObject?) -> Void in
			callback(err: err)
		}, nil)
	}
}
