import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import '../../../core/constants/values.dart';
import '../../../dto/event.dart';
import '../../widget/event_booking_form.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with SingleTickerProviderStateMixin {

  final ScrollController _scrollController = ScrollController();

  String formatManual(DateTime date) {
    const days = [
      "Lundi", "Mardi", "Mercredi", "Jeudi",
      "Vendredi", "Samedi", "Dimanche"
    ];
    const month = [
      "janvier", "février", "mars", "avril", "mai", "juin",
      "juillet", "août", "septembre", "octobre", "novembre", "décembre"
    ];

    String jour = days[date.weekday - 1];
    String moisNom = months[date.month - 1];

    return "$jour ${date.day} $moisNom ${date.year}";
  }

  // Keys pour les ancres
  final _presentationKey = GlobalKey();
  final _horairesKey = GlobalKey();
  final _dateKey = GlobalKey();
  final _localisationKey = GlobalKey();
  final _avisKey = GlobalKey();


  late TabController _tabController;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;


    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          event.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        children: [
          if (event.pictures.isNotEmpty)
            SizedBox(
              height: 220,
              child: CarouselSlider.builder(
                unlimitedMode: true,
                enableAutoSlider: true,
                autoSliderDelay: const Duration(seconds: 3),
                slideBuilder: (int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.network(
                      event.pictures[index],
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
                itemCount: event.pictures.length,
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
                      event.desc,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),

                  /// --- HORAIRES ---
                  Container(key: _horairesKey),
                  _sectionTitle("Horaires", Icons.schedule),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')} "
                          "- ${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  /// --- DATE ---
                  Container(key: _dateKey),
                  _sectionTitle("Date", Icons.calendar_today),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "${formatManual(event.date)} ",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  /// --- LOCALISATION ---
                  // Localisation
                  Container(key: _localisationKey),
                  _sectionTitle("Localisation", Icons.location_on),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.canteenInfo.name ?? 'Restaurant inconnu',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "📍 ${event.canteenInfo.location?.address },"
                              " ${event.canteenInfo.location?.city }, ${event.canteenInfo.location?.postalCode}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),

                      ],
                    ),

                    /**/
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.event_available, color: Colors.white),
                            label: const Text(
                              "Participer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
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
                                      child: EventBookingForm(
                                        onReserved: () {
                                          Navigator.pop(context, true);
                                        },
                                        event: event,
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
                          ),
                        ),
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
