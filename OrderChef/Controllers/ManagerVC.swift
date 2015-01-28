
import UIKit

class ManagerVC: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Manager"
		
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "basic")
		
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
		if section == 2 {
			return 2
		}
		
		return 1
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
			cell!.textLabel!.text = "Items"
		case 3:
			cell!.textLabel!.text = "Categories"
		default:
			break
		}
		
		return cell!
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var vc: UIViewController!
		
		switch indexPath.section {
		case 0:
			vc = ManagerConfigVC(nibName: "ManagerConfigVC", bundle: nil)
		case 1:
			if indexPath.row == 0 {
				vc = ManagerTableTypesVC(nibName: "ManagerTableTypesVC", bundle: nil)
			} else {
				vc = ManagerTablesVC(nibName: "ManagerTablesVC", bundle: nil)
			}
		case 3:
			vc = ManagerCategoriesVC(nibName: "ManagerCategoriesVC", bundle: nil)
		default:
			return tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == 3 {
			var name = "<Unnamed Venue>"
			if storage.venue_name != nil {
				name = storage.venue_name!
			}
			
			return name + " — orderchef v" + versionNumber
		}
		
		return nil
	}
	
}
