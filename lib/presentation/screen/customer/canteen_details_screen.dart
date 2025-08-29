import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:vegnbio/presentation/widget/room_booking_form.dart';
import 'package:vegnbio/presentation/widget/table_booking_form.dart';

import '../../../dto/canteen.dart';

class CanteenDetailScreen extends StatefulWidget {
  final Canteen canteen;

  const CanteenDetailScreen({super.key, required this.canteen});

  @override
  State<CanteenDetailScreen> createState() => _CanteenDetailScreenState();
}

class _CanteenDetailScreenState extends State<CanteenDetailScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // Keys pour les ancres
  final _presentationKey = GlobalKey();
  final _horairesKey = GlobalKey();
  final _localisationKey = GlobalKey();
  final _avisKey = GlobalKey();

  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _reviewItem(String author, String content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(author),
        subtitle: Text(content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canteen = widget.canteen;

    return Scaffold(
      appBar: AppBar(
        title: Text(canteen.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Column(
        children: [
          if (canteen.pictures.isNotEmpty)
            SizedBox(
              height: 220,
              child: CarouselSlider.builder(
                unlimitedMode: true,
                enableAutoSlider: true,
                autoSliderDelay: const Duration(seconds: 3),
                slideBuilder: (index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.network(
                      canteen.pictures[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 40),
                        );
                      },
                    ),
                  );
                },
                itemCount: canteen.pictures.length,
              ),
            ),
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              onTap: (index) {
                switch (index) {
                  case 0:
                    _scrollTo(_presentationKey);
                    break;
                  case 1:
                    _scrollTo(_horairesKey);
                    break;
                  case 2:
                    _scrollTo(_localisationKey);
                    break;
                  case 3:
                    _scrollTo(_avisKey);
                    break;
                }
              },
              tabs: const [
                Tab(text: "Présentation"),
                Tab(text: "Horaires"),
                Tab(text: "Localisation"),
                Tab(text: "Avis"),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(key: _presentationKey),
                  _sectionTitle("Présentation", Icons.info),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(canteen.desc),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final result = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    insetPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 500,
                                        maxHeight: 350,
                                      ),
                                      child: TableBookingForm(
                                        onReserved: () {
                                          Navigator.pop(context, true);
                                        },
                                        canteenId: canteen.id,
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (result == true) {
                                // ✅ Affiche une alerte de succès
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Succès"),
                                      content: const Text(
                                        "Votre réservation a bien été enregistrée ✅",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                            ).pop(); // ferme l'alerte
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                // Refresh data
                                setState(() {});
                              }
                            },
                            icon: const Icon(Icons.restaurant),
                            label: const Text("Réserver une table"),
                          ),
                        ),
                        const SizedBox(width: 12), // espace entre les boutons
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final result = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    insetPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 500,
                                        maxHeight: 350,
                                      ),
                                      child: RoomBookingForm(
                                        onReserved: () {
                                          Navigator.pop(context, true);
                                        },
                                        canteenId: canteen.id,
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (result == true) {
                                // ✅ Affiche une alerte de succès
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Succès"),
                                      content: const Text(
                                        "Votre réservation a bien été enregistrée ✅",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                            ).pop(); // ferme l'alerte
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                // Refresh data
                                setState(() {});
                              }
                            },
                            icon: const Icon(Icons.local_post_office),
                            label: const Text("Réserver une salle"),
                          ),

                          /*
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    insetPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 500,
                                        maxHeight: 350,
                                      ),
                                      child: RoomBookingForm(
                                        onReserved: () {
                                          Navigator.pop(context);
                                        },
                                        canteenId: canteen.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.meeting_room),
                            label: const Text("Réserver une salle"),
                          ),*/
                        ),
                      ],
                    ),
                  ),

                  //if(_showRoomForm)
                  Container(key: _horairesKey),
                  _sectionTitle("Horaires", Icons.access_time),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: canteen.openingHourMap.entries.map((entry) {
                        final day = entry.key;
                        final hours = entry.value;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(day),
                            Text(
                              "${hours.openingTime} -"
                              "${hours.closeTime}",
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  // Localisation
                  Container(key: _localisationKey),
                  _sectionTitle("Localisation", Icons.location_on),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("📍 ${canteen.location.address}"),
                  ),

                  // Avis
                  Container(key: _avisKey),
                  _sectionTitle("Avis", Icons.star),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _reviewItem(
                          "Alice",
                          "Super expérience, plats délicieux !",
                        ),
                        _reviewItem("Bob", "Très bon accueil, je recommande."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        /*Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            // Localisation
            Container(key: _locationKey),
            _sectionTitle("Localisation", icon: Icons.location_on),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("📍 ${canteen.location.address}"),
            ),

            // Description
            Container(key: _descriptionKey),
            _sectionTitle("Description", icon: Icons.info),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(canteen.desc),
            ),

            // Équipements
            Container(key: _equipmentsKey),
            _sectionTitle("Équipements", icon: Icons.build),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 12,
                children: [
                  if (canteen.equipments.contains("wifi"))
                    Chip(label: Text("Wi-Fi")),
                  if (canteen.equipments.contains("printer"))
                    Chip(label: Text("Imprimante")),
                  Chip(label: Text("${canteen.seats} places")),
                ],
              ),
            ),

            // Contact
            Container(key: _contactKey),
            _sectionTitle("Contact", icon: Icons.phone),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.phone),
                    label: Text("Appeler"),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.email),
                    label: Text("Envoyer un email"),
                  ),
                ],
              ),
            ),

            // Tags
            Container(key: _tagsKey),
            _sectionTitle("Tags", icon: Icons.label),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                children: canteen.tags
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),
            ),
          ],
        ),*/
      ),
    );
  }
}
