
import SwiftUI

struct RecipeRow: View {
    var recipe: Recipe
    
    var body: some View {
        HStack {
            LoadableImageView(with: recipe.strMealThumb,
                              placeholder:"").scaledToFit().frame(width:80, height:80).cornerRadius(8.0).padding(8.0)

            VStack(alignment: .leading) {
                Spacer()
                Text(recipe.strMeal).font(.headline).fontWeight(.bold).lineLimit(1)
                Spacer()
            }.padding(8.0)
            Spacer()

        }
    }
}

struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRow(recipe:recipeData[0])
    }
}
