
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/Family/FamilyProfileScrean.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:ahlachat/viewmodels/Relations_ViewModel/RelationsViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class UserRelationResults extends StatelessWidget {
  const UserRelationResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    RelationsViewModel Relation=  Provider.of<RelationsViewModel>(context,listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(  leading: IconButton(
        icon: Icon(Icons.navigate_before, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ), title:   Text('العلاقات',style: style4.copyWith(height: 1,color: Colors.black87,fontWeight: FontWeight.normal)),centerTitle: false),
      body: Directionality(textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child:   ListView.builder(physics: BouncingScrollPhysics(),itemCount: Relation.UserRelations.length,itemBuilder: (context, index) {

          if( Relation.UserRelations[index].status==0&&Relation.UserRelations[index].anotheruser?.id==user.userinfo?.id){
            return  Row(
              children: [
                CircleAvatar(radius: 25,backgroundImage: CachedNetworkImageProvider(Relation.UserRelations[index].user?.image??''),),
                SizedBox(width: 10,),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(' لقد قمت بارسال علاقه ${Relation.UserRelations[index].items?.name} ',style: style5),
                    Text('الي : ${Relation.UserRelations[index].user?.name}   '),
                  ],
                ),
                Spacer(),
                SizedBox(height: 20,
                  child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                      onSelected: (value) {
                    if(value=='1'){
                     Relation.RemoveRelation(context: context,id:Relation.UserRelations[index].id );
                    }

                      },
                      itemBuilder: (BuildContext bc) {
                        return   [
                          PopupMenuItem(
                            child: Text('الغاء الاهداء',style: style2,),
                            value: '1',
                          ),
                          ];}),
                ),
              ],
            );
          }if( Relation.UserRelations[index].status==0&&Relation.UserRelations[index].anotheruser?.id!=user.userinfo?.id){
            return  Row(
              children: [
                CircleAvatar(radius: 25,backgroundImage: CachedNetworkImageProvider(Relation.UserRelations[index].anotheruser?.image??''),),
                SizedBox(width: 10,),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('  لقد قام ${Relation.UserRelations[index].anotheruser?.name} بارسال علاقه ${Relation.UserRelations[index].items?.name} ',style: style5),
                    Text('اليك قم بقبولها الان'),
                  ],
                ),
                Spacer(),
                SizedBox(height: 20,
                  child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                      onSelected: (value) {
                        if(value=='1'){
                         Relation.AcceptRelation(Relati:Relation.UserRelations[index] ,context: context,id:Relation.UserRelations[index].id,userid:Relation.UserRelations[index].anotheruser?.id  );
                        }

                      },
                      itemBuilder: (BuildContext bc) {
                        return   [
                          PopupMenuItem(
                            child: Text('قبول العلاقه',style: style2,),
                            value: '1',
                          ),
                        ];}),
                ),
              ],
            );

          }else if(Relation.UserRelations[index].status==1&&Relation.UserRelations[index].anotheruser?.id!=user.userinfo?.id){

            return Row(
              children: [
                CircleAvatar(radius: 25,backgroundImage: CachedNetworkImageProvider(Relation.UserRelations[index].anotheruser?.image??''),),
                SizedBox(width: 10,),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('  لقد قام ${Relation.UserRelations[index].anotheruser?.name} بارسال علاقه ${Relation.UserRelations[index].items?.name} ',style: style5),
                    Text('اليك وانت قمت بقبولها',style: style5),
                  ],
                ),
                Spacer(),
                SizedBox(height: 20,
                  child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                      onSelected: (value) {
                        if(value=='1'){
                          Relation.LeaveRelation(context: context,id:Relation.UserRelations[index].id  );


                        }
                      },
                      itemBuilder: (BuildContext bc) {
                        return   [
                          PopupMenuItem(
                            child: Text('الخروج من العلاقه',style: style2,),
                            value: '1',
                          ),
                        ];}),
                ),
              ],
            );
          }else if(Relation.UserRelations[index].status==1&&Relation.UserRelations[index].anotheruser?.id==user.userinfo?.id){
            return Row(
              children: [
                CircleAvatar(radius: 25,backgroundImage: CachedNetworkImageProvider(Relation.UserRelations[index].user?.image??''),),
                SizedBox(width: 10,),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('  لقد قام ${Relation.UserRelations[index].user?.name} بقبول اهداء العلاقه ${Relation.UserRelations[index].items?.name} ',style: style5),
                    Text('التي قمت بارسالها اليه',style: style5)
                  ],
                ),
                Spacer(),
                SizedBox(height: 20,
                  child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                      onSelected: (value) {
                        if(value=='1'){
                          Relation.LeaveRelation(context: context,id:Relation.UserRelations[index].id  );


                        }
                      },
                      itemBuilder: (BuildContext bc) {
                        return   [
                          PopupMenuItem(
                            child: Text('الخروج من العلاقه',style: style2,),
                            value: '1',
                          ),
                        ];}),
                ),
              ],
            );


          }
          else if (Relation.UserRelations[index].status==2&&Relation.UserRelations[index].anotheruser?.id!=user.userinfo?.id&&Relation.UserRelations[index].Leaved==user.userinfo?.id){
            return Row(
              children: [
                CircleAvatar(radius: 25,backgroundImage: CachedNetworkImageProvider(Relation.UserRelations[index].anotheruser?.image??''),),
                SizedBox(width: 10,),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('  لقد قمت  بالخروج من علاقه ${Relation.UserRelations[index].items?.name} ',style: style5),
                    Text(' بينك انت و  ${Relation.UserRelations[index].anotheruser?.name}  '),
                  ],
                ),
                Spacer(),
                // SizedBox(height: 20,
                //   child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:const Icon(
                //     Icons.more_vert,
                //     color: Colors.black,
                //   ),
                //       onSelected: (value) {
                //         if(value=='1'){
                //        //   Relation.LeaveRelation(context: context,id:Relation.UserRelations[index].id  );
                //
                //
                //         }
                //       },
                //       itemBuilder: (BuildContext bc) {
                //         return   [
                //           PopupMenuItem(
                //             child: Text('الخروج من العلاقه',style: style2,),
                //             value: '1',
                //           ),
                //         ];}),
                // ),
              ],
            );
          }  else if (Relation.UserRelations[index].status==2&&Relation.UserRelations[index].anotheruser?.id==user.userinfo?.id&&Relation.UserRelations[index].Leaved==user.userinfo?.id){

        return    Row(
          children: [
            CircleAvatar(radius: 25,backgroundImage: CachedNetworkImageProvider(Relation.UserRelations[index].user?.image??''),),
            SizedBox(width: 10,),
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('  لقد قمت  بالخروج من علاقه ${Relation.UserRelations[index].items?.name} ',style: style5),
                Text(' بينك انت و  ${Relation.UserRelations[index].user?.name}  '),
              ],
            ),
            Spacer(),

          ],
        );
          } else if (Relation.UserRelations[index].status==2&&Relation.UserRelations[index].anotheruser?.id==user.userinfo?.id&&Relation.UserRelations[index].Leaved!=user.userinfo?.id){
            return InkWell( onTap: () {

              user.GetShoweduserProfile(usermodel(id: Relation.UserRelations[index].user?.id,name: Relation.UserRelations[index].user?.name,image: Relation.UserRelations[index].user?.image));
              navigateTo(context: context,screen: ShowUserProfile());

            },
              child:  Row(
                children: [
                  CircleAvatar(radius: 25,backgroundImage: CachedNetworkImageProvider(Relation.UserRelations[index].user?.image??''),),
                  SizedBox(width: 10,),
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('  لقد قام ${Relation.UserRelations[index].user?.name}  بالخروج من علاقه ${Relation.UserRelations[index].items?.name} ',style: style5),
                      Text(' بينك انت و  ${Relation.UserRelations[index].user?.name}  '),
                    ],
                  ),
                  Spacer(),

                ],
              ),
            );
          }


    return SizedBox();

          }


          ),
        ),
      ),
    );
  }
}
