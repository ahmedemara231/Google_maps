import 'package:cis_project/view/maps/google_maps_view.dart';
import 'package:cis_project/view_model/google_maps/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider(
        create: (context) => MapsCubit(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: GoogleMapsView()
        ),
      ),
    );
  }
}




