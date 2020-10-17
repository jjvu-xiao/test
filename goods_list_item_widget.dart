import 'package:fenggomall/application/common/widget/other/custom_click_widget.dart';
import 'package:fenggomall/application/common/widget/text/common_text.dart';
import 'package:fenggomall/application/common/widget/text/money_text.dart';
import 'package:fenggomall/config/resource_mananger.dart';
import 'package:fenggomall/framework/base/base_state.dart';
import 'package:fenggomall/framework/util/router_util.dart';
import 'package:fenggomall/model/goodslist_entity.dart';
import 'package:fenggomall/ui/classify/classify_sub_page.dart';
import 'package:fenggomall/ui/goods/goods_detail_page.dart';
import 'package:fenggomall/ui/widget/image_extended.dart';
import 'package:fenggomall/ui/widget/text_common.dart';
import 'package:fenggomall/utils/other_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nav_router/nav_router.dart';

class GoodsItemWidget extends StatefulWidget {
  final GoodslistEntity entity;
  GoodsItemWidget(this.entity, {Key key}) : super(key: key);

  @override
  _GoodsItemWidgetState createState() => _GoodsItemWidgetState();
}

class _GoodsItemWidgetState extends BaseState<GoodsItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => routePush(GoodsDetailPage(goodsId: widget.entity.spuId.toString())),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            height: 132,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(child: ImageNetwork(widget.entity.icon, size: 112)),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextCommon(widget.entity?.spuName ?? '',
                          maxLines: 2, size: 14, color: Color(0xFF262A30)),
                      SizedBox(height: 12),
                      if (widget.entity.recommendInstallmentPlan != null)
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: ColorsHelper.primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: TextCommon(widget.entity.recommendInstallmentPlan.installmentName,
                              size: 10, color: ColorsHelper.primaryColor, height: 1),
                        ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '¥',
                                  style: TextStyle(
                                      color: ColorsHelper.primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: (widget.entity.sellingPrice ~/ 1).toString(),
                                  style: TextStyle(
                                      color: ColorsHelper.primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                TextSpan(
                                  text: OtherUtils.getFloatString(widget.entity.sellingPrice),
                                  style: TextStyle(
                                      color: ColorsHelper.primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Visibility(
                            visible: widget.entity.marketPrice != null,
                            child: Text(
                              // OtherUtils.priceFormat(widget.entity.marketPrice),
                              '¥ ${OtherUtils.cutZero(widget.entity.marketPrice.toString())}',
                              style: TextStyle(
                                color: ColorsHelper.nineColor,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 9),
                      TextCommon(
                          '热销${widget.entity.salesVolume > 10000 ? (widget.entity.salesVolume / 1000.0).toString() + '万' : widget.entity.salesVolume}件',
                          size: 10,
                          color: ColorsHelper.nineColor)
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 20,
            top: 16,
            child: Offstage(
              offstage: !(widget?.entity?.hasExhibition ?? false),
              // offstage: false,
              child: Align(
                alignment: Alignment.topLeft,
                child: HotLabel()
                // ImageAsset("second_kill_v",  height: 28,  width: 48)
              ),
            )
          )
        ],
      ),
    );
  }
}
///
/// 纵向显示商品
///
class GoodsItemCardWidget extends StatefulWidget {

  final GoodslistEntity entity;

  int index;

  GoodsItemCardWidget(this.entity,this.index, {Key key}) : super(key: key);

  @override
  _GoodsItemCardWidgetState createState() => _GoodsItemCardWidgetState();
}

class _GoodsItemCardWidgetState extends BaseState<GoodsItemCardWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomClickWidget(
        singleClick: () => RouterUtil.instance.keyPush(GoodsDetailPage(goodsId: (widget.entity.spuId ~/ 1).toString())),
        child: Stack(
          children: [
            Container(
                padding: widget.index % 2 == 0 ? EdgeInsets.fromLTRB(10, 5, 0, 0) : EdgeInsets.fromLTRB(0, 5, 10, 0) ,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ImageNetwork(
                        widget.entity?.icon ?? '',
                        width: sWidth(350),
                        height: sHeight(320),
                        fit: BoxFit.cover,
                      ),
                      // Container(color: Colors.red,height: sHeight(320), width: sWidth(350),alignment: Alignment.center,),
                      SizedBox(
                        height: sHeight(6),
                      ),
                      Expanded(
                        child: Padding(
                          padding: sInsetsHV(20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CommonText(
                                widget.entity?.spuName ?? '',
                                fontSize: 28,
                                maxLine: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: sInsetsHV(20, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            MoneyText(widget.entity.sellingPrice.toString(), 36),
                            SizedBox(
                              width: sWidth(24),
                            ),
                            Expanded(
                                child: CommonText(
                                  // '${OtherUtils.priceFormat(widget.entity.marketPrice)}',
                                  '¥ ${OtherUtils.cutZero(widget.entity.marketPrice.toString())}',
                                  textDecoration: TextDecoration.lineThrough,
                                  fontSize: 24,
                                  fontHeight: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textColor: ColorsHelper.hintColor,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: sInsetsLTRB(20, 6, 0, 24),
                        child: CommonText(
                          '热销${widget.entity.salesVolume.floor()}件',
                          fontSize: 20,
                          textColor: ColorsHelper.nineColor,
                          fontHeight: 1,
                        ),
                      )
                    ]
                )
            ),
            Positioned(
                left: widget.index % 2 == 0 ? 10 : 0,
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Offstage(
                      // offstage: false,
                        offstage: !(widget?.entity?.hasExhibition ?? false),
                        child: HotLabel()
                    )
                )
            )
            // Positioned(
            //   left: widget.index % 2 == 0 ? 10 : 0,
            //   child: Align(
            //       alignment: Alignment.topLeft,
            //       child: Offstage(
            //           offstage: false,
            //           // offstage: !(widget?.entity?.hasExhibition ?? false),
            //           child: ImageAsset("second_kill_v",  height: 28,  width: 48)
            //       )
            //   )
            // )
          ]
        )
    );
  }
}