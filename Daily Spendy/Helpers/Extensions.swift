//
//  Extensions.swift
//  MiniShopManager
//
//  Created by Tran Quoc Loc on 5/11/16.
//  Copyright © 2016 LocTQ. All rights reserved.
//

import UIKit

extension UITextField {
    func clear() {
        self.text = ""
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}

extension Character
{
    func unicodeScalarCodePoint() -> UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}

extension Float {
    func toString() -> String {
        return String(format: "%.2f", self)
    }
    
    func toMoney(_ unit: String = "VNĐ") -> String {
        let indexOfDot = self.toString().range(of: ".", options: .backwards)?.lowerBound
        let s = self.toString().substring(to: indexOfDot!)
        var s2 = self.toString().substring(from: indexOfDot!)
        for i in (0..<s.characters.count).reversed() {
            let index = s.characters.count - 1 - i
            if index % 3 != 0 || index == 0 {
                s2 = "\(s[i])" + s2
            }
            else {
                s2 = "\(s[i])" + "," + s2
            }
        }
        
        s2 = s2 + " " + unit
        
        return s2
    }
}

extension Int {
    
    func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
    
    func toString() -> String {
        return "\(self)"
    }
    
    func toMoney(_ unit: String = "VNĐ") -> String {
        let s = self.toString()
        var s2 = ""
        for i in (0..<s.characters.count).reversed() {
            let index = s.characters.count - 1 - i
            if index % 3 != 0 || index == 0 {
                s2 = "\(s[i])" + s2
            }
            else {
                s2 = "\(s[i])" + "," + s2
            }
        }
        
        s2 = s2 + " " + unit
        
        return s2
    }
}

extension UInt {
    
    func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
}

extension UIView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    func setHideKeyboardOnTap(_ enable: Bool = true) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.dismissKeyboard))
        self.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func setBackgroundImage(image: UIImage) {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = image
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension Date
{
    
    init(dateString:String) {
        if dateString == "" {
            self = Date(dateString: "01/01/1900")
        }
        else {
            let dateStringFormatter = DateFormatter()
            dateStringFormatter.dateFormat = ("dd/MM/yyyy")
            dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateStringFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let d = dateStringFormatter.date(from: dateString)!
            self = d
        }
    }
    
    init(dateString:String, format: String) {
        if dateString == "" {
            self = Date(dateString: "01/01/1900")
        }
        else {
            let dateStringFormatter = DateFormatter()
            dateStringFormatter.dateFormat = (format)
//            dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateStringFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let d = dateStringFormatter.date(from: dateString) ?? Date()
            self = d
        }
    }
    
    func toString(withFormat format: String = "dd / MM / yyyy") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func isEqualDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqual = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqual = true
        }
        
        //Return Result
        return isEqual
    }
    
    func addDays(_ daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(_ hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    func getDay() -> Int {
        return (Calendar.current as NSCalendar).component(.day, from: self)
    }
    
    func getMonth() -> Int {
        return (Calendar.current as NSCalendar).component(.month, from: self)
    }
    
    func getYear() -> Int {
        return (Calendar.current as NSCalendar).component(.year, from: self)
    }
    
    func startDay() -> Date {
        let calendar = Calendar.current
        let systemVersion:NSString = UIDevice.current.systemVersion as NSString
        if systemVersion.floatValue >= 8.0 {
            return calendar.startOfDay(for: self)
        } else {
            let components = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: self)
            return calendar.date(from: components)!
        }
    }
}

extension Array {
    mutating func removeIf(_ closure:((Element) -> Bool)) {
        for i in (0..<self.count).reversed() {
            if closure(self[i]) {
                self.remove(at: i)
            }
        }
    }
}

extension String {
    
    var lenght: Int {
        return self.characters.count
    }
    
    func sizeWithFont(font: UIFont, maxSize: CGSize? = nil) -> CGSize {
        var _maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        if let maxSize = maxSize {
            _maxSize = maxSize
        }
        
        return (self as NSString).boundingRect(with: _maxSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSFontAttributeName:font], context: nil).size
    }
    
    func doesContainWhiteSpace() -> Bool {
        let whitespace = CharacterSet.whitespaces
        
        let range = self.rangeOfCharacter(from: whitespace)
        
        // range will be nil if no whitespace is found
        if (range != nil) {
            return true
        }
        else {
            return false
        }
    }
    
    func isValidPassword() -> Bool {
        
        if self.characters.count < 6 || self.doesContainWhiteSpace() {
            return false
        }
        
        return true
    }
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    func isValidPhoneNumber() -> Bool {
        
        if self.isEmpty {
            return false
        }
        
//        let phoneRegEx = "^(0\\d{9,})$"
        let phoneRegEx = "^((\\+)|(0)|(\\*)|())[0-9]{3,14}((\\#)|())$"
        
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
        
    }
    
    var isAllHiragana: Bool {
        get {
            if self.isEmpty {
                return false
            }
            
            let regex = "^(.{0}|[ぁ-ゞー]{1,32})$"
            
            let test = NSPredicate(format:"SELF MATCHES %@", regex)
            return test.evaluate(with: self)
        }
    }
    
    var isJapaneseWords: Bool {
        get {
            if self.isEmpty {
                return false
            }
            
            let regex = "^(.{0}|[ぁ-ゞァ-ヶー々〇?\\x{3400}-\\x{9FFF}\\x{F900}-\\x{FAFF}\\x{20000}-\\x{2FFFF}]{1,32})$"
            
            let test = NSPredicate(format:"SELF MATCHES %@", regex)
            return test.evaluate(with: self)
        }
    }
    
    func isValidEmail() -> Bool {
        if self.isEmpty {
            return false
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9]{1,}[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidWebsite() -> Bool {
        if self.isEmpty {
            return false
        }
        
        let validateUrl = URL(string: self)
        if (validateUrl != nil && validateUrl?.host != "") {
            return true
        }
        
        return false
    }
    
    func doesContainSpecialCharacters() -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func substringFromIndex(_ index: Int) -> String {
        return (self as NSString).substring(from: index)
    }
    
    func substringToIndex(_ index: Int) -> String {
        return (self as NSString).substring(to: index)
    }
    
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    func insert(_ string:String,index:Int) -> String {
        return  String(self.characters.prefix(index)) + string + String(self.characters.suffix(self.characters.count-index))
    }
    
    func replace(_ index: Int, _ newChar: Character) -> String {
        var chars = Array(self.characters)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
}

extension NSMutableAttributedString {
    func bold(_ text: String, size: CGFloat = 17) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: size)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normal(_ text: String) -> NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}
