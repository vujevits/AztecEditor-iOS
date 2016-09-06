import Foundation


/// Custom text attachment.
///
public class AztecTextAttachment: NSTextAttachment
{
    /// Identifier used to match this attachment with a custom UIView subclass
    ///
    private(set) public var identifier: String

    /// Attachment Kind
    ///
    public var kind: Kind?

    /// Attachment Alignment
    ///
    public var alignment: Alignment = .Center

    /// Attachment Size
    ///
    public var size: Size = .Maximum

    /// Attachments Manager
    ///
    weak var manager: AztecAttachmentManager?


    /// Designed Initializer
    ///
    public init(identifier: String) {
        self.identifier = identifier
        super.init(data: nil, ofType: nil)
    }

    /// Required Initializer
    ///
    required public init?(coder aDecoder: NSCoder) {
        identifier = ""
        super.init(coder: aDecoder)
    }

    /// Returns the "Onscreen Character Size" of the attachment range. When we're in Alignment.None,
    /// the attachment will be 'Inline', and thus, we'll return the actual Associated View Size.
    /// Otherwise, we'll always take the whole container's width.
    ///
    public override func attachmentBoundsForTextContainer(textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        let associatedViewSize = manager?.viewForAttachment(self)?.frame.size ?? CGSizeZero
        let characterSize: CGSize

        switch alignment {
        case .None:
            characterSize = associatedViewSize
        default:
            characterSize = CGSizeMake(lineFrag.width, associatedViewSize.height)
        }

        return CGRect(origin: CGPointZero, size: characterSize)
    }
}



/// Nested Types
///
extension AztecTextAttachment
{
    /// Alignment
    ///
    public enum Alignment {
        case None
        case Left
        case Center
        case Right
    }

    /// Supported Media
    ///
    public enum Kind {
        case Image(image: UIImage)
    }

    /// Size Onscreen!
    ///
    public enum Size {
        case Thumbnail
        case Medium
        case Large
        case Maximum

        var targetWidth: CGFloat {
            switch self {
            case .Thumbnail: return Settings.thumbnail
            case .Medium: return Settings.medium
            case .Large: return Settings.large
            case .Maximum: return Settings.maximum
            }
        }

        private struct Settings {
            static let thumbnail = CGFloat(135)
            static let medium = CGFloat(270)
            static let large = CGFloat(360)
            static let maximum = CGFloat.max
        }
    }
}
