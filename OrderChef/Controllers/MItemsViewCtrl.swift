
import UIKit

class MItemsViewCtrl: UITableViewController, RefreshDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Items"
		
		AppDelegate.setupRefreshControl(self)
		AppDelegate.registerCommonCellsForTable(self.tableView)
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSString.fontAwesomeIconStringForEnum(FAIcon.FAPlus) + " ", style: UIBarButtonItemStyle.Plain, target: self, action: "add")
		self.navigationItem.rightBarButtonItem!.setTitleTextAttributes(AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20), forState: UIControlState.Normal)
		
		self.reloadData(nil)
	}
	
	func reloadData(sender: AnyObject?) {
		storage.updateItems({ (err: NSError?) -> Void in
			self.refreshControl!.endRefreshing()
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.tableView.reloadData()
		})
	}
	
	func add() {
		var vc = MItemViewCtrl(nibName: groupedTableNibName, bundle: nil)
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return storage.items.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var vc = MItemViewCtrl(nibName: groupedTableNibName, bundle: nil)
		
		vc.item = storage.items[indexPath.row]
		
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let item = storage.items[indexPath.row]
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = .DisclosureIndicator
		cell!.textLabel!.text = item.name
		
		return cell!
	}

}
