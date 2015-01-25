
import Foundation

protocol TextFieldCellDelegate {
	func TextFieldCellDidChangeValue(cell: UITableViewCell, value: String)
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
	
	override func setSelected(selected: Bool, animated: Bool) {
		if selected == true {
			self.field.becomeFirstResponder()
		}
		
		super.setSelected(false, animated: false)
		
		return
	}
	
	override func setHighlighted(highlighted: Bool, animated: Bool) {
		return
	}
	
}
