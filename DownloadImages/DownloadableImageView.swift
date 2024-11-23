import UIKit

enum DownloadOptions: Hashable {
    enum From {
        case disk
        case memory
    }
    
    case circle
    case cached(From)
    case resize
}

class ImageCacheState {
    enum State {
        case original(UIImage)
        case rounded(UIImage)
        case resized(UIImage)
        case roundedAndResized(UIImage)
    }
    
    var state: State
    
    init(state: State) {
        self.state = state
    }
}

protocol Downloadable {
    func loadImage(from url: URL, withOptions: [DownloadOptions]) async -> UIImage?
}

class DownloadableImageView: UIImageView, Downloadable {
    
    private let memoryCache = NSCache<NSURL, ImageCacheState>()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
    }

    func loadImage(from url: URL, withOptions: [DownloadOptions]) async -> UIImage? {
        let options = withOptions.removingDuplicates() 
        
        if let cachedState = memoryCache.object(forKey: url as NSURL) {
            switch cachedState.state {
            case .rounded(let image) where options.contains(.circle):
                return image
            case .resized(let image) where options.contains(.resize):
                return image
            case .roundedAndResized(let image) where options.contains(.circle) && options.contains(.resize):
                return image
            case .original(let image) where !options.contains(.circle) && !options.contains(.resize):
                return image
            default:
                break
            }
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            var processedImage = image
            
            for option in options {
                switch option {
                case .resize:
                    processedImage = processedImage.resized(to: self.bounds.size)
                case .circle:
                    processedImage = processedImage.rounded()
                default:
                    break
                }
            }
            
            var cacheState: ImageCacheState
            if options.contains(.circle) && options.contains(.resize) {
                cacheState = ImageCacheState(state: .roundedAndResized(processedImage))
            } else if options.contains(.circle) {
                cacheState = ImageCacheState(state: .rounded(processedImage))
            } else if options.contains(.resize) {
                cacheState = ImageCacheState(state: .resized(processedImage))
            } else {
                cacheState = ImageCacheState(state: .original(processedImage))
            }
            
            memoryCache.setObject(cacheState, forKey: url as NSURL)
            
            return processedImage
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
}

extension UIImage {
    func rounded() -> UIImage {
        let sideLength = max(size.width, size.height)
        let rect = CGRect(origin: .zero, size: CGSize(width: sideLength, height: sideLength))

        UIGraphicsBeginImageContextWithOptions(CGSize(width: sideLength, height: sideLength), false, scale)
        UIBezierPath(ovalIn: rect).addClip()
        draw(in: rect)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage ?? self
    }
    
    func resized(to targetSize: CGSize) -> UIImage {
        print("Resizing image to: \(targetSize)") 
        let aspectWidth = targetSize.width / size.width
        let aspectHeight = targetSize.height / size.height
        let aspectRatio = min(aspectWidth, aspectHeight)

        let newWidth = size.width * aspectRatio
        let newHeight = size.height * aspectRatio
        let newSize = CGSize(width: newWidth, height: newHeight)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
