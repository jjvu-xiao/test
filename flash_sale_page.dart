import 'package:fenggomall/application/common/widget/index.dart';
import 'package:fenggomall/application/common/widget/text/common_text.dart';
import 'package:fenggomall/application/common/widget/text/money_text.dart';
import 'package:fenggomall/config/resource_mananger.dart';
import 'package:fenggomall/framework/base/base_state.dart';
import 'package:fenggomall/model/flash_sale_home_entity.dart';
import 'package:fenggomall/provider/provider_widget.dart';
import 'package:fenggomall/provider/view_state_widget.dart';
import 'package:fenggomall/ui/goods/goods_detail_page.dart';
import 'package:fenggomall/ui/goods/goods_share_widget.dart';
import 'package:fenggomall/ui/widget/image_extended.dart';
import 'package:fenggomall/ui/widget/text_common.dart';
import 'package:fenggomall/utils/color_utils.dart';
import 'package:fenggomall/utils/other_utils.dart';
import 'package:fenggomall/utils/share_utils.dart';
import 'package:fenggomall/view_model/flash_sale_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nav_router/nav_router.dart';

import 'widget/sale_progress_widget.dart';


class FlashSalePage extends StatefulWidget {

  int flashSaleIndex;

  FlashSalePage(
      {Key key, this.flashSaleIndex : 0}) : super(key: key);

  @override
  _FlashSalePageState createState({Key key}) => _FlashSalePageState();
}

