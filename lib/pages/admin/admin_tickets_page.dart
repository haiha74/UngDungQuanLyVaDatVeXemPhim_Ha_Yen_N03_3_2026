import 'admin_dashboard_page.dart';

class AdminTicketsPage extends AdminCollectionPage {
  const AdminTicketsPage({super.key})
      : super(
          collection: 'tickets',
          title: 'Tickets',
          titleField: 'ticketCode',
          statusField: 'status',
        );
}
