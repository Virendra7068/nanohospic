import 'package:floor/floor.dart';

@Entity(tableName: 'test_bookings')
class TestBooking {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  @ColumnInfo(name: 'registration_no')
  final String registrationNo;
  
  @ColumnInfo(name: 'mrd_no')
  final String? mrdNo;
  
  @ColumnInfo(name: 'date') // Store as String in ISO format
  final String date; // Changed from DateTime to String
  
  @ColumnInfo(name: 'phone_no')
  final String? phoneNo;
  
  @ColumnInfo(name: 'patient_name')
  final String patientName;
  
  final String? gender;
  
  final int age;
  
  final String email;
  
  final String? address;
  
  @ColumnInfo(name: 'doctor_referrer')
  final String? doctorReferrer;
  
  final String? barcode;
  
  @ColumnInfo(name: 'token_no')
  final String tokenNo;
  
  @ColumnInfo(name: 'assign_to')
  final String? assignTo;
  
  final String? client;
  
  final double total;
  
  @ColumnInfo(name: 'bill_discount')
  final double billDiscount;
  
  @ColumnInfo(name: 'total_discount')
  final double totalDiscount;
  
  final double gst;
  
  @ColumnInfo(name: 'total_amount')
  final double totalAmount;
  
  @ColumnInfo(name: 'paid_amount')
  final double paidAmount;
  
  final double balance;
  
  @ColumnInfo(name: 'return_amount')
  final double returnAmount;
  
  @ColumnInfo(name: 'created_at')
  final String createdAt;
  
  @ColumnInfo(name: 'created_by')
  final String? createdBy;
  
  @ColumnInfo(name: 'last_modified')
  final String? lastModified;
  
  @ColumnInfo(name: 'last_modified_by')
  final String? lastModifiedBy;
  
  @ColumnInfo(name: 'is_deleted')
  final int isDeleted;
  
  @ColumnInfo(name: 'deleted_by')
  final String? deletedBy;
  
  @ColumnInfo(name: 'is_synced')
  final int isSynced;
  
  @ColumnInfo(name: 'sync_status')
  final String syncStatus;
  
  @ColumnInfo(name: 'sync_attempts')
  final int syncAttempts;
  
  @ColumnInfo(name: 'last_sync_error')
  final String? lastSyncError;
  
  @ColumnInfo(name: 'booking_status')
  final String bookingStatus;
  
  @ColumnInfo(name: 'payment_status')
  final String paymentStatus;

  TestBooking({
    this.id,
    this.serverId,
    required this.registrationNo,
    this.mrdNo,
    required this.date, // Now String
    this.phoneNo,
    required this.patientName,
    this.gender,
    required this.age,
    required this.email,
    this.address,
    this.doctorReferrer,
    this.barcode,
    required this.tokenNo,
    this.assignTo,
    this.client,
    required this.total,
    required this.billDiscount,
    required this.totalDiscount,
    required this.gst,
    required this.totalAmount,
    required this.paidAmount,
    required this.balance,
    required this.returnAmount,
    required this.createdAt,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
    this.isDeleted = 0,
    this.deletedBy,
    this.isSynced = 0,
    this.syncStatus = 'pending',
    this.syncAttempts = 0,
    this.lastSyncError,
    this.bookingStatus = 'pending',
    this.paymentStatus = 'pending',
  });

  // Helper method to get DateTime from string
  DateTime get dateTime => DateTime.parse(date);
  
  // Helper method to create from DateTime
  static TestBooking fromDateTime({
    int? id,
    int? serverId,
    required String registrationNo,
    String? mrdNo,
    required DateTime date,
    String? phoneNo,
    required String patientName,
    String? gender,
    required int age,
    required String email,
    String? address,
    String? doctorReferrer,
    String? barcode,
    required String tokenNo,
    String? assignTo,
    String? client,
    required double total,
    required double billDiscount,
    required double totalDiscount,
    required double gst,
    required double totalAmount,
    required double paidAmount,
    required double balance,
    required double returnAmount,
    required String createdAt,
    String? createdBy,
    String? lastModified,
    String? lastModifiedBy,
    int isDeleted = 0,
    String? deletedBy,
    int isSynced = 0,
    String syncStatus = 'pending',
    int syncAttempts = 0,
    String? lastSyncError,
    String bookingStatus = 'pending',
    String paymentStatus = 'pending',
  }) {
    return TestBooking(
      id: id,
      serverId: serverId,
      registrationNo: registrationNo,
      mrdNo: mrdNo,
      date: date.toIso8601String(),
      phoneNo: phoneNo,
      patientName: patientName,
      gender: gender,
      age: age,
      email: email,
      address: address,
      doctorReferrer: doctorReferrer,
      barcode: barcode,
      tokenNo: tokenNo,
      assignTo: assignTo,
      client: client,
      total: total,
      billDiscount: billDiscount,
      totalDiscount: totalDiscount,
      gst: gst,
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      balance: balance,
      returnAmount: returnAmount,
      createdAt: createdAt,
      createdBy: createdBy,
      lastModified: lastModified,
      lastModifiedBy: lastModifiedBy,
      isDeleted: isDeleted,
      deletedBy: deletedBy,
      isSynced: isSynced,
      syncStatus: syncStatus,
      syncAttempts: syncAttempts,
      lastSyncError: lastSyncError,
      bookingStatus: bookingStatus,
      paymentStatus: paymentStatus,
    );
  }
}


@Entity(tableName: 'payment_details')
class PaymentDetail {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'server_id')
  final int? serverId;
  
  @ColumnInfo(name: 'booking_id')
  final int bookingId;
  
  @ColumnInfo(name: 'payment_mode')
  final String paymentMode;
  
  final double amount;
  
  @ColumnInfo(name: 'reference_no')
  final String? referenceNo;
  
  final String? description;
  
  @ColumnInfo(name: 'payment_date') // Store as String
  final String paymentDate; // Changed from DateTime to String
  
  @ColumnInfo(name: 'created_at')
  final String createdAt;
  
  @ColumnInfo(name: 'created_by')
  final String? createdBy;
  
  @ColumnInfo(name: 'is_deleted')
  final int isDeleted;
  
  @ColumnInfo(name: 'is_synced')
  final int isSynced;

  PaymentDetail({
    this.id,
    this.serverId,
    required this.bookingId,
    required this.paymentMode,
    required this.amount,
    this.referenceNo,
    this.description,
    required this.paymentDate, // Now String
    required this.createdAt,
    this.createdBy,
    this.isDeleted = 0,
    this.isSynced = 0,
  });

  // Helper method to get DateTime from string
  DateTime get paymentDateTime => DateTime.parse(paymentDate);
  
  // Helper method to create from DateTime
  static PaymentDetail fromDateTime({
    int? id,
    int? serverId,
    required int bookingId,
    required String paymentMode,
    required double amount,
    String? referenceNo,
    String? description,
    required DateTime paymentDate,
    required String createdAt,
    String? createdBy,
    int isDeleted = 0,
    int isSynced = 0,
  }) {
    return PaymentDetail(
      id: id,
      serverId: serverId,
      bookingId: bookingId,
      paymentMode: paymentMode,
      amount: amount,
      referenceNo: referenceNo,
      description: description,
      paymentDate: paymentDate.toIso8601String(),
      createdAt: createdAt,
      createdBy: createdBy,
      isDeleted: isDeleted,
      isSynced: isSynced,
    );
  }
}