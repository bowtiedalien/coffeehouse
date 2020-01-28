import 'dart:convert';

class Test {
  List<Order> orders;

  Test({
    this.orders,
  });

  factory Test.fromJson(String str) => Test.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Test.fromMap(Map<String, dynamic> json) => Test(
    orders: List<Order>.from(json["orders"].map((x) => Order.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "orders": List<dynamic>.from(orders.map((x) => x.toMap(),),),
  };
}

class Order {
  String coffeeName;
  String cupSize;
  int flavour;

  Order({
    this.coffeeName,
    this.cupSize,
    this.flavour,
  });

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
    coffeeName: json["coffee_name"],
    cupSize: json["cup_size"],
    flavour: json["flavour"],
  );

  Map<String, dynamic> toMap() => {
    "coffee_name": coffeeName,
    "cup_size": cupSize,
    "flavour": flavour,
  };
}


class Products {
  List<Product> product;

  Products({
    this.product,
  });

  factory Products.fromJson(String str) => Products.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Products.fromMap(Map<String, dynamic> json) => Products(
    product: List<Product>.from(json["product"].map((x) => Product.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "product": List<dynamic>.from(product.map((x) => x.toMap())),
  };
}

// product model class
class Product {
  String name;
  String picture;
  int price;
  String description;
  String ingredients;

  Product({
    this.name,
    this.picture,
    this.price,
    this.description,
    this.ingredients,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  //used for getting data from the network - data is in JSON format, we get it and put it in Map format
  factory Product.fromMap(Map<String, dynamic> json) => Product(
    name: json["name"],
    picture: json["picture"],
    price: json["price"] is String ? int.parse(json["price"]) : json["price"], //sometimes, data might come as int and sometimes it might comes as String.
    //The above line is how we handle both conditions. Why does it sometimes come as int and sometimes as String? Because there are instances in the database
    //where I entered the price as string and other times I entered the price as int! Smart Sarah!
    description: json["description"],
    ingredients: json["ingredients"],
  );

  //used for sending data over the network
  Map<String, dynamic> toMap() => {
    "name": name,
    "picture": picture,
    "price": price,
    "description": description,
    "ingredients": ingredients,
  };

  void printOut()
  {
    print(this.name);
    print(this.price.toString());
  }
}
