
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../modules/news_app/news_search/news_search.dart';


class NewsLayout extends StatelessWidget {
  const NewsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      builder: (BuildContext context, state) {
        var cubit=NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'NewsApp',
            ),
            actions: [
              IconButton(onPressed: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsSearch()),
                );
              }, icon: const Icon(
                Icons.search,
              ),),
              IconButton(onPressed: (){
                NewsCubit.get(context).changeAppMode();
              }, icon: const Icon(
                Icons.brightness_4_outlined,
              ),),
            ],

          ),
          bottomNavigationBar: BottomNavigationBar(
            items:cubit.bottomItems,
            currentIndex: cubit.currentIndex,
            onTap:(index) {
              cubit.changeBottomNavBar(index);
            },
          ),
          body: cubit.screens[cubit.currentIndex],
        );
      },
      listener: (BuildContext context, Object? state) {  },
    );
  }
}


