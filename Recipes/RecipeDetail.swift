
import SwiftUI

struct RecipeDetail: View {
    @ObservedObject var recipeDetailFetcher: RecipeDetailFetcher
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var partialRecipe: Recipe
    
    init(path: String, partialRecipe: Recipe) {
        self.partialRecipe = partialRecipe
        self.recipeDetailFetcher = RecipeDetailFetcher(path: path)
    }
    
    var body: some View {
        stateContent
    }
    
    var stateContent: AnyView {
        switch recipeDetailFetcher.state {
        case .loading:
            return AnyView(
                partial(message: "Loading...")
            )
        case .fetched(let result):
            switch result {
            case .failure(let error):
                return AnyView(
                    partial(message: error.localizedDescription)
                )
            case .success(let recipe):
                return AnyView(
                    ForEach(recipe.meals, id: \.idMeal) { recipe in
                        full(recipe: recipe)
                    }
                )
            }
        }
    }
    
    var fillColor: Color {
        return (colorScheme == ColorScheme.light) ? Color.white : Color.black
    }
    
    func partial(message: String) -> some View {
        return ScrollView {
            VStack {
                HStack {
                    LoadableImageView(with: partialRecipe.strMealThumb).scaledToFill()
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.center)
                
                VStack {
                    Text(partialRecipe.strMeal)
                        .font(.largeTitle)
                    Text(partialRecipe.strMeal)
                }.padding().background(fillColor).cornerRadius(8).offset(y:-30).padding(.bottom, -30)
                Spacer()
                Text(message)
                    .font(.headline)
                    .foregroundColor(Color.blue)
                Spacer()
            }
        }.edgesIgnoringSafeArea(.top)
        
    }
    
    
    func header(recipe: RecipeDescription) -> some View {
        return Group {
            HStack {
                LoadableImageView(with: recipe.strMealThumb ?? "").scaledToFill()
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200, alignment: Alignment.center)
            
            VStack {
                Text(recipe.strMeal ?? "")
                    .font(.largeTitle)
                Spacer()
                Text(recipe.strInstructions ?? "")
                Spacer()
                Spacer()
                Spacer()
                Text("Ingredients & Measurements").font(.body)
                Spacer()
                showIngredients(recipe: recipe)
            }.padding().background(fillColor).cornerRadius(8).offset(y:-30).padding(.bottom, -30)
        }
    }
    
    func showIngredients(recipe:RecipeDescription) -> some View {
        return VStack {
            Text((recipe.strIngredient1 ?? "") + " -" + " " + (recipe.strMeasure1 ?? ""))
            Text((recipe.strIngredient2 ?? "") + " -" + " " + (recipe.strMeasure2 ?? ""))
            Text((recipe.strIngredient3 ?? "") + " -" + " " + (recipe.strMeasure3 ?? ""))
            Text((recipe.strIngredient4 ?? "") + " -" + " " + (recipe.strMeasure4 ?? ""))
            Text((recipe.strIngredient5 ?? "") + " -" + " " + (recipe.strMeasure5 ?? ""))
            Text((recipe.strIngredient6 ?? "") + " -" + " " + (recipe.strMeasure6 ?? ""))
            if recipe.strIngredient7 != nil && recipe.strIngredient7 != "" {
                Text((recipe.strIngredient7 ?? "") + " -" + " " + (recipe.strMeasure7 ?? ""))
            }
            if recipe.strIngredient8 != nil && recipe.strIngredient8 != "" {
                Text((recipe.strIngredient8 ?? "") + " -" + " " + (recipe.strMeasure8 ?? ""))
            }
            if recipe.strIngredient9 != nil && recipe.strIngredient9 != "" {
                Text((recipe.strIngredient9 ?? "") + " -" + " " + (recipe.strMeasure9 ?? ""))
            }
        }
    }
    
    func full(recipe: RecipeDescription) -> some View {
        return Group {
            VStack {
                VStack(alignment: .leading) {
                    TabView {
                        ScrollView {
                            header(recipe:recipe)
                        }.transition(AnyTransition.opacity.animation(.easeInOut))
                    }.padding(0)
                }
            }.edgesIgnoringSafeArea(.top)
            
        }
    }
    
    struct RecipeDetail_Previews: PreviewProvider {
        static var previews: some View {
            RecipeDetail(path: "", partialRecipe: recipeDetails)
        }
    }
}
