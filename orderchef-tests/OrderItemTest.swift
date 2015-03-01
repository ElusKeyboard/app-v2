
import UIKit
import XCTest

// note to self: This is fugly.

class OrderItemTest: XCTestCase {
	
	func getTableType(callback: (tableType: TableType) -> Void) {
		var tableType = TableType()
		tableType.name = "Test table type"
		tableType.save({ (err: NSError?) -> Void in
			XCTAssert(err == nil, "Table type not created" + err!.description)
			callback(tableType: tableType)
		})
	}
	
	func getOrderType(callback: (orderType: OrderType) -> Void) {
		var orderType = OrderType()
		orderType.name = "Test table type"
		orderType.save({ (err: NSError?) -> Void in
			XCTAssert(err == nil, "order type not created. " + err!.description)
			callback(orderType: orderType)
		})
	}
	
	func getTable(callback: (table: Table, group: OrderGroup) -> Void) {
		self.getTableType({ (tableType: TableType) -> Void in
			var table = Table()
			table.name = "Test Table"
			table.table_type = tableType
			table.table_type_id = tableType.id!
			table.save({ (err: NSError?) -> Void in
				XCTAssert(err == nil, "cannot save table. " + err!.description)
				
				table.getGroup({ (err: NSError?, group: OrderGroup?) -> Void in
					XCTAssert(err == nil, "Err not nil")
					
					callback(table: table, group: group!)
				})
			})
		})
	}
	
	func getCategory(callback: (category: Category) -> Void) {
		var category = Category()
		category.name = "Test Category"
		category.save({ (err: NSError?) -> Void in
			XCTAssert(err == nil, "category not created. " + err!.description)
			callback(category: category)
		})
	}
	
	func getItem(callback: (item: Item) -> Void) {
		getCategory({ (category: Category) -> Void in
			var item = Item()
			item.name = "Test Item"
			item.category_id = category.id!
			
			item.save({ (err: NSError?) -> Void in
				XCTAssert(err == nil, "item not created. " + err!.description)
				
				callback(item: item)
			})
		})
	}
	
	func prepareItem(callback: (item: Item, modifierGroup: ConfigModifierGroup, modifier: ConfigModifier) -> Void) {
		self.getItem({ (item: Item) -> Void in
			var group = ConfigModifierGroup(name: "Test", choiceRequired: false)
			group.save({ (err: NSError?) -> Void in
				XCTAssert(err == nil, "group modifier not created. " + err!.description)
				
				var modifier = ConfigModifier()
				modifier.name = "Test modifier"
				modifier.group_id = group.id!
				modifier.save({ (err: NSError?) -> Void in
					XCTAssert(err == nil, "modifier not created. " + err!.description)
					
					item.modifiers = [modifier.id!]
					item.setModifiers({ (err: NSError?) -> Void in
						XCTAssert(err == nil, "item cannot set modifiers. " + err!.description)
						
						callback(item: item, modifierGroup: group, modifier: modifier)
					})
				})
			})
		})
	}
	
	func testAddModifier() {
		var expectation = self.expectationWithDescription("Set OrderItem Modifiers")
		
		self.getTable({ (table: Table, group: OrderGroup) -> Void in
			self.getOrderType({ (orderType: OrderType) -> Void in
				var order = Order()
				order.type = orderType
				order.type_id = orderType.id!
				
				group.addOrder(order, callback: { (err: NSError?) -> Void in
					XCTAssert(err == nil, "cannot add order to group. " + err!.description)
					
					group.getOrders({ (err: NSError?, orders: [Order]) -> Void in
						self.prepareItem({ (item: Item, modifierGroup: ConfigModifierGroup, modifier: ConfigModifier) -> Void in
							order.addItem(item, callback: { (err: NSError?, orderItem: OrderItem?) -> Void in
								XCTAssert(err == nil, "cannot add item to order. " + err!.description)
								
								var orderModifier = OrderItemModifier()
								orderModifier.order_id = order.id!
								orderModifier.order_item_id = orderItem!.id!
								orderModifier.modifier_group_id = modifierGroup.id!
								orderModifier.modifier_id = modifier.id!
								orderModifier.save({ (err: NSError?) -> Void in
									XCTAssert(err == nil, "cannot save modifier to orderItem. " + err!.description)
									expectation.fulfill()
								})
							})
						})
					})
				})
			})
		})
		
		self.waitForExpectationsWithTimeout(2, handler: nil)
	}
	
}
