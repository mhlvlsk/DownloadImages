import Foundation

class ImagesViewModel {
    private let baseURLs: [URL] = [
        URL(string: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-card-40-iphone16prohero-202409?wid=680&hei=528&fmt=p-jpg&qlt=95&.v=1725567335931")!,
        URL(string: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-card-40-iphone16hero-202409?wid=680&hei=528&fmt=p-jpg&qlt=95&.v=1723234230295")!,
        URL(string: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-card-40-iphone15hero-202309?wid=680&hei=528&fmt=p-jpg&qlt=95&.v=1693086290559")!,
        URL(string: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MYYE3?wid=400&hei=400&fmt=jpeg&qlt=90&.v=1723252210691")!,
        URL(string: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MYYP3?wid=400&hei=400&fmt=jpeg&qlt=90&.v=1723593626066")!,
        URL(string: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/airpods-4-anc-select-202409?wid=400&hei=400&fmt=jpeg&qlt=90&.v=1725502639798")!,
        URL(string: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/airpods-max-select-202409-orange?wid=400&hei=400&fmt=jpeg&qlt=90&.v=1724927451265")!,
        URL(string: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MCFM4?wid=400&hei=400&fmt=jpeg&qlt=90&.v=1724013475838")!
    ]
    
    private(set) var imageURLs: [URL] = []
    
    init() {
        randomImages()
    }
    
    func randomImages() {
        imageURLs = (0..<64).compactMap { _ in baseURLs.randomElement() }
    }
}
