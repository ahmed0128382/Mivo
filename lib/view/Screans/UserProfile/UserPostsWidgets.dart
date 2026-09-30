import 'package:ahlachat/models/PostsModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MomentScrean/MomentContent.dart';
import 'package:ahlachat/view/widgets/ImageView.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
class UserPostsWidgets extends StatelessWidget {
  const UserPostsWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    MomentViewModel   posts=Provider.of<MomentViewModel>(context,listen: true);

    return Column(
      children:List.generate(user.userProfileData?.Postuser?.length??0, (index) {
     usermodel ?Postuser= user.userProfileData;
        return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Container(width: SizeConfig.screenWidth!,
              child: Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(onTap: () =>navigateTo(context: context, screen: Momentcontent(ChoosePost:  user.userProfileData?.Postuser![index]??Postes(),)),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: CachedNetworkImageProvider(Postuser?.image ?? ''), radius: 23, ),
                        SizedBox(width: 5,),
                        UserSideInfoWidgets(UserDate: Postuser,showdescr: 1,),
                        Spacer(),
                        if(user.userProfileData?.id==user.userinfo?.id)      SizedBox(height: 20,
                          child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:const Icon(
                            Icons.more_vert,
                            color:MainColor,
                          ),
                              onSelected: (value) {
                               user.DeletePost(context: context,postid: user.userProfileData?.Postuser![index].id);
                              },
                              itemBuilder: (BuildContext bc) {
                                return   [
                                    PopupMenuItem(
                                    child: Text(getLang(context: context,key: "Delete"),style: style6,),
                                    value: '0',


                                  ),
                                ];}),
                        ),
                      ],
                    ),

                  ),
                  const SizedBox(height: 5),
                  InkWell(onTap: () =>navigateTo(context: context, screen: Momentcontent(ChoosePost: user.userProfileData?.Postuser![index]??Postes(),)),
                    child: Container(color: Colors.transparent,width: SizeConfig.screenWidth,
                      child: Column(mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          ReadMoreText(
                            user.userProfileData?.Postuser![index].content ?? '',
                            trimLines: 2,
                            colorClickableText: MainColor,
                            trimMode: TrimMode.Line,style: style5.copyWith(height: 1),
                            trimCollapsedText: getLang(context: context,key: "Show_more"),
                            trimExpandedText:  getLang(context: context,key: "Show_less"),
                            moreStyle: TextStyle(fontSize: 14,color: MainColor, fontWeight: FontWeight.bold),
                            lessStyle: TextStyle(fontSize: 14,color: MainColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),

                          if(user.userProfileData?.Postuser![index].image!=null && user.userProfileData?.Postuser![index].image!='')   InkWell(onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(url: user.userProfileData?.Postuser![index].image??''),)),child: Container( height: 250, width: SizeConfig.screenWidth!/2, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: CachedNetworkImageProvider(user.userProfileData?.Postuser![index].image ?? Images.offical), fit: BoxFit.fill)), )),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10, ),
                  Column(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Helper().getTimeago(time:user.userProfileData?.Postuser![index].createdAt), style: style6.copyWith(fontSize: 13, color: Colors.black26)),
                      const SizedBox(height: 10, ),
                      Row(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [


                          Row(
                            children: [
                              InkWell(onTap: (){
                                if(posts.LikedPost.contains( user.userProfileData?.Postuser![index].id.toString())){
                                  posts.RemoveLike(Postid:  user.userProfileData?.Postuser![index].id ,context: context);
                                } else{
                                  posts.LikePost(Postid: user.userProfileData?.Postuser![index].id,context: context );
                                }
                              }, child:  FaIcon( FontAwesomeIcons.fire,color: posts.LikedPost.contains( user.userProfileData?.Postuser![index].id.toString())?MainColor:Colors.grey,  )),
                              SizedBox(width: 7,),
                              Text(  user.userProfileData?.Postuser![index].like?.length.toString() ?? '', style: style6),
                            ],
                          ),

                          InkWell(onTap:(){
                            navigateTo(context: context, screen: Momentcontent(ChoosePost:  user.userProfileData?.Postuser![index]??Postes(),));

                          },
                            child: Row(
                              children: [
                                FaIcon( FontAwesomeIcons.comment,color: MainColor,size: 22),
                                SizedBox(width: 7,),
                                Text( user.userProfileData?.Postuser![index].commentsuser?.length.toString() ?? '', style: style6, ),
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
      }),
    );
  }
}
