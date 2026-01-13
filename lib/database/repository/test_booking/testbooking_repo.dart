// // ignore_for_file: avoid_print, depend_on_referenced_packages

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:nanohospic/database/app_database.dart';
// import 'package:nanohospic/database/entity/sales/test_booking_entity.dart';

// class TestBookingRepository {
//   final AppDatabase _database;

//   TestBookingRepository(this._database);

//   // ==================== LOCAL DATABASE OPERATIONS ====================

//   Future<List<TestBooking>> getAllBookings() async {
//     try {
//       print('📋 Fetching all bookings from database...');
//       final bookings = await _database.testBookingDao.getAllBookings();
//       print('✅ Found ${bookings.length} bookings');
//       return bookings;
//     } catch (e) {
//       print('❌ Error fetching bookings: $e');
//       return [];
//     }
//   }

//   Future<TestBooking?> getBookingById(int id) async {
//     try {
//       print('🔍 Fetching booking by ID: $id');
//       final booking = await _database.testBookingDao.getBookingById(id);
//       if (booking == null) {
//         print('⚠️ Booking not found with ID: $id');
//       } else {
//         print('✅ Found booking: ${booking.registrationNo}');
//       }
//       return booking;
//     } catch (e) {
//       print('❌ Error fetching booking by ID: $e');
//       return null;
//     }
//   }

//   Future<TestBooking?> getBookingByRegistrationNo(String registrationNo) async {
//     try {
//       print('🔍 Fetching booking by Registration No: $registrationNo');
//       final booking = await _database.testBookingDao.getBookingByRegistrationNo(
//         registrationNo,
//       );
//       if (booking == null) {
//         print('⚠️ Booking not found with Registration No: $registrationNo');
//       } else {
//         print('✅ Found booking: ${booking.patientName}');
//       }
//       return booking;
//     } catch (e) {
//       print('❌ Error fetching booking by Registration No: $e');
//       return null;
//     }
//   }

//   Future<int> insertBooking(TestBooking booking) async {
//     try {
//       print('💾 Inserting booking: ${booking.registrationNo}');
//       final id = await _database.testBookingDao.insertBooking(booking);
//       print('✅ Booking inserted with ID: $id');
//       return id;
//     } catch (e) {
//       print('❌ Error inserting booking: $e');
//       rethrow;
//     }
//   }

//   Future<void> updateBooking(TestBooking booking) async {
//     try {
//       print(
//         '🔄 Updating booking: ${booking.registrationNo} (ID: ${booking.id})',
//       );
//       await _database.testBookingDao.updateBooking(booking);
//       print('✅ Booking updated successfully');
//     } catch (e) {
//       print('❌ Error updating booking: $e');
//       rethrow;
//     }
//   }

//   Future<void> deleteBooking(int id, String deletedBy) async {
//     try {
//       print('🗑️ Deleting booking with ID: $id');
//       await _database.testBookingDao.deleteBooking(id, deletedBy);
//       print('✅ Booking deleted successfully');
//     } catch (e) {
//       print('❌ Error deleting booking: $e');
//       rethrow;
//     }
//   }

//   Future<void> softDeleteBooking(int id, String deletedBy) async {
//     try {
//       print('🗑️ Soft deleting booking with ID: $id');
//       // Get the existing booking first
//       final existingBooking = await getBookingById(id);
//       if (existingBooking != null) {
//         final updatedBooking = TestBooking(
//           id: existingBooking.id,
//           serverId: existingBooking.serverId,
//           registrationNo: existingBooking.registrationNo,
//           mrdNo: existingBooking.mrdNo,
//           date: existingBooking.date,
//           phoneNo: existingBooking.phoneNo,
//           patientName: existingBooking.patientName,
//           gender: existingBooking.gender,
//           age: existingBooking.age,
//           email: existingBooking.email,
//           address: existingBooking.address,
//           doctorReferrer: existingBooking.doctorReferrer,
//           barcode: existingBooking.barcode,
//           tokenNo: existingBooking.tokenNo,
//           assignTo: existingBooking.assignTo,
//           client: existingBooking.client,
//           total: existingBooking.total,
//           billDiscount: existingBooking.billDiscount,
//           totalDiscount: existingBooking.totalDiscount,
//           gst: existingBooking.gst,
//           totalAmount: existingBooking.totalAmount,
//           paidAmount: existingBooking.paidAmount,
//           balance: existingBooking.balance,
//           returnAmount: existingBooking.returnAmount,
//           createdAt: existingBooking.createdAt,
//           createdBy: existingBooking.createdBy,
//           lastModified: DateTime.now().toIso8601String(),
//           lastModifiedBy: deletedBy,
//           isDeleted: 1,
//           deletedBy: deletedBy,
//           isSynced: existingBooking.isSynced,
//           syncStatus: existingBooking.syncStatus,
//           syncAttempts: existingBooking.syncAttempts,
//           lastSyncError: existingBooking.lastSyncError,
//           bookingStatus: 'cancelled',
//           paymentStatus: existingBooking.paymentStatus,
//         );
//         await updateBooking(updatedBooking);
//         print('✅ Booking soft deleted successfully');
//       }
//     } catch (e) {
//       print('❌ Error soft deleting booking: $e');
//       rethrow;
//     }
//   }

