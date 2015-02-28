
import UIKit
import XCTest

class ItemTest: XCTestCase {
	
	func getCategory(callback: (category: Category) -> Void) {
		var category = Category()
		category.name = "Test Category"
		category.save({ (err: NSError?) -> Void in
			XCTAssert(err == nil, "Err not nil")
			callback(category: category)
		})
	}
	
	func getItem(callback: (item: Item) -> Void) {
		getCategory({ (category: Category) -> Void in
			var item = Item()
			item.name = "Test Item"
			item.category_id = category.id!
			
			item.save({ (err: NSError?) -> Void in
				XCTAssert(err == nil, "Err is not nil")
				
				callback(item: item)
			})
		})
	}
	
	func testSetModifiers() {
		var expectation = self.expectationWithDescription("Set Item Modifiers")
		
		self.getItem({ (item: Item) -> Void in
			item.modifiers = [1, 2, 3]
			item.setModifiers({ (err: NSError?) -> Void in
				XCTAssert(err == nil, "Err is not nil")
				
				item.getModifiers({ (err: NSError?) -> Void in
					XCTAssert(err == nil, "Err is not nil")
					XCTAssert(item.modifiers.count == 3, "Did not save modifiers")
					
					expectation.fulfill()
				})
			})
		})
		
		self.waitForExpectationsWithTimeout(2, handler: nil)
	}
	
}
