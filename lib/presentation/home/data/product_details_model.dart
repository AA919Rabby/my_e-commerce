class ProductDetails {
  bool? success;
  String? message;
  Result? result;

  ProductDetails({this.success, this.message, this.result});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? id;
  String? name;
  List<String>? images;
  String? description;
  int? price;
  String? brand;
  int? quantity;
  String? availability;
  String? productCategory;
  Null? technicalSpecification;
  Null? physicalSpecification;
  Null? warrantyInformation;
  int? rating;
  String? createdAt;
  String? updatedAt;
  List<Varients>? varients;
  List<Reviews>? reviews;

  Result(
      {this.id,
        this.name,
        this.images,
        this.description,
        this.price,
        this.brand,
        this.quantity,
        this.availability,
        this.productCategory,
        this.technicalSpecification,
        this.physicalSpecification,
        this.warrantyInformation,
        this.rating,
        this.createdAt,
        this.updatedAt,
        this.varients,
        this.reviews});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    images = json['images'].cast<String>();
    description = json['description'];
    price = json['price'];
    brand = json['brand'];
    quantity = json['quantity'];
    availability = json['availability'];
    productCategory = json['productCategory'];
    technicalSpecification = json['technicalSpecification'];
    physicalSpecification = json['physicalSpecification'];
    warrantyInformation = json['warrantyInformation'];
    rating = json['rating'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['varients'] != null) {
      varients = <Varients>[];
      json['varients'].forEach((v) {
        varients!.add(new Varients.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['images'] = this.images;
    data['description'] = this.description;
    data['price'] = this.price;
    data['brand'] = this.brand;
    data['quantity'] = this.quantity;
    data['availability'] = this.availability;
    data['productCategory'] = this.productCategory;
    data['technicalSpecification'] = this.technicalSpecification;
    data['physicalSpecification'] = this.physicalSpecification;
    data['warrantyInformation'] = this.warrantyInformation;
    data['rating'] = this.rating;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.varients != null) {
      data['varients'] = this.varients!.map((v) => v.toJson()).toList();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Varients {
  String? id;
  String? productId;
  int? quantity;
  String? color;
  Null? size;
  String? createdAt;
  String? updatedAt;

  Varients(
      {this.id,
        this.productId,
        this.quantity,
        this.color,
        this.size,
        this.createdAt,
        this.updatedAt});

  Varients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    quantity = json['quantity'];
    color = json['color'];
    size = json['size'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['quantity'] = this.quantity;
    data['color'] = this.color;
    data['size'] = this.size;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Reviews {
  String? id;
  int? rating;
  String? comment;
  String? createdAt;
  String? updatedAt;
  String? productId;
  String? userId;
  User? user;

  Reviews(
      {this.id,
        this.rating,
        this.comment,
        this.createdAt,
        this.updatedAt,
        this.productId,
        this.userId,
        this.user});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    productId = json['productId'];
    userId = json['userId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['productId'] = this.productId;
    data['userId'] = this.userId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;

  User({this.firstName, this.lastName, this.email, this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['profileImage'] = this.profileImage;
    return data;
  }
}
