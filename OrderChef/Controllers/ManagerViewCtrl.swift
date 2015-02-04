
import UIKit

class ManagerViewCtrl: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Manager"
		
		AppDelegate.registerCommonCellsForTable(self.tableView)
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " " + NSString.fontAwesomeIconStringForEnum(FAIcon.FATimes), style: UIBarButtonItemStyle.Plain, target: self, action: "closeView")
		self.navigationItem.leftBarButtonItem!.setTitleTextAttributes(AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20), forState: UIControlState.Normal)
	}
	
	func closeView() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 4
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 1:
			return 2
		case 3:
			return 3
		default:
			return 1
		}
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = .DisclosureIndicator
		
		switch (indexPath.section) {
		case 0:
			cell!.textLabel!.text = "Config"
		case 1:
			if indexPath.row == 0 {
				cell!.textLabel!.text = "Table Types"
			} else {
				cell!.textLabel!.text = "Tables"
			}
		case 2:
			cell!.textLabel!.text = "Order Types"
		case 3:
			switch indexPath.row {
			case 0:
				cell!.textLabel!.text = "Items"
			case 1:
				cell!.textLabel!.text = "Categories"
			case 2:
				cell!.textLabel!.text = "Modifiers"
			default:
				break
			}
		default:
			break
		}
		
		return cell!
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var vc: UIViewController!
		
		switch indexPath.section {
		case 0:
			vc = MConfigViewCtrl(nibName: groupedTableNibName, bundle: nil)
		case 1:
			if indexPath.row == 0 {
				vc = MTableTypesViewCtrl(nibName: plainTableNibName, bundle: nil)
			} else {
				vc = MTablesViewCtrl(nibName: plainTableNibName, bundle: nil)
			}
		case 2:
			vc = MOrderTypesViewCtrl(nibName: plainTableNibName, bundle: nil)
		case 3:
			if indexPath.row == 0 {
				vc = MItemsViewCtrl(nibName: plainTableNibName, bundle: nil)
			} else {
				vc = MCategoriesViewCtrl(nibName: plainTableNibName, bundle: nil)
			}
		default:
			return tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == self.numberOfSectionsInTableView(tableView) - 1 {
			var name = "<Unnamed Venue>"
			if storage.venue_name != nil {
				name = storage.venue_name!
			}
			
			return name + " — orderchef v" + versionNumber
		}
		
		return nil
	}
	
}
