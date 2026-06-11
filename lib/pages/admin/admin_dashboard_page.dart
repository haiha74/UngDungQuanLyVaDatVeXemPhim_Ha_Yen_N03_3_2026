import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/admin_service.dart';
import '../../widgets/app_background.dart';
import 'admin_bookings_page.dart';
import 'admin_movies_page.dart';
import 'admin_payments_page.dart';
import 'admin_rooms_page.dart';
import 'admin_seats_page.dart';
import 'admin_showtimes_page.dart';
import 'admin_tickets_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key, this.showAppBar = true});

  static const routeName = '/admin';
  final bool showAppBar;

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _service = AdminService();
  late Future<bool> _allowed;
  late Future<Map<String, int>> _counts;

  @override
  void initState() {
    super.initState();
    _allowed = _service.isCurrentUserAdmin();
    _counts = _service.getDashboardCounts();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Admin Dashboard'),
              actions: [
                IconButton(
                  tooltip: 'Đăng xuất',
                  icon: const Icon(Icons.logout),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            )
          : null,
      body: AppBackground(
        child: FutureBuilder<bool>(
          future: _allowed,
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (authSnapshot.data != true) {
              return Center(
                child: Text(
                  'Bạn không có quyền truy cập',
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );
            }

            return FutureBuilder<Map<String, int>>(
              future: _counts,
              builder: (context, snapshot) {
                final counts = snapshot.data ?? const <String, int>{};
                return GridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: MediaQuery.sizeOf(context).width > 900
                      ? 4
                      : MediaQuery.sizeOf(context).width > 560
                          ? 2
                          : 1,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.8,
                  children: [
                    _AdminCard(title: 'Movies', count: counts['movies'], icon: Icons.movie, onTap: () => _open(context, const AdminMoviesPage())),
                    _AdminCard(title: 'Showtimes', count: counts['showtimes'], icon: Icons.schedule, onTap: () => _open(context, const AdminShowtimesPage())),
                    _AdminCard(title: 'Rooms', count: counts['rooms'], icon: Icons.meeting_room, onTap: () => _open(context, const AdminRoomsPage())),
                    _AdminCard(title: 'Seats', count: counts['seats'], icon: Icons.event_seat, onTap: () => _open(context, const AdminSeatsPage())),
                    _AdminCard(title: 'Bookings', count: counts['bookings'], icon: Icons.receipt_long, onTap: () => _open(context, const AdminBookingsPage())),
                    _AdminCard(title: 'Tickets', count: counts['tickets'], icon: Icons.confirmation_number, onTap: () => _open(context, const AdminTicketsPage())),
                    _AdminCard(title: 'Payments', count: counts['payments'], icon: Icons.payments, onTap: () => _open(context, const AdminPaymentsPage())),
                    _AdminCard(
                      title: 'Users',
                      count: counts['users'],
                      icon: Icons.people,
                      onTap: () => _open(context, const AdminCollectionPage(collection: 'users', title: 'Users')),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final int? count;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: scheme.surfaceContainerHighest,
          border: Border.all(color: scheme.outline),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: scheme.primary, size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${count ?? 0} records',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class AdminField {
  const AdminField.text(this.name, {this.label, this.required = false, this.number = false})
      : sourceCollection = null,
        sourceLabelField = null,
        options = null,
        type = 'text';

  const AdminField.dropdown(this.name, {required this.sourceCollection, required this.sourceLabelField, this.label, this.required = true})
      : number = false,
        options = null,
        type = 'dropdown';

  const AdminField.options(this.name, {required this.options, this.label, this.required = true})
      : number = false,
        sourceCollection = null,
        sourceLabelField = null,
        type = 'options';

  const AdminField.date(this.name, {this.label, this.required = false})
      : number = false,
        sourceCollection = null,
        sourceLabelField = null,
        options = null,
        type = 'date';

  const AdminField.dateTime(this.name, {this.label, this.required = false})
      : number = false,
        sourceCollection = null,
        sourceLabelField = null,
        options = null,
        type = 'dateTime';

  final String name;
  final String? label;
  final bool required;
  final bool number;
  final String? sourceCollection;
  final String? sourceLabelField;
  final List<String>? options;
  final String type;
}

class AdminReference {
  const AdminReference({required this.collection, required this.labelField});

  final String collection;
  final String labelField;
}

class AdminCollectionPage extends StatefulWidget {
  const AdminCollectionPage({
    super.key,
    required this.collection,
    required this.title,
    this.fields = const [],
    this.statusField,
    this.references = const {},
    this.titleField,
  });

  final String collection;
  final String title;
  final List<AdminField> fields;
  final String? statusField;
  final Map<String, AdminReference> references;
  final String? titleField;

  @override
  State<AdminCollectionPage> createState() => _AdminCollectionPageState();
}

class _AdminCollectionPageState extends State<AdminCollectionPage> {
  final _service = AdminService();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.fields.isNotEmpty)
            IconButton(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add),
              tooltip: 'Add',
            ),
        ],
      ),
      body: AppBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search'),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _service.watchCollection(widget.collection),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}', style: TextStyle(color: scheme.onSurfaceVariant)),
                    );
                  }

                  final docs = (snapshot.data?.docs ?? []).where((doc) {
                    final haystack = '${doc.id} ${doc.data()}'.toLowerCase();
                    return haystack.contains(_query.toLowerCase());
                  }).toList();

                  if (docs.isEmpty) {
                    return Center(child: Text('No data', style: TextStyle(color: scheme.onSurfaceVariant)));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: docs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return _AdminDocCard(
                        id: doc.id,
                        data: doc.data(),
                        titleField: widget.titleField,
                        references: widget.references,
                        statusField: widget.statusField,
                        onEdit: widget.fields.isEmpty ? null : () => _openForm(id: doc.id, data: doc.data()),
                        onDelete: () => _delete(doc.id),
                        onStatus: widget.statusField == null ? null : (value) => _updateStatus(doc.id, value),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openForm({String? id, Map<String, dynamic>? data}) async {
    final scheme = Theme.of(context).colorScheme;
    final entityName = widget.title.endsWith('s') ? widget.title.substring(0, widget.title.length - 1) : widget.title;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: scheme.scrim.withValues(alpha: 0.62),
      builder: (_) => _AdminFormDialog(
        fields: widget.fields,
        initial: data ?? const {},
        title: id == null ? 'Add $entityName' : 'Edit $entityName',
        submitLabel: id == null ? 'Create' : 'Save',
      ),
    );
    if (result == null) return;

    try {
      if (id == null) {
        await _service.createDocument(widget.collection, result);
        _snack('Created successfully');
      } else {
        await _service.updateDocument(widget.collection, id, result);
        _snack('Updated successfully');
      }
    } catch (error) {
      _snack('Save failed: $error');
    }
  }

  Future<void> _delete(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm delete'),
        content: Text('Delete ${widget.collection}/$id?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await _service.deleteDocument(widget.collection, id);
      _snack('Deleted successfully');
    } catch (error) {
      _snack('Delete failed: $error');
    }
  }

  Future<void> _updateStatus(String id, String status) async {
    try {
      await _service.updateDocument(widget.collection, id, {widget.statusField!: status});
      _snack('Status updated');
    } catch (error) {
      _snack('Status update failed: $error');
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _AdminDocCard extends StatelessWidget {
  const _AdminDocCard({
    required this.id,
    required this.data,
    required this.references,
    required this.titleField,
    this.onEdit,
    required this.onDelete,
    this.statusField,
    this.onStatus,
  });

  final String id;
  final Map<String, dynamic> data;
  final Map<String, AdminReference> references;
  final String? titleField;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;
  final String? statusField;
  final ValueChanged<String>? onStatus;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DocTitle(
              id: id,
              data: data,
              titleField: titleField,
              references: references,
            ),
          const SizedBox(height: 8),
          for (final entry in data.entries.take(10))
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _FieldLine(field: entry.key, value: entry.value, reference: references[entry.key]),
            ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              if (onEdit != null) OutlinedButton.icon(onPressed: onEdit, icon: const Icon(Icons.edit), label: const Text('Edit')),
              if (statusField != null)
                PopupMenuButton<String>(
                  onSelected: onStatus,
                  itemBuilder: (_) => ['NOW_SHOWING', 'COMING_SOON'].map((s) => PopupMenuItem(value: s, child: Text(s))).toList(),
                  child: const OutlinedButton(onPressed: null, child: Text('Update status')),
                ),
              OutlinedButton.icon(onPressed: onDelete, icon: const Icon(Icons.delete), label: const Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}

class _DocTitle extends StatelessWidget {
  const _DocTitle({
    required this.id,
    required this.data,
    required this.titleField,
    required this.references,
  });

  final String id;
  final Map<String, dynamic> data;
  final String? titleField;
  final Map<String, AdminReference> references;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final field = titleField;
    final value = field == null ? null : data[field];

    if (field != null && value is String && references[field] != null) {
      final reference = references[field]!;

      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection(reference.collection)
            .doc(value)
            .get(),
        builder: (context, snapshot) {
          final refData = snapshot.data?.data();
          final label = refData?[reference.labelField]?.toString() ?? value;

          return _TitleText(text: label);
        },
      );
    }

    final title = value?.toString();

    if (title != null && title.isNotEmpty) {
      return _TitleText(text: title);
    }

    return _TitleText(text: id);
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: scheme.onSurface,
        fontWeight: FontWeight.w900,
        fontSize: 18,
      ),
    );
  }
}

class _FieldLine extends StatelessWidget {
  const _FieldLine({required this.field, required this.value, this.reference});

  final String field;
  final Object? value;
  final AdminReference? reference;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (reference != null && value is String && (value as String).isNotEmpty) {
      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection(reference!.collection).doc(value as String).get(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          final label = data?[reference!.labelField] as String? ?? value.toString();
          return Text('$field: $label ($value)', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: scheme.onSurfaceVariant));
        },
      );
    }
    return Text('$field: $value', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: scheme.onSurfaceVariant));
  }
}

