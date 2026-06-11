import 'admin_dashboard_page.dart';

class AdminPaymentsPage extends AdminCollectionPage {
  const AdminPaymentsPage({super.key})
      : super(
          collection: 'payments',
          title: 'Payments',
          titleField: 'bookingId',
          statusField: 'status',
        );
}
