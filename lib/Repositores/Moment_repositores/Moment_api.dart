
import 'package:ahlachat/Repositores/Moment_repositores/Moment_repository.dart';
import 'package:dio/dio.dart';

import 'package:provider/provider.dart';

import '../../models/CommentsModel.dart';
import '../../models/Likemodel.dart';
import '../../models/PostsModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../../viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';

int Index=2;
int PostIndex=2;
int FollowIndex=2;
class Momentapi extends MomentRepository {
  @override
  var dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization':Token,
        'awqeASERQW':'8/325*mAIOEN',
        'userid':UserId.toString(),
        'UserIP':UserIP,
      },
    ),
  );
List<Postes> GeneralPostes=[];
  List<Postes>   GetMyPostslist=[];
  Future<List<Postes>>  GetPosts(context)async {
    PostIndex=2 ;
    try {
      Response response2 = await dio.get(
        '/api/GetPosts/${UserId}',
      );

      if (response2.statusCode == 200) {
         List list =response2.data['Postes']['date']['data'];
         List ste=response2.data['Postes']['posts'];
         list.forEach((element) {
          GeneralPostes.add(Postes.fromJson(element));
        });
        Provider.of<MomentViewModel>(context,listen: false).GetLikedPost(ste);
      }
    } catch (e) {

      
    }

    return GeneralPostes;

  }
  Future<List<Postes>>  GetFollowPostes(context)async {
    FollowIndex=2 ;
    try {
      Response response2 = await dio.get(
        '/api/GetPostsUserFollowing/${UserId}',
      );

      if (response2.statusCode == 200) {

        List ste=response2.data['Postes']['data'];
        ste.forEach((element) {
          GeneralPostes.add(Postes.fromJson(element));
        });

      }
    } catch (e) {


    }

    return GeneralPostes;

  }

  Future<List<Postes>>  AddmoreFollowPosts(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetPostsUserFollowing/${UserId}?page=${FollowIndex.toString()}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Postes']['data'] ;
        if(list.isNotEmpty){
          FollowIndex++;
        }

        list.forEach((element){
          GeneralPostes.add(Postes.fromJson(element));
        });

      }
    } catch (e) {
      print(e);

    }

    return GeneralPostes;

  }
  Future<List<Postes>>  AddmorePosts(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetPosts/${UserId}?page=${PostIndex.toString()}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Postes']['date']['data'];
        if(list.isNotEmpty){
          PostIndex++;
        }
        print("INDEX IS $Index");
        list.forEach((element){
          GeneralPostes.add(Postes.fromJson(element));
        });
        print(GeneralPostes);
      }
    } catch (e) {
      print(e);
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return GeneralPostes;

  }

  Future<bool> ReportPost({ context, Postid}) async {
    bool status=false;
    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "post_id": Postid.toString(),
        "reason":'Post',
      });
      Response response2 = await dio.post(
        'api/AddPostReport',
        data: formData,
      );


      if (response2.statusCode == 200) {
        status=true;
      }else{
        status=false;
      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return status;
  }

  Future<bool> ReportUser({ context, Userid}) async {
    bool status=false;
    try {
      FormData formData = new FormData.fromMap({
        "sender_id": UserId.toString(),
        "user_id": Userid.toString(),

      });
      Response response2 = await dio.post(
        'api/AddUserReport',
        data: formData,
      );


      if (response2.statusCode == 200) {
        status=true;
      }else{
        status=false;
      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return status;
  }

  Future<bool> BlockUser({ context, Userid}) async {
    bool status=false;
    try {
      FormData formData = new FormData.fromMap({
        "sender_id": UserId.toString(),
        "user_id": Userid.toString(),

      });
      Response response2 = await dio.post(
        'api/AddBlockList',
        data: formData,
      );


      if (response2.statusCode == 200) {

        status=true;
      }else{
        status=false;
      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return status;
  }
  Future<bool> UnBlockUser({ context, Userid}) async {
    bool status=false;
    try {
      FormData formData = new FormData.fromMap({
        "sender_id": UserId.toString(),
        "user_id": Userid.toString(),

      });
      Response response2 = await dio.post(
        'api/UnBlockUser',
        data: formData,
      );


      if (response2.statusCode == 200) {

        status=true;
      }else{
        status=false;
      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return status;
  }

  Future<List<Postes> >  GetMyPosts(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetMyPosts/${UserId}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Postes'];


        list.forEach((element) {
          GetMyPostslist.add(Postes.fromJson(element));
        });


 
      }
    } catch (e) {
      print(e);
      
    }

    return GetMyPostslist;

  }

  Future<bool >  DeletePost({context,postid})async {
bool deleted=false;
    try {
      Response response2 = await dio.get(
        '/api/Deletemypost/${postid}',
      );

      if (response2.statusCode == 200) {
        deleted=true;
      }else{
        deleted=false;
      }
    } catch (e) {
      deleted=false;
      print(e);
      
    }

    return deleted;

  }
  Comments  Commentss=Comments();
  Future<Comments> AddComment({ context,Comment,Postid}) async {
    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "post_id": Postid.toString(),
        "Comment": Comment.toString(),
      });
      Response response2 = await dio.post(
        'api/AddComment',
        data: formData,
      );
      print(response2.data['Comment']);
      print('mssssartrrrrrrrr');
      print(response2.data['Comment']);
      if (response2.statusCode == 200) {
         Commentss=Comments.fromJson(response2.data['Comment']);


      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return Commentss;
  }
  Future<Comments> ReplayComment({ context,Commentid,Replay}) async {

    try {
      FormData formData = new FormData.fromMap({
        "Comment_id": Commentid.toString(),
        "Replay": Replay.toString(),
      });
      Response response2 = await dio.post(
        'api/ReplayComment',
        data: formData,
      );

      if (response2.statusCode == 200) {
 print('goooooooooooooooooooooooooooo');

 Commentss=Comments.fromJson(response2.data['Comment']);
      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return Commentss;
  }

  Like  Likes=Like();
  Future<Like> LikePost({ Postid}) async {
    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "post_id": Postid.toString(),

      });
      Response response2 = await dio.post(
        'api/AddLike',
        data: formData,
      );
      print(response2.data['Comment']);
      print('mssssartrrrrrrrr');
      print(response2.data['Like']);
      if (response2.statusCode == 200) {
        Likes=Like.fromJson(response2.data['Like']);


      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);

      } else {
        print(e);
      }
    }

    return Likes;
  }
  Postes post=Postes();
  Future<bool> RemoveLike({ context,Postid}) async {
    bool delete=false;
    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "post_id": Postid.toString(),

      });
      Response response2 = await dio.post(
        'api/RemoveLike',
        data: formData,
      );

      print('mssssartrrrrrrrr');
      print(response2.data['Like']);
      if (response2.statusCode == 200) {

        delete=true;

      }else{
        delete=false;
      }
    } catch (e) {
      delete=false;
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return delete;
  }
  Future<Postes> AddPost({ context,tittle,image}) async {

    try {
      var  map;
      if(image==null){
        map={
          "user_id": UserId.toString(),
          "content": tittle.toString(),
        };
      }else{
        map={
          "user_id": UserId.toString(),
          "content": tittle.toString(),
          "image":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
         };
      }

      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = new FormData.fromMap(map);



      Response response2 = await dio.post(
        'api/AddPost',
        data: formData,
      );
      print(response2.data['Comment']);
    
      if (response2.statusCode == 200) {

        post=Postes.fromJson(response2.data['Postes']);

      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return post;
  }

}
