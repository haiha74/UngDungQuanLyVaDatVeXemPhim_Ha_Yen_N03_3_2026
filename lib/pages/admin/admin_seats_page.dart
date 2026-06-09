import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/admin_service.dart';
import '../../widgets/app_background.dart';

class AdminSeatsPage extends StatefulWidget {
  const AdminSeatsPage({super.key});

  @override
  State<AdminSeatsPage> createState() => _AdminSeatsPageState();
}

class _AdminSeatsPageState extends State<AdminSeatsPage> {
  final _service = AdminService();
  final _rowsController = TextEditingController(text: '4');
  final _colsController = TextEditingController(text: '10');
  final _typeController = TextEditingController(text: 'STANDARD');
  String? _roomId;
  bool _busy = false;

  @override
  void dispose() {
    _rowsController.dispose();
    _colsController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Seats')),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _ControlPanel(
              roomId: _roomId,
              rowsController: _rowsController,
              colsController: _colsController,
              typeController: _typeController,
              busy: _busy,
              onRoomChanged: (value) => setState(() => _roomId = value),
              onGenerate: _generate,
              onClear: _clear,
              onReload: () => setState(() {}),
            ),
            const SizedBox(height: 16),
            _SeatList(roomId: _roomId),
          ],
        ),
      ),
    );
  }

  Future<void> _generate() async {
    final roomId = _roomId;
    if (roomId == null || roomId.isEmpty) {
      _snack('Please choose a room');
      return;
    }
    final rows = int.tryParse(_rowsController.text.trim()) ?? 0;
    final cols = int.tryParse(_colsController.text.trim()) ?? 0;
    if (rows <= 0 || cols <= 0) {
      _snack('Rows and Cols must be greater than 0');
      return;
    }

    setState(() => _busy = true);
    try {
      await _service.generateSeatsForRoom(
        roomId: roomId,
        rows: rows,
        cols: cols,
        type: _typeController.text,
      );
      _snack('Generated ${rows * cols} seats');
    } catch (error, stackTrace) {
      debugPrint('[AdminSeatsPage] generate failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      _snack('Generate failed: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _clear() async {
    final roomId = _roomId;
    if (roomId == null || roomId.isEmpty) {
      _snack('Please choose a room');
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm clear'),
        content: const Text('Delete all seats of the selected room?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Clear')),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _busy = true);
    try {
      final deleted = await _service.clearSeatsForRoom(roomId);
      _snack('Deleted $deleted seats');
    } catch (error, stackTrace) {
      debugPrint('[AdminSeatsPage] clear failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      _snack('Clear failed: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({
    required this.roomId,
    required this.rowsController,
    required this.colsController,
    required this.typeController,
    required this.busy,
    required this.onRoomChanged,
    required this.onGenerate,
    required this.onClear,
    required this.onReload,
  });

  final String? roomId;
  final TextEditingController rowsController;
  final TextEditingController colsController;
  final TextEditingController typeController;
  final bool busy;
  final ValueChanged<String?> onRoomChanged;
  final VoidCallback onGenerate;
  final VoidCallback onClear;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF17171B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2B2B31)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generate seats by room', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 14),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? const <QueryDocumentSnapshot<Map<String, dynamic>>>[];
              final selected = docs.any((doc) => doc.id == roomId) ? roomId : null;
              return DropdownButtonFormField<String>(
                initialValue: selected,
                decoration: const InputDecoration(labelText: 'Room'),
                items: [
                  for (final doc in docs)
                    DropdownMenuItem(
                      value: doc.id,
                      child: Text(doc.data()['roomName'] as String? ?? doc.id),
                    ),
                ],
                onChanged: busy ? null : onRoomChanged,
              );
            },
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 620;
              final fields = [
                TextField(controller: rowsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Rows')),
                TextField(controller: colsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Cols')),
                TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Seat Type')),
              ];
              if (!wide) {
                return Column(
                  children: [
                    for (final field in fields) Padding(padding: const EdgeInsets.only(bottom: 10), child: field),
                  ],
                );
              }
              return Row(
                children: [
                  for (var i = 0; i < fields.length; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    Expanded(child: fields[i]),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(onPressed: busy ? null : onGenerate, icon: const Icon(Icons.auto_awesome), label: const Text('Generate')),
              OutlinedButton.icon(onPressed: busy ? null : onReload, icon: const Icon(Icons.refresh), label: const Text('Reload')),
              OutlinedButton.icon(onPressed: busy ? null : onClear, icon: const Icon(Icons.delete), label: const Text('Clear')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeatList extends StatelessWidget {
  const _SeatList({required this.roomId});

  final String? roomId;

  @override
  Widget build(BuildContext context) {
    final selectedRoomId = roomId;
    if (selectedRoomId == null || selectedRoomId.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Choose a room to view seats.', style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('seats')
          .where('roomId', isEqualTo: selectedRoomId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white70));
        }
        final docs = [...?snapshot.data?.docs]
          ..sort((a, b) {
            final aData = a.data();
            final bData = b.data();
            final row = ((aData['rowIndex'] as num?)?.toInt() ?? 0).compareTo((bData['rowIndex'] as num?)?.toInt() ?? 0);
            if (row != 0) return row;
            return ((aData['colIndex'] as num?)?.toInt() ?? 0).compareTo((bData['colIndex'] as num?)?.toInt() ?? 0);
          });
        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text('No seats for this room.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
          );
        }

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF17171B),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF2B2B31)),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final doc in docs)
                Chip(
                  label: Text(doc.data()['seatCode'] as String? ?? doc.id),
                  avatar: const Icon(Icons.event_seat, size: 16),
                  backgroundColor: const Color(0xFF202027),
                  labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
            ],
          ),
        );
      },
    );
  }
}
