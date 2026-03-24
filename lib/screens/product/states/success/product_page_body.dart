import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/product/product_fetcher.dart';
import 'package:formation_flutter/screens/product/states/success/product_header.dart';
import 'package:formation_flutter/screens/product/states/success/tabs/product_tab0.dart';
import 'package:formation_flutter/screens/product/states/success/tabs/product_tab1.dart';
import 'package:formation_flutter/screens/product/states/success/tabs/product_tab2.dart';
import 'package:formation_flutter/screens/product/states/success/tabs/product_tab3.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ProductPageBody extends StatefulWidget {
  const ProductPageBody({super.key});

  @override
  State<ProductPageBody> createState() => _ProductPageBodyState();
}

class _ProductPageBodyState extends State<ProductPageBody> {
  late ProductDetailsCurrentTab _tab;

  @override
  void initState() {
    super.initState();
    _tab = ProductDetailsCurrentTab.summary;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final fetcherState = context.read<ProductFetcher>().state as ProductFetcherSuccess;

    return Provider<Product>(
      create: (_) => fetcherState.product,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                ProductPageHeader(),
                if (fetcherState.recallData != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Material(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            context.push('/recall', extra: fetcherState.recallData);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: Colors.red),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Ce produit fait l\'objet d\'un rappel. Appuyez ici pour plus d\'informations.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsetsDirectional.only(top: 10.0),
                  sliver: SliverFillRemaining(
                    fillOverscroll: true,
                    hasScrollBody: false,
                    child: _getBody(),
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBar(
            currentIndex: _tab.index,
            onTap: (int position) => setState(
              () => _tab = ProductDetailsCurrentTab.values[position],
            ),
            items: ProductDetailsCurrentTab.values
                .map(
                  (ProductDetailsCurrentTab tab) => BottomNavigationBarItem(
                    icon: Icon(tab.icon),
                    label: tab.label(localizations),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _tab != ProductDetailsCurrentTab.summary,
          child: ProductTab0(),
        ),
        Offstage(
          offstage: _tab != ProductDetailsCurrentTab.info,
          child: ProductTab1(),
        ),
        Offstage(
          offstage: _tab != ProductDetailsCurrentTab.nutrition,
          child: ProductTab2(),
        ),
        Offstage(
          offstage: _tab != ProductDetailsCurrentTab.nutritionalValues,
          child: ProductTab3(),
        ),
      ],
    );
  }
}

enum ProductDetailsCurrentTab {
  summary(AppIcons.tab_barcode),
  info(AppIcons.tab_fridge),
  nutrition(AppIcons.tab_nutrition),
  nutritionalValues(AppIcons.tab_array);

  const ProductDetailsCurrentTab(this.icon);

  final IconData icon;

  String label(AppLocalizations appLocalizations) => switch (this) {
    ProductDetailsCurrentTab.summary => appLocalizations.product_tab_summary,
    ProductDetailsCurrentTab.info => appLocalizations.product_tab_properties,
    ProductDetailsCurrentTab.nutrition =>
      appLocalizations.product_tab_nutrition,
    ProductDetailsCurrentTab.nutritionalValues =>
      appLocalizations.product_tab_nutrition_facts,
  };
}
