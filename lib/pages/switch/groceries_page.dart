import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:influx/widgets/status_container.dart';
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
      // check if inserted product is a barcode
      final product = GroceriesService.looksLikeBarcode(cleanQuery)
          ? await GroceriesService.searchByBarcode(cleanQuery)
          : null;

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
    } on OpenFoodFactsRateLimitException {
      setState(() {
        _errorMessage = 'Troppe richieste a Open Food Facts. Riprova tra un minuto.';
      });
    } on OpenFoodFactsServiceException {
      setState(() {
        _errorMessage = 'Open Food Facts non risponde al momento. Riprova tra poco.';
      });
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
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        bool isModalLoading = true;
        List<GroceryProduct> ecoAlternatives = [];
        String? ecoErrorMessage;
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
              }).catchError((e) {
                if (modalContext.mounted) {
                  setModalState(() {
                    if (e is OpenFoodFactsRateLimitException) {
                      ecoErrorMessage = 'Troppe richieste a Open Food Facts. Riprova tra un minuto.';
                    } else if (e is OpenFoodFactsServiceException) {
                      ecoErrorMessage = 'Open Food Facts non risponde al momento. Riprova tra poco.';
                    } else {
                      ecoErrorMessage = 'Errore nel caricamento delle alternative';
                    }
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
                  errorMessage: ecoErrorMessage,
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
            StatusContainer(
              title: _errorMessage!,
              description: "Prova a cercare qualcos'altro",
              icon: LucideIcons.search_x,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AppContainer(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProductImage(product, size: 68),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.containerTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product.brand.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        product.brand,
                        style: AppTypography.containerBody.copyWith(
                          color: AppColors.white.withValues(alpha: 0.55),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (product.ecoscore != null) ...[
                      const SizedBox(height: 8),
                      _buildEcoscoreBadge(product.ecoscore!),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                LucideIcons.chevron_right,
                size: 18,
                color: AppColors.white.withValues(alpha: 0.25),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(GroceryProduct product, {required double size}) {
    final placeholder = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.containerBorder, width: 1),
      ),
      child: Icon(
        LucideIcons.package,
        color: AppColors.white.withValues(alpha: 0.25),
        size: size * 0.4,
      ),
    );

    if (product.imageUrl.isEmpty) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.containerBackground,
          border: Border.all(color: AppColors.containerBorder, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image.network(
          product.imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(
              child: SizedBox(
                width: size * 0.3,
                height: size * 0.3,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white.withValues(alpha: 0.25),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => placeholder,
        ),
      ),
    );
  }

  Widget _buildEcoscoreBadge(String grade) {
    final color = _getEcoscoreColor(grade);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.leaf, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            'Eco-Score ${grade.toUpperCase()}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductModalContent({
    required BuildContext context,
    required ScrollController scrollController,
    required GroceryProduct product,
    required List<GroceryProduct> ecoAlternatives,
    required bool isLoading,
    String? errorMessage,
  }) {
    return PagePadding(
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModalHeroImage(product),
            const SizedBox(height: 24),
            Text(
              product.name,
              style: AppTypography.pageTitle,
            ),
            if (product.brand.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                product.brand,
                style: AppTypography.pageSubtitle,
              ),
            ],
            if (product.ecoscore != null) ...[
              const SizedBox(height: 12),
              _buildEcoscoreBadge(product.ecoscore!),
            ],
            const SizedBox(height: 16),
            const Divider(color: AppColors.containerBorder,),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  LucideIcons.leaf,
                  size: 16,
                  color: AppColors.white.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Alternative più ecologiche',
                  style: AppTypography.containerTitle,
                ),
                if (!isLoading && errorMessage == null && ecoAlternatives.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.containerBackground,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${ecoAlternatives.length}',
                      style: AppTypography.containerBody.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(
                    color: AppColors.btnBackground,
                  ),
                ),
              )
            else if (errorMessage != null)
              _buildModalStatus(icon: LucideIcons.wifi_off, message: errorMessage)
            else if (ecoAlternatives.isEmpty)
                _buildModalStatus(
                  icon: LucideIcons.leaf,
                  message: 'Nessuna alternativa più ecologica trovata',
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

  Widget _buildModalHeroImage(GroceryProduct product) {
    final placeholder = Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.containerBorder, width: 1),
      ),
      child: Center(
        child: Icon(
          LucideIcons.package,
          color: AppColors.white.withValues(alpha: 0.25),
          size: 44,
        ),
      ),
    );

    if (product.imageUrl.isEmpty) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.containerBackground,
          border: Border.all(color: AppColors.containerBorder, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.network(
          product.imageUrl,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white.withValues(alpha: 0.25),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => placeholder,
        ),
      ),
    );
  }

  Widget _buildModalStatus({required IconData icon, required String message}) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.white.withValues(alpha: 0.3), size: 28),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.containerBody,
            ),
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