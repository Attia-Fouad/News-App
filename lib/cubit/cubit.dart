import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubit/states.dart';

import '../modules/news_app/business/business_screen.dart';
import '../modules/news_app/science/science_screen.dart';
import '../modules/news_app/sports/sports_screen.dart';
import '../shared/networks/local/cache_helper.dart';
import '../shared/networks/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>{

  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems=[
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.business,
        ),
      label: 'Business',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(
    //     Icons.settings,
    //   ),
    //   label: 'Settings',
    // ),
  ];
  List<Widget> screens=[
    BusinessScreen(),
    const SportsScreen(),
    const ScienceScreen(),
    //SettingsScreen(),
  ];
  void changeBottomNavBar(index)
  {
    if(index==1) {
      getSports();
    }
    if(index==2) {
      getScience();
    }
    currentIndex=index;
    emit(NewsBottomNavState());
  }
 List<dynamic> business=[];
  void getBusiness()
  {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
        url: 'v2/top-headlines',
        query:
        {
          'country':'eg',
          'category':'business',
          'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
    }).then((value)
    {
      //print(value.data['articles'][0]['title']);
      business = value.data['articles'];
      if (kDebugMode) {
        print(business[0]['title']);
      }

      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  List<dynamic> sports=[];
  void getSports()
  {
    emit(NewsGetSportsLoadingState());
    if(sports.isEmpty)
      {
        DioHelper.getData(
            url: 'v2/top-headlines',
            query:
            {
              'country':'eg',
              'category':'sports',
              'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
            }).then((value)
        {
          //print(value.data['articles'][0]['title']);
          sports = value.data['articles'];
          if (kDebugMode) {
            print(sports[0]['title']);
          }

          emit(NewsGetSportsSuccessState());
        }).catchError((error){
          if (kDebugMode) {
            print(error.toString());
          }
          emit(NewsGetSportsErrorState(error.toString()));
        });
      }
    else
      {
        emit(NewsGetSportsSuccessState());
      }

  }

  List<dynamic> science=[];
  void getScience()
  {
    emit(NewsGetBusinessLoadingState());
    if(science.isEmpty)
      {
        DioHelper.getData(
            url: 'v2/top-headlines',
            query:
            {
              'country':'eg',
              'category':'science',
              'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
            }).then((value)
        {
          //print(value.data['articles'][0]['title']);
          science = value.data['articles'];
          if (kDebugMode) {
            print(science[0]['title']);
          }

          emit(NewsGetScienceSuccessState());
        }).catchError((error){
          if (kDebugMode) {
            print(error.toString());
          }
          emit(NewsGetScienceErrorState(error.toString()));
        });
      }
    else
      {
        emit(NewsGetScienceSuccessState());
      }

  }

  List<dynamic> search=[];
  void getSearch(String value)
  {
    emit(NewsGetSearchLoadingState());
    search=[];
    DioHelper.getData(
        url: 'v2/everything',
        query:
        {
          'q':value,
          'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
        }).then((value)
    {
      //print(value.data['articles'][0]['title']);
      search = value.data['articles'];
      if (kDebugMode) {
        print(search[0]['title']);
      }

      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(NewsGetSearchErrorState(error.toString()));
    });

  }

  bool isDark=false;
  void changeAppMode({ bool? fromShared}){
    if(fromShared!=null)
    {
      isDark=fromShared;
      emit(AppChangeModeState());

    }
    else {
      isDark = !isDark;
      CacheHelper.sharedPreferences.setBool('isDark', isDark).then((value) {
        emit(AppChangeModeState());
      });
    }

  }

}
