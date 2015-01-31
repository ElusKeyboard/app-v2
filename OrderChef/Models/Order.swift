
import Foundation

class Order {
	var id: Int? = nil
	
	var type_id: Int!
	var type: OrderType!
	
	var group_id: Int!
	var group: OrderGroup? = nil
	
	var order_items: [OrderItem] = []
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.type_id = res["type_id"] as Int
		self.group_id = res["group_id"] as Int
		
		for ot in storage.order_types {
			if ot.id != nil && ot.id! == self.type_id {
				self.type = ot
				break
			}
		}
		
		// self.order_items
	}
	
	func json() -> [NSString: AnyObject] {
		var json: [NSString: AnyObject] = [:]
		
		if self.id != nil { json["id"] = self.id }
		json["type_id"] = self.type_id
		json["group_id"] = self.group_id
		
		return json
	}
}