class _FlashSalePageState extends BaseState<FlashSalePage>
    with TickerProviderStateMixin {
  FlashSaleModel model = FlashSaleModel();

  TabController flashSaleTabController;

  // int flashSaleIndex = 1;

  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;
    return ProviderWidget<FlashSaleModel>(
      model: model,
      onModelReady: (model) async {
        await model.getFlashSaleList();
        if (flashSaleTabController == null) {
          flashSaleTabController = TabController(
              length: model.entity.flashSaleList.length, vsync: this);
        }
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Color.fromRGBO(248, 248, 248, 1),
          body: viewStateBuilder(context, model, null) ??
              Stack(
                children: <Widget>[
                  ImageAsset('flash_sale_bg',
                      width: double.infinity,
                      height: 175 + top,
                      fit: BoxFit.fill),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        height: 44,
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  pop();
                                },
                                child: Row(
                                    children: [
                                      SizedBox(
                                        width: 12,
                                      ),
                                      ImageAsset('title_back_w', width: 11, height: 20),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      TextCommon(
                                        '限时秒杀',
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ]
                                )
                            ),
                            Spacer(),
                            ImageAsset(
                              'flash_sale_share_white',
                              size: 14,
                            ),
                            SizedBox(
                              width: sWidth(8),
                            ),
                            CustomClickWidget(
                              child: TextCommon(
                                '分享',
                                size: 14,
                                color: Colors.white,
                              ),
                              singleClick: () {
                                showSheet(GoodsShareWidget(
                                  WXSharePageType.FLASHSALE,
                                  shareModel: model.entity,
                                ));
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        // ),
                      ),
                      SingleChildScrollView(
                        // margin: EdgeInsets.only(top: 100),
                        child: TabBar(
                          tabs:
                          model.entity.flashSaleList.asMap().keys.map((e) {
                            FlashSaleHomeFlashSaleList listItemModel =
                            model.entity.flashSaleList[e];
                            return Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 1,
                                ),
                                TextCommon(
                                  listItemModel.gmtStartStr,
                                  size: widget.flashSaleIndex == e
                                      ? sFontSize(52)
                                      : sFontSize(36),
                                  medium: widget.flashSaleIndex == e,
                                  color: widget.flashSaleIndex == e
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(255, 255, 255, 0.6),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: widget.flashSaleIndex == e
                                            ? Color.fromRGBO(255, 255, 255, 1)
                                            : Color.fromRGBO(255, 255, 255, 0),
                                      ),
                                      child: TextCommon(
                                        listItemModel.statusDesc,
                                        size: sFontSize(28),
                                        center: true,
                                        bold: widget.flashSaleIndex == e,
                                        color: widget.flashSaleIndex == e
                                            ? ColorUtils.fromHex('#FF1D3E')
                                            : Color.fromRGBO(
                                            255, 255, 255, 0.6),
                                      ),
                                      padding: sInsetsHV(20, 6),
                                    )
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                          controller: flashSaleTabController,
                          indicatorColor: Color.fromRGBO(1, 1, 1, 0),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 1,
                          indicatorPadding: EdgeInsets.only(top: 0),
                          onTap: (index) {
                            setState(() {
                              widget.flashSaleIndex = index;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: model.entity?.flashSaleList == null
                              ? Container()
                              : IndexedStack(
                            index: widget.flashSaleIndex,
                            children:
                            model.entity.flashSaleList.map((mode) {
                              return Container(
                                child: ListView.separated(
                                  padding: EdgeInsets.only(top: 14),
                                  itemBuilder: (_, index) =>
                                      buildFlashSaleListItem(
                                          mode.flashSaleSkuList[index]),
                                  itemCount: mode.flashSaleSkuList.length,
                                  separatorBuilder: (_, index) =>
                                      SizedBox(
                                        height: 12,
                                      ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        );
      },
    );
  }

  get mainColor => Theme.of(context).primaryColor;

  ///抢购的每个商品
  buildFlashSaleListItem(FlashSaleHomeFlashSaleListFlashSaleSkuList model) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        routePush(GoodsDetailPage(
          goodsId: model.spuId.toString(),
        ));
      },
      child: Container(
        height: sHeight(278),
        width: double.infinity,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 12,
            ),
            Container(
              padding: EdgeInsets.only(top: 12),
              child: ImageNetwork(
                model.icon,
                width: 115,
                height: 115,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 10),
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          SizedBox(
                            height: 8,
                          ),
                          TextCommon(
                            model.spuName,
                            maxLines: 2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SaleProgressWidget(
                        progress:
                        (1-model.exhibitionStock / model.exhibitionTotalStock) * 100,
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              MoneyText(model.sellingPrice.toString(), 40),
                              SizedBox(
                                width: sWidth(10),
                              ),
                              TextCommon(
                                '￥ ${OtherUtils.cutZero(model.marketPrice.toString())}',
                                // '￥' + model.marketPrice.toString(),
                                size: 10,
                                color: ColorUtils.fromHex('#999999'),
                                decoration: TextDecoration.lineThrough,
                              ),
                              // CommonText(
                              //   '¥ ${OtherUtils.cutZero(model.marketPrice.toString())}',
                              //   textDecoration: TextDecoration.lineThrough,
                              //   fontSize: 24,
                              //   overflow: TextOverflow.ellipsis,
                              //   textColor: ColorsHelper.hintColor,
                              // )
                              // TextCommon(
                              //   "￥",
                              //   size: 10,
                              //   color: mainColor,
                              // ),
                              // TextCommon(
                              //   (model.sellingPrice / 100 ?? 0 ~/ 1)
                              //       .toInt()
                              //       .toString(),
                              //   // "99",
                              //   color: mainColor,
                              //   size: 18,
                              //   height: 0.9,
                              //   bold: true,
                              // ),
                              // TextCommon(
                              //   OtherUtils.getFloatString(
                              //       model.sellingPrice / 100 ?? 0),
                              //   color: mainColor,
                              //   size: 12,
                              // ),
                              // TextCommon(
                              //   // '￥ ${OtherUtils.cutZero(model.marketPrice})',
                              //   '￥' + model.marketPrice.toString(),
                              //   size: 10,
                              //   color: ColorUtils.fromHex('#999999'),
                              //   decoration: TextDecoration.lineThrough,
                              // ),
                            ],
                          ),

                          if (this.model.entity.flashSaleList[widget.flashSaleIndex].statusDesc == '即将开始')
                            Container(
                                padding: sInsetsHV(30, 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                    border: Border.all(
                                        width: 1, color: ColorsHelper.hintColor),
                                    color: ColorsHelper.hintColor
                                ),
                                child: TextCommon(
                                  '即将开始',
                                  size: 14,
                                  color: Colors.white,
                                )
                            )
                          else if (model.exhibitionStock > 0)
                            Container(
                              padding: sInsetsHV(30, 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  border: Border.all(
                                      width: 1, color: ColorsHelper.primaryColor),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 255, 45, 61),
                                      Color.fromARGB(255, 255, 120, 130)
                                    ],
                                  )),
                              child: Column(
                                children: <Widget>[
                                  TextCommon(
                                    // '22件已售',
                                    '${model.salesVolume.toString()}件已售',
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                  TextCommon(
                                    '马上抢',
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              padding: sInsetsHV(25, 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: ColorsHelper.hintColor
                              ),
                              child: Column(
                                children: <Widget>[
                                  TextCommon(
                                    '已抢完',
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )

                          // model.exhibitionStock > 0 ?
                          // Container(
                          //   padding: sInsetsHV(30, 10),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //           bottomLeft: Radius.circular(5),
                          //           topLeft: Radius.circular(5),
                          //           topRight: Radius.circular(5)),
                          //       border: Border.all(
                          //           width: 1, color: ColorsHelper.primaryColor),
                          //       gradient: LinearGradient(
                          //         colors: [
                          //           Color.fromARGB(255, 255, 45, 61),
                          //           Color.fromARGB(255, 255, 120, 130)
                          //         ],
                          //       )),
                          //   child: Column(
                          //     children: <Widget>[
                          //       TextCommon(
                          //          // '22件已售',
                          //         '${model.salesVolume.toString()}件已售',
                          //         size: 10,
                          //         color: Colors.white,
                          //       ),
                          //       TextCommon(
                          //         '马上抢',
                          //         size: 14,
                          //         color: Colors.white,
                          //       ),
                          //     ],
                          //   ),
                          // )
                          // :
                          // Container(
                          //   padding: sInsetsHV(25, 20),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.only(
                          //         bottomLeft: Radius.circular(5),
                          //         topLeft: Radius.circular(5),
                          //         topRight: Radius.circular(5)),
                          //     color: ColorsHelper.hintColor
                          //   ),
                          //   child: Column(
                          //     children: <Widget>[
                          //       TextCommon(
                          //         '已抢完',
                          //         size: 16,
                          //         color: Colors.white,
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  orderItem(String icon, int count, String text, int index) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 40,
              height: 24,
              child: Stack(
                children: <Widget>[
                  ImageAsset(icon, width: 40, height: 24),
                  Visibility(
                    visible: count != 0,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFF9B37),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: 15,
                        height: 15,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: TextCommon('$count',
                                  color: Colors.white, size: 8),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            TextCommon(text, color: ColorsHelper.threeColor, size: 12),
          ],
        ),
      ),
    );
  }

  bottomItem(String icon, String text, String route, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ImageAsset(icon, width: 38, height: 30),
            SizedBox(height: 4),
            TextCommon(text, color: ColorsHelper.sixColor, size: 12),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  // * 弹出方法
  showSheet(widget) async {
    return await showModalBottomSheet(
      backgroundColor: Color(0x000000),
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return widget;
      },
    );
  }
}


