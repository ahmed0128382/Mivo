

import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/widgets/LevelWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../util/Localization.dart';
import '../../../util/SizeConfig.dart';
import '../../../util/app_constants.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../viewmodels/Language_Viewmodel/LanguageViewmodel.dart';
import '../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
class LevelScrean extends StatelessWidget {
  const LevelScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);

    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.black),backgroundColor: Colors.white,title:   Text(getLang(context: context,key: "Level"),style: style2,),automaticallyImplyLeading: true ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),
            SliverToBoxAdapter(child:  Row(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(radius: 35,backgroundColor: whitecolor,backgroundImage: CachedNetworkImageProvider(user.userinfo?.image??Images.profilephoto)),
                SizedBox(width:Dimensions.FONT_SIZE_EXTRA_LARGE,),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('${user.userinfo?.name}' ,style: style2.copyWith(fontSize: 20),),
                      LevelWidget(Karisma:user.userinfo?.Karisma??0 ),
                      const  SizedBox(height:   5,),

                      Row(
                        children: [
                          Expanded(child: ProgressLine(percentage:((user.userinfo?.Karisma??0)/UserLevel.where((element) => element['Level']==(int.parse(UserLevel.where((element) => element['karisma']<=user.userinfo?.Karisma).last['Level'])+1).toString()).first['karisma']*100).round())),
                          const  SizedBox(width:   50,),
                        ],
                      )

                    ],
                  ),
                ),

              ],

            ),),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),
            SliverToBoxAdapter(child:Center(child: InkWell(onTap: () {

 },child: Text(getLang(context: context, key: "Privileges"),style: style2.copyWith(fontSize: 16,fontWeight: FontWeight.bold),))),),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),
          SliverToBoxAdapter(child:      Container(width: SizeConfig.screenWidth!,child: Row(
            children: [
              Expanded(
                child: InkWell(onTap:(){
                  //  Provider.of<LevelViewModel>(context,listen: false).UserlevelGifts(context: context);
                  // Navigator.pushNamed(context, '${AppConstants.Level_Gifts}');
                } ,
                  child: Column(
                    children: [
                      Image.asset(Images.GETLEVEL1,width: 90,height: 90),

                      Text(getLang(context: context, key: "Level_Gifts"),style: style6.copyWith(fontSize: 13),),

                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(onTap:(){
                  showDialog(context: context,builder: (context) {
                    return AlertDialog(backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      content:Container(
                          child: Column(mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  InkWell(onTap: (){Navigator.pop(context);},child: Icon(Icons.cancel_outlined,color: Colors.black54)),
                                  const Spacer(),
                                  Icon(Icons.cancel_outlined,color: whitecolor),

                                ],
                              ),
                              Text(getLang(context: context, key: "level_frame"),style: style5.copyWith(fontSize: 16,fontWeight: FontWeight.bold),),
                              SizedBox(height: 15,),

                              Container(width: 250,height: 300,
                                child: GridView.builder(
                                  itemCount: user.LevelFrames.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:   2 ,childAspectRatio: 0.8 ),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      decoration: BoxDecoration(color:Color(0xFFFAFAFA),borderRadius: BorderRadius.circular(20)),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(width: 80,height: 80,child:  CachedNetworkImage(
                                              imageUrl:user.LevelFrames[index].image??Images.Level  ,fit: BoxFit.cover)),
                                          Text('${user.LevelFrames[index].levelStart} - ${user.LevelFrames[index].levelEnd}',style: TextStyle(fontWeight: FontWeight.bold)),

                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Text(getLang(context: context, key: "Clarification") ,style: style5.copyWith(fontSize: 16,fontWeight: FontWeight.bold),),
                              Text('${getLang(context: context, key: "Receved_frame")} 19 , 39 ,59 79 ,99 ,119,.....,300',style: style6.copyWith(fontSize: 13)),

                            ],
                          )
                      ),

                    );
                  },);
                } ,
                  child: Column(
                    children: [
                      Image.asset(Images.GETLEVEL3,width: 90,height: 90),
                      Text(getLang(context: context, key: "level_frame"),style: style6.copyWith(fontSize: 13)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: (){
                    showDialog(context: context,builder: (context) {
                      return AlertDialog(backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        content:Container(
                            child: Column(mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    InkWell(onTap: (){Navigator.pop(context);},child: Icon(Icons.cancel_outlined,color: Colors.black54)),
                                    const Spacer(),
                                    Icon(Icons.cancel_outlined,color: whitecolor),

                                  ],
                                ),
                                Text( getLang(context: context, key: "Level_badge") ,style: style5.copyWith(fontSize: 16,fontWeight: FontWeight.bold),),
                                const SizedBox(height: 15,),
                                Column(
                                  children: [
                                    Container(color:  Colors.grey.withOpacity(0.2),child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(getLang(context: context, key: "level"),style: style6.copyWith(fontSize: 13)),
                                          Text(getLang(context: context, key: "symbol_picture") ,style: style6.copyWith(fontSize: 13)),
                                        ],
                                      ),
                                    ),)

                                  ],
                                ),
                                Container(height: 200,
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Column(
                                        children: List.generate(LevelsListmodel.length, (index) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,

                                            children: [
                                              Text('${LevelsListmodel[index].start}-${LevelsListmodel[index].end}',style: TextStyle(fontWeight: FontWeight.bold)),
                                              Image.asset(LevelsListmodel[index].image??"" ,width: 50),
                                            ],
                                          ),
                                        ))
                                    ),
                                  ),
                                ),
                                Text(getLang(context: context, key: "Clarification") ,style: style5.copyWith(fontSize: 16,fontWeight: FontWeight.bold),),
                                Text(getLang(context: context, key: "note"),style: style6.copyWith(fontSize: 13)),

                              ],
                            )
                        ),

                      );
                    },);
                  },
                  child: Column(
                    children: [
                      Image.asset(Images.GETLEVEL2,width:90,height: 90),
                      Text(getLang(context: context, key: "Level_badge") ,style: style6.copyWith(fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),),),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
           SliverToBoxAdapter(child:  Center(child: Text(getLang(context: context, key: "How_level"),style: style5.copyWith(fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
            SliverToBoxAdapter(
              child:   Lang=='En'?Column(
                  children:List.generate(LevelsContentEN.length, (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                        Image.asset(LevelsContentEN[index].image??'',height: 30,width: 30),
                        SizedBox(width:   10),
                        Column(  crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(LevelsContentEN[index].name??'',style: style5.copyWith(fontWeight: FontWeight.bold,fontSize: 12),),
                            SizedBox(height: 3),
                            Container(width:300,child: Text(LevelsContentEN[index].description??'',style: styleb45.copyWith(fontSize: 12),)),
                          ],)
                      ]),
                    ),
                  ))
              ):Column(
                  children:List.generate(LevelsContent.length, (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                        Image.asset(LevelsContent[index].image??'',height: 30,width: 30),
                        SizedBox(width:   10),
                        Column(  crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(LevelsContent[index].name??'',style: style5.copyWith(fontWeight: FontWeight.bold,fontSize: 12),),
                            SizedBox(height: 3),
                            Container(width:300,child: Text(LevelsContent[index].description??'',style: styleb45.copyWith(fontSize: 12),)),
                          ],)
                      ]),
                    ),
                  ))
              )
            )
          ],
        ),
      )
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = Colors.lightBlueAccent,
    required this.percentage,
  }) : super(key: key);

  final Color color;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    var sum=((user.userinfo?.Karisma??0)-UserLevel.where((element) => element['karisma']<=user.userinfo?.Karisma).last['karisma']).round();
    var total=UserLevel.where((element) => element['Level']==(int.parse(UserLevel.where((element) => element['karisma']<=user.userinfo?.Karisma).last['Level'])+1).toString()).first['karisma']-UserLevel.where((element) => element['karisma']<=user.userinfo?.Karisma).last['karisma'];

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 15,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * ((sum/total)*100)/100,
            height: 15,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 15,child: Center(child:Text('$sum/$total',style: TextStyle(fontSize: 10,color: Colors.white),)),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ],
    );
  }
}
List<LevelsContentmodel> LevelsContent = [
  LevelsContentmodel(name: 'إرسال هديه',image: 'assets/image/1.png',description: 'أرسل الهدايا للحصول علي نقاط الخبره'),
  LevelsContentmodel(name: 'تسجيل الدخول',image: 'assets/image/2.png',description: 'احصل علي نقاط الخبره عند تسجيل الدخول'),
  LevelsContentmodel(name: 'العاب',image: 'assets/image/3.png',description: 'اكسب خبره مجانيه عند لعب العاب التطبيق'),
  LevelsContentmodel(name: 'الدخول الي غرف الدردشه',image: 'assets/image/4.png',description: 'الدخول الي غرف الدردشه'),
  LevelsContentmodel(name:'اخذ الميكروفن',image: 'assets/image/5.png',description: 'خذ الميكروفن للحصول علي نقاط خبره'),
  LevelsContentmodel(name:'متابعه المستخدمين',image: 'assets/image/6.png',description: 'احصل يوميا علي المتابعه للحصول علي نقاط خبره'),
  LevelsContentmodel(name: 'احصل علي المتابعه',image: 'assets/image/7.png',description: ' احصل يوميا علي المتابعه للحصول علي نقاط خبره'),

];
List<LevelsContentmodel> LevelsContentEN = [
  LevelsContentmodel(name: 'Send a gift',image: 'assets/image/1.png',description: 'Send gifts to get experience points'),
  LevelsContentmodel(name: 'Sign in',image: 'assets/image/2.png',description: 'Get experience points when you log in'),
  LevelsContentmodel(name: 'Games',image: 'assets/image/3.png',description: 'Earn free experience when playing the app\'s games'),
  LevelsContentmodel(name: 'Entering the chat rooms',image: 'assets/image/4.png',description: 'Entering the chat rooms'),
  LevelsContentmodel(name:'Take The Microphone',image: 'assets/image/5.png',description: 'Take the microphone to get experience points'),
  LevelsContentmodel(name:'Follow users',image: 'assets/image/6.png',description: 'Get daily follow up to get experience points'),
  LevelsContentmodel(name: 'Get the follow',image: 'assets/image/7.png',description: 'Get daily follow up to get experience points'),

];
List<Levelsmodel> LevelsListmodel = [
  Levelsmodel(end: '10',start:'1' ,image: 'assets/image/rl1.png' ),
  Levelsmodel(end: '20',start:'11' ,image: 'assets/image/rl2.png' ),
  Levelsmodel(end: '30',start:'21' ,image: 'assets/image/rl3.png' ),
  Levelsmodel(end: '40',start:'31' ,image: 'assets/image/rl4.png' ),
  Levelsmodel(end: '50',start:'41' ,image: 'assets/image/rl5.png' ),
  Levelsmodel(end: '60',start:'51' ,image: 'assets/image/rl6.png' ),
  Levelsmodel(end: '70',start:'61' ,image: 'assets/image/rl7.png' ),
  Levelsmodel(end: '80',start:'71' ,image: 'assets/image/rl8.png' ),
  Levelsmodel(end: '90',start:'81',image: 'assets/image/rl9.png'),
  Levelsmodel(end: '100',start:'91',image: 'assets/image/rl10.png' ),
];


class LevelsContentmodel {
  String? image;
  String? name;
  String? description;
  LevelsContentmodel(
      { this.image,
        this.name,
        this.description,
        });

}
class Levelsmodel {

  String? image;
  String? start;
  String? end;

  Levelsmodel(
      {
        this.image,
        this.start,
        this.end,
      });

}