import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:vegnbio/presentation/widget/room_booking_form.dart';
import 'package:vegnbio/presentation/widget/table_booking_form.dart';

import '../../../core/constants/values.dart';
import '../../../dto/canteen.dart';
import '../../../dto/opening_hour.dart';

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

  Map<String, String> dayTranslations = {
    'MONDAY': 'Lundi',
    'TUESDAY': 'Mardi',
    'WEDNESDAY': 'Mercredi',
    'THURSDAY': 'Jeudi',
    'FRIDAY': 'Vendredi',
    'SATURDAY': 'Samedi',
    'SUNDAY': 'Dimanche',
  };


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
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4CAF50)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewItem(String author, String content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4CAF50),
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          author,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(content),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final canteen = widget.canteen;

    List<Map<String, String>> formatOpeningHours(Map<String, OpeningHours> openingHoursMap) {
      List<Map<String, String>> list = [];

      openingHoursMap.forEach((dayKey, hours) {
        final dayName = dayTranslations[dayKey] ?? dayKey; // traduction en français
        final hoursString =
            '${hours.open.hour.toString().padLeft(2, '0')}:${hours.open.minute.toString().padLeft(2, '0')} - '
            '${hours.close.hour.toString().padLeft(2, '0')}:${hours.close.minute.toString().padLeft(2, '0')}';

        list.add({
          'day': dayName,
          'hours': hoursString,
        });
      });

      return list;
    }




    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          canteen.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 4,
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
                    child: Text(
                      canteen.desc,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),

                  // Booking button

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
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
                                        maxHeight: 400,
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
                                //Affiche une alerte de succès
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF388E3C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
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
                                        maxHeight: 405,
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
                            icon: const Icon(Icons.meeting_room),
                            label: const Text("Réserver une salle"),
                          ),

                        ),
                      ],
                    ),
                  ),

                  Container(key: _horairesKey),
                  _sectionTitle("Horaires", Icons.access_time),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column( // ← ici il fallait "child:"
                      children: formatOpeningHours(canteen.openingHoursMap)
                          .map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry["day"]!,
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text(entry["hours"]!,
                                  style: const TextStyle(color: Colors.black54)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Localisation
                  Container(key: _localisationKey),
                  _sectionTitle("Localisation", Icons.location_on),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("📍 ${canteen.location.address} ${canteen.location.city} ${canteen.location.postalCode}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87
                      ),
                    ),
                  ),

                /**button**/

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

      ),
    );
  }
}