//   Future<List<TestBooking>> searchBookings(String query) async {
//     try {
//       print('🔍 Searching bookings for: $query');
//       final results = await _database.testBookingDao.searchBookings('%$query%');
//       print('✅ Found ${results.length} results');
//       return results;
//     } catch (e) {
//       print('❌ Error searching bookings: $e');
//       return [];
//     }
//   }

//   Future<int> getTotalCount() async {
//     try {
//       final count = await _database.testBookingDao.getTotalBookings();
//       return count;
//     } catch (e) {
//       print('❌ Error getting total count: $e');
//       return 0;
//     }
//   }

//   // ==================== BOOKING ITEMS OPERATIONS ====================

//   Future<List<BookingItem>> getBookingItems(int bookingId) async {
//     try {
//       print('📦 Fetching items for booking ID: $bookingId');
//       final items = await _database.bookingItemDao.getItemsByBooking(bookingId);
//       print('✅ Found ${items.length} items');
//       return items;
//     } catch (e) {
//       print('❌ Error fetching booking items: $e');
//       return [];
//     }
//   }

//   Future<void> addBookingItems(List<BookingItem> items) async {
//     try {
//       print('💾 Adding ${items.length} booking items');
//       await _database.bookingItemDao.insertItems(items);
//       print('✅ Booking items added successfully');
//     } catch (e) {
//       print('❌ Error adding booking items: $e');
//       rethrow;
//     }
//   }

//   Future<void> updateBookingItem(BookingItem item) async {
//     try {
//       print('🔄 Updating booking item: ${item.name}');
//       await _database.bookingItemDao.updateItem(item);
//       print('✅ Booking item updated successfully');
//     } catch (e) {
//       print('❌ Error updating booking item: $e');
//       rethrow;
//     }
//   }

//   Future<void> clearBookingItems(int bookingId) async {
//     try {
//       print('🗑️ Clearing items for booking ID: $bookingId');
//       await _database.bookingItemDao.deleteItemsByBooking(bookingId);
//       print('✅ Booking items cleared successfully');
//     } catch (e) {
//       print('❌ Error clearing booking items: $e');
//       rethrow;
//     }
//   }

//   // ==================== PAYMENT DETAILS OPERATIONS ====================

//   Future<List<PaymentDetail>> getBookingPayments(int bookingId) async {
//     try {
//       print('💰 Fetching payments for booking ID: $bookingId');
//       final payments = await _database.paymentDetailDao.getPaymentsByBooking(
//         bookingId,
//       );
//       print('✅ Found ${payments.length} payments');
//       return payments;
//     } catch (e) {
//       print('❌ Error fetching booking payments: $e');
//       return [];
//     }
//   }

//   Future<double> getTotalPaidAmount(int bookingId) async {
//     try {
//       print('💰 Calculating total paid for booking ID: $bookingId');
//       final total = await _database.paymentDetailDao.getTotalPaidAmount(
//         bookingId,
//       );
//       final amount = total ?? 0.0;
//       print('✅ Total paid: ₹$amount');
//       return amount;
//     } catch (e) {
//       print('❌ Error getting total paid amount: $e');
//       return 0.0;
//     }
//   }

//   Future<void> addPaymentDetails(List<PaymentDetail> payments) async {
//     try {
//       print('💾 Adding ${payments.length} payment details');
//       await _database.paymentDetailDao.insertPayments(payments);
//       print('✅ Payment details added successfully');
//     } catch (e) {
//       print('❌ Error adding payment details: $e');
//       rethrow;
//     }
//   }

//   Future<void> updatePaymentDetail(PaymentDetail payment) async {
//     try {
//       print('🔄 Updating payment detail: ${payment.paymentMode}');
//       await _database.paymentDetailDao.updatePayment(payment);
//       print('✅ Payment detail updated successfully');
//     } catch (e) {
//       print('❌ Error updating payment detail: $e');
//       rethrow;
//     }
//   }

//   Future<void> clearPaymentDetails(int bookingId) async {
//     try {
//       print('🗑️ Clearing payments for booking ID: $bookingId');
//       await _database.paymentDetailDao.deletePaymentsByBooking(bookingId);
//       print('✅ Payment details cleared successfully');
//     } catch (e) {
//       print('❌ Error clearing payment details: $e');
//       rethrow;
//     }
//   }

//   // ==================== COMPLEX OPERATIONS ====================

//   Future<Map<String, dynamic>> createCompleteBooking({
//     required TestBooking booking,
//     required List<BookingItem> items,
//     required List<PaymentDetail> payments,
//   }) async {
//     try {
//       print('🚀 Starting complete booking creation...');
//       print(
//         '📝 Booking details: ${booking.registrationNo} - ${booking.patientName}',
//       );
//       print('📦 Items: ${items.length}, 💰 Payments: ${payments.length}');

//       // Start transaction
//       await _database.database.beginTransaction();
//       print('✅ Transaction started');

//       try {
//         // Insert booking
//         final bookingId = await _database.testBookingDao.insertBooking(booking);
//         print('✅ Booking created with ID: $bookingId');

//         // Update items with booking ID
//         final updatedItems = items.map((item) {
//           return BookingItem(
//             bookingId: bookingId,
//             type: item.type,
//             name: item.name,
//             mrp: item.mrp,
//             rate: item.rate,
//             quantity: item.quantity,
//             gstPercent: item.gstPercent,
//             discountPercent: item.discountPercent,
//             amount: item.amount,
//             createdAt: DateTime.now().toIso8601String(),
//             isDeleted: 0,
//             isSynced: 0,
//           );
//         }).toList();

//         if (updatedItems.isNotEmpty) {
//           await _database.bookingItemDao.insertItems(updatedItems);
//           print('✅ ${updatedItems.length} booking items added');
//         }

//         // Update payments with booking ID
//         final updatedPayments = payments.map((payment) {
//           return PaymentDetail(
//             bookingId: bookingId,
//             paymentMode: payment.paymentMode,
//             amount: payment.amount,
//             referenceNo: payment.referenceNo,
//             description: payment.description,
//             paymentDate: DateTime.now(),
//             createdAt: DateTime.now().toIso8601String(),
//             isDeleted: 0,
//             isSynced: 0,
//           );
//         }).toList();

//         if (updatedPayments.isNotEmpty) {
//           await _database.paymentDetailDao.insertPayments(updatedPayments);
//           print('✅ ${updatedPayments.length} payment details added');
//         }

//         // Calculate total paid
//         final totalPaid = updatedPayments.fold(
//           0.0,
//           (sum, payment) => sum + payment.amount,
//         );
//         final balance = booking.totalAmount - totalPaid;
//         final returnAmount = balance < 0 ? balance.abs() : 0;
//         final finalBalance = balance > 0 ? balance : 0;

//         // Update booking with calculated values
//         final updatedBooking = TestBooking(
//           id: bookingId,
//           serverId: booking.serverId,
//           registrationNo: booking.registrationNo,
//           mrdNo: booking.mrdNo,
//           date: booking.date,
//           phoneNo: booking.phoneNo,
//           patientName: booking.patientName,
//           gender: booking.gender,
//           age: booking.age,
//           email: booking.email,
//           address: booking.address,
//           doctorReferrer: booking.doctorReferrer,
//           barcode: booking.barcode,
//           tokenNo: booking.tokenNo,
//           assignTo: booking.assignTo,
//           client: booking.client,
//           total: booking.total,
//           billDiscount: booking.billDiscount,
//           totalDiscount: booking.totalDiscount,
//           gst: booking.gst,
//           totalAmount: booking.totalAmount,
//           paidAmount: totalPaid,
//           balance: finalBalance,
//           returnAmount: returnAmount,
//           createdAt: booking.createdAt,
//           createdBy: booking.createdBy,
//           lastModified: DateTime.now().toIso8601String(),
//           lastModifiedBy: booking.createdBy,
//           isDeleted: booking.isDeleted,
//           deletedBy: booking.deletedBy,
//           isSynced: booking.isSynced,
//           syncStatus: booking.syncStatus,
//           syncAttempts: booking.syncAttempts,
//           lastSyncError: booking.lastSyncError,
//           bookingStatus: booking.bookingStatus,
//           paymentStatus: totalPaid >= booking.totalAmount
//               ? 'completed'
//               : totalPaid > 0
//                   ? 'partial'
//                   : 'pending',
//         );

