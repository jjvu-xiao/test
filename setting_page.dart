import 'dart:io';

import 'package:fenggomall/config/resource_mananger.dart';
import 'package:fenggomall/eventbus/event_bus.dart';
import 'package:fenggomall/ui/address/address_list_page.dart';
import 'package:fenggomall/ui/helper/dialog_helper.dart';
import 'package:fenggomall/ui/mine/about_page.dart';
import 'package:fenggomall/ui/mine/account_page.dart';
import 'package:fenggomall/ui/mine/datum_page.dart';
import 'package:fenggomall/ui/page/main/main_page.dart';
import 'package:fenggomall/ui/widget/app_bar_left_title.dart';
import 'package:fenggomall/ui/widget/divider.dart';
import 'package:fenggomall/ui/widget/image_extended.dart';
import 'package:fenggomall/ui/widget/text_common.dart';
import 'package:fenggomall/ui/widget/toast_common.dart';
import 'package:fenggomall/utils/other_utils.dart';
import 'package:fenggomall/view_model/login_model.dart';
import 'package:fenggomall/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nav_router/nav_router.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  PackageInfo packageInfo;
  int _cacheSize = 0;

  @override
  void initState() {
    super.initState();
    loadCache();

    PackageInfo.fromPlatform().then((value) {
      setState(() {
        packageInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsHelper.bgColor,
      appBar: AppBarLeftTitle(title: '设置'),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return _item('个人资料', '', false, () => routePush(DatumPage()));
              break;
            case 1:
              return _item('账户安全', '', false, () => routePush(AccountPage()));
              break;
            case 2:
              return _item('管理收货地址', '', true, () {
                routePush(AddressListPage(
                  isFromConfirmOrder: false,
                ));
              });
              break;
            case 3:
              return _item(
                  '清除缓存', '(${OtherUtils.getRollupSize(_cacheSize)})', true, () => _clearCache());
              break;
            case 4:
              return _item('关于蜂go', '', true, () {
                routePush(AboutPage(packageInfo: packageInfo));
              });
              break;
            case 5:
              return _item('当前版本', '${packageInfo?.version ?? 0}(${packageInfo?.buildNumber ?? 0})',
                  true, () {},
                  isRight: false);
              break;
            case 6:
              return GestureDetector(
                onTap: () async {
                  if (await DialogHelper.showCupertinoAlertDialog(context, '确定要退出当前登录吗？',
                      isCenter: true)) {
                    LoginOutModel().loginOut();
                    UserModel().clearUser();
                    popUntil(ModalRoute.withName(MainPage().toStringShort()));
                    eventBus.fire(PageEvent(0));
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 46,
                  color: Colors.white,
                  child: TextCommon('退出登录', size: 16, color: ColorsHelper.nineColor),
                ),
              );
              break;
            default:
              return SizedBox();
          }
        },
      ),
    );
  }

  _item(String title, String subTitle, bool isLongDivider, GestureTapCallback onTap,
      {bool isRight = true}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 46,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                TextCommon(title, color: Colors.black, size: 14),
                Spacer(),
                if (subTitle.length > 0)
                  TextCommon(subTitle, size: 14, color: ColorsHelper.nineColor, height: 1),
                if (isRight) ImageAsset('arrow_right', size: 15)
              ],
            ),
          ),
          if (isLongDivider)
            DividerHorizontal(height: 12)
          else
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: DividerHorizontal(),
            ),
        ],
      ),
    );
  }

  Future<Null> loadCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      print('临时目录大小: ' + value.toString());
      setState(() {
        _cacheSize = value.toInt();
      });
    } catch (err) {
      print(err);
    }
  }

  /// 递归方式 计算文件的大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  void _clearCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      //删除缓存目录
      await delDir(tempDir);
      await loadCache();
      showToastCommon('清除缓存成功');
    } catch (e) {
      print(e);
      showToastCommon('清除缓存失败');
    } finally {}
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }
}
