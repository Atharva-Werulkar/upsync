import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upsync/model/api_model.dart';
import 'package:upsync/screens/add_app_screen.dart';
import 'package:upsync/screens/update_app_screen.dart';
import 'package:upsync/services/backend.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:upsync/utils/consts.dart';
import 'package:upsync/widgets/shimmer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> _refreshApps() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('UpSync', style: TextStyles.title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<AppModel>>(
        future: Backend.fetchApps(),
        builder: (context, snapshot) {
          return Scaffold(
            floatingActionButton:
                snapshot.hasData && snapshot.data!.isNotEmpty
                    ? Padding(
                      padding: EdgeInsets.only(
                        bottom: deviceHeight(context) * 0.1,
                        right: 4,
                      ),
                      child: ShadButton(
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddAppScreen(),
                              ),
                            ),
                        // variant: ButtonVariant.defaultVariant,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 6),
                            Text("Add App"),
                          ],
                        ),
                      ),
                    )
                    : null,
            body: Builder(
              builder: (context) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return RefreshIndicator(
                      onRefresh: _refreshApps,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(height: 200),
                            Text(
                              'No apps available',
                              textAlign: TextAlign.center,
                              style: TextStyles.title2,
                            ),
                          ],
                        ),
                      ),
                    );
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Shimmers.homeShimmer;
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return RefreshIndicator.adaptive(
                        onRefresh: _refreshApps,
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildHeight(deviceHeight(context) * 0.35),
                              Center(
                                child: Text(
                                  'Error loading apps',
                                  textAlign: TextAlign.center,
                                  style: TextStyles.title2.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return RefreshIndicator.adaptive(
                        onRefresh: _refreshApps,
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildHeight(deviceHeight(context) * 0.35),
                              Center(
                                child: Text(
                                  'No apps available',
                                  textAlign: TextAlign.center,
                                  style: TextStyles.title2,
                                ),
                              ),

                              //button to add app
                              buildHeight(deviceHeight(context) * 0.05),
                              ShadButton(
                                onPressed:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const AddAppScreen(),
                                      ),
                                    ),
                                // variant: ButtonVariant.defaultVariant,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add),
                                    SizedBox(width: 6),
                                    Text("Add App"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final apps = snapshot.data!;
                      return RefreshIndicator(
                        onRefresh: _refreshApps,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: apps.length,
                          itemBuilder: (context, index) {
                            final app = apps[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              child: ShadCard(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                child: ListTile(
                                  leading: ShadAvatar(
                                    'assets/images/updated.png',
                                  ),
                                  title: Text(
                                    app.appName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Latest Version: ${app.latestVersion}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  trailing: ShadButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  UpdateAppScreen(app: app),
                                        ),
                                      );
                                    },
                                    // variant: ButtonVariant.secondary,
                                    child: const Text("Update"),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
