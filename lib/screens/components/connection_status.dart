import 'package:flutter/material.dart';

import '../../services/sync_service.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SyncService.cloudState,
      builder: (context, state, _) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: state == CloudState.online ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(state == CloudState.online ? "Connesso" : "Non connesso"),
      ),
    );
  }
}
