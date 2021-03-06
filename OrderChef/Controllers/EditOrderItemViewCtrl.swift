
import UIKit

class EditOrderItemViewCtrl: UITableViewController, TextFieldCellDelegate {
	var order: Order!
	var item: OrderItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = order.type.name
		
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
		self.item.save({ (err: NSError?) -> Void in
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.navigationController!.popViewControllerAnimated(true)
		})
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 4
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 0
		}
		
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 1 {
			var cell: TextViewCell? = tableView.dequeueReusableCellWithIdentifier("textView", forIndexPath: indexPath) as? TextViewCell
			if cell == nil {
				cell = TextViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "textView")
			}
			
			cell!.label.text = "Description:"
			cell!.field.text = self.item.notes
			
			cell!.delegate = self
			cell!.setup()
			
			return cell!
		} else if indexPath.section == 2 {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
			}
			
			cell!.textLabel!.text = "Modifiers"
			cell!.textLabel!.textAlignment = .Center
			
			return cell!
		} else {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
			}
			
			cell!.textLabel!.text = "Remove from Order"
			cell!.textLabel!.textAlignment = .Center
			
			return cell!
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 2 {
			// pick modifiers
			let modifiersVC = SetOrderItemModifiersViewCtrl(nibName: groupedTableNibName, bundle: nil)
			modifiersVC.orderItem = self.item
			
			let vc = UINavigationController(rootViewController: modifiersVC)
			self.presentViewController(vc, animated: true, completion: nil)
			return
		}
		
		if indexPath.section == 3 {
			// Delete
			item.remove({ (err: NSError?) -> Void in
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
				
				if err != nil {
					return SVProgressHUD.showErrorWithStatus(err!.description)
				}
				
				self.navigationController!.popViewControllerAnimated(true)
			})
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 1 && indexPath.row == 0 {
			return 44 * 2
		}
		
		return 44
	}
	
	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section != 0 {
			return nil
		}
		
		var str = "Name: " + self.item.item.name + "\n"
		if self.item.item.description != nil {
			str += self.item.item.description!
		}
		
		return str
	}
	
	// MARK: TextFieldCellDelegate
	
	func TextFieldCellDidChangeValue(cell: UITableViewCell, value: String) {
		self.didEdit()
		
		var indexPath = self.tableView.indexPathForCell(cell)
		
		if indexPath!.section == 1 {
			self.item.notes = value
		}
	}
}
