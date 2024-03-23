import 'package:admin/constants.dart';
import 'package:admin/controllers/BackupController.dart';
import 'package:admin/models/Backup.dart';
import 'package:admin/screens/components/action_button.dart';
import 'package:admin/screens/party/components/balance.dart';
import 'package:admin/services/cloud_service.dart';
import 'package:admin/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BackupPanel extends StatelessWidget {
  const BackupPanel({
    Key? key,
    required BackupController backupController,
  })  : _backupController = backupController,
        super(key: key);

  final BackupController _backupController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(kDefaultPadding),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Backup",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Spacer(),
              ActionButton(
                title: "Backup",
                onPressed: SocketService.backup,
                icon: Icons.backup,
                color: Colors.lightBlue,
              )
            ],
          ),
          Obx(
            () => _backupController.backups.length == 0
                ? Container()
                : SizedBox(
                    height: kDefaultPadding,
                  ),
          ),
          Obx(
            () => _backupController.backups.length == 0
                ? border(Text("Non sono presenti backup"))
                : ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Backup backup = _backupController.backups[index];

                      return Container(
                        padding: EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(
                            kDefaultPadding,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.archive,
                              color: Colors.white,
                              size: 32,
                            ),
                            Column(
                              children: [
                                Text(
                                    "Backup del ${DateFormat('dd MMMM yyyy', 'it-IT').format(backup.date)}"),
                                Text("${(backup.size / 10).round() / 100} MB")
                              ],
                            ),
                            Wrap(
                              children: [
                                IconButton(
                                  onPressed: () => launchUrl(
                                    CloudService.backupUri(backup),
                                  ),
                                  icon: Icon(Icons.download),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      _backupController.delete(backup),
                                  icon: Icon(Icons.delete),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(
                          height: kDefaultPadding,
                        ),
                    itemCount: _backupController.backups.length),
          ),
        ],
      ),
    );
  }
}
