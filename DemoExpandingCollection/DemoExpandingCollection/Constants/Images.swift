// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIImage
    typealias Image = UIImage
#elseif os(OSX)
    import AppKit.NSImage
    typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum Asset: String {
    case backgroundImage = "BackgroundImage"
    case closeButton = "CloseButton"
    case dots
    case face1
    case face2
    case heand
    case icons
    case image
    case item0
    case item1
    case item2
    case item3
    case locationButton
    case map
    case pinIcon
    case searchIcon
    case stars
    case title = "Title"

    var image: Image {
        let bundle = Bundle(for: BundleToken.self)
        #if os(iOS) || os(tvOS) || os(watchOS)
            let image = Image(named: rawValue, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            let image = bundle.image(forResource: rawValue)
        #endif
        guard let result = image else { fatalError("Unable to load image \(rawValue).") }
        return result
    }
}

// swiftlint:enable type_body_length

extension Image {
    convenience init!(asset: Asset) {
        #if os(iOS) || os(tvOS) || os(watchOS)
            let bundle = Bundle(for: BundleToken.self)
            self.init(named: asset.rawValue, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            self.init(named: asset.rawValue)
        #endif
    }
}

private final class BundleToken {}
