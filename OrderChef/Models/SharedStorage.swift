
import Foundation

class SharedStorage {
	var venue_name: String? = nil
	var server_ip: String? = nil
	
	var tables: [Table] = []
	var table_types: [TableType] = []
	
	var categories: [Category] = []
	var items: [Item] = []
	
	func updateSettings(callback: (err: NSError?) -> Void) {
		doRequest(makeRequest("/config/settings", "GET"), { (err: NSError?, data: AnyObject?) -> Void in
			if err != nil {
				return callback(err: err)
			}
			
			var json: [NSString: AnyObject]? = data as? [NSString: AnyObject]
			if json != nil {
				self.venue_name = json!["venue_name"] as? String
			}
			
			callback(err: nil)
		}, nil)
	}
	
	func setSettings(callback: (err: NSError?) -> Void) {
		var settings: [NSObject: AnyObject] = [:]
		if self.venue_name != nil {
			settings["venue_name"] = self.venue_name!
		}
		
		doPostRequest(makeRequest("/config/settings", "POST"), { (err: NSError?, data: AnyObject?) -> Void in
			callback(err: err)
		}, settings)
	}
	
	func updateTableTypes(callback: (err: NSError?) -> Void) {
		TableType.getAll({ (err: NSError?, list: [TableType]) -> Void in
			if err != nil {
				return callback(err: err)
			}
			
			self.table_types = list
			
			self.updateTableTypeMappings()
			callback(err: nil)
		})
	}
	
	func updateTables(callback: (err: NSError?) -> Void) {
		Table.getAll({ (err: NSError?, list: [Table]) -> Void in
			if err != nil {
				return callback(err: err)
			}
			
			self.tables = list
			
			self.updateTableTypeMappings()
			callback(err: nil)
		})
	}
	
	func updateCategories(callback: (err: NSError?) -> Void) {
		Category.getCategories({ (err: NSError?, categories: [Category]) -> Void in
			if err != nil {
				return callback(err: err)
			}
			
			self.categories = categories
			
			self.updateItemCategoryMappings()
			callback(err: nil)
		})
	}
	
	func updateItems(callback: (err: NSError?) -> Void) {
		Item.getItems({ (err: NSError?, items: [Item]) -> Void in
			if err != nil {
				return callback(err: err)
			}
			
			self.items = items
			
			self.updateItemCategoryMappings()
			callback(err: nil)
		})
	}
	
	func updateItemCategoryMappings() {
		for cat in self.categories {
			cat.items = []
		}
		
		for it in self.items {
			for cat in self.categories {
				if cat.id != nil && cat.id! == it.category_id {
					cat.items.append(it)
					it.category = cat
				}
			}
		}
	}
	
	func updateTableTypeMappings() {
		for type in self.table_types {
			type.tables = []
		}
		
		for type in self.table_types {
			for t in self.tables {
				if type.id != nil && type.id! == t.table_type_id {
					type.tables.append(t)
					t.table_type = type
				}
			}
		}
	}
}
