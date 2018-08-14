//
//  StringExtensions.swift
//  ZiShu
//
//  Created by CodingDoge on 2018/6/10.
//  Copyright © 2018年 Kuixi Song. All rights reserved.
//

extension String {
    func urlAllowedEncoding() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    func isValidPhone() -> Bool {
        return String.isValid("^[0-9]{11}$", in: self)
    }
    
    func isVaildValidateCode() -> Bool {
        return String.isValid("^[0-9]{0,6}", in: self)
    }
    
    func isValidPassword() -> Bool {
        return String.isValid("^[A-Za-z0-9]{6,20}+$", in: self)
    }
    
    func isDigit() -> Bool {
        return String.isValid("^[0-9]*$", in: self)
    }
    
    private static func isValid(_ regexString: String, in newString: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: regexString,
                                             options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let numberOfMatches = regex?.numberOfMatches(in: newString,
                                                     options:NSRegularExpression.MatchingOptions.reportProgress,
                                                     range: NSRange.init(location: 0, length: (newString as NSString).length))
        return numberOfMatches != 0
    }
    
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            
            return String(self[startIndex..<endIndex])
        }
    }
    
    var unicodeStr: String {
        
        let tempStr1 = replacingOccurrences(of: "\\U", with: "\\u")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\\\"", with: "\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: .utf8)
        var returnStr:String = ""
        do {
            returnStr = (try String(data: PropertyListSerialization.data(fromPropertyList: tempData!, format: PropertyListSerialization.PropertyListFormat.openStep, options: PropertyListSerialization.WriteOptions.bitWidth), encoding: String.Encoding.utf8))!
            
//            returnStr = try NSPropertyListSerialization.propertyListWithData(tempData!, options: .Immutable, format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    
    func calculateWidth(withFontSize fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func calculateTextHeight(withFont font: UIFont, width: CGFloat = 300) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font : font], context: nil)
        return ceil(rect.height)
    }
    
    func calculateTextHeight(withFont font: UIFont, width: CGFloat = 300, maxHeight: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return ceil(rect.height) > maxHeight ? maxHeight : ceil(rect.height)
    }
}
