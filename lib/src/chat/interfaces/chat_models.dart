class ModelsCompletionResponse {
  final List<Model> data;

  ModelsCompletionResponse({
    required this.data,
  });

  ModelsCompletionResponse.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List)
            .map((e) => Model.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class Model {
  final String id;
  final String object;
  final String ownedBy;
  final Map<String, dynamic>? permissions;

  Model({
    required this.id,
    required this.object,
    required this.ownedBy,
    required this.permissions,
  });

  Model.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        object = json['object'],
        ownedBy = json['owned_by'],
        permissions = json['permissions'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'object': object,
        'owned_by': ownedBy,
        'permissions': permissions,
      };
}
