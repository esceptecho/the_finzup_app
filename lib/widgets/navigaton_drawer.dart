import 'package:flutter/material.dart';
import 'package:the_finzup_app/features/dashboard/ui/app_colors.dart';
import 'package:the_finzup_app/features/dashboard/ui/dashboard_screen.dart';
import 'package:the_finzup_app/features/dashboard/widgets/example/lib/presentation/samples/line/line_chart_sample1.dart';
import 'package:the_finzup_app/features/transactions/widgets/real_time_animated.dart';

class NavigatonDrawer extends StatelessWidget {
  const NavigatonDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        children: <Widget>[buildHeader(context), buildMenuItems(context)],
      ),
    ),
  );
  Widget buildHeader(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Placeholder(
              color: AppColors.color0efffaff,
              child: const SizedBox(
                height: 500,
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Card(
                      child: Hero(
                        tag: 'assets/arees_profile',
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 150,
                          backgroundImage: AssetImage(
                            'assets/arees_profile.jpeg',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsetsGeometry.all(30),
                      child: Text(
                        'Miss Arees Angulo, sea bienvenida a este su espacio de trabajo donde puede organizar sus asuntos personales',
                        style: TextStyle(
                          color: AppColors.white,
                          backgroundColor: Colors.black,
                          fontSize: 14,
                          decoration: .none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        color: Colors.transparent,
        child: Column(
          children: const [
            Hero(
              tag: 'assets/arees_profile',
              child: CircleAvatar(
                radius: 52,
                backgroundImage: AssetImage('assets/arees_profile.jpeg'),
              ),
            ),
            Text(
              'Arees Angulo',
              style: TextStyle(fontSize: 28, color: AppColors.iceWhite),
            ),
            Text(
              'arees@brang.com',
              style: TextStyle(fontSize: 16, color: AppColors.white),
            ),
          ],
        ),
      ),
    ),
  );
  Widget buildMenuItems(BuildContext context) => Container(
    padding: EdgeInsets.all(24),
    child: Wrap(
      runSpacing: 16, // vertical space
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined, color: AppColors.white),
          title: const Text('Home', style: TextStyle(color: AppColors.white)),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.favorite_border, color: AppColors.white),
          title: const Text(
            'Favorites',
            style: TextStyle(color: AppColors.white),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Placeholder(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.attach_money_outlined,
            color: AppColors.white,
          ),
          title: const Text(
            'Transacciones',
            style: TextStyle(color: AppColors.white),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LineChartSample1(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.update, color: AppColors.white),
          title: const Text(
            'Updates',
            style: TextStyle(color: AppColors.white),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Placeholder(
                  color: AppColors.dividerColor,
                  child: const Icon(Icons.update, color: AppColors.white),
                ),
              ),
            );
          },
        ),
        const Divider(color: AppColors.dividerColor),
        ListTile(
          leading: const Icon(
            Icons.account_tree_outlined,
            color: AppColors.white,
          ),
          title: const Text(
            'Plugins',
            style: TextStyle(color: AppColors.white),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RealTimeAnimated(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications, color: AppColors.white),
          title: const Text(
            'Notifications',
            style: TextStyle(color: AppColors.white),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Placeholder(
                  color: AppColors.textHint,
                  child: const Icon(
                    Icons.notifications,
                    color: AppColors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}
