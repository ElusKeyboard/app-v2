
import Foundation

class SharedStorage {
	var categories: [Category] = []
	var items: [Item] = []
	
	func updateCategories(callback: (err: NSError?) -> Void) {
		Category.getCategories({ (err: NSError?, categories: [Category]) -> Void in
			if err != nil {
				return callback(err: err)
			}
			
			self.categories = categories
			callback(err: nil)
		})
	}
	
	func updateItems(callback: (err: NSError?) -> Void) {
		Item.getItems({ (err: NSError?, items: [Item]) -> Void in
			if err != nil {
				return callback(err: err)
			}
			
			self.items = items
			callback(err: nil)
		})
	}
}
