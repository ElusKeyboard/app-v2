
import UIKit

class ManagerCategoryVC: UITableViewController, TextFieldCellDelegate {
	
	var category: Category = Category()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Add Category"
		if category.id == nil {
			self.navigationItem.title = "Save Category"
		}
		
		self.tableView.registerNib(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "textField")
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
		self.category.save({ (err: NSError?) -> Void in
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.navigationController!.popViewControllerAnimated(true)
		})
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: TextFieldCell? = tableView.dequeueReusableCellWithIdentifier("textField", forIndexPath: indexPath) as? TextFieldCell
		if cell == nil {
			cell = TextFieldCell(style: UITableViewCellStyle.Default, reuseIdentifier: "textField")
		}
		
		if indexPath.section == 0 {
			cell!.label.text = "Name:"
			cell!.field.text = self.category.name
		} else {
			cell!.label.text = "Description:"
			cell!.field.text = self.category.description
		}
		
		cell!.delegate = self
		cell!.setup()
		
		return cell!
	}
	
	//MARK: TextFieldCellDelegate
	
	func TextFieldCellDidChangeValue(cell: TextFieldCell, value: String) {
		self.didEdit()
		
		var indexPath = self.tableView.indexPathForCell(cell)
		
		if indexPath!.section == 0 {
			self.category.name = value
		} else if indexPath!.section == 1 {
			self.category.description = value
		}
	}
	
}
