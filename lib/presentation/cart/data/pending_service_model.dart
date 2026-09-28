class PendingService {
  int? id;
  String? tranId;
  int? serviceId;
  String? serviceAddress;
  String? customerPhone;
  int? totalAmount;
  String? status;
  String? paymentStatus;
  Null? paymentSessionUrl;
  String? createdAt;

  PendingService(
      {this.id,
        this.tranId,
        this.serviceId,
        this.serviceAddress,
        this.customerPhone,
        this.totalAmount,
        this.status,
        this.paymentStatus,
        this.paymentSessionUrl,
        this.createdAt});

  PendingService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tranId = json['tran_id'];
    serviceId = json['service_id'];
    serviceAddress = json['service_address'];
    customerPhone = json['customer_phone'];
    totalAmount = json['total_amount'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    paymentSessionUrl = json['payment_session_url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tran_id'] = this.tranId;
    data['service_id'] = this.serviceId;
    data['service_address'] = this.serviceAddress;
    data['customer_phone'] = this.customerPhone;
    data['total_amount'] = this.totalAmount;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['payment_session_url'] = this.paymentSessionUrl;
    data['created_at'] = this.createdAt;
    return data;
  }
}
