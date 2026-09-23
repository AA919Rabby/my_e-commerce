class AllProduct {
  bool? success;
  String? message;
  Result? result;

  AllProduct({
    this.success,
    this.message,
    this.result,
  });

  AllProduct.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    result = json['result'] != null
        ? Result.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
    <String, dynamic>{};

    data['success'] = success;
    data['message'] = message;

    if (result != null) {
      data['result'] = result!.toJson();
    }

    return data;
  }
}

class Result {
  Meta? meta;
  List<Result>? result;

  String? id;
  String? name;
  List<String>? images;
  double? price;
  String? description;
  String? brand;
  String? productCategory;
  int? quantity;
  String? availability;

  Result({
    this.meta,
    this.result,
    this.id,
    this.name,
    this.images,
    this.price,
    this.description,
    this.brand,
    this.productCategory,
    this.quantity,
    this.availability,
  });

  Result.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null
        ? Meta.fromJson(json['meta'])
        : null;

    if (json['result'] != null) {
      result = <Result>[];

      json['result'].forEach((v) {
        result!.add(
          Result.fromJson(v),
        );
      });
    }

    id = json['id'];
    name = json['name'];

    if (json['images'] != null) {
      images = <String>[];

      json['images'].forEach((v) {
        images!.add(v.toString());
      });
    }

    if (json['price'] != null) {
      price = double.tryParse(
        json['price'].toString(),
      );
    }

    description = json['description'];
    brand = json['brand'];
    productCategory = json['productCategory'];
    quantity = json['quantity'];
    availability = json['availability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
    <String, dynamic>{};

    if (meta != null) {
      data['meta'] = meta!.toJson();
    }

    if (result != null) {
      data['result'] =
          result!.map((v) => v.toJson()).toList();
    }

    data['id'] = id;
    data['name'] = name;
    data['images'] = images;
    data['price'] = price;
    data['description'] = description;
    data['brand'] = brand;
    data['productCategory'] = productCategory;
    data['quantity'] = quantity;
    data['availability'] = availability;

    return data;
  }
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPages;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
    <String, dynamic>{};

    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    data['totalPages'] = totalPages;

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

  Varients({
    this.id,
    this.productId,
    this.quantity,
    this.color,
    this.size,
    this.createdAt,
    this.updatedAt,
  });

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
    final Map<String, dynamic> data =
    <String, dynamic>{};

    data['id'] = id;
    data['productId'] = productId;
    data['quantity'] = quantity;
    data['color'] = color;
    data['size'] = size;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }
}