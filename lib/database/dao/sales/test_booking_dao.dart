// import 'package:floor/floor.dart';
// import 'package:nanohospic/database/entity/sales/test_booking_entity.dart';

// @dao
// abstract class TestBookingDao {
//   @Query('SELECT * FROM test_bookings WHERE is_deleted = 0 ORDER BY date DESC')
//   Future<List<TestBooking>> getAllBookings();

//   @Query('SELECT * FROM test_bookings WHERE id = :id AND is_deleted = 0')
//   Future<TestBooking?> getBookingById(int id);

//   @Query('SELECT * FROM test_bookings WHERE registration_no = :registrationNo AND is_deleted = 0')
//   Future<TestBooking?> getBookingByRegistrationNo(String registrationNo);

//   @Query('SELECT * FROM test_bookings WHERE token_no = :tokenNo AND is_deleted = 0')
//   Future<TestBooking?> getBookingByTokenNo(String tokenNo);

//   @Query('SELECT * FROM test_bookings WHERE server_id = :serverId AND is_deleted = 0')
//   Future<TestBooking?> getBookingByServerId(int serverId);

//   @Query('''
//     SELECT * FROM test_bookings 
//     WHERE (patient_name LIKE :search OR registration_no LIKE :search OR token_no LIKE :search)
//     AND is_deleted = 0 
//     ORDER BY date DESC
//   ''')
//   Future<List<TestBooking>> searchBookings(String search);

//   @insert
//   Future<int> insertBooking(TestBooking booking);

//   @Update(onConflict: OnConflictStrategy.replace)
//   Future<void> updateBooking(TestBooking booking);

//   @Query('UPDATE test_bookings SET is_deleted = 1, deleted_by = :deletedBy WHERE id = :id')
//   Future<void> deleteBooking(int id, String deletedBy);

//   @Query('SELECT COUNT(*) FROM test_bookings WHERE is_deleted = 0')
//   Future<int> getTotalBookings();

//   @Query('''
//     SELECT SUM(total_amount) FROM test_bookings 
//     WHERE date(date) = date(:date) AND is_deleted = 0
//   ''')
//   Future<double?> getDailyRevenue(String date);

//   // ADD THESE MISSING METHODS:
//   @Query('''
//     SELECT * FROM test_bookings 
//     WHERE date BETWEEN :startDate AND :endDate
//     AND is_deleted = 0
//     ORDER BY date DESC
//   ''')
//   Future<List<TestBooking>> getBookingsByDateRange(String startDate, String endDate);

//   @Query('''
//     SELECT * FROM test_bookings 
//     WHERE booking_status = :status
//     AND is_deleted = 0
//     ORDER BY date DESC
//   ''')
//   Future<List<TestBooking>> getBookingsByStatus(String status);
// }

// @dao
// abstract class BookingItemDao {
//   @Query('SELECT * FROM booking_items WHERE booking_id = :bookingId AND is_deleted = 0')
//   Future<List<BookingItem>> getItemsByBooking(int bookingId);

//   @Query('''
//     SELECT bi.* FROM booking_items bi
//     INNER JOIN test_bookings tb ON bi.booking_id = tb.id
//     WHERE tb.registration_no = :registrationNo 
//     AND bi.is_deleted = 0
//     AND tb.is_deleted = 0
//   ''')
//   Future<List<BookingItem>> getItemsByRegistrationNo(String registrationNo);

//   @insert
//   Future<int> insertItem(BookingItem item);

//   @insert
//   Future<List<int>> insertItems(List<BookingItem> items);

//   @Update(onConflict: OnConflictStrategy.replace)
//   Future<void> updateItem(BookingItem item);

//   @Query('UPDATE booking_items SET is_deleted = 1 WHERE booking_id = :bookingId')
//   Future<void> deleteItemsByBooking(int bookingId);
// }

// @dao
// abstract class PaymentDetailDao {
//   @Query('SELECT * FROM payment_details WHERE booking_id = :bookingId AND is_deleted = 0')
//   Future<List<PaymentDetail>> getPaymentsByBooking(int bookingId);

//   @Query('SELECT SUM(amount) FROM payment_details WHERE booking_id = :bookingId AND is_deleted = 0')
//   Future<double?> getTotalPaidAmount(int bookingId);

//   @insert
//   Future<int> insertPayment(PaymentDetail payment);

//   @insert
//   Future<List<int>> insertPayments(List<PaymentDetail> payments);

//   @Update(onConflict: OnConflictStrategy.replace)
//   Future<void> updatePayment(PaymentDetail payment);

//   @Query('UPDATE payment_details SET is_deleted = 1 WHERE booking_id = :bookingId')
//   Future<void> deletePaymentsByBooking(int bookingId);
// }