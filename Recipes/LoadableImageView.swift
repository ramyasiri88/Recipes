import SwiftUI

struct LoadableImageView: View {
    @ObservedObject var imageFetcher: ImageFetcher
    var placeholder: String
    
    init(with urlString: String, placeholder: String = "") {
        imageFetcher = ImageFetcher(url: urlString)
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let image = UIImage(data: imageFetcher.data) {
            return AnyView(
                Image(uiImage: image).resizable().renderingMode(.original)
            )
        } else {
            return AnyView(
                Text(placeholder)
                    .font(Font.system(size: 100))
                    .frame(width: 400, height: 400, alignment: Alignment.center)
            )
        }
    }
}
