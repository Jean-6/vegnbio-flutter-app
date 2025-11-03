import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/core/routes/app_routes.dart';
import 'package:vegnbio/core/services/date_picker_service.dart';
import 'package:vegnbio/dto/upload_item.dart';
import '../../../core/services/image_picker_service.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../domain/services/product_service.dart';
import '../../../core/constants/values.dart';
import '../demo/dash.dart';

class PlaceProductScreen extends StatefulWidget {
  const PlaceProductScreen({super.key});
  @override
  State<StatefulWidget> createState() => _PlaceOfferScreenState();
}

class _PlaceOfferScreenState extends State<PlaceProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _quantityCtrl = TextEditingController();
  final TextEditingController _unitPriceCtrl = TextEditingController();

  DateTime? _availabilityDate;
  DateTime? _expirationDate;
  String? _selectedType;
  String? _selectedUnit;
  String? _selectedOrigin;

  bool _isLoading = false;

  String? _selectedCategory;
  bool isLoading = false;

  final ImagePickerService imagePickerService = ImagePickerService();
  final DatePickerService datePickerService = DatePickerService();

  final logger = Logger();

  List<UploadItem> uploads = [];

  final offerService = ProductService();

  Future<void> _pickDate(bool isAvailability) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isAvailability) {
          _availabilityDate = picked;
        } else {
          _expirationDate = picked;
        }
      });
    }
  }

  Future<void> _trySubmit() async {

    if (!_formKey.currentState!.validate()) return;

    /**/
    if (_selectedType == null || _selectedType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez selectionner le type d'offre")),
      );
      return;
    }
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer le ,om du produit")),
      );
      return;
    }
    if (_descCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("La description du produit est requise")),
      );
      return;
    }
    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner une catégorie")),
      );
      return;
    }
    final quantity = double.tryParse(_quantityCtrl.text);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Entrez une quantité valide (> 0)")),
      );
      return;
    }
    if (_selectedUnit == null || _selectedUnit!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner une unité")),
      );
      return;
    }

    // Validation du prix unitaire
    final unitPrice = double.tryParse(_unitPriceCtrl.text);
    if (unitPrice == null || unitPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Entrez un prix unitaire valide (> 0)")),
      );
      return;
    }

    if (_selectedOrigin == null || _selectedOrigin!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner une origine")),
      );
      return;
    }

    /**/

    if (uploads.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez uploader au moins une image 📷"),
        ),
      );
      return;
    }

    if (_availabilityDate == null || _expirationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner les dates")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = await SecureStorageService.getUserId();
      if (userId == null) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utilisateur non connecté")),
        );
        return;
      }

      final result = await offerService.save(
        type: _selectedType ?? "",
        name: _nameCtrl.text.trim(),
        desc: _descCtrl.text.trim(),
        category: _selectedCategory ?? "",
        quantity: double.tryParse(_quantityCtrl.text) ?? 0,
        unit: _selectedUnit ?? "",
        unitPrice: double.tryParse(_unitPriceCtrl.text) ?? 0,
        origin: _selectedOrigin ?? "",
        availabilityDate: _availabilityDate!,
        expirationDate: _expirationDate!,
        uploads: uploads,
        userId: userId,
        onProgress: (fileName, sent, total) {
          setState(() {
            if (fileName.isNotEmpty) {
              final item =
                  uploads.where((u) => u.fileName == fileName).isNotEmpty
                  ? uploads.firstWhere((u) => u.fileName == fileName)
                  : null;

              if (item != null) {
                item.isUploading = true;
                item.progress = total > 0 ? sent / total : 0;
              }
            }
          });
        },
      );

      if (result != null) {
        setState(() {
          for (var u in uploads) {
            u.progress = 1.0;
            u.isUploading = false;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Offre créée avec succès ✅")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dash(),
          ),
        );
        //Navigator.of(context).pushReplacementNamed(AppRoutes.supplierDashboard);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur lors de la création de l'offre ❌"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImages() async {
    final files = await imagePickerService.pickImages(
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (files.isEmpty) return;

    // Four images max
    if (uploads.length + files.length > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vous pouvez uploader maximum 4 images")),
      );
      return;
    }

    setState(() {
      uploads.addAll(
        files.map(
          (f) => UploadItem(
            fileName: f.name,
            path: f.path,
            file: f,
            progress: 0,
            isUploading: false,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Créer une offre",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF4CAF50),
                          width: 2,
                        ),
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      labelText: "Type d'offre",
                    ),
                    value: _selectedType,
                    items: types.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value ?? "";
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF4CAF50),
                        width: 2,
                      ),
                    ),
                    labelText: "Nom du produit",
                    hintText: "Entrez le nom du produit",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "Nom du produit requis"
                      : null,
                ),

                const SizedBox(height: 15),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF4CAF50),
                        width: 2,
                      ),
                    ),
                    labelText: "Description",
                    hintText: "Décrivez le produit en quelques phrases",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "La description est requise";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF4CAF50),
                        width: 2,
                      ),
                    ),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    labelText: "Catégorie",
                  ),
                  value: _selectedCategory,
                  items: categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedCategory = value),
                  validator: (value) =>
                      value == null ? "Sélectionnez une catégorie" : null,
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      flex: 1, // 1 partie pour le dropdown
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        child: DropdownButtonFormField<String>(
                          value: _selectedUnit,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                            labelText: "Unité",
                          ),
                          items: unities.map((unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedUnit = value!;
                            });
                          },
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        child: TextFormField(
                          controller: _quantityCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                            labelText: "Quantité",
                            hintText: "0",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Quantité requise";
                            final qty = double.tryParse(value);
                            if (qty == null || qty <= 0)
                              return "Entrez une quantité valide (> 0)";
                            return null;
                          },
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 2, // 2 parties pour le prix
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        child: TextFormField(
                          controller: _unitPriceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                            labelText: "Prix Unitaire",
                            hintText: "0.00",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Le prix est requis";
                            if (double.tryParse(value) == null)
                              return "Entrez un nombre valide";
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: DropdownButtonFormField<String>(
                    value: _selectedOrigin,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF4CAF50),
                          width: 2,
                        ),
                      ),
                      labelText: 'Origine',
                    ),
                    items: countries.map((origin) {
                      return DropdownMenuItem<String>(
                        value: origin,
                        child: Text(origin),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedOrigin = value!;
                      });
                    },
                    validator: (value) => value == null
                        ? "Veuillez sélectionner une origine"
                        : null,
                  ),
                ),

                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickDate(true),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFFE0E0E0)),
                          ),
                          child: Text(
                            _availabilityDate == null
                                ? "Disponibilité"
                                : "${_availabilityDate!.day}/${_availabilityDate!.month}/${_availabilityDate!.year}",
                            style: TextStyle(
                              color: _availabilityDate == null
                                  ? Colors.grey.shade500
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickDate(false),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFFE0E0E0)),
                          ),
                          child: Text(
                            _expirationDate == null
                                ? "Expiration"
                                : "${_expirationDate!.day}/${_expirationDate!.month}/${_expirationDate!.year}",
                            style: TextStyle(
                              color: _expirationDate == null
                                  ? Colors.grey.shade500
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5, // pour 50%
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.greenAccent.withOpacity(0.4),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    onPressed: _pickImages,
                    child: Text("Uploader les images"),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: uploads.length,
                  itemBuilder: (context, i) {
                    final item = uploads[i];
                    return ListTile(
                      leading: const Icon(Icons.image),
                      title: Text(item.fileName),
                      subtitle: item.isUploading
                          ? LinearProgressIndicator(
                              value: item.progress,
                              minHeight: 5,
                              color: Color(0xFF4CAF50),
                              backgroundColor: Colors.grey.shade300,
                            )
                          : null,
                      trailing: item.isUploading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                value: item.progress,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.check_circle, color: Colors.green),
                    );
                  },
                ),
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.greenAccent.withOpacity(0.4),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    onPressed: isLoading ? null : _trySubmit,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text("Enregistrer"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
