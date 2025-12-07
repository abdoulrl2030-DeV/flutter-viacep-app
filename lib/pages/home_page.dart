import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cep_controller.dart';
import '../core/utils/constants.dart';
import '../widgets/custom_text_field.dart';

/// Página inicial do aplicativo
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _cepController;
  late FocusNode _cepFocusNode;

  @override
  void initState() {
    super.initState();
    _cepController = TextEditingController();
    _cepFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _cepController.dispose();
    _cepFocusNode.dispose();
    super.dispose();
  }

  void _handleSearchCep(CepController controller) {
    final cep = _cepController.text.trim();
    if (cep.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppConstants.emptyFieldMessage),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    controller.searchCep(cep);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<CepController>(
        builder: (context, controller, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card de busca
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Campo de entrada de CEP
                        CustomTextField(
                          hintText: 'Digite um CEP (ex: 01310100)',
                          label: 'CEP',
                          controller: _cepController,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          prefixIcon: const Icon(Icons.location_on),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppConstants.emptyFieldMessage;
                            }
                            if (!controller.validateCep(value)) {
                              return AppConstants.invalidCepMessage;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 24),
                        // Botão de busca
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: controller.isLoading
                                ? null
                                : () => _handleSearchCep(controller),
                            icon: controller.isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.search),
                            label: Text(
                              controller.isLoading
                                  ? AppConstants.searchingMessage
                                  : 'BUSCAR',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Exibe erro ou resultado
                if (controller.hasError)
                  _buildErrorWidget(controller.error)
                else if (controller.hasData)
                  _buildResultWidget(controller.cepData!)
                else
                  _buildEmptyWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(String? error) {
    return Card(
      color: Colors.red[50],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.red[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                error ?? AppConstants.errorMessage,
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultWidget(dynamic cepData) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Endereço encontrado',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoRow('CEP', cepData.cep ?? 'N/A'),
            _buildInfoRow('Logradouro', cepData.logradouro ?? 'N/A'),
            if (cepData.complemento != null && cepData.complemento!.isNotEmpty)
              _buildInfoRow('Complemento', cepData.complemento!),
            _buildInfoRow('Bairro', cepData.bairro ?? 'N/A'),
            _buildInfoRow('Cidade', cepData.localidade ?? 'N/A'),
            _buildInfoRow('Estado', cepData.uf ?? 'N/A'),
            if (cepData.ddd != null && cepData.ddd!.isNotEmpty)
              _buildInfoRow('DDD', cepData.ddd!),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _cepController.clear();
                  context.read<CepController>().clearData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.grey[800],
                ),
                child: const Text('NOVA BUSCA'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          if (label != 'Estado') Divider(color: Colors.grey[200]),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.location_searching,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Digite um CEP para começar',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
