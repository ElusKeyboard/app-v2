
import UIKit

class MOrderTypeViewCtrl: UITableViewController, TextFieldCellDelegate {
	
	var order_type: OrderType = OrderType()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Add Order Type"
		if self.order_type.id != nil {
			self.navigationItem.title = "Update Order Type"
		}
		
		AppDelegate.registerCommonCellsForTable(self.tableView)
	}
	
	func didEdit() {
		self.navigationItem.setHidesBackButton(true, animated: true)
		
		var attributes = AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " " + NSString.fontAwesomeIconStringForEnum(FAIcon.FATimes), style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSString.fontAwesomeIconStringForEnum(FAIcon.FACheck) + " ", style: UIBarButtonItemStyle.Plain, target: self, action: "save")
		
		self.navigationItem.leftBarButtonItem!.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
		self.navigationItem.rightBarButtonItem!.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
	}
	
	func cancel() {
		self.navigationController!.popViewControllerAnimated(true)
	}
	
	func save() {
		self.order_type.save({ (err: NSError?) -> Void in
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.navigationController!.popViewControllerAnimated(true)
		})
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.order_type.id == nil ? 2 : 3
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			var cell: TextFieldCell? = tableView.dequeueReusableCellWithIdentifier("textField", forIndexPath: indexPath) as? TextFieldCell
			if cell == nil {
				cell = TextFieldCell(style: UITableViewCellStyle.Default, reuseIdentifier: "textField")
			}
			
			cell!.label.text = "Name:"
			cell!.field.text = self.order_type.name
			
			cell!.delegate = self
			cell!.setup()
			
			return cell!
		} else if indexPath.section == 1 {
			var cell: TextViewCell? = tableView.dequeueReusableCellWithIdentifier("textView", forIndexPath: indexPath) as? TextViewCell
			if cell == nil {
				cell = TextViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "textView")
			}
			
			cell!.label.text = "Description:"
			cell!.field.text = self.order_type.description
			
			cell!.delegate = self
			cell!.setup()
			
			return cell!
		} else {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
			}
			
			cell!.textLabel!.text = "Delete"
			cell!.textLabel!.textAlignment = .Center
			
			return cell!
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 2 {
			// Delete
			order_type.remove({ (statusCode: Int) -> Void in
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
				
				if statusCode >= 400 {
					return SVProgressHUD.showErrorWithStatus("Cannot remove order type")
				}
				
				self.navigationController!.popViewControllerAnimated(true)
			})
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 1 {
			return 44 * 2
		}
		
		return 44
	}
	
	// MARK: TextFieldCellDelegate
	
	func TextFieldCellDidChangeValue(cell: UITableViewCell, value: String) {
		self.didEdit()
		
		var indexPath = self.tableView.indexPathForCell(cell)
		
		if indexPath!.section == 0 {
			self.order_type.name = value
		} else if indexPath!.section == 1 {
			self.order_type.description = value
		}
	}
	
}
