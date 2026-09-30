import 'package:flutter/material.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';

import 'package:ahlachat/view/Screans/MomentScrean/MomentContent.dart';

import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/ImageView.dart';

import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:ahlachat/viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:readmore/readmore.dart';

import '../../../../../util/images.dart';
import '../../../../../util/styles.dart';

class FollowingMoments extends StatefulWidget {
  const FollowingMoments({Key? key}) : super(key: key);

  @override
  State<FollowingMoments> createState() => _FollowingMomentsState();
}

class _FollowingMomentsState extends State<FollowingMoments> {

  ScrollController? _controller2;
  void _scrollListener2() {
    MomentViewModel Moment=  Provider.of<MomentViewModel>(context,listen: false);
    if((_controller2?.offset??0) >= (_controller2?.position.maxScrollExtent??0)-20 && !Moment.showloading7){
      print('gooooooooooooooooooooooooooooooooooooooooo');
      Moment.GetMoreFollow(context);
    }



  }

  @override
  void initState() {
    super.initState();

    _controller2 = ScrollController();
    _controller2?.addListener(_scrollListener2);}
  @override
  Widget build(BuildContext context) {

    MomentViewModel   posts=Provider.of<MomentViewModel>(context,listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    return  ListView.separated( physics:BouncingScrollPhysics(),controller:_controller2,itemCount: posts.FollowPosts.length,separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(height: 5,color: whitecolor),
    ),itemBuilder: (context, index)
    {
      usermodel ?Postuser= posts.FollowPosts[index].user;
      return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(width: SizeConfig.screenWidth!,
            child: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(onTap: () =>navigateTo(context: context, screen: Momentcontent(ChoosePost:  posts.GeneralPosts[index],)),
                  child: Row( crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      InkWell(onTap: (){
                        if(Postuser?.id!=user.userinfo?.id){
                          user.GetShoweduserProfile(Postuser);
                          navigateTo(context: context,screen: ShowUserProfile());
                        }

                      },
                        child: Row(
                          children: [
                            CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: CachedNetworkImageProvider(posts.FollowPosts[index].user?.image ?? ''), radius: 23, ),
                            SizedBox(width: 5,),
                            UserSideInfoWidgets(UserDate: posts.FollowPosts[index].user,showdescr: 1,)
                          ],
                        ),
                      ),
                      const Spacer(),
                      if(!user.checkuserkind(context:context, id:posts.FollowPosts[index].user?.id ))
                        InkWell(onTap: (){
                          if((user.userinfo?.followIds?.contains(posts.FollowPosts[index].user?.id.toString() ?? '') ?? true)){

                            Follow.RemoveFollows3(context: context, userid:posts.FollowPosts[index].user?.id );
                          } else{

                            print(posts.FollowPosts[index].user?.id );
                            Follow.SentFollow3(context: context, userid:posts.FollowPosts[index].user?.id );
                          }
                        },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:(user.userinfo?.followIds?.contains(posts.FollowPosts[index].user?.id.toString() ?? '') ?? true)? Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: MainColor),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 9),
                                child: Text(getLang(context: context,key: "UnFollow")),
                              ),
                            ): Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: MainColor),
                                  borderRadius: BorderRadius.circular(25)),

                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 9),
                                child:Text(getLang(context: context,key: "Follow") ),
                              ),
                            ),  ),   ),], ),   ),
                const SizedBox(height: 5),
                InkWell(onTap: () =>navigateTo(context: context, screen: Momentcontent(ChoosePost:  posts.FollowPosts[index],)),
                  child: Container(color: Colors.transparent,width: SizeConfig.screenWidth,
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        ReadMoreText(
                          posts.FollowPosts[index].content ?? '',
                          trimLines: 2,
                          colorClickableText: MainColor,
                          trimMode: TrimMode.Line,style: style5.copyWith(height: 1),
                          trimCollapsedText: getLang(context: context,key: "Show_more"),
                          trimExpandedText:  getLang(context: context,key: "Show_less"),
                          moreStyle: TextStyle(fontSize: 14,color: MainColor, fontWeight: FontWeight.bold),
                          lessStyle: TextStyle(fontSize: 14,color: MainColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),

                        if(posts.FollowPosts[index].image!=null && posts.FollowPosts[index].image!='')   InkWell(onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(url: posts.FollowPosts[index].image??''),)),child: Container( height: 250, width: SizeConfig.screenWidth!/2, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: CachedNetworkImageProvider(posts.FollowPosts[index].image ?? Images.offical), fit: BoxFit.fill)), )),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10, ),
                Column(mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Helper().getTimeago(time: posts.FollowPosts[index].createdAt), style: style6.copyWith(fontSize: 13, color: Colors.black26)),
                    const SizedBox(height: 10, ),
                    Row(crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 20,
                          child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:const Icon(
                            Icons.more_vert,
                            color:MainColor,
                          ),
                              onSelected: (value) {
                                posts.ReportPost(Postid: posts.FollowPosts[index].id);
                              },
                              itemBuilder: (BuildContext bc) {
                                return   [
                                    PopupMenuItem(
                                    child: Text(getLang(context: context,key: getLang(context: context,key: "Report")),style: style6,),
                                    value: '0',


                                  ),
                                ];}),
                        ),

                        Row(
                          children: [
                            InkWell(onTap: (){
                              if(posts.LikedPost.contains(posts.FollowPosts[index].id.toString())){
                                posts.RemoveLike(Postid: posts.FollowPosts[index].id );
                              } else{
                                posts.LikePost(Postid: posts.FollowPosts[index].id );
                              }
                            }, child:  FaIcon( FontAwesomeIcons.fire,color: posts.LikedPost.contains(posts.FollowPosts[index].id.toString())?MainColor:Colors.grey,  )),
                            SizedBox(width: 7,),
                            Text( posts.FollowPosts[index].like?.length.toString() ?? '', style: style6),
                          ],
                        ),

                        InkWell(onTap:(){
                          navigateTo(context: context, screen: Momentcontent(ChoosePost:  posts.GeneralPosts[index],));

                        },
                          child: Row(
                            children: [
                              FaIcon( FontAwesomeIcons.comment,color: MainColor,size: 22),
                              SizedBox(width: 7,),
                              Text( posts.FollowPosts[index].commentsuser?.length.toString() ?? '', style: style6, ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ],
            )),
      );


    }

    );
  }
}
