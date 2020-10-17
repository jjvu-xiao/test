import 'package:fenggomall/application/common/widget/index.dart';
import 'package:fenggomall/application/module/user/collect/view/collect_goods_page.dart';
import 'package:fenggomall/application/module/user/collect/view/collect_shop_page.dart';
import 'package:fenggomall/config/resource_mananger.dart';
import 'package:fenggomall/provider/provider_widget.dart';
import 'package:fenggomall/provider/view_state_widget.dart';
import 'package:fenggomall/service/repository_order.dart';
import 'package:fenggomall/ui/address/address_list_page.dart';
import 'package:fenggomall/ui/aftersale/after_sale_order_list/after_sale_order_list.dart';
import 'package:fenggomall/ui/aftersale/apply_after_sale/apply_after_sale_page.dart';
import 'package:fenggomall/ui/chat/card_utils.dart';
import 'package:fenggomall/ui/chat/chat_list_page.dart';
import 'package:fenggomall/ui/chat/chat_page.dart';
import 'package:fenggomall/ui/coupon/coupon_center_page.dart';
import 'package:fenggomall/ui/coupon/coupon_goods_page.dart';
import 'package:fenggomall/ui/coupon/coupon_list_page.dart';
import 'package:fenggomall/ui/helper/dialog_helper.dart';
import 'package:fenggomall/ui/insurance/my_insurance_page.dart';
import 'package:fenggomall/ui/login/login_page.dart';
import 'package:fenggomall/ui/mine/setting_page.dart';
import 'package:fenggomall/ui/mine/view_history_page.dart';
import 'package:fenggomall/application/module/order/view/order_confirm_page.dart';
import 'package:fenggomall/ui/order/order_list_page.dart';
import 'package:fenggomall/ui/widget/app_bar_common.dart';
import 'package:fenggomall/ui/widget/divider.dart';
import 'package:fenggomall/ui/widget/text_common.dart';
import 'package:fenggomall/ui/widget/toast_common.dart';
import 'package:fenggomall/view_model/chat_model.dart';
import 'package:fenggomall/view_model/order_model.dart';
import 'package:fenggomall/view_model/parameters_model.dart';
import 'package:fenggomall/view_model/user_model.dart';
import 'package:tobias/tobias.dart' as tobias;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fenggomall/ui/widget/image_extended.dart';
import 'package:nav_router/nav_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  // @override
  // bool get wantKeepAlive => true;
  UserModel userModel = UserModel();
  OrderNumModel orderNumModel = OrderNumModel();

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    double top = MediaQuery.of(context).padding.top;
    return ProviderWidget<UserModel>(
      model: userModel,
      onModelReady: (userModel) {
        userModel.getUserInfo();
        orderNumModel.getOrderNum();
        // if (!UserModel().hasUser) await routePush(LoginPage(), RouterType.material);
      },
      builder: (context, userModel, child) {
        return Scaffold(
            backgroundColor: Color.fromRGBO(248, 248, 248, 1),
            body: Stack(children: <Widget>[
              Container(
                  child: ImageAsset('User_grzx_bg_pic', width: double.infinity, height: 142 + top),
                  width: double.infinity,
                  height: 142 + top),
              Column(children: <Widget>[
                SizedBox(height: 15 + top),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 15),
                          ImageNetwork(
                            userModel.user.userIcon ?? '',
                            size: 54,
                            circle: true,
                            avatar: true,
                          ),
                          SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextCommon(
                                userModel.user.nickname ?? '',
                                color: Colors.black,
                                size: 16,
                              ),
                              SizedBox(height: 5),
                              userModel.user.membershipLevel == '普通会员'
                                  ? ImageAsset(
                                      'member_level',
                                      width: 72,
                                      height: 22,
                                    )
                                  : Stack(
                                      children: <Widget>[
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            width: 72,
                                            height: 22,
                                            child: ImageAsset(
                                              'member_level_bak',
                                              width: 72,
                                              height: 22,
                                            )),
                                        Positioned(
                                          left: 23,
                                          top: 4,
                                          child: TextCommon(
                                            userModel.user.membershipLevel,
                                            color: Colors.white,
                                            bold: true,
                                            size: 10,
                                          ),
                                        ),
                                        Container(
                                          width: 72,
                                          height: 22,
                                        ),
                                      ],
                                    )
                            ],
                          )
                        ],
                      ),
                      // onTap: () => routePush(EditUserInfo(userModel.user)),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              await routePush(SettingPage());
                              await userModel.getUserInfo();
                            },
                            child: ImageAsset(
                              'mine_setting_icon',
                              size: 22,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                routePush(ChatListPage());
                              },
                              child: ImageAsset('mine_massage_icon', size: 22)),
                          SizedBox(
                            width: 15,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 75,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      userItem('收藏', userModel.user.goodsNum, 0),
                      userItem('关注店铺', userModel.user.shopNum, 1),
                      userItem('我的积分', userModel.user.points, 2),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: 1,
                        padding: EdgeInsets.only(top: 12),
                        itemBuilder: (context, index) {
                          return Column(children: <Widget>[
                            Container(
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 15),
                                      TextCommon('我的订单',
                                          color: ColorsHelper.threeColor,
                                          size: 16,
                                          medium: true,
                                          bold: true),
                                      Spacer(),
                                      GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      routePush(OrderListPage());
                                                    },
                                                    child: TextCommon('查看全部订单',
                                                        color: ColorsHelper.nineColor, size: 12),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  ImageAsset(
                                                    'home_flash_more',
                                                    width: 4,
                                                    height: 7,
                                                  ),
                                                ],
                                              )),
                                          onTap: () async {
                                            // var payInfo =
                                            //     RepositoryOrder.getPayInfo(
                                            //         {});
                                          }
                                          // routePush(OrderListPage()),
                                          ),
                                    ],
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      orderItem(
                                          'mine_order_wait_pay',
                                          orderNumModel.orderNum.waitPayCount ?? 0,
                                          // model.entity.order.waitPay ?? 0,
                                          '待付款',
                                          0,
                                          model: userModel),
                                      orderItem(
                                          'mine_order_wait_send',
                                          orderNumModel.orderNum.waitSendCount ?? 0,
                                          // model.entity.order.waitSend ?? 0,
                                          '待发货',
                                          1,
                                          model: userModel),
                                      orderItem(
                                          'mine_order_wait_receive',
                                          orderNumModel.orderNum.waitConfirmCount ?? 0,
                                          // model.entity.order.waitReceive ??0,
                                          '待收货',
                                          2,
                                          model: userModel),
                                      orderItem(
                                          'mine_order_finish',
                                          orderNumModel.orderNum.completeCount ?? 0,
                                          // model.entity.order.waitSend ?? 0,
                                          '已完成',
                                          3,
                                          model: userModel),
                                      orderItem(
                                          'mine_order_refund',
                                          0,
                                          // model.entity.order.waitReceive ??0,
                                          '退款',
                                          4,
                                          model: userModel),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            userCell('mine_row_coupon', '我的优惠券', 1),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              color: Colors.white,
                              child: DividerHorizontal(),
                            ),
                            if (!ParametersModel().isAudit) userCell('mine_row_safe', '保险信息', 2),
                            if (!ParametersModel().isAudit)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                color: Colors.white,
                                child: DividerHorizontal(),
                              ),
                            userCell('mine_row_service', '联系客服', 3),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              color: Colors.white,
                              child: DividerHorizontal(),
                            ),
                            // userCell('mine_order_wait_pay', '多店铺下单测试', 4),
                          ]);
                        }))
              ])
            ]));
      },
    );
  }
}

userCell(String icon, String text, int actionType) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      switch (actionType) {
        case 1:
          routePush(CouponListPage());
          break;
        case 2:
          // routePush(OrderConfirmPage());
          routePush(MyInsurancePage());
          break;
        case 3:
          {
            IMGetGroup model = IMGetGroup();
            model.getGroupId({'shopId': '0', 'accountType': '1'}).then((value) {
              if (value) {
                routePush(ChatPage(model.groupId));
              } else {
                showToastCommon(model.errorMessage);
              }
            });
          }
          break;
        case 4:
          {
            List resultList = [
              {
                "goodsInfoList": [
                  {
                    "goodsId": 98,
                    "quantity": 1,
                    "skuId": 585,
                  },
                  {
                    "goodsId": 91,
                    "quantity": 1,
                    "skuId": 579,
                  },
                ],
                "shopId": 1,
              },
              {
                "goodsInfoList": [
                  {
                    "goodsId": 119,
                    "quantity": 1,
                    "skuId": 606,
                  },
                ],
                "shopId": 17,
              }
            ];

            routePush(OrderConfirmPage(list: resultList, cart: true));
          }
          break;
        default:
          break;
      }
    },
    child: Container(
      height: 54,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              ImageAsset(
                icon,
                size: 20,
              ),
              SizedBox(
                width: 12,
              ),
              TextCommon(
                text,
                size: 14,
                color: Colors.black,
              ),
            ],
          ),
          ImageAsset(
            'home_flash_more',
            width: 6,
            height: 10,
          ),
        ],
      ),
    ),
  );
}

userItem(
  String title,
  int value,
  int index,
) {
  return Container(
    width: 90,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        switch (index) {
          case 0:
            routePush(CollectionGoodsPage());
            break;
          case 1:
            routePush(CollectionShopPage());
            break;
          case 2:
            routePush(AfterSaleOrderListPage());
            break;
          default:
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextCommon(
            value.toString(),
            color: Colors.black,
            medium: true,
            size: 18,
          ),
          SizedBox(
            height: 2,
          ),
          TextCommon(
            title,
            medium: true,
            size: 12,
            color: Colors.black,
          ),
        ],
      ),
    ),
  );
}

orderItem(String icon, int count, String text, int index, {@required UserModel model}) {
  return Expanded(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 34,
            height: 24,
            child: Stack(
              children: <Widget>[
                Center(
                    child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 2,
                    ),
                    ImageAsset(
                      icon,
                      size: 22,
                    ),
                  ],
                )),
                Visibility(
                  visible: count != 0,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: OvalNumContainer(
                      count: count,
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
      onTap: () => pushOrder(index),
    ),
  );
}

pushOrder(int index) async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  if (index == 4) {
    await routePush(AfterSaleOrderListPage());
  } else {
    await routePush(OrderListPage(index: index + 1));
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

push(int index) async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  switch (index) {
    case 0:
      await routePush(CollectionGoodsPage());
      break;
    case 1:
      await routePush(CouponListPage());
      break;
    case 2:
      await routePush(CouponCenterPage());
      break;
    case 3:
      await routePush(AddressListPage());
      break;
    case 4:
      await routePush(CollectionShopPage());
      break;
    case 5:
      await routePush(ViewHistoryPage());
      break;
    case 6:
      // await routePush(CouponGoodsPage());
      break;
    default:
      await routePush(CollectionGoodsPage());
      break;
  }

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}
