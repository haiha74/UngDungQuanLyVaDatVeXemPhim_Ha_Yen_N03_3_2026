import 'admin_dashboard_page.dart';

class AdminBookingsPage extends AdminCollectionPage {
  const AdminBookingsPage({super.key})
      : super(
          collection: 'bookings',
          title: 'Bookings',
          statusField: 'status',
        );
        
}
