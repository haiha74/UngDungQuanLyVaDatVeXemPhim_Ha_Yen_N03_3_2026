import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:firebase_auth/firebase_auth.dart';

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: widget.showAppBar
    ? AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              tooltip: 'Đăng xuất',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
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
              return const Center(
                child: Text(
                  'Bạn không có quyền truy cập',
                  style: TextStyle(
                    color: Colors.white,
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
                    _AdminCard(
                      title: 'Movies',
                      count: counts['movies'],
                      icon: Icons.movie,
                      onTap: () => _open(context, const AdminMoviesPage()),
                    ),
                    _AdminCard(
                      title: 'Showtimes',
                      count: counts['showtimes'],
                      icon: Icons.schedule,
                      onTap: () => _open(context, const AdminShowtimesPage()),
                    ),
                    _AdminCard(
                      title: 'Rooms',
                      count: counts['rooms'],
                      icon: Icons.meeting_room,
                      onTap: () => _open(context, const AdminRoomsPage()),
                    ),
                    _AdminCard(
                      title: 'Seats',
                      count: counts['seats'],
                      icon: Icons.event_seat,
                      onTap: () => _open(context, const AdminSeatsPage()),
                    ),
                    _AdminCard(
                      title: 'Bookings',
                      count: counts['bookings'],
                      icon: Icons.receipt_long,
                      onTap: () => _open(context, const AdminBookingsPage()),
                    ),
                    _AdminCard(
                      title: 'Tickets',
                      count: counts['tickets'],
                      icon: Icons.confirmation_number,
                      onTap: () => _open(context, const AdminTicketsPage()),
                    ),
                    _AdminCard(
                      title: 'Payments',
                      count: counts['payments'],
                      icon: Icons.payments,
                      onTap: () => _open(context, const AdminPaymentsPage()),
                    ),
                    _AdminCard(
                      title: 'Users',
                      count: counts['users'],
                      icon: Icons.people,
                      onTap: () => _open(
                        context,
                        const AdminCollectionPage(
                          collection: 'users',
                          title: 'Users',
                        ),
                      ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF231114), Color(0xFF17171B)],
          ),
          border: Border.all(color: const Color(0xFF34262A)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF6B35), size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${count ?? 0} records',
                    style: const TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class AdminField {
  const AdminField.text(
    this.name, {
    this.label,
    this.required = false,
    this.number = false,
  })  : sourceCollection = null,
        sourceLabelField = null,
        type = 'text';

  const AdminField.dropdown(
    this.name, {
    required this.sourceCollection,
    required this.sourceLabelField,
    this.label,
    this.required = true,
  })  : number = false,
        type = 'dropdown';

  const AdminField.date(
    this.name, {
    this.label,
    this.required = false,
  })  : number = false,
        sourceCollection = null,
        sourceLabelField = null,
        type = 'date';

  const AdminField.dateTime(
    this.name, {
    this.label,
    this.required = false,
  })  : number = false,
        sourceCollection = null,
        sourceLabelField = null,
        type = 'dateTime';

  final String name;
  final String? label;
  final bool required;
  final bool number;
  final String? sourceCollection;
  final String? sourceLabelField;
  final String type;
}

class AdminReference {
  const AdminReference({
    required this.collection,
    required this.labelField,
  });

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
  });

  final String collection;
  final String title;
  final List<AdminField> fields;
  final String? statusField;
  final Map<String, AdminReference> references;

  @override
  State<AdminCollectionPage> createState() => _AdminCollectionPageState();
}

class _AdminCollectionPageState extends State<AdminCollectionPage> {
  final _service = AdminService();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                ),
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
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  final docs = (snapshot.data?.docs ?? []).where((doc) {
                    final haystack = '${doc.id} ${doc.data()}'.toLowerCase();
                    return haystack.contains(_query.toLowerCase());
                  }).toList();

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No data',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: docs.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final doc = docs[index];

                      return _AdminDocCard(
                        id: doc.id,
                        data: doc.data(),
                        references: widget.references,
                        statusField: widget.statusField,
                        onEdit: widget.fields.isEmpty
                            ? null
                            : () => _openForm(id: doc.id, data: doc.data()),
                        onDelete: () => _delete(doc.id),
                        onStatus: widget.statusField == null
                            ? null
                            : (value) => _updateStatus(doc.id, value),
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

  Future<void> _openForm({
    String? id,
    Map<String, dynamic>? data,
  }) async {
    final entityName = widget.title.endsWith('s')
        ? widget.title.substring(0, widget.title.length - 1)
        : widget.title;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.62),
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
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
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
      await _service.updateDocument(
        widget.collection,
        id,
        {widget.statusField!: status},
      );
      _snack('Status updated');
    } catch (error) {
      _snack('Status update failed: $error');
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _AdminDocCard extends StatelessWidget {
  const _AdminDocCard({
    required this.id,
    required this.data,
    required this.references,
    this.onEdit,
    required this.onDelete,
    this.statusField,
    this.onStatus,
  });

  final String id;
  final Map<String, dynamic> data;
  final Map<String, AdminReference> references;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;
  final String? statusField;
  final ValueChanged<String>? onStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF17171B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2B2B31)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            id,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          for (final entry in data.entries.take(10))
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _FieldLine(
                field: entry.key,
                value: entry.value,
                reference: references[entry.key],
              ),
            ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              if (onEdit != null)
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              if (statusField != null)
                PopupMenuButton<String>(
                  onSelected: onStatus,
                  itemBuilder: (_) => [
                    'ACTIVE',
                    'INACTIVE',
                    'OPEN',
                    'CANCELLED',
                    'PENDING',
                    'PAID',
                    'ISSUED',
                    'CHECKED_IN',
                    'FAILED',
                    'SUCCESS',
                  ]
                      .map((s) => PopupMenuItem(value: s, child: Text(s)))
                      .toList(),
                  child: const OutlinedButton(
                    onPressed: null,
                    child: Text('Update status'),
                  ),
                ),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FieldLine extends StatelessWidget {
  const _FieldLine({
    required this.field,
    required this.value,
    this.reference,
  });

  final String field;
  final Object? value;
  final AdminReference? reference;

  @override
  Widget build(BuildContext context) {
    if (reference != null && value is String && (value as String).isNotEmpty) {
      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection(reference!.collection)
            .doc(value as String)
            .get(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          final label =
              data?[reference!.labelField] as String? ?? value.toString();

          return _LineText(field: field, value: '$label ($value)');
        },
      );
    }

    return _LineText(field: field, value: _displayValue(value));
  }

  String _displayValue(Object? value) {
    if (value is Timestamp) {
      final date = value.toDate();
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year} '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    }

    return value.toString();
  }
}

class _LineText extends StatelessWidget {
  const _LineText({
    required this.field,
    required this.value,
  });

