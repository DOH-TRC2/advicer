import 'package:advicer/2_application/core/services/theme_service.dart';
import 'package:advicer/2_application/pages/advicer/bloc/advicer_bloc.dart';
import 'package:advicer/2_application/pages/advicer/widgets/advice_field.dart';
import 'package:advicer/2_application/pages/advicer/widgets/custom_button.dart';
import 'package:advicer/2_application/pages/advicer/widgets/error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AdvicerPageWrapperProvider extends StatelessWidget {
  const AdvicerPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdvicerBloc(),
      child: const AdvicerPage(),
    );
  }
}

class AdvicerPage extends StatelessWidget {
  const AdvicerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Advicer",
            style: themeData.textTheme.displayLarge,
          ),
          centerTitle: true,
          actions: [
            Switch(
                value: Provider.of<ThemeService>(context).isDarkModeOn,
                onChanged: (_) {
                  Provider.of<ThemeService>(context, listen: false)
                      .toggleTheme();
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ignore: prefer_const_constructors
              Expanded(
                  child: Center(child: BlocBuilder<AdvicerBloc, AdvicerState>(
                builder: (context, state) {
                  if (state is AdvicerInitial) {
                    return Text('Advice is waiting for you',
                        style: themeData.textTheme.displayLarge);
                  } else if (state is AdvicerStateLoading) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: themeData.colorScheme.onPrimary,
                    ));
                  } else if (state is AdvicerStateLoaded) {
                    return  AdviceField(
                      advice: state.advice,
                    );
                  } else if (state is AdvicerStateError) {
                    return  ErrorMessage(message: state.message);
                  }
                  return const Text('Serious Error');
                },
              ))),
              const SizedBox(
                height: 200,
                child: Center(child: CustomButton()),
              )
            ],
          ),
        ));
  }
}