//         await _database.testBookingDao.updateBooking(updatedBooking);
//         print('✅ Booking updated with payment calculations');

//         // Commit transaction
//         await _database.database.commit();
//         print('✅ Transaction committed successfully');

//         return {
//           'success': true,
//           'bookingId': bookingId,
//           'message': 'Booking created successfully',
//           'booking': updatedBooking,
//           'totalPaid': totalPaid,
//           'balance': finalBalance,
//         };
//       } catch (e) {
//         await _database.database.rollback();
//         print('❌ Transaction rolled back due to error: $e');
//         return {
//           'success': false,
//           'error': 'Failed to create booking: $e',
//           'details': e.toString(),
//         };
//       }
//     } catch (e, stackTrace) {
//       print('❌ Error in createCompleteBooking: $e');
//       print('Stack trace: $stackTrace');
//       return {
//         'success': false,
//         'error': 'Database error: $e',
//         'details': e.toString(),
//       };
//     }
//   }

//   Future<Map<String, dynamic>> getBookingSummary(int bookingId) async {
//     try {
//       print('📊 Getting booking summary for ID: $bookingId');

//       final booking = await getBookingById(bookingId);
//       if (booking == null) {
//         return {
//           'success': false,
//           'error': 'Booking not found with ID: $bookingId',
//         };
//       }

//       final items = await getBookingItems(bookingId);
//       final payments = await getBookingPayments(bookingId);
//       final totalPaid = await getTotalPaidAmount(bookingId);

//       final balance = booking.totalAmount - totalPaid;
//       final paymentStatus = balance <= 0
//           ? 'completed'
//           : totalPaid > 0
//               ? 'partial'
//               : 'pending';

//       // Calculate item summary
//       double itemsTotal = items.fold(0.0, (sum, item) => sum + item.amount);
//       double itemsDiscount = items.fold(
//         0.0,
//         (sum, item) => sum + ((item.mrp - item.rate) * item.quantity),
//       );
//       double itemsGst = items.fold(
//         0.0,
//         (sum, item) => sum + (item.amount * (item.gstPercent / 100)),
//       );

//       return {
//         'success': true,
//         'booking': booking,
//         'items': items,
//         'payments': payments,
//         'summary': {
//           'totalItems': items.length,
//           'itemsTotal': itemsTotal,
//           'itemsDiscount': itemsDiscount,
//           'itemsGst': itemsGst,
//           'totalAmount': booking.totalAmount,
//           'totalPaid': totalPaid,
//           'balance': balance,
//           'paymentStatus': paymentStatus,
//           'bookingStatus': booking.bookingStatus,
//           'patientName': booking.patientName,
//           'registrationNo': booking.registrationNo,
//           'tokenNo': booking.tokenNo,
//           'date': DateFormat('dd/MM/yyyy').format(booking.date),
//         },
//       };
//     } catch (e, stackTrace) {
//       print('❌ Error getting booking summary: $e');
//       print('Stack trace: $stackTrace');
//       return {'success': false, 'error': 'Failed to get booking summary: $e'};
//     }
//   }

//   // ==================== STATISTICS & REPORTS ====================

//   Future<Map<String, dynamic>> getBookingStatistics() async {
//     try {
//       print('📈 Getting booking statistics...');

//       final totalBookings = await _database.testBookingDao.getTotalBookings();
//       final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//       final dailyRevenue = await _database.testBookingDao.getDailyRevenue(
//         today,
//       );

//       // Get status counts
//       final allBookings = await getAllBookings();
//       final pendingCount = allBookings
//           .where((b) => b.bookingStatus == 'pending')
//           .length;
//       final completedCount = allBookings
//           .where((b) => b.bookingStatus == 'completed')
//           .length;
//       final cancelledCount = allBookings
//           .where((b) => b.bookingStatus == 'cancelled')
//           .length;

