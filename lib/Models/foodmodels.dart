class FoodModel {
  //
  //Field
  late String? food_id;
  late String food_name,
      food_image,
      food_video,
      food_level,
      food_ingredients,
      food_solution,
      food_type,
      food_description,
      food_time,
      food_nation,
      food_point,
      user_id;
  //Method
  FoodModel(
      this.food_id,
      this.food_name,
      this.food_image,
      this.food_video,
      this.food_level,
      this.food_ingredients,
      this.food_solution,
      this.food_type,
      this.food_description,
      this.food_time,
      this.food_nation,
      this.food_point,
      this.user_id);

  FoodModel.fromMap(Map<String, dynamic> dataMap) {
    // food_id = dataMap['Food_id'];
    // food_name = dataMap['Food_Name'];
    // food_image = dataMap['Food_Image'];
    // food_video = dataMap['Food_Video'];
    // food_level = dataMap['Food_Level'];
    // food_ingredients = dataMap['Food_Ingredients'];
    // food_solution = dataMap['Food_Solution'];
    // food_type = dataMap['Food_Type'];
    // food_description = dataMap['Food_Description'];
    // food_time = dataMap['Food_Time'];
    // food_nation = dataMap['Food_Nation'];
    // food_point = dataMap['Food_Point'];
    // user_id = dataMap['User_id'];

    // food_id = dataMap['Food_id'];
    // food_name = dataMap['Food_Name'] ?? '';
    // food_image = dataMap['Food_Image'];
    // //food_video = dataMap['Food_Video'];
    // //food_level = dataMap['Food_Level'];
    // food_ingredients = dataMap['Food_Ingredients'];
    // //food_solution = dataMap['Food_Solution'];
    // //food_type = dataMap['Food_Type'];
    // food_description = dataMap['Food_Description'];
    // //food_time = dataMap['Food_Time'];
    // //food_nation = dataMap['Food_Nation'];
    // //food_point = dataMap['Food_Point'];
    // user_id = dataMap['User_id'];

    food_id = dataMap['Food_id'];
    food_name = dataMap['Food_Name'] ?? '';
    food_image = dataMap['Food_Image']; // Exception
    //food_video = dataMap['Food_Video'];
    food_level = dataMap['Food_Level'] ?? '';
    food_ingredients = dataMap['Food_Ingredients'] ?? '';
    food_solution = dataMap['Food_Solution'] ?? '';
    food_type = dataMap['Food_Type'] ?? '';
    food_description = dataMap['Food_Description'] ?? '';
    food_time = dataMap['Food_Time'] ?? '';
    food_nation = dataMap['Food_Nation'] ?? '';
    food_point = dataMap['Food_Point'] ?? '';
    user_id = dataMap['User_id'];
    // user_id = "Worapong";
  } //setter

  Map<String, dynamic> toJson() => {
        'Food_id': food_id,
        'Food_Name': food_name,
        'Food_Image': food_image,
        'Food_Video': food_video,
        'Food_Level': food_level,
        'Food_Ingredients': food_ingredients,
        'Food_Solution': food_solution,
        'Food_Type': food_type,
        'Food_Description': food_description,
        'Food_Time': food_time,
        'Food_Nation': food_nation,
        'Food_Point': food_point,
      };
}
