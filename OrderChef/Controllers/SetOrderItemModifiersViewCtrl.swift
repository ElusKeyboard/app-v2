
import UIKit

class SetOrderItemModifiersViewCtrl: UITableViewController, RefreshDelegate {
	
	var orderItem: OrderItem!
	var selectedModifierGroup: ConfigModifierGroup?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Modifiers"
		if self.selectedModifierGroup != nil {
			self.navigationItem.title = self.selectedModifierGroup!.name + " Modifiers"
		}
		
		AppDelegate.setupRefreshControl(self)
		AppDelegate.registerCommonCellsForTable(self.tableView)
		
		if self.selectedModifierGroup == nil {
			self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
			self.reloadData(nil)
		}
	}
	
	func reloadData(sender: AnyObject?) {
		self.orderItem.getModifiers({ (err: NSError?) -> Void in
			self.refreshControl!.endRefreshing()
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.tableView.reloadData()
		})
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.tableView.reloadData()
	}
	
	func done() {
		var needsMore = false
		
		for modifierGroupId in self.orderItem.item.modifiers {
			var modifierGroup = self.getModifier(modifierGroupId)
			if modifierGroup == nil {
				continue
			}
			
			if modifierGroup!.choiceRequired == false {
				continue
			}
			
			var didPick = false
			for item_modifier in self.orderItem.modifiers {
				if item_modifier.modifier_group_id == modifierGroup!.id! {
					didPick = true
					break
				}
			}
			
			if didPick == false {
				needsMore = true
				break
			}
		}
		
		if needsMore == true {
			SVProgressHUD.showErrorWithStatus("Pick all required modifiers!")
			self.tableView.reloadData()
			return
		}
		
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func getModifier(id: Int) -> ConfigModifierGroup? {
		for modifier in storage.modifiers {
			if modifier.id! == id {
				return modifier
			}
		}
		
		return nil
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.selectedModifierGroup != nil {
			return self.selectedModifierGroup!.modifiers.count
		}
		
		return self.orderItem.item.modifiers.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if self.selectedModifierGroup != nil {
			let modifier = self.selectedModifierGroup!.modifiers[indexPath.row]
			
			var found = -1
			for (i, item_modifier) in enumerate(self.orderItem.modifiers) {
				if item_modifier.modifier_id == modifier.id! && item_modifier.modifier_group_id == self.selectedModifierGroup!.id! {
					found = i
					
					break
				}
			}
			
			if found == -1 {
				// add modifier
				var orderModifier = OrderItemModifier()
				orderModifier.modifier_group_id = self.selectedModifierGroup!.id!
				orderModifier.modifier_id = modifier.id!
				orderModifier.order_id = self.orderItem.order_id
				orderModifier.order_item_id = self.orderItem.id!
				
				SVProgressHUD.showProgress(0, status: "Saving Modifier")
				orderModifier.save({ (err: NSError?) -> Void in
					if err != nil {
						return SVProgressHUD.showErrorWithStatus("Cannot save modifier. " + err!.description)
					}
					
					SVProgressHUD.dismiss()
					
					self.orderItem.getModifiers({ (err: NSError?) -> Void in
						if err != nil {
							return SVProgressHUD.showErrorWithStatus("Cannot get modifiers. " + err!.description)
						}
						
						self.navigationController!.popViewControllerAnimated(true)
					})
				})
			} else {
				// delete modifier
				SVProgressHUD.showProgress(0, status: "Deleting Modifier")
				self.orderItem.modifiers[found].remove({ (err: NSError?) -> Void in
					if err != nil {
						return SVProgressHUD.showErrorWithStatus("Cannot delete modifier. " + err!.description)
					}
					
					SVProgressHUD.dismiss()
					
					self.orderItem.getModifiers({ (err: NSError?) -> Void in
						if err != nil {
							return SVProgressHUD.showErrorWithStatus("Cannot get modifiers. " + err!.description)
						}
						
						self.navigationController!.popViewControllerAnimated(true)
					})
				})
			}
			
			return
		}
		
		let modifierGroup = self.getModifier(self.orderItem.item.modifiers[indexPath.row])
		if modifierGroup == nil {
			return tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		
		let vc = SetOrderItemModifiersViewCtrl(nibName: groupedTableNibName, bundle: nil)
		vc.orderItem = self.orderItem
		vc.selectedModifierGroup = modifierGroup
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
		}
		
		if self.selectedModifierGroup != nil {
			let modifier = self.selectedModifierGroup!.modifiers[indexPath.row]
			
			cell!.accessoryType = .None
			cell!.textLabel!.text = modifier.name
			
			for item_modifier in self.orderItem.modifiers {
				if item_modifier.modifier_id == modifier.id! && item_modifier.modifier_group_id == self.selectedModifierGroup!.id! {
					cell!.accessoryType = .Checkmark
					break
				}
			}
		} else {
			let modifierGroup = self.getModifier(self.orderItem.item.modifiers[indexPath.row])
			if modifierGroup == nil {
				cell!.textLabel!.text = "Unknown Modifier"
				return cell!
			}
			
			cell!.accessoryType = .DisclosureIndicator
			cell!.textLabel!.text = modifierGroup!.name
			cell!.textLabel!.textColor = UIColor.blackColor()
			
			if modifierGroup!.choiceRequired == true {
				// check if choice was made
				cell!.textLabel!.textColor = UIColor.redColor()
				for item_modifier in self.orderItem.modifiers {
					if item_modifier.modifier_group_id == modifierGroup!.id! {
						cell!.textLabel!.textColor = UIColor.blackColor()
						break
					}
				}
			}
		}
		
		return cell!
	}
	
}