  final String field;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$field: $value',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.white70),
    );
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
      for (final field in widget.fields.where(
        (field) => field.type == 'text',
      ))
        field.name: TextEditingController(
          text: widget.initial[field.name]?.toString() ?? '',
        ),
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
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 720),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1D25).withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF3A3B48)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
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
                                width: twoColumns && !_isWideField(field)
                                    ? (constraints.maxWidth - 12) / 2
                                    : constraints.maxWidth,
                                child: _buildField(field),
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
        ),
      ),
    );
  }

  Widget _buildField(AdminField field) {
    if (field.type == 'dropdown') {
      return _dropdownField(field);
    }

    if (field.type == 'date' || field.type == 'dateTime') {
      return _dateTimeField(field);
    }

    return _textField(field);
  }

  Widget _dialogHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF30313B))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
          IconButton.filledTonal(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _dialogFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF23242C),
        border: Border(top: BorderSide(color: Color(0xFF30313B))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFF75E4D0), Color(0xFF6767FF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6767FF).withValues(alpha: 0.28),
                  blurRadius: 18,
                ),
              ],
            ),
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: const Color(0xFF0B0D12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                widget.submitLabel,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(AdminField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          text: field.label ?? _labelFor(field.name),
          required: field.required,
        ),
        const SizedBox(height: 7),
        TextField(
          controller: _controllers[field.name],
          keyboardType:
              field.number ? TextInputType.number : TextInputType.text,
          minLines: field.name == 'description' ? 3 : 1,
          maxLines: field.name == 'description' ? 5 : 1,
          decoration: InputDecoration(
            hintText: _hintFor(field.name),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateTimeField(AdminField field) {
    final value = _values[field.name];
    DateTime? selectedDate;

    if (value is Timestamp) {
      selectedDate = value.toDate();
    } else if (value is DateTime) {
      selectedDate = value;
    }

    final displayText = selectedDate == null
        ? field.type == 'dateTime'
            ? 'Chọn ngày và giờ'
            : 'Chọn ngày'
        : field.type == 'dateTime'
            ? _formatDateTime(selectedDate)
            : _formatDate(selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          text: field.label ?? _labelFor(field.name),
          required: field.required,
        ),
        const SizedBox(height: 7),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            final initialDate = selectedDate ?? DateTime.now();

            final pickedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            );

            if (pickedDate == null) return;

            DateTime result = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
            );

            if (field.type == 'dateTime') {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: selectedDate == null
                    ? TimeOfDay.now()
                    : TimeOfDay.fromDateTime(selectedDate),
              );

              if (pickedTime == null) return;

              result = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
            }

            setState(() {
              _values[field.name] = Timestamp.fromDate(result);
            });
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.calendar_month),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
            ),
            child: Text(
              displayText,
              style: TextStyle(
                color: selectedDate == null ? Colors.white54 : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField(AdminField field) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(field.sourceCollection!)
          .snapshots(),
      builder: (context, snapshot) {
        final docs =
            snapshot.data?.docs ?? const <QueryDocumentSnapshot<Map<String, dynamic>>>[];

        final currentValue = _values[field.name] as String?;
        final selectedValue =
            docs.any((doc) => doc.id == currentValue) ? currentValue : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FieldLabel(
              text: field.label ?? _labelFor(field.name),
              required: field.required,
            ),
            const SizedBox(height: 7),
            DropdownButtonFormField<String>(
              initialValue: selectedValue,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 15,
                ),
              ),
              hint: const Text('-- select --'),
              isExpanded: true,
              items: [
                for (final doc in docs)
                  DropdownMenuItem(
                    value: doc.id,
                    child: Text(
                      doc.data()[field.sourceLabelField!] as String? ?? doc.id,
                    ),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  _values[field.name] = value;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _save() {
    final data = <String, dynamic>{};

    for (final field in widget.fields) {
      if (field.type == 'date' || field.type == 'dateTime') {
        final value = _values[field.name];

        if (field.required && value == null) return;

        if (value != null) {
          data[field.name] = value;
        }
      } else if (field.type == 'dropdown') {
        final value = _values[field.name];

        if (field.required && (value == null || value.toString().isEmpty)) {
          return;
        }

        if (value != null) {
          data[field.name] = value;
        }
      } else {
        final text = _controllers[field.name]?.text.trim() ?? '';

        if (field.required && text.isEmpty) return;

        if (text.isEmpty) continue;

        data[field.name] = field.number ? num.tryParse(text) ?? text : text;
      }
    }

    Navigator.pop(context, data);
  }

  bool _isWideField(AdminField field) {
    return {
      'title',
      'posterUrl',
      'trailerUrl',
      'description',
      'roomName',
      'screenType',
      'basePrice',
    }.contains(field.name);
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
      'endTime': 'End time',
      'releaseDate': 'Release date',
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
      'status': 'NOW_SHOWING',
      'basePrice': '70000',
      'screenType': '2D',
    };

    return hints[name];
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.text,
    required this.required,
  });

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFFC8C8D0),
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
        ],
      ),
    );
  }
}