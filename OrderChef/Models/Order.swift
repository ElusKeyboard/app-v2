
import Foundation

class Order {
	var id: Int? = nil
	var type_id: Int? = nil
	var group_id: Int? = nil
	
	var order_items: [OrderItem] = []
	
	init(){}
	
	init(res: [NSString: AnyObject]) {
		self.parse(res)
	}
	
	func parse(res: [NSString: AnyObject]) {
		self.id = res["id"] as? Int
		self.type_id = res["type_id"] as? Int
		self.group_id = res["group_id"] as? Int
		// self.order_items
	}
}
