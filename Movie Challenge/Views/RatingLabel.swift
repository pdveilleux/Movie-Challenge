import SwiftUI

struct RatingLabel: View {
    let rating: Double
    
    var body: some View {
        Label("\(rating.formatted(.number.precision(.significantDigits(2))))", systemImage: "star.fill")
            .labelStyle(.titleAndIcon)
            .font(.callout)
    }
}

struct RatingLabel_Previews: PreviewProvider {
    static var previews: some View {
        RatingLabel(rating: 8.7)
    }
}
