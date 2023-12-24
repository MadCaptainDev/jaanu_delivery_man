// ignore_for_file: non_constant_identifier_names

class IncentiveModel {
  int? id;
  double? single_amount;
  double? start_km;
  double? end_km;
  double? total_amount;
  int? status;
  String? created_at;
  String? updated_at;

  IncentiveModel(
      {this.id,
      this.single_amount,
      this.start_km,
      this.end_km,
      this.total_amount,
      this.created_at,
      this.updated_at,
      this.status});

  IncentiveModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    single_amount = json['single_amount'].toDouble();
    start_km = json['start_km'].toDouble();
    end_km = json['end_km'].toDouble();
    total_amount = json['total_amount'].toDouble();
    status = json['status'];
    created_at = json['created_at'].toString();
    updated_at = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['single_amount'] = single_amount;
    data['start_km'] = start_km;
    data['end_km'] = end_km;
    data['total_amount'] = total_amount;
    data['status'] = status;
    data['created_at'] = created_at;
    data['updated_at'] = updated_at;
    return data;
  }
}
