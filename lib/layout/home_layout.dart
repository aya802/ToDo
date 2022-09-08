import 'dart:ffi';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/models/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do/models/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do/models/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do/shared/components/components.dart';
import 'package:to_do/shared/cubit/cubit.dart';

import '../shared/components/constants.dart';
import '../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget


{

  var scaffoldKey=GlobalKey<ScaffoldState>();
  final _formKey=GlobalKey<FormState>();
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child:BlocConsumer<AppCubit,AppStates>(
        listener:(context,state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context,state){
          AppCubit cubit=AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title:Text(cubit.titles[cubit.currentIndex]),
            ),
            body:ConditionalBuilder(
              condition:true ,
              builder:(context) =>cubit.screens[cubit.currentIndex],
              fallback: (context) =>Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if (cubit.isBottomSheetShown) {
                  if(_formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   time: timeController.text,
                    //   date: dateController.text,
                    // ).then((value) {
                    //   Navigator.pop(context);
                    //   isBottomSheetShown = false;
                    //   // setState(() {
                    //   //   fabIcon = Icons.edit;
                    //   // });
                    // });
                  }
                }else{
                  scaffoldKey.currentState?.showBottomSheet((context) =>
                      Container(

                        color: Colors.grey[200],
                        padding: EdgeInsets.all(20),
                        child:Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller:titleController,
                                type: TextInputType.text,
                                textOfValidation: 'title must not be empty',
                                lable: 'Task Title',
                                prefix: Icons.title,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                controller:timeController,
                                type: TextInputType.datetime,
                                onTab: (){
                                  showTimePicker(
                                      context: context,
                                      initialTime:TimeOfDay.now()
                                  ).then((value) {
                                    timeController.text=value!.format(context).toString();
                                    // print(value.format(context));
                                  });

                                },
                                textOfValidation: 'time must not be empty',
                                lable: 'Task Time',
                                prefix: Icons.watch_later_outlined,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                controller:dateController,
                                type: TextInputType.datetime,
                                onTab: (){
                                  showDatePicker(
                                      context: context,
                                      initialDate:DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate:DateTime.parse('2022-10-14')
                                  ).then((value) {
                                    dateController.text=DateFormat.yMMMd().format(value!);
                                    // print(DateFormat.yMMMd().format(value!));
                                  });
                                },
                                textOfValidation: 'date must not be empty',
                                lable: 'Task Date',
                                prefix: Icons.calendar_month_outlined,
                              ),
                            ],
                          ),
                        ),
                      ),
                    elevation: 20,

                  ).closed.then((value) {
                    cubit.changeBottomSheetState(
                        isShown: false,
                        icon: Icons.edit);

                  });
                  cubit.changeBottomSheetState(
                      isShown: true,
                      icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),

            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex:cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index){

                cubit.changeIndex(index);

              },
              items: [
                BottomNavigationBarItem(
                    icon:Icon(Icons.menu),
                    label: 'New'
                ),
                BottomNavigationBarItem(
                    icon:Icon(Icons.done),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon:Icon(Icons.archive),
                    label: 'Archived'
                ),
              ],
            ),

          );
        },

      ),
    );
  }


}
