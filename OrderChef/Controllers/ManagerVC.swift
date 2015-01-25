
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
		return 2
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
			cell!.textLabel!.text = "Items"
		case 1:
			cell!.textLabel!.text = "Categories"
		default:
			break
		}
		
		return cell!
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			return tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		
		var vc: UIViewController!
		if indexPath.section == 1 {
			vc = ManagerCategoriesVC(nibName: "ManagerCategoriesVC", bundle: nil)
		}
		
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
}
