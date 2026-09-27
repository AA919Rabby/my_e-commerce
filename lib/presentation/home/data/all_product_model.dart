class AllProduct {
  int? totalItems;
  int? totalPages;
  int? currentPage;
  int? limit;
  bool? hasNext;
  bool? hasPrevious;
  List<Items>? items;

  AllProduct({
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.limit,
    this.hasNext,
    this.hasPrevious,
    this.items,
  });

  AllProduct.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    totalPages = json['total_pages'];
    currentPage = json['current_page'];
    limit = json['limit'];
    hasNext = json['has_next'];
    hasPrevious = json['has_previous'];

    if (json['items'] != null) {
      items = <Items>[];

      json['items'].forEach((v) {
        items!.add(
          Items.fromJson(v),
        );
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
    <String, dynamic>{};

    data['total_items'] = totalItems;
    data['total_pages'] = totalPages;
    data['current_page'] = currentPage;
    data['limit'] = limit;
    data['has_next'] = hasNext;
    data['has_previous'] = hasPrevious;

    if (items != null) {
      data['items'] =
          items!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Items {
  int? id;
  String? title;
  String? category;
  String? description;
  int? priceBdt;
  int? stock;
  String? imageUrl;
  String? locationArea;
  int? servicePersons;
  bool? isAvailable;
  int? rating;
  int? totalReviews;

  Items({
    this.id,
    this.title,
    this.category,
    this.description,
    this.priceBdt,
    this.stock,
    this.imageUrl,
    this.locationArea,
    this.servicePersons,
    this.isAvailable,
    this.rating,
    this.totalReviews,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category = json['category'];
    description = json['description'];

    priceBdt =
        (json['price_bdt'] as num?)?.toInt();

    stock = json['stock'];

    imageUrl = json['image_url'];

    locationArea = json['location_area'];

    servicePersons =
    json['service_persons'];

    isAvailable =
    json['is_available'];

    rating =
        (json['rating'] as num?)?.toInt();

    totalReviews =
    json['total_reviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =
    <String, dynamic>{};

    data['id'] = id;
    data['title'] = title;
    data['category'] = category;
    data['description'] = description;
    data['price_bdt'] = priceBdt;
    data['stock'] = stock;
    data['image_url'] = imageUrl;
    data['location_area'] = locationArea;
    data['service_persons'] = servicePersons;
    data['is_available'] = isAvailable;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;

    return data;
  }
}