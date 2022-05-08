import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../../../cubit/cubit.dart';
import '../../../cubit/states.dart';
import '../../../shared/components/components.dart';
class NewsSearch extends StatelessWidget {
  const NewsSearch({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController() ;
    return BlocConsumer<NewsCubit,NewsStates>(
      listener: (context,states){},
      builder: (context,states){
        var cubit=NewsCubit.get(context);
        var list =NewsCubit.get(context).search;
        return Scaffold(
          appBar: AppBar(
            actions: [
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
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: designedFormField(
                  fontColor: cubit.isDark?Colors.white:Colors.black,
                    controller: searchController,
                    onChange: (value){
                      NewsCubit.get(context).getSearch(value);
                    },
                    validator: (value)
                    {
                      if(value.isEmpty)
                      {
                        return 'search must be not empty';
                      }
                      return null;
                    },
                    type: TextInputType.text,
                    label: 'Search'
                ),
              ),
              Expanded(child: articleBuilder(list, context,isSearch: true)),
            ],
          ),
        );
      },

    );
  }
}
