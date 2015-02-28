
import Foundation

class SharedStorage {
	var venue_name: String? = nil
	var server_ip: String? = nil
	
	var tables: [Table] = []
	var table_types: [TableType] = []
	
	var order_types: [OrderType] = []
	
	var categories: [Category] = []
	var items: [Item] = []
	
	var modifiers: [ConfigModifierGroup] = []
	
	func initSequence() {
		var seqRemaining = 7;
		var seqTotal = seqRemaining;
		
		SVProgressHUD.showProgress(0, status: "Initialising")
		
		var cb = { (err: NSError?) -> Void in
			SVProgressHUD.showProgress(Float((seqRemaining / seqTotal - 1) * -1))
			
			if (--seqRemaining <= 0) {
				SVProgressHUD.dismiss()
				println("Finished Init")
				NSNotificationCenter.defaultCenter().postNotificationName("didInit", object: nil)
			}
		}
		
		self.updateSettings(cb)
		self.updateOrderTypes(cb)
		
		self.updateTableTypes({ (err: NSError?) -> Void in
			cb(nil)
			self.updateTables(cb)
		})
		
		self.updateCategories({ (err: NSError?) -> Void in
			cb(nil)
			self.updateItems(cb)
		})
		
		self.updateModifiers(cb)
	}
	
	// MARK: - Update methods
	
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
	
	func updateOrderTypes(callback: (err: NSError?) -> Void) {
		OrderType.getAll({ (err: NSError?, list: [OrderType]) -> Void in
			if err != nil {
				return callback(err: err)
			}
			
			self.order_types = list
			
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
	
	func updateModifiers(callback: (err: NSError?) -> Void) {
		ConfigModifierGroup.getModifiers({ (err: NSError?, modifiers: [ConfigModifierGroup]) -> Void in
			if err != nil {
				return callback(err: err)
			}
			
			self.modifiers = modifiers
			
			var numGot = 0
			for modifier in self.modifiers {
				modifier.getModifiers({ (err: NSError?) -> Void in
					if ++numGot >= self.modifiers.count {
						callback(err: nil)
					}
				})
			}
		})
	}
	
	// MARK: Mappings
	
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
