
import UIKit
import XCTest

class ConfigModifierTest: XCTestCase {
	
	func addGroup(callback: (group: ConfigModifierGroup) -> Void) {
		var group = ConfigModifierGroup(name: "Test", choiceRequired: false)
		group.save({ (err: NSError?) -> Void in
			XCTAssert(err == nil, "Err is not nil")
			
			callback(group: group)
		})
	}
	
	func testAddConfigModifierGroup() {
		var expectation = self.expectationWithDescription("Save Group")
		
		self.addGroup({ (group: ConfigModifierGroup) -> Void in
			ConfigModifierGroup.getModifiers({ (err: NSError?, modifiers: [ConfigModifierGroup]) -> Void in
				XCTAssert(err == nil, "Err is not nil")
				
				var found = false
				for (var i = 0; i < modifiers.count; i++) {
					if modifiers[i].id! == group.id! {
						found = true
						break
					}
				}
				
				XCTAssert(found, "Created Modifier Not Found")
				
				expectation.fulfill()
			})
		})
		
		self.waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testGetAllModifiers() {
		var expectation = self.expectationWithDescription("Get all Group Modifiers")
		ConfigModifierGroup.getModifiers({ (err: NSError?, modifiers: [ConfigModifierGroup]) -> Void in
			XCTAssert(err == nil, "Err is not nil")
			XCTAssert(modifiers.count > 0, "No modifiers..")
			
			expectation.fulfill()
		})
		
		self.waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testAddChildModifier() {
		var expectation = self.expectationWithDescription("Get all Child modifiers")
		
		self.addGroup({ (group: ConfigModifierGroup) -> Void in
			var modifier = ConfigModifier()
			modifier.group_id = group.id!
			modifier.name = "Sub Modifier"
			modifier.price = 10
			
			modifier.save({ (err: NSError?) -> Void in
				XCTAssert(err == nil, "Err is not nil")
				
				group.getModifiers({ (err: NSError?) -> Void in
					XCTAssert(err == nil, "Err is not nil")
					XCTAssert(group.modifiers.count > 0, "No modifiers found")
					
					XCTAssert(group.modifiers[0].name == modifier.name, "Child and saved modifier differ (name)")
					XCTAssert(group.modifiers[0].price == modifier.price, "Child and saved modifier differ (price)")
					
					expectation.fulfill()
				})
			})
		})
		
		self.waitForExpectationsWithTimeout(2, handler: nil)
	}
	
}
