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
    "orders": List<dynamic>.from(orders.map((x) => x.toMap())),
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

