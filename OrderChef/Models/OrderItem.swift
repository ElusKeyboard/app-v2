
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
		self.item_id = res["item_id"] as? Int
		self.quantity = res["quantity"] as Int
		self.order_id = res["order_id"] as Int
		self.notes = res["notes"] as? String
	}
}
