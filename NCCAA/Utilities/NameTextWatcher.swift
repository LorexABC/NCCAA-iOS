import UIKit

class NameTextWatcher: NSObject, UITextFieldDelegate {
    let textField: UITextField
    
    init(textField: UITextField) {
        self.textField = textField
        super.init()
        self.textField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text as NSString? else { return true }
        
        let newText = text.replacingCharacters(in: range, with: string)
        
        if newText.hasSuffix(" ") || newText.hasSuffix("-") {
            textField.text = newText
            return true
        }
        
        let names = newText.components(separatedBy: " ")
        
        var formattedName = ""
        
        for name in names {
            if !name.isEmpty {
                var formattedPart = name.prefix(1).uppercased() + name.dropFirst().lowercased()
                
                if formattedPart.contains("-") {
                    let hyphenatedNames = formattedPart.components(separatedBy: "-")
                    var hyphenatedFormattedName = ""
                    
                    for hyphenatedName in hyphenatedNames {
                        hyphenatedFormattedName += hyphenatedName.prefix(1).uppercased() + hyphenatedName.dropFirst().lowercased() + "-"
                    }
                    
                    formattedPart = String(hyphenatedFormattedName.dropLast()) // Remove the last "-"
                }
                
                formattedName += formattedPart + " "
            }
        }
        
        textField.text = formattedName.trimmingCharacters(in: .whitespaces)
        return false
    }
}
