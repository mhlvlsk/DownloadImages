import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    
    private let imageView: DownloadableImageView = {
        let view = DownloadableImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var task: Task<Void, Never>?

    func configure(with url: URL, options: [DownloadOptions]) {
        Task { [weak self] in
            guard let self = self else { return }
            
            if let image = await imageView.loadImage(from: url, withOptions: options) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}
