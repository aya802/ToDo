import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:to_do/shared/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  ValueChanged<String>? onSubmit,
  VoidCallback? onTab,
  ValueChanged<String>? onChange,
  required String textOfValidation,
  required String lable,
  required IconData prefix,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    validator: (String? value) {
      if (value!.isEmpty) {
        return '$textOfValidation';
      } else {
        return null;
      }
    },
    decoration: InputDecoration(
      labelText: lable,
      prefixIcon: Icon(prefix),
      border: OutlineInputBorder(),
    ),
    onTap: onTab,
  );
}

Widget buildTaskItem(Map model,context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text('${model['time']}'),
          ),
          SizedBox(
            width: 20,
          ),
      Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed:(){
                AppCubit.get(context).updateData(
                    status:'done',
                    id: model['id']);
              },
              icon:Icon( Icons.check_box,color: Colors.green,),
          ),

          IconButton(
            onPressed:(){
              AppCubit.get(context).updateData(
                  status:'archive',
                  id: model['id']);
            },
            icon:Icon( Icons.archive,color: Colors.black45,),
          ),
        ],
      ),
    ),
    onDismissed: (direction){
AppCubit.get(context).deleteFromData(id:model['id']);
    },
  );
}
Widget tasksBuilder(
{
  required List<Map> tasks,
}
    ){
  return ConditionalBuilder(
    condition: tasks.length > 0,
    builder: (context) => ListView.separated(
      itemBuilder: (context, index) {
        return buildTaskItem(tasks[index], context);
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[400],
          ),
        );
      },
      itemCount: tasks.length,
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            Icons.menu,
            size: 40,
            color: Colors.black45,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'No Tasks Yet ,Enter Your Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black45),
          )
        ],
      ),
    ),
  );
}
