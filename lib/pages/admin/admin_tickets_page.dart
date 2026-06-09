import 'admin_dashboard_page.dart';

class AdminTicketsPage extends AdminCollectionPage {
  const AdminTicketsPage({super.key})
      : super(
          collection: 'tickets',
          title: 'Tickets',
          statusField: 'status',
        );
}
