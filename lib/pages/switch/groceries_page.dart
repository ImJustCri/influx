import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/switch/grocery_model.dart';
import '../../services/groceries_service.dart';
import '../../theme.dart';
import '../../widgets/app_container.dart';
import '../../widgets/page_padding.dart';

class GroceriesPage extends StatefulWidget {
  const GroceriesPage({super.key});

  @override
  State<GroceriesPage> createState() => _GroceriesPageState();
}

class _GroceriesPageState extends State<GroceriesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<GroceryProduct> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchOpenFoodFactsUrl() async {
    final Uri url = Uri.parse('https://world.openfoodfacts.org');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _searchProduct(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final product = await GroceriesService.searchByBarcode(cleanQuery);
      if (product != null) {
        if (mounted) {
          _selectProduct(product);
        }
      } else {
        final results = await GroceriesService.searchByKeyword(cleanQuery);
        setState(() {
          _searchResults = results;
          if (results.isEmpty) {
            _errorMessage = 'Nessun prodotto trovato';
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Errore nella ricerca: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scanBarcode() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        bool isProcessing = false;

        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  child: MobileScanner(
                    controller: MobileScannerController(
                      detectionSpeed: DetectionSpeed.noDuplicates,
                      facing: CameraFacing.back,
                    ),
                    onDetect: (capture) {
                      if (isProcessing) return;

                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        final String? rawValue = barcode.rawValue;
                        if (rawValue != null && rawValue.isNotEmpty) {
                          isProcessing = true;
                          Navigator.pop(modalContext);

                          _searchController.text = rawValue;
                          _searchProduct(rawValue);
                          break;
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectProduct(GroceryProduct product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) {
        bool isModalLoading = true;
        List<GroceryProduct> ecoAlternatives = [];
        bool hasFetched = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            if (!hasFetched) {
              hasFetched = true;
              GroceriesService.getEcoFriendlyAlternatives(product)
                  .then((alternatives) {
                if (modalContext.mounted) {
                  setModalState(() {
                    ecoAlternatives = alternatives;
                    isModalLoading = false;
                  });
                }
              }).catchError((_) {
                if (modalContext.mounted) {
                  setModalState(() {
                    isModalLoading = false;
                  });
                }
              });
            }

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return _buildProductModalContent(
                  context: context,
                  scrollController: scrollController,
                  product: product,
                  ecoAlternatives: ecoAlternatives,
                  isLoading: isModalLoading,
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 72,
        title: const Text(
          "Alimentari",
          style: AppTypography.pageTitle,
        ),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: PagePadding(
        child: _buildSearchView(),
      ),
    );
  }

  Widget _buildSearchView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            _searchResults = [];
                          }
                        });
                      },
                      onSubmitted: _searchProduct,
                      style: AppTypography.containerBody,
                      decoration: InputDecoration(
                        hintText: 'Barcode o nome prodotto...',
                        hintStyle: AppTypography.containerBody.copyWith(
                          color: AppColors.white.withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          LucideIcons.search,
                          color: AppColors.white.withValues(alpha: 0.5),
                          size: 20,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(
                            LucideIcons.x,
                            color: AppColors.white.withValues(
                              alpha: 0.5,
                            ),
                            size: 20,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchResults = [];
                            });
                          },
                        )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  AppContainer(
                    padding: const EdgeInsets.all(4),
                    child: IconButton(
                      icon: const Icon(LucideIcons.barcode),
                      onPressed: _scanBarcode,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              
              AppContainer(
                width: double.infinity,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTypography.containerBody.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                    children: [
                      const TextSpan(text: 'Dati forniti da  '),
                      TextSpan(
                        text: 'Open Food Facts',
                        style: TextStyle(
                          color: AppColors.btnBackground,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _launchOpenFoodFactsUrl,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_errorMessage != null)
            AppContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.red.withValues(alpha: 0.1),
              border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
              child: Text(
                _errorMessage!,
                style: AppTypography.containerBody.copyWith(color: Colors.red),
              ),
            ),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(
                  color: AppColors.btnBackground,
                ),
              ),
            )
          else if (_searchResults.isNotEmpty)
            ...List.generate(_searchResults.length, (index) {
              final product = _searchResults[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildProductCard(
                  product: product,
                  onTap: () => _selectProduct(product),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required GroceryProduct product,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (product.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.containerBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        LucideIcons.image,
                        color: AppColors.white.withValues(alpha: 0.3),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.containerBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  LucideIcons.package,
                  color: AppColors.white.withValues(alpha: 0.3),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.containerTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.brand,
                    style: AppTypography.containerBody,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (product.ecoscore != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.leaf,
                            color: _getEcoscoreColor(product.ecoscore!),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Eco-Score ${product.ecoscore!.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getEcoscoreColor(product.ecoscore!),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              LucideIcons.arrow_right,
              color: AppColors.white.withValues(alpha: 0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductModalContent({
    required BuildContext context,
    required ScrollController scrollController,
    required GroceryProduct product,
    required List<GroceryProduct> ecoAlternatives,
    required bool isLoading,
  }) {
    return PagePadding(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.containerBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              LucideIcons.image,
                              color: AppColors.white.withValues(alpha: 0.3),
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.containerBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.package,
                        color: AppColors.white.withValues(alpha: 0.3),
                        size: 40,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  product.name,
                  style: AppTypography.pageTitle,
                ),
                const SizedBox(height: 8),
                Text(
                  product.brand,
                  style: AppTypography.pageSubtitle,
                ),
                const SizedBox(height: 8),
                if (product.ecoscore != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.leaf,
                        color: _getEcoscoreColor(product.ecoscore!),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Eco-Score ${product.ecoscore!.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getEcoscoreColor(product.ecoscore!),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.containerBorder),
            const SizedBox(height: 16),
            const Text(
              'Alternative più ecologiche',
              style: AppTypography.containerTitle,
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(
                    color: AppColors.btnBackground,
                  ),
                ),
              )
            else if (ecoAlternatives.isEmpty)
              const AppContainer(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Nessuna alternativa più ecologica trovata',
                    style: AppTypography.containerBody,
                  ),
                ),
              )
            else
              ...List.generate(ecoAlternatives.length, (index) {
                final alt = ecoAlternatives[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildProductCard(
                    product: alt,
                    onTap: () {
                      Navigator.pop(context);
                      _selectProduct(alt);
                    },
                  ),
                );
              }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Color _getEcoscoreColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'a':
        return Colors.green.shade700;
      case 'b':
        return Colors.lightGreen;
      case 'c':
        return Colors.amber;
      case 'd':
        return Colors.orange;
      case 'e':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}