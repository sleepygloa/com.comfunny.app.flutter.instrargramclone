import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/avatar_widget.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/components/user_card.dart';
import 'package:flutter_clone_instagram/src/controller/api_service.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/dto/my_post_dto.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_data_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/controller/inatargram_login_controller.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/mypost/my_post.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/profile/mypage_profile_edit.dart';
import 'package:flutter_clone_instagram/src/pages/login/login_page.dart';
import 'package:flutter_clone_instagram/src/pages/instargram/profile/setting.dart';
import 'package:get/get.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  late TabController tabController;
  InstargramLoginController loginController = Get.find<InstargramLoginController>();
  InstargramDataController dataController = Get.find<InstargramDataController>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    loginController.checkLoginStatus();
  }
  //화면이 변경될 때 호출되는 메서드
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginController.checkLoginStatus(); // 화면 진입 시 로그인 상태 확인
    dataController.getBasicData(context); // 화면 진입 시 MyPage 정보 조회
  }

  //로그아웃
  _logout() async {
    await loginController.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  //통계
  Widget _statisticOne(String title, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  //프로필 정보
  Widget _information() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              //나의 아바타
              GestureDetector(
                child: Obx(()=>AvatarWidget(
                  type: AvatarType.type4,
                  thumbPath: dataController.myProfile.value.thumbnailPth,
                  size: 80,
                )),
                //클릭시 아바타 확대
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: const Text('Avatar'),
                        ),
                        body: Center(
                          child: AvatarWidget(
                            type: AvatarType.type4,
                            thumbPath: dataController.myProfile.value.thumbnailPth,
                            size: 200,
                          ),
                        ),
                      ),
                    ),
                  );
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
              const SizedBox(width: 10,),
              Obx(()=>Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: _statisticOne('Post', dataController.myProfile.value.postCnt )),
                    Expanded(child: _statisticOne('Followers', dataController.myProfile.value.followerCnt )),
                    Expanded(child: _statisticOne('Following', dataController.myProfile.value.followingCnt )),
                  ],
                ),
              ))
            ],
          ),
          const SizedBox(height: 10,),
          Text(
            dataController.myProfile.value.userName,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          Text(
            dataController.myProfile.value.description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  //메뉴
  Widget _menu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const MypageProfileEdit()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: const Color(0xffdedede),
                  ),
                ),
                child: const Text(
                  '프로필 편집',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ),
          const SizedBox(width: 8,),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: const Color(0xffdedede),
              ),
              color: const Color(0xffefefef),
            ),
            child: ImageData(IconPath.addFriend),
          )
        ],
      ),
    );
  }

  //추천 친구
  Widget _discoverPeople() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discover People',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children:
              List.generate(10, (index) => UserCard(
                userId: '또노$index',
                description: '또노e$index 님이 팔로우합니다.',
                thumbPath: 'https://storage.blip.kr/collection/6628fb909a38cca29077a6a2e336a59c.jpg'
              )).toList(),
          )
        ),
      ],
    );
  }

  //탭 메뉴
  Widget _tabMenu() {
    return TabBar(
      controller: tabController,
      indicatorColor: Colors.black,
      indicatorWeight: 1,
      tabs: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ImageData(IconPath.gridViewOn),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ImageData(IconPath.myTagImageOff),
        ),
      ]
    );
  }

  //탭 뷰
  Widget _tabView() {
    return Obx(() {
      if (dataController.isLoading.value) {
        return Center(child: CircularProgressIndicator()); // 로딩 중일 때
      }
      if (dataController.myPostList.isEmpty) {
        return Center(
          child: Text(
            '게시물이 없습니다.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        );
      }
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dataController.myPostList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          PostDto postDto = dataController.myPostList[index];
          var imgPth = postDto.list[0].imgPth;
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyPost()));
            },
            child: Container(
              color: Colors.grey,
              child: Stack(
                children: [
                  Image(
                    image: NetworkImage('${ApiService.serverUrl}/${imgPth}'),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ImageData(
                      IconPath.imageSelectIcon,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '마이 페이지',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: ImageData(
              IconPath.uploadIcon,
              width: 50,
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const Setting()));
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageData(
                IconPath.menuIcon,
                width: 50,
              ),
            ),
          )
        ],
      ),

      body: RefreshIndicator(
        // 아래로 드래그시 재조회
        onRefresh: () async {
          dataController.getBasicData(context);
        },
        // 
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _information(),
              _menu(),
              _discoverPeople(),
              _tabMenu(),
              _tabView(),
              // _introduce(),
            ],
          ),
        ),
      ),
    );
  }
}