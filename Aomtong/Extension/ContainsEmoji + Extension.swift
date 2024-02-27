//
//  ContainsEmoji + Extension.swift
//  LUMPSUM
//
//  Created by Kritsanun Wisessuk on 17/10/2566 BE.
//  Copyright © 2566 BE OnlineAsset. All rights reserved.
//

import UIKit
import CoreFoundation
import CoreGraphics
import CoreText

class EmojiUtilities {
    
    static var emojiCharacterSet = EmojiUtilities.getCharacterSet()
    
    class func getCharacterSet() -> CFMutableCharacterSet? {
        let nullPtr: UnsafePointer<CGAffineTransform>? = nil
        let set = CFCharacterSetCreateMutableCopy(kCFAllocatorDefault, CTFontCopyCharacterSet(CTFontCreateWithName("AppleColorEmoji" as CFString, 0.0, nullPtr)))
        CFCharacterSetRemoveCharactersInString(set, " 0123456789#*" as CFString);
        return set
    }

    class func containsEmoji(emoji: String) -> Bool {
        let nullPtr: UnsafeMutablePointer<CFRange>? = nil
        return CFStringFindCharacterFromSet(emoji as CFString, emojiCharacterSet, CFRangeMake(0, CFStringGetLength(emoji as CFString)), CFStringCompareFlags(rawValue: 0), nullPtr);
    }
    
}
