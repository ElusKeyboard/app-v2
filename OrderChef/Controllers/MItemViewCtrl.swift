
import UIKit

class MItemViewCtrl: UITableViewController, TextFieldCellDelegate {
	
	var item: Item = Item()
	var isPickingCategory = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Add Item"
		if item.id != nil {
			self.navigationItem.title = "Update Item"
		}
		
		AppDelegate.registerCommonCellsForTable(self.tableView)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if self.isPickingCategory == true {
			self.isPickingCategory = false
			self.didEdit()
			
			var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3)) as UITableViewCell!
			cell.textLabel!.text = "Item: "
			if self.item.category != nil && self.item.category.name != nil {
				cell.textLabel!.text! += self.item.category.name!
			}
		}
	}
	
	func didEdit() {
		self.navigationItem.setHidesBackButton(true, animated: true)
		
		var attributes = AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " " + NSString.fontAwesomeIconStringForEnum(FAIcon.FATimes), style: .Plain, target: self, action: "cancel")
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSString.fontAwesomeIconStringForEnum(FAIcon.FACheck) + " ", style: .Plain, target: self, action: "save")
		
		self.navigationItem.leftBarButtonItem!.setTitleTextAttributes(attributes, forState: .Normal)
		self.navigationItem.rightBarButtonItem!.setTitleTextAttributes(attributes, forState: .Normal)
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
		return self.item.id == nil ? 4 : 5
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
			cell!.field.text = self.item.name
			cell!.field.keyboardType = .Default
			
			cell!.delegate = self
			cell!.setup()
			
			return cell!
		} else if indexPath.section == 1 {
			var cell: TextViewCell? = tableView.dequeueReusableCellWithIdentifier("textView", forIndexPath: indexPath) as? TextViewCell
			if cell == nil {
				cell = TextViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "textView")
			}
			
			cell!.label.text = "Description:"
			cell!.field.text = self.item.description
			
			cell!.delegate = self
			cell!.setup()
			
			return cell!
		} else if indexPath.section == 2 {
			var cell: TextFieldCell? = tableView.dequeueReusableCellWithIdentifier("textField", forIndexPath: indexPath) as? TextFieldCell
			if cell == nil {
				cell = TextFieldCell(style: UITableViewCellStyle.Default, reuseIdentifier: "textField")
			}
			
			cell!.label.text = "Price:"
			cell!.field.text = String(format: "%.2f",	self.item.price)
			cell!.field.keyboardType = .DecimalPad
			
			cell!.delegate = self
			cell!.setup()
			
			return cell!
		} else if indexPath.section == 3 {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
			}
			
			cell!.textLabel!.text = "Category: "
			if self.item.category != nil && self.item.category.name != nil {
				cell!.textLabel!.text! += self.item.category.name!
			}
			
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
		if indexPath.section == 3 {
			self.isPickingCategory = true
			
			let vc = MCategoriesViewCtrl(nibName: plainTableNibName, bundle: nil)
			vc.pickingForItem = self.item
			self.navigationController!.pushViewController(vc, animated: true)
		} else if indexPath.section == 4 {
			// Delete
			self.item.remove({ (err: NSError?) -> Void in
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
				
				if err != nil {
					return SVProgressHUD.showErrorWithStatus(err!.description)
				}
				
				self.navigationController!.popViewControllerAnimated(true)
			})
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 1 {
			return 44 * 3
		}
		
		return 44
	}
	
	//MARK: TextFieldCellDelegate
	
	func TextFieldCellDidChangeValue(cell: UITableViewCell, value: String) {
		self.didEdit()
		
		var indexPath = self.tableView.indexPathForCell(cell)
		
		if indexPath!.section == 0 {
			self.item.name = value
		} else if indexPath!.section == 1 {
			self.item.description = value
		} else if indexPath!.section == 2 {
			var formatter = NSNumberFormatter()
			formatter.numberStyle = .DecimalStyle
			
			var number = formatter.numberFromString(value)
			if number != nil {
				self.item.price = number!.floatValue
			} else {
				SVProgressHUD.showErrorWithStatus("Price Invalid")
			}
		}
	}
	
}
