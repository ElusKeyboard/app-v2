
import UIKit

class MModifiersViewCtrl: UITableViewController, RefreshDelegate {
	
	var item: Item?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Modifier Groups"
		
		AppDelegate.setupRefreshControl(self)
		AppDelegate.registerCommonCellsForTable(self.tableView)
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSString.fontAwesomeIconStringForEnum(FAIcon.FAPlus) + " ", style: UIBarButtonItemStyle.Plain, target: self, action: "add")
		self.navigationItem.rightBarButtonItem!.setTitleTextAttributes(AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20), forState: UIControlState.Normal)
		
		self.reloadData(nil)
	}
	
	func reloadData(sender: AnyObject?) {
		storage.updateModifiers({ (err: NSError?) -> Void in
			self.refreshControl!.endRefreshing()
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.tableView.reloadData()
		})
	}
	
	func add() {
		var vc = MModifierViewCtrl(nibName: groupedTableNibName, bundle: nil)
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return storage.modifiers.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let modifier = storage.modifiers[indexPath.row]
		
		if self.item != nil {
			var found = -1
			for (i, modifier_id) in enumerate(self.item!.modifiers) {
				if modifier_id == modifier.id! {
					found = i
				}
			}
			
			if (found == -1) {
				// add
				self.item!.modifiers.append(modifier.id!)
			} else {
				self.item!.modifiers.removeAtIndex(found)
			}
			
			tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			
			return
		}
		
		var vc = MModifierViewCtrl(nibName: groupedTableNibName, bundle: nil)
		vc.modifier = modifier

		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let modifier = storage.modifiers[indexPath.row]
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = .DisclosureIndicator
		
		if self.item != nil {
			var found = false
			for modifier_id in self.item!.modifiers {
				if modifier_id == modifier.id! {
					found = true
				}
			}
			
			cell!.accessoryType = found ? .Checkmark : .None
		}
		
		cell!.textLabel!.text = modifier.name
		
		return cell!
	}
	
}
