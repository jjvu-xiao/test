import 'package:fenggomall/application/common/widget/container/lx_radius_container.dart';
import 'package:fenggomall/config/resource_mananger.dart';
import 'package:fenggomall/model/order_message_item_entity.dart';
import 'package:fenggomall/model/system_message_item_entity.dart';
import 'package:fenggomall/provider/provider_widget.dart';
import 'package:fenggomall/provider/view_state_widget.dart';
import 'package:fenggomall/ui/chat/message/system_info_page.dart';
import 'package:fenggomall/ui/widget/app_bar_common.dart';
import 'package:fenggomall/ui/widget/app_bar_left_title.dart';
import 'package:fenggomall/ui/widget/image_extended.dart';
import 'package:fenggomall/ui/widget/text_common.dart';
import 'package:fenggomall/ui/widget/toast_common.dart';
import 'package:fenggomall/utils/other_utils.dart';
import 'package:fenggomall/utils/ui_util.dart';
import 'package:fenggomall/view_model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nav_router/nav_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'widget/message_time_widget.dart';

class SystemMessagesPage extends StatefulWidget {
  SystemMessagesPage({Key key}) : super(key: key);

  @override
  _SystemMessagesPageState createState() => _SystemMessagesPageState();
}

class _SystemMessagesPageState extends State<SystemMessagesPage> with UI {
  SystemMessageListModel _systemMessageListModel = SystemMessageListModel();

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SystemMessageListModel>(
      model: _systemMessageListModel,
      builder: (context, addressListModel, child) {
        return Scaffold(
          appBar: AppBarLeftTitle(title: '系统消息'),
          body: _renderBody(),
        );
      },
      onModelReady: (addressListModel) => addressListModel.initData(),
    );
  }

  Widget _itemCell(SystemMessageItemEntity itemEntity) {
    //var msgLogisticInfoList = list.messageInfoDetailVO.msgLogisticInfoList;
    return Column(
      children: [
        // MessageTimeWidget(timeStamp: itemEntity.messageInfoDetailVO.gmtPublish.floor()),
        LxRadiusContainer(
          radius: 0,
          margin: sInsetsHV(30, 24),
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextCommon(
                      itemEntity.messageInfoDetailVO.messageTitle,
                      bold: true,
                      maxLines: 1,
                      color: ColorsHelper.sixColor,
                    ),
                  ),
                  SizedBox(
                    width: sWidth(20),
                  ),
                  if (itemEntity.readStatus == 2)
                    TextCommon(
                        OtherUtils.timeFormat(
                          itemEntity.messageInfoDetailVO.gmtPublish.floor(),
                        ),
                        size: 12,
                        color: ColorsHelper.nineColor)
                  else
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(4, 4, 4, 2),
                      // decoration: BoxDecoration(
                      //   color: Colors.black.withOpacity(0.1),
                      //   borderRadius: BorderRadius.all(Radius.circular(2)),
                      // ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(23, 255, 123, 133),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: TextCommon('已读', size: 10,
                          // color: Colors.white,
                          color: ColorsHelper.primaryColor,
                          height: 1
                      ),
                    )
                ],
              ),
              SizedBox(height: 10),
              TextCommon(itemEntity?.messageInfoDetailVO?.subtitle ?? '',
                  color: ColorsHelper.sixColor, maxLines: 2)
            ],
          ),
        ),
      ],
    );
  }

  _renderBody() {
    Widget empty = Column(
      children: <Widget>[
        SizedBox(height: 34),
        ImageAsset('MassageEmpty', width: 300, height: 280),
        SizedBox(height: 20),
        TextCommon('您暂时没有信息要处理~', color: ColorsHelper.nineColor, size: 14),
        SizedBox(height: 12),
        // GestureDetector(
        //   onTap: () {
        //     popUntil(ModalRoute.withName(MainPage().toStringShort()));
        //     eventBus.fire(PageEvent(0));
        //   },
        //   child: Container(
        //     alignment: Alignment.center,
        //     margin: EdgeInsets.symmetric(horizontal: 70),
        //     decoration: BoxDecoration(
        //         color: ColorsHelper.primaryColor, borderRadius: BorderRadius.circular(20)),
        //     height: 40,
        //     child: TextCommon('去首页看看吧', size: 14, color: Colors.white, medium: true),
        //   ),
        // )
      ],
    );
    return viewStateBuilder(
            context, _systemMessageListModel, () => _systemMessageListModel.loadData(),
            empty: empty) ??
        SmartRefresher(
          controller: _systemMessageListModel.refreshController,
          onRefresh: () => _systemMessageListModel.refresh(),
          child: ListView.builder(
            itemCount: _systemMessageListModel.list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    if (_systemMessageListModel.list[index].readStatus == 2) {
                      MessageDoReadModel model = MessageDoReadModel();
                      model
                          .messageDoRead(
                              _systemMessageListModel.list[index].messageInfoDetailVO.id.floor())
                          .then((value) {
                        if (!value) {
                          showToastCommon(model.errorMessage);
                        } else {
                          setState(() {
                            _systemMessageListModel.list[index].readStatus = 1;
                          });
                        }
                      });
                    }
                    routePush(SystemInfoPage(itemEntity: _systemMessageListModel.list[index]));
                  },
                  child: _itemCell(_systemMessageListModel.list[index]));
            },
          ),
        );
  }
}