//       // Calculate monthly revenue
//       final now = DateTime.now();
//       final monthStart = DateTime(now.year, now.month, 1);
//       final monthEnd = DateTime(now.year, now.month + 1, 0);

//       double monthlyRevenue = 0.0;
//       for (var booking in allBookings) {
//         if (booking.date.isAfter(
//               monthStart.subtract(const Duration(days: 1)),
//             ) &&
//             booking.date.isBefore(monthEnd.add(const Duration(days: 1)))) {
//           monthlyRevenue += booking.totalAmount;
//         }
//       }

//       return {
//         'success': true,
//         'statistics': {
//           'totalBookings': totalBookings,
//           'dailyRevenue': dailyRevenue ?? 0.0,
//           'monthlyRevenue': monthlyRevenue,
//           'pendingBookings': pendingCount,
//           'completedBookings': completedCount,
//           'cancelledBookings': cancelledCount,
//           'today': today,
//         },
//       };
//     } catch (e, stackTrace) {
//       print('❌ Error getting booking statistics: $e');
//       print('Stack trace: $stackTrace');
//       return {'success': false, 'error': 'Failed to get statistics: $e'};
//     }
//   }

//   // ==================== GENERATORS ====================

//   Future<String> generateNextRegistrationNo() async {
//     try {
//       final bookings = await getAllBookings();
//       if (bookings.isEmpty) {
//         return 'R0001';
//       }

//       // Extract numeric part from existing registration numbers
//       final numbers = bookings.map((b) {
//         try {
//           final match = RegExp(r'R(\d+)').firstMatch(b.registrationNo);
//           return match != null ? int.parse(match.group(1)!) : 0;
//         } catch (e) {
//           return 0;
//         }
//       }).toList();

//       final maxNumber = numbers.isNotEmpty
//           ? numbers.reduce((a, b) => a > b ? a : b)
//           : 0;
//       final nextNumber = maxNumber + 1;
//       final nextRegNo = 'R${nextNumber.toString().padLeft(4, '0')}';
//       print('🔢 Generated next registration number: $nextRegNo');
//       return nextRegNo;
//     } catch (e) {
//       print('❌ Error generating next registration number: $e');
//       return 'R0001';
//     }
//   }

//   Future<String> generateNextTokenNo() async {
//     try {
//       final bookings = await getAllBookings();
//       if (bookings.isEmpty) {
//         return 'T001';
//       }

//       // Extract numeric part from existing token numbers
//       final numbers = bookings.map((b) {
//         try {
//           final match = RegExp(r'T(\d+)').firstMatch(b.tokenNo);
//           return match != null ? int.parse(match.group(1)!) : 0;
//         } catch (e) {
//           return 0;
//         }
//       }).toList();

//       final maxNumber = numbers.isNotEmpty
//           ? numbers.reduce((a, b) => a > b ? a : b)
//           : 0;
//       final nextNumber = maxNumber + 1;
//       final nextTokenNo = 'T${nextNumber.toString().padLeft(3, '0')}';
//       print('🔢 Generated next token number: $nextTokenNo');
//       return nextTokenNo;
//     } catch (e) {
//       print('❌ Error generating next token number: $e');
//       return 'T001';
//     }
//   }

//   // ==================== SERVER SYNC OPERATIONS ====================

//   Future<List<TestBooking>> getPendingSync() async {
//     try {
//       final allBookings = await getAllBookings();
//       return allBookings.where((b) => b.isSynced == 0).toList();
//     } catch (e) {
//       print('❌ Error getting pending sync: $e');
//       return [];
//     }
//   }

