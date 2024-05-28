import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../domain/domain.dart';
import '../../../../infrastructure/infrastructure.dart';

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

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
  try {
    final commerceDocRef = _firestore.collection('commerce').doc(widget.commerceId);
    final commerceDocSnapshot = await commerceDocRef.get();

    if (commerceDocSnapshot.exists) {
      final commerceData = CommerceData.fromJson(commerceDocSnapshot.data()!);
      setState(() {
        _campaigns.clear();
        _campaigns.addAll(commerceData.campaigns);
      });
    }
  } catch (e) {
    print("Error al cargar las campaña: $e");
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
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _campaigns.length,
      itemBuilder: (context, index) {
        return _buildCampaignCard(_campaigns[index]);
      },
    );
  }

Widget _buildCampaignCard(Campaign campaign) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              campaign.campaignName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Duración: ${campaign.duration} días',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Cantidad de puntos: ${campaign.pointsQuantity}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Condiciones especiales: ${campaign.specialsConditions}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditCampaignDialog(campaign),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteCampaign(campaign),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
 /* Widget _buildCampaignCard(Campaign campaign) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campaign.campaignName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Duración: ${campaign.duration} días',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Cantidad de puntos: ${campaign.pointsQuantity}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Condiciones especiales: ${campaign.specialsConditions}',
              style: const TextStyle(fontSize: 14),
            ),            
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditCampaignDialog(campaign),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteCampaign(campaign),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }*/

void _showAddCampaignDialog() {
  final _formKey = GlobalKey<FormState>();
  String? campaignName;
  int? duration;
  int? pointsQuantity;
  String? specialsConditions;

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
                  decoration: const InputDecoration(labelText: 'Nombre de la Campaña'),
                  validator: (value) => value!.isEmpty ? 'Ingrese el nombre de la campaña' : null,
                  onSaved: (value) => campaignName = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Duración (días)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Ingrese la duración' : null,
                  onSaved: (value) => duration = int.tryParse(value!),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Cantidad de puntos'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Ingrese la cantidad de puntos' : null,
                  onSaved: (value) => pointsQuantity = int.tryParse(value!),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Condiciones especiales'),
                  validator: (value) => value!.isEmpty ? 'Ingrese las condiciones especiales' : null,
                  onSaved: (value) => specialsConditions = value,
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
            child: const Text('Adicionar'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                String campaignId = _firestore.collection('commerce').doc().id; // Generar un id único
                Campaign newCampaign = Campaign(
                  id: campaignId, // Usar el id generado
                  campaignName: campaignName!,
                  duration: duration!,
                  pointsQuantity: pointsQuantity!,
                  specialsConditions: specialsConditions!,
                );

                await AuthMethods().addCampaignToCommerce(widget.commerceId, newCampaign);

                setState(() {
                  _campaigns.add(newCampaign);
                });

                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Campaña creada de forma satisfactoria'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

  void _showEditCampaignDialog(Campaign campaign) {
  final _formKey = GlobalKey<FormState>();
  String? campaignName = campaign.campaignName;
  int? duration = campaign.duration;
  int? pointsQuantity = campaign.pointsQuantity;
  String? specialsConditions = campaign.specialsConditions;

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
                  decoration: const InputDecoration(labelText: 'Nombre de la Campaña'),
                  validator: (value) => value!.isEmpty ? 'Ingrese el nombre de la campaña' : null,
                  onSaved: (value) => campaignName = value,
                ),
                TextFormField(
                  initialValue: duration.toString(),
                  decoration: const InputDecoration(labelText: 'Duración (días)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Ingrese la duración' : null,
                  onSaved: (value) => duration = int.tryParse(value!),
                ),
                TextFormField(
                  initialValue: pointsQuantity.toString(),
                  decoration: const InputDecoration(labelText: 'Cantidad de puntos'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Ingrese la cantidad de puntos' : null,
                  onSaved: (value) => pointsQuantity = int.tryParse(value!),
                ),
                TextFormField(
                  initialValue: specialsConditions,
                  decoration: const InputDecoration(labelText: 'Condiciones especiales'),
                  validator: (value) => value!.isEmpty ? 'Ingrese las condiciones especiales' : null,
                  onSaved: (value) => specialsConditions = value,
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
            child: const Text('Guardar'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Campaign updatedCampaign = Campaign(
                  id: campaign.id, // Mantener el mismo id
                  campaignName: campaignName!,
                  duration: duration!,
                  pointsQuantity: pointsQuantity!,
                  specialsConditions: specialsConditions!,
                );

                await AuthMethods().updateCampaignInCommerce(widget.commerceId, updatedCampaign);

                setState(() {
                  int index = _campaigns.indexWhere((c) => c.id == campaign.id);
                  if (index != -1) {
                    _campaigns[index] = updatedCampaign;
                  }
                });

                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Campaña actualizada de forma satisfactoria'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

void _deleteCampaign(Campaign campaign) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Eliminar Campaña'),
        content: Text('¿Estás seguro de que deseas eliminar la campaña "${campaign.campaignName}"?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Eliminar'),
            onPressed: () async {
              await AuthMethods().deleteCampaignFromCommerce(widget.commerceId, campaign.id);

              setState(() {
                _campaigns.removeWhere((c) => c.id == campaign.id);
              });

              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Campaña eliminada de forma satisfactoria'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      );
    },
  );
}



}