class _AdminFormDialog extends StatefulWidget {
  const _AdminFormDialog({
    required this.fields,
    required this.initial,
    required this.title,
    required this.submitLabel,
  });

  final List<AdminField> fields;
  final Map<String, dynamic> initial;
  final String title;
  final String submitLabel;

  @override
  State<_AdminFormDialog> createState() => _AdminFormDialogState();
}

class _AdminFormDialogState extends State<_AdminFormDialog> {
  late final Map<String, TextEditingController> _controllers;
  final _values = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final field in widget.fields.where((field) => !{'dropdown', 'options'}.contains(field.type)))
        field.name: TextEditingController(text: widget.initial[field.name]?.toString() ?? ''),
    };
    for (final field in widget.fields) {
      _values[field.name] = widget.initial[field.name];
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      backgroundColor: scheme.surfaceContainerHighest,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 720),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogHeader(context),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final twoColumns = constraints.maxWidth >= 560;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 14,
                      children: [
                        for (final field in widget.fields)
                          SizedBox(
                            width: twoColumns && !_isWideField(field) ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth,
                            child: _field(field),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            _dialogFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _dialogHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: scheme.outline))),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: scheme.onSurface, fontWeight: FontWeight.w900),
            ),
          ),
          IconButton.filledTonal(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close), tooltip: 'Close'),
        ],
      ),
    );
  }

  Widget _dialogFooter(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outline)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          const SizedBox(width: 12),
          FilledButton(onPressed: _save, child: Text(widget.submitLabel)),
        ],
      ),
    );
  }

  Widget _field(AdminField field) {
    if (field.type == 'dropdown') return _dropdownField(field);
    if (field.type == 'options') return _optionsField(field);
    return _textField(field);
  }

  Widget _textField(AdminField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: field.label ?? _labelFor(field.name), required: field.required),
        const SizedBox(height: 7),
        TextField(
          controller: _controllers[field.name],
          keyboardType: field.number ? TextInputType.number : TextInputType.text,
          minLines: field.name == 'description' ? 3 : 1,
          maxLines: field.name == 'description' ? 5 : 1,
          decoration: InputDecoration(hintText: _hintFor(field.name)),
        ),
      ],
    );
  }

  Widget _dropdownField(AdminField field) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection(field.sourceCollection!).snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? const <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        final currentValue = _values[field.name] as String?;
        final selectedValue = docs.any((doc) => doc.id == currentValue) ? currentValue : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FieldLabel(text: field.label ?? _labelFor(field.name), required: field.required),
            const SizedBox(height: 7),
            DropdownButtonFormField<String>(
              initialValue: selectedValue,
              hint: const Text('-- select --'),
              isExpanded: true,
              items: [
                for (final doc in docs)
                  DropdownMenuItem(value: doc.id, child: Text(doc.data()[field.sourceLabelField!] as String? ?? doc.id)),
              ],
              onChanged: (value) => setState(() => _values[field.name] = value),
            ),
          ],
        );
      },
    );
  }

  Widget _optionsField(AdminField field) {
    final options = field.options ?? const <String>[];
    final currentValue = _values[field.name] as String?;
    final selectedValue = options.contains(currentValue) ? currentValue : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: field.label ?? _labelFor(field.name), required: field.required),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          initialValue: selectedValue,
          hint: const Text('-- select --'),
          isExpanded: true,
          items: [
            for (final option in options) DropdownMenuItem(value: option, child: Text(option)),
          ],
          onChanged: (value) => setState(() => _values[field.name] = value),
        ),
      ],
    );
  }

  void _save() {
    final data = <String, dynamic>{};
    for (final field in widget.fields) {
      if ({'dropdown', 'options'}.contains(field.type)) {
        final value = _values[field.name];
        if (field.required && (value == null || value.toString().isEmpty)) return;
        if (value != null) data[field.name] = value;
        continue;
      }
      final text = _controllers[field.name]?.text.trim() ?? '';
      if (field.required && text.isEmpty) return;
      if (text.isEmpty) continue;
      data[field.name] = field.number ? num.tryParse(text) ?? text : text;
    }
    Navigator.pop(context, data);
  }

  bool _isWideField(AdminField field) {
    return {'title', 'posterUrl', 'trailerUrl', 'description', 'roomName', 'screenType', 'basePrice'}.contains(field.name);
  }

  String _labelFor(String name) {
    const labels = {
      'title': 'Title',
      'posterUrl': 'Poster URL',
      'trailerUrl': 'Trailer URL (YouTube / Embed)',
      'runtime': 'Runtime (minutes)',
      'status': 'Status',
      'description': 'Description',
      'movieId': 'Movie',
      'roomId': 'Room',
      'startTime': 'Start time',
      'endTime': 'End time (optional)',
      'basePrice': 'Base price',
      'roomName': 'Room name',
      'screenType': 'Screen type',
      'totalRows': 'Total rows',
      'seatsPerRow': 'Seats per row',
    };
    return labels[name] ?? name;
  }

  String? _hintFor(String name) {
    const hints = {
      'posterUrl': 'https://...',
      'trailerUrl': 'https://www.youtube.com/embed/xxxx',
      'runtime': '120',
      'startTime': '2026-01-31T19:00:00',
      'endTime': '2026-01-31T21:00:00',
      'basePrice': '70000',
      'screenType': '2D',
    };
    return hints[name];
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, required this.required});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w800, fontSize: 13),
        children: [
          if (required) TextSpan(text: ' *', style: TextStyle(color: scheme.error)),
        ],
      ),
    );
  }
}
