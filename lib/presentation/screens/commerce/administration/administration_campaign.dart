import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../domain/domain.dart';
import '../../../../infrastructure/infrastructure.dart';
import 'package:ecommerce_beta/presentation/screens/commerce/administration/campaign_details_page.dart';

class AdministratorCampaign extends StatefulWidget {
  static const name = 'administration_campaign_screen';
  final String commerceId;

  const AdministratorCampaign({super.key, required this.commerceId});

  @override
  State<AdministratorCampaign> createState() => _AdministratorCampaignState();
}

class _AdministratorCampaignState extends State<AdministratorCampaign> {
  final List<Campaign> _campaigns = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    try {
      final commerceDocRef =
          _firestore.collection('commerce').doc(widget.commerceId);
      final commerceDocSnapshot = await commerceDocRef.get();

      if (commerceDocSnapshot.exists) {
        final commerceData = CommerceData.fromJson(commerceDocSnapshot.data()!);
        setState(() {
          _campaigns.clear();
          _campaigns.addAll(commerceData.campaigns);
        });
      }
    } catch (e) {
      print("Error al cargar las campañas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _campaigns.isEmpty
          ? const Center(
              child: Text('No hay campañas'),
            )
          : _buildCampaignGrid(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Adicionar Campaña'),
        icon: const Icon(Icons.add),
        onPressed: () {
          _showAddCampaignDialog();
        },
      ),
    );
  }

  Widget _buildCampaignGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 1.5, // Relación de aspecto ajustada para centrado
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _campaigns.length,
      itemBuilder: (context, index) {
        return _buildCampaignCard(_campaigns[index]);
      },
    );
  }

  Widget _buildCampaignCard(Campaign campaign) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CampaignDetailsPage(campaign: campaign),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0), // Sangría lateral
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centrar verticalmente el contenido
            children: [
              const Text(
                'Campaña',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                  height:
                      8), // Espacio entre "Campaña" y el nombre de la campaña
              Text(
                campaign.campaignName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCampaignDialog() {
    final _formKey = GlobalKey<FormState>();
    String? campaignName;
    int? duration;
    int pointsQuantity = 10;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Campaña'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Nombre de la Campaña'),
                    validator: (value) => value!.isEmpty
                        ? 'Ingrese el nombre de la campaña'
                        : null,
                    onSaved: (value) => campaignName = value,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Duración (días)'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Ingrese la duración' : null,
                    onSaved: (value) => duration = int.tryParse(value!),
                  ),
                  TextFormField(
                    initialValue: '10',
                    decoration: const InputDecoration(labelText: 'Objetivo'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      int? intValue = int.tryParse(value!);
                      if (intValue == null || intValue < 10) {
                        return 'La cantidad de puntos debe ser mayor a 10';
                      }
                      return null;
                    },
                    onSaved: (value) => pointsQuantity = int.tryParse(value!)!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: _isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    )
                  : const Text('Adicionar'),
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        _formKey.currentState!.save();
                        String campaignId =
                            _firestore.collection('commerce').doc().id;
                        Campaign newCampaign = Campaign(
                          id: campaignId,
                          campaignName: campaignName!,
                          duration: duration!,
                          pointsQuantity: pointsQuantity,
                        );

                        await AuthMethods().addCampaignToCommerce(
                            widget.commerceId, newCampaign);

                        setState(() {
                          _campaigns.add(newCampaign);
                          _isLoading = false;
                        });

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Campaña creada de forma satisfactoria'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showEditCampaignDialog(Campaign campaign) {
    final _formKey = GlobalKey<FormState>();
    String? campaignName = campaign.campaignName;
    int? duration = campaign.duration;
    int pointsQuantity = campaign.pointsQuantity;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Campaña'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: campaignName,
                    decoration: const InputDecoration(
                        labelText: 'Nombre de la Campaña'),
                    validator: (value) => value!.isEmpty
                        ? 'Ingrese el nombre de la campaña'
                        : null,
                    onSaved: (value) => campaignName = value,
                  ),
                  TextFormField(
                    initialValue: duration.toString(),
                    decoration:
                        const InputDecoration(labelText: 'Duración (días)'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Ingrese la duración' : null,
                    onSaved: (value) => duration = int.tryParse(value!),
                  ),
                  TextFormField(
                    initialValue: pointsQuantity.toString(),
                    decoration:
                        const InputDecoration(labelText: 'Cantidad de puntos'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      int? intValue = int.tryParse(value!);
                      if (intValue == null || intValue < 10) {
                        return 'La cantidad de puntos debe ser mayor a 10';
                      }
                      return null;
                    },
                    onSaved: (value) => pointsQuantity = int.tryParse(value!)!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: _isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    )
                  : const Text('Guardar'),
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        _formKey.currentState!.save();
                        Campaign updatedCampaign = Campaign(
                          id: campaign.id,
                          campaignName: campaignName!,
                          duration: duration!,
                          pointsQuantity: pointsQuantity,
                        );

                        await AuthMethods().updateCampaignInCommerce(
                            widget.commerceId, updatedCampaign);

                        setState(() {
                          int index =
                              _campaigns.indexWhere((c) => c.id == campaign.id);
                          if (index != -1) {
                            _campaigns[index] = updatedCampaign;
                          }
                          _isLoading = false;
                        });

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Campaña actualizada de forma satisfactoria'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _deleteCampaign(Campaign campaign) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Campaña'),
          content: Text(
              '¿Estás seguro de que deseas eliminar la campaña "${campaign.campaignName}"?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: _isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    )
                  : const Text('Eliminar'),
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await AuthMethods().deleteCampaignFromCommerce(
                          widget.commerceId, campaign.id);

                      setState(() {
                        _campaigns.removeWhere((c) => c.id == campaign.id);
                        _isLoading = false;
                      });

                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Campaña eliminada de forma satisfactoria'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
