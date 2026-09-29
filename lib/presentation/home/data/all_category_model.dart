class AllCategory {
  List<Result>? result;

  AllCategory({this.result});

  AllCategory.fromJson(dynamic json) {
    if (json is List) {
      result = <Result>[];

      for (final item in json) {
        result!.add(
          Result(
            name: item.toString(),
          ),
        );
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result?.map((v) => v.name).toList(),
    };
  }
}

class Result {
  String? name;

  Result({this.name});

  Result.fromJson(dynamic json) {
    if (json is String) {
      name = json;
    } else if (json is Map<String, dynamic>) {
      name = json['name'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}