
import Foundation

protocol TextFieldCellDelegate {
	func TextFieldCellDidChangeValue(cell: TextFieldCell, value: String)
}

class TextFieldCell: UITableViewCell {
	
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var field: UITextField!
	
	var delegate: TextFieldCellDelegate?
	
	func setup() {
		self.field.addTarget(self, action: "fieldValueChanged:", forControlEvents: UIControlEvents.EditingChanged)
	}
	
	func fieldValueChanged(field: AnyObject?) {
		if self.delegate == nil {
			return
		}
		
		self.delegate!.TextFieldCellDidChangeValue(self, value: self.field.text)
	}
	
}
