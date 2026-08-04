
class CategoryModel {


  final String id;
  final String name;
  final String icon;
  final String color;



  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    required this.icon
  });


  factory CategoryModel.fromJson(Map<String,dynamic> json){
    return CategoryModel(
        id: json['id'],
        name: json['name'],
        color: json['color'],
        icon: json['icon']
    );

  }


}