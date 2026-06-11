import 'admin_dashboard_page.dart';

class AdminRoomsPage extends AdminCollectionPage {
  const AdminRoomsPage({super.key})
      : super(
          collection: 'rooms',
          title: 'Rooms',
          titleField: 'roomName',
          fields: const [
            AdminField.text('roomName', required: true),
            AdminField.text('screenType', required: true),
            AdminField.text('totalRows', number: true, required: true),
            AdminField.text('seatsPerRow', number: true, required: true),
            AdminField.text('status', required: true),
          ],
          statusField: 'status',
        );
}
