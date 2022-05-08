
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../modules/news_app/business/business_screen.dart';
import '../modules/news_app/news_search/news_search.dart';

import '../modules/news_app/science/science_screen.dart';
import '../modules/news_app/sports/sports_screen.dart';
import '../shared/styles/icon_broken.dart';


class NewsLayout extends StatelessWidget {
  const NewsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      builder: (BuildContext context, state) {
        var cubit=NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.title[cubit.currentIndex]),
            actions: [
              IconButton(onPressed: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsSearch()),
                );
              }, icon: const Icon(
                IconBroken.Search,
              ),),
              IconButton(onPressed: (){
                NewsCubit.get(context).changeAppMode();
              },
                icon: Conditional.single(
                  context: context,
                  conditionBuilder: (BuildContext context) => cubit.isDark ,
                  widgetBuilder: (BuildContext context) =>const Icon(
                    Icons.light_mode_outlined,
                  ),
                  fallbackBuilder: (BuildContext context) => const Icon(
                    Icons.dark_mode_outlined,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items:cubit.bottomItems,
            currentIndex: cubit.currentIndex,
            onTap:(index) {
              cubit.pageController.animateToPage(index, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut,);
              cubit.changeBottomNavBar(index);
            },
          ),
          body:PageView(
            controller: cubit.pageController,
            onPageChanged: (index){
              cubit.changeBottomNavBar(index);
            },
            scrollDirection: Axis.horizontal,
            children:  [
              BusinessScreen(),
              const SportsScreen(),
              const ScienceScreen(),
            ],
          ),
          /*cubit.screens[cubit.currentIndex],*/
        );
      },
      listener: (BuildContext context, Object? state) {  },
    );
  }
}


