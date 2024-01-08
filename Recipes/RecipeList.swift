
import SwiftUI

struct RecipeList: View {
    @ObservedObject var recipeListFetcher = RecipeListFetcher()

    var stateContent: AnyView {
        switch recipeListFetcher.state {
        case .loading:
            return AnyView(Text("Loading"))
        case .fetched(let result):
            switch result {
            case .failure(let error):
                return AnyView(
                    Text(error.localizedDescription)
                )
            case .success(let response):
                return AnyView(
                    //List {  
                    ForEach(response.meals, id: \.idMeal) { recipe in
                        NavigationLink(
                            destination: RecipeDetail(path: recipe.idMeal, partialRecipe: recipe)
                        ) {
                            RecipeRow(recipe: recipe)
                        }.buttonStyle(PlainButtonStyle())
                    //}
                    }
                )
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    stateContent
                    Spacer()
                }
                .navigationBarTitle(Text("Recipes"))
            }
        }
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 11 Pro"], id: \.self) { deviceName in
            RecipeList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
