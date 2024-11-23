import UIKit

class ImagesViewController: UIViewController, UICollectionViewDataSource {
    private let viewModel = ImagesViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemsInRow: CGFloat = 4
        let spacing: CGFloat = 5
        let totalSpacing = spacing * (itemsInRow - 1)
        let padding: CGFloat = 10
        
        let itemWidth = (view.bounds.width - totalSpacing - (padding * 2)) / itemsInRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.frame = view.bounds
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        let url = viewModel.imageURLs[indexPath.item]
        cell.configure(with: url, options: [.circle, .cached(.memory), .resize])
        return cell
    }
}
