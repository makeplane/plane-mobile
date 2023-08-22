import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/screens/on_boarding/auth/signUp.dart';
import 'package:plane_startup/utils/constants.dart';
import '../../provider/provider_list.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';
import 'auth/sign_in.dart';
import 'package:plane_startup/utils/enums.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  int currentIndex = 0;

  List data = [
    {
      'title': 'Plan with Issues',
      'description':
          'The issue is the building block of the Plane. Most concepts in Plane are either associated with issues and their properties.'
    },
    {
      'title': 'Move with cycles',
      'description':
          'Cycles help you and your team to progress faster, similar to the sprints commonly used in agile development.'
    },
    {
      'title': 'Break into modules',
      'description':
          'Modules break your big think into Projects or Features,  to help you organize better.'
    }
  ];

  List cards = [];
  @override
  void initState() {
    var themeProvider = ref.read(ProviderList.themeProvider);
    ProviderList.clear(ref: ref);
    cards = [
      SizedBox(
        height: 150,
        child: Card(
          elevation: 3,
          color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          shadowColor: primaryColor.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'FIR 3',
                  type: FontStyle.Small,
                  color: Color.fromRGBO(82, 82, 82, 1),
                  fontSize: 16,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(
                  'Add Responsive Design Landing Page',
                  type: FontStyle.Large,
                  fontWeight: FontWeightt.Medium,
                  color: themeProvider.themeManager.primaryTextColor,
                  maxLines: 1,
                ),
                const Spacer(),
                Wrap(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: const Color.fromRGBO(212, 212, 212, 1))),
                      child: SvgPicture.asset(
                          'assets/svg_images/graph_icon.svg',
                          height: 10,
                          width: 10,
                          colorFilter: const ColorFilter.mode(
                              Colors.orange, BlendMode.srcIn)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 32,
                      width: 75,
                      child: Stack(
                        children: List.generate(
                            4,
                            (index) => Positioned(
                                left: (13 * index).toDouble(),
                                child: index == 3
                                    ? Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              245, 245, 245, 1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  212, 212, 212, 1)),
                                        ),
                                        alignment: Alignment.center,
                                        child: const CustomText(
                                          '+2',
                                          color: Color.fromRGBO(82, 82, 82, 1),
                                          type: FontStyle.Small,
                                          fontWeight: FontWeightt.Medium,
                                        ),
                                      )
                                    : Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  212, 212, 212, 1)),
                                        ),
                                        child: Image.asset(
                                            index == 0
                                                ? "assets/images/avatar2.jpg"
                                                : "assets/images/avatar1.jpg",
                                            fit: BoxFit.cover),
                                      ))),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: const Color.fromRGBO(212, 212, 212, 1))),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromRGBO(151, 71, 255, 1)),
                          ),
                          const CustomText(
                            '3 Labels',
                            type: FontStyle.Small,
                            color: Color.fromRGBO(104, 104, 104, 1),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: const Color.fromRGBO(212, 212, 212, 1))),
                      child: const Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            size: 18,
                            color: lightTextErrorColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            '21 Jun',
                            type: FontStyle.Small,
                            color: Color.fromRGBO(104, 104, 104, 1),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      Container(
        height: 160,
        constraints: const BoxConstraints(maxWidth: 500),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          shadowColor: primaryColor.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromRGBO(240, 253, 244, 1),
                      ),
                      child: SvgPicture.asset(
                        "assets/svg_images/cycles_icon.svg",
                        height: 30,
                        width: 30,
                        colorFilter: const ColorFilter.mode(
                            Colors.green, BlendMode.srcIn),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Release 0.9',
                          type: FontStyle.Small,
                          color: themeProvider.themeManager.primaryTextColor,
                          fontWeight: FontWeightt.Bold,
                        ),
                        const CustomText(
                          'Current',
                          type: FontStyle.XSmall,
                          color: Color.fromRGBO(163, 163, 163, 1),
                          fontWeight: FontWeightt.Medium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color.fromRGBO(245, 245, 245, 1),
                      ),
                      child: const CustomText(
                        '24 Jul -> 12 Aug',
                        type: FontStyle.Small,
                        color: Color.fromRGBO(104, 104, 104, 1),
                        fontWeight: FontWeightt.Medium,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      width: 65,
                      child: Stack(
                        children: List.generate(
                            4,
                            (index) => Positioned(
                                left: (13 * index).toDouble(),
                                child: index == 3
                                    ? Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              245, 245, 245, 1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  212, 212, 212, 1)),
                                        ),
                                        alignment: Alignment.center,
                                        child: const CustomText(
                                          '+2',
                                          color: Color.fromRGBO(82, 82, 82, 1),
                                          type: FontStyle.XSmall,
                                          fontWeight: FontWeightt.Medium,
                                        ),
                                      )
                                    : Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  212, 212, 212, 1)),
                                        ),
                                        child: Image.asset(
                                            index == 0
                                                ? "assets/images/avatar2.jpg"
                                                : "assets/images/avatar1.jpg",
                                            fit: BoxFit.cover),
                                      ))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      '5 days left',
                      color: Color.fromRGBO(82, 82, 82, 1),
                      type: FontStyle.Small,
                      fontWeight: FontWeightt.Medium,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_border,
                          size: 18,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.more_horiz,
                          size: 18,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      Container(
        height: 200,
        constraints: const BoxConstraints(maxWidth: 500),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          shadowColor: primaryColor.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromRGBO(240, 253, 244, 1),
                      ),
                      child: SvgPicture.asset(
                        "assets/svg_images/cycles_icon.svg",
                        height: 30,
                        width: 30,
                        colorFilter: const ColorFilter.mode(
                            Colors.green, BlendMode.srcIn),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Module Title',
                          type: FontStyle.Medium,
                          color: themeProvider.themeManager.primaryTextColor,
                          fontWeight: FontWeightt.Semibold,
                        ),
                        const CustomText(
                          'In Progress',
                          type: FontStyle.XSmall,
                          color: Color.fromRGBO(163, 163, 163, 1),
                          fontWeight: FontWeightt.Medium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      '30% complete',
                      type: FontStyle.Small,
                      color: Color.fromRGBO(38, 38, 38, 1),
                      fontWeight: FontWeightt.Medium,
                    ),
                    CustomText(
                      '6 days left ',
                      type: FontStyle.Small,
                      color: Color.fromRGBO(38, 38, 38, 1),
                      fontWeight: FontWeightt.Medium,
                    ),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 15),
                    height: 4,
                    width: MediaQuery.of(Const.globalKey.currentContext!)
                        .size
                        .width,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(229, 229, 229, 1)),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 150),
                            height: 4,
                            width: 50,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(22, 163, 74, 1)),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: Container(),
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 25,
                      width: 65,
                      child: Stack(
                        children: List.generate(
                            4,
                            (index) => Positioned(
                                left: (13 * index).toDouble(),
                                child: index == 3
                                    ? Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              245, 245, 245, 1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  212, 212, 212, 1)),
                                        ),
                                        alignment: Alignment.center,
                                        child: const CustomText(
                                          '+2',
                                          color: Color.fromRGBO(82, 82, 82, 1),
                                          type: FontStyle.XSmall,
                                          fontWeight: FontWeightt.Medium,
                                        ),
                                      )
                                    : Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  212, 212, 212, 1)),
                                        ),
                                        child: Image.asset(
                                            index == 0
                                                ? "assets/images/avatar2.jpg"
                                                : "assets/images/avatar1.jpg",
                                            fit: BoxFit.cover),
                                      ))),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          size: 12,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          'Start Jun 21 ',
                          type: FontStyle.XSmall,
                          color: Color.fromRGBO(104, 104, 104, 1),
                          fontWeight: FontWeightt.Medium,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.date_range_outlined,
                          size: 12,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          'End Jul 16 ',
                          type: FontStyle.XSmall,
                          color: Color.fromRGBO(104, 104, 104, 1),
                          fontWeight: FontWeightt.Medium,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 14),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      '5 days left',
                      color: Color.fromRGBO(82, 82, 82, 1),
                      type: FontStyle.Small,
                      fontWeight: FontWeightt.Medium,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_border,
                          size: 18,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.more_horiz,
                          size: 18,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: themeProvider.theme == THEME.dark ||
                    themeProvider.theme == THEME.darkHighContrast
                ? null
                : gradient,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 4),
              Expanded(
                child: PageView.builder(
                  itemCount: 3,
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        cards[index],
                        const SizedBox(
                          height: 20,
                        ),
                        CustomText(
                          data[index]['title'],
                          type: FontStyle.H4,
                          color: themeProvider.themeManager.primaryTextColor,
                          fontWeight: FontWeightt.Semibold,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: CustomText(
                            data[index]['description'],
                            type: FontStyle.Medium,
                            color: themeProvider.themeManager.tertiaryTextColor,
                            textAlign: TextAlign.center,
                            maxLines: 5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CircleAvatar(
                            backgroundColor: currentIndex == 0
                                ? themeProvider.themeManager.primaryColour
                                : const Color.fromRGBO(206, 212, 218, 1),
                            radius: 3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CircleAvatar(
                            backgroundColor: currentIndex == 1
                                ? themeProvider.themeManager.primaryColour
                                : const Color.fromRGBO(206, 212, 218, 1),
                            radius: 3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CircleAvatar(
                            backgroundColor: currentIndex == 2
                                ? themeProvider.themeManager.primaryColour
                                : const Color.fromRGBO(206, 212, 218, 1),
                            radius: 3,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Hero(
                tag: 'button',
                child: Button(
                  text: 'Get Started',
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            dotenv.env['ENABLE_O_AUTH'] != null &&
                                    isEnableAuth()
                                ? const SignInScreen()
                                : const SignUp(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isEnableAuth() {
    bool enableAuth = false;
    String enableOAuth = dotenv.env['ENABLE_O_AUTH'] ?? '';
    int enableOAuthValue = int.tryParse(enableOAuth) ?? 0;
    if (enableOAuthValue == 1) {
      enableAuth = true;
    } else {
      enableAuth = false;
    }
    return enableAuth;
  }
}
