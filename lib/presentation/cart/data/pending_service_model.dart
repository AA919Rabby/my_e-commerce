class PendingService {
  final int? id;
  final String? tranId;
  final int? serviceId;
  final String? serviceAddress;
  final String? customerPhone;
  final double? totalAmount;
  final String? status;
  final String? paymentStatus;
  final String? paymentSessionUrl;

  PendingService({
    this.id,
    this.tranId,
    this.serviceId,
    this.serviceAddress,
    this.customerPhone,
    this.totalAmount,
    this.status,
    this.paymentStatus,
    this.paymentSessionUrl,
  });

  factory PendingService.fromJson(Map<String, dynamic> json) {
    return PendingService(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      tranId: json['tran_id']?.toString(),
      serviceId: json['service_id'] is int
          ? json['service_id']
          : int.tryParse(json['service_id']?.toString() ?? ''),
      serviceAddress: json['service_address']?.toString(),
      customerPhone: json['customer_phone']?.toString(),
      totalAmount: json['total_amount'] != null
          ? double.tryParse(json['total_amount'].toString())
          : null,
      status: json['status']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      // Typed as String? instead of Null so string URLs are parsed safely
      paymentSessionUrl: json['payment_session_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tran_id': tranId,
      'service_id': serviceId,
      'service_address': serviceAddress,
      'customer_phone': customerPhone,
      'total_amount': totalAmount,
      'status': status,
      'payment_status': paymentStatus,
      'payment_session_url': paymentSessionUrl,
    };
  }
}