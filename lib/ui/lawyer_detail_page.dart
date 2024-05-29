import 'package:client_dlaw/common/style.dart';
import 'package:client_dlaw/data/api/api_services.dart';
import 'package:client_dlaw/data/model/models.dart';
import 'package:client_dlaw/provider/detail_lawyer_provider.dart';
import 'package:client_dlaw/utils/result_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LawyerDetailPage extends StatefulWidget {
  static const routeName = '/lawyer_detail';

  final LawyerUser lawyer;

  const LawyerDetailPage({super.key, required this.lawyer});

  @override
  State<LawyerDetailPage> createState() => _LawyerDetailPageState();
}

class _LawyerDetailPageState extends State<LawyerDetailPage> {
  bool isExpanded = false;
  bool isHeroLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isHeroLoaded = true;
      });
    });
  }

  Widget _buildAppBar({List<Widget>? actions}) {
    return SliverAppBar(
      pinned: false,
      automaticallyImplyLeading: false,
      expandedHeight: 200,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: Positioned.fill(
        child: FlexibleSpaceBar(
          background: Hero(
            tag: widget.lawyer.user.id,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
                child: Image.network(
                  widget.lawyer.user.profilePicture ?? '',
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: grey,
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.broken_image,
                      color: grey,
                      size: 100,
                    );
                  },
                )),
          ),
        ),
      ),
      actions: actions,
    );
  }

  Widget _buildBody(LawyerUser lawyer) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lawyer.user.fullname,
                  style: textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                _buildListSpecialities(lawyer.specialities ?? []),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${lawyer.user.address ?? ''}, ${lawyer.user.address ?? ''}',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(lawyer.rating.toString()),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money_rounded,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(lawyer.pricePerHour.toString() + ' dollar/hour')
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: grey,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Description',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  lawyer.user.bio ?? '',
                  style: textTheme.bodyMedium,
                  maxLines: isExpanded ? 100 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    isExpanded ? 'Show Less' : 'Show More',
                    style: const TextStyle(
                      color: backgroundColor1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: lightGrey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSpecialities(List<Specialities> categories) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                EdgeInsets.only(right: index == categories.length - 1 ? 0 : 8),
            child: Chip(
              label: Text(
                categories[index].name,
                style: textTheme.bodySmall,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailLawyerProvider>(
      create: (_) => DetailLawyerProvider(
        apiServices: ApiServices(),
        id: widget.lawyer.id,
      ),
      child: Stack(children: [
        Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Consumer<DetailLawyerProvider>(
                  builder: (context, value, _) {
                    if (value.state == ResultState.loading) {
                      return const Center(
                        heightFactor: 10,
                        child: CircularProgressIndicator(),
                      );
                    } else if (value.state == ResultState.hasData) {
                      return _buildBody(value.result.lawyer);
                    } else if (value.state == ResultState.noData) {
                      return Center(
                        child: Text(value.message),
                      );
                    } else if (value.state == ResultState.error) {
                      return Center(
                        child: Text(value.message),
                      );
                    } else {
                      return const Center(
                        child: Text(''),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 15,
          child: SafeArea(
            child: Opacity(
              opacity: isHeroLoaded ? 1 : 0,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
