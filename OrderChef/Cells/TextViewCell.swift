
import UIKit
import QuartzCore

class TextViewCell: UITableViewCell, UITextViewDelegate {
	
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var field: UITextView!
	
	var delegate: TextFieldCellDelegate? = nil
	
	func setup() {
		self.field.delegate = self
		
		self.field.layer.borderColor = UIColor.grayColor().CGColor
		self.field.layer.borderWidth = 1
		self.field.layer.cornerRadius = 4
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
