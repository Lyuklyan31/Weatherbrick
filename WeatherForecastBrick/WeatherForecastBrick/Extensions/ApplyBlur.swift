import UIKit

extension UIImage {
    func applyBlur(radius: CGFloat) -> UIImage? {
        let context = CIContext()
        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
      
        let beginImage = CIImage(image: self)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let output = currentFilter.outputImage,
              let cgImage = context.createCGImage(output, from: output.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