//   Future<void> markAsSynced(int id, int serverId) async {
//     try {
//       final booking = await getBookingById(id);
//       if (booking != null) {
//         final updatedBooking = TestBooking(
//           id: booking.id,
//           serverId: serverId,
//           registrationNo: booking.registrationNo,
//           mrdNo: booking.mrdNo,
//           date: booking.date,
//           phoneNo: booking.phoneNo,
//           patientName: booking.patientName,
//           gender: booking.gender,
//           age: booking.age,
//           email: booking.email,
//           address: booking.address,
//           doctorReferrer: booking.doctorReferrer,
//           barcode: booking.barcode,
//           tokenNo: booking.tokenNo,
//           assignTo: booking.assignTo,
//           client: booking.client,
//           total: booking.total,
//           billDiscount: booking.billDiscount,
//           totalDiscount: booking.totalDiscount,
//           gst: booking.gst,
//           totalAmount: booking.totalAmount,
//           paidAmount: booking.paidAmount,
//           balance: booking.balance,
//           returnAmount: booking.returnAmount,
//           createdAt: booking.createdAt,
//           createdBy: booking.createdBy,
//           lastModified: DateTime.now().toIso8601String(),
//           lastModifiedBy: booking.createdBy,
//           isDeleted: booking.isDeleted,
//           deletedBy: booking.deletedBy,
//           isSynced: 1,
//           syncStatus: 'synced',
//           syncAttempts: booking.syncAttempts,
//           lastSyncError: booking.lastSyncError,
//           bookingStatus: booking.bookingStatus,
//           paymentStatus: booking.paymentStatus,
//         );
//         await updateBooking(updatedBooking);
//         print('✅ Booking marked as synced with server ID: $serverId');
//       }
//     } catch (e) {
//       print('❌ Error marking booking as synced: $e');
//     }
//   }

//   Future<void> updateSyncError(int id, String error) async {
//     try {
//       final booking = await getBookingById(id);
//       if (booking != null) {
//         final syncAttempts = booking.syncAttempts + 1;
//         final updatedBooking = TestBooking(
//           id: booking.id,
//           serverId: booking.serverId,
//           registrationNo: booking.registrationNo,
//           mrdNo: booking.mrdNo,
//           date: booking.date,
//           phoneNo: booking.phoneNo,
//           patientName: booking.patientName,
//           gender: booking.gender,
//           age: booking.age,
//           email: booking.email,
//           address: booking.address,
//           doctorReferrer: booking.doctorReferrer,
//           barcode: booking.barcode,
//           tokenNo: booking.tokenNo,
//           assignTo: booking.assignTo,
//           client: booking.client,
//           total: booking.total,
//           billDiscount: booking.billDiscount,
//           totalDiscount: booking.totalDiscount,
//           gst: booking.gst,
//           totalAmount: booking.totalAmount,
//           paidAmount: booking.paidAmount,
//           balance: booking.balance,
//           returnAmount: booking.returnAmount,
//           createdAt: booking.createdAt,
//           createdBy: booking.createdBy,
//           lastModified: DateTime.now().toIso8601String(),
//           lastModifiedBy: booking.createdBy,
//           isDeleted: booking.isDeleted,
//           deletedBy: booking.deletedBy,
//           isSynced: booking.isSynced,
//           syncStatus: 'failed',
//           syncAttempts: syncAttempts,
//           lastSyncError: error,
//           bookingStatus: booking.bookingStatus,
//           paymentStatus: booking.paymentStatus,
//         );
//         await updateBooking(updatedBooking);
//         print('✅ Updated sync error for booking ID: $id');
//       }
//     } catch (e) {
//       print('❌ Error updating sync error: $e');
//     }
//   }

//   // ==================== UTILITY METHODS ====================

//   Future<List<TestBooking>> getBookingsByDateRange({
//     required DateTime startDate,
//     required DateTime endDate,
//   }) async {
//     try {
//       print(
//         '📅 Getting bookings from ${DateFormat('dd/MM/yyyy').format(startDate)} to ${DateFormat('dd/MM/yyyy').format(endDate)}',
//       );

//       final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
//       final endDateStr = DateFormat('yyyy-MM-dd').format(endDate);

//       final bookings = await _database.testBookingDao.getBookingsByDateRange(
//         startDateStr,
//         endDateStr,
//       );
//       print('✅ Found ${bookings.length} bookings in date range');
//       return bookings;
//     } catch (e) {
//       print('❌ Error getting bookings by date range: $e');
//       return [];
//     }
//   }

//   Future<TestBooking?> getBookingByToken(String tokenNo) async {
//     try {
//       return await _database.testBookingDao.getBookingByTokenNo(tokenNo);
//     } catch (e) {
//       print('❌ Error getting booking by token: $e');
//       return null;
//     }
//   }

//   Future<List<TestBooking>> getBookingsByStatus(String status) async {
//     try {
//       return await _database.testBookingDao.getBookingsByStatus(status);
//     } catch (e) {
//       print('❌ Error getting bookings by status: $e');
//       return [];
//     }
//   }
// }