class ProductDetails {
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
  List<dynamic>? reviews;

  ProductDetails({
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
    this.reviews,
  });

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category = json['category'];
    description = json['description'];
    priceBdt = (json['price_bdt'] as num?)?.toInt();
    stock = json['stock'];
    imageUrl = json['image_url'];
    locationArea = json['location_area'];
    servicePersons = json['service_persons'];
    isAvailable = json['is_available'];
    rating = (json['rating'] as num?)?.toInt();
    totalReviews = json['total_reviews'];

    if (json['reviews'] != null) {
      reviews = List<dynamic>.from(json['reviews']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

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

    if (reviews != null) {
      data['reviews'] = reviews;
    }

    return data;
  }
}