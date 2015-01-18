
import UIKit

class TextViewCell: UITableViewCell, UITextViewDelegate {
	
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var field: UITextView!
	
	var delegate: TextFieldCellDelegate? = nil
	
	func setup() {
		self.field.delegate = self
	}
	
	func fieldValueChanged(field: AnyObject?) {
		if self.delegate == nil {
			return
		}
		
		self.delegate!.TextFieldCellDidChangeValue(self, value: self.field.text)
	}
	
	func textViewDidChange(textView: UITextView) {
		if self.delegate == nil {
			return
		}
		
		self.delegate!.TextFieldCellDidChangeValue(self, value: self.field.text)
	}
	
}
