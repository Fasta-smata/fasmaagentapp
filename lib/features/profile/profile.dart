import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastaagent/controller/profile_controler.dart';
import 'package:fastaagent/global_widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../apis/models/agent_profile.dart';
import '../../controller/agent_controller.dart';
import '../../controller/secure_storage.dart';

import '../../core/pick_image.dart';
import '../../global_widget/button_component.dart';
import 'package:fastaagent/contants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../global_widget/form_field.dart';
import '../../ob/onBoardScreen/agent_welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AgentController userController = Get.put(AgentController());
  Agent? agent = Get.put(ProfileController()).getAgentDetails;
  late TextEditingController nameCom;
  late TextEditingController emailCom;
  late TextEditingController phoneCom;

  late TextEditingController ninCom;
  late TextEditingController bankName;
  late TextEditingController accountName;
  late TextEditingController accountNumber;
  late TextEditingController whyCom = TextEditingController();
  String? dropDownValue;
  bool isLoading = false;
  File? ninImage;
  @override
  void initState() {
    nameCom = TextEditingController(
        text: agent?.name ?? "Check your Connectivity and refresh");
    emailCom = TextEditingController(
        text: agent?.email ?? "Check your Connectivity and refresh");
    phoneCom = TextEditingController(
        text: "+${agent?.phone ?? "Check your Connectivity and refresh"}");
    bankName = TextEditingController(
        text: agent?.bankName ?? "Check your Connectivity and refresh");
    accountName = TextEditingController(
        text: agent?.accountName ?? "Check your Connectivity and refresh");
    accountNumber = TextEditingController(
        text: agent?.accountNumber ?? "Check your Connectivity and refresh");
    ninCom = TextEditingController(
        text: agent?.nin ?? "Check your Connectivity and refresh");
    dropDownValue = "Weekly";
    super.initState();
  }

  @override
  void dispose() {
    nameCom.dispose();
    ninCom.dispose();
    emailCom.dispose();
    phoneCom.dispose();

    super.dispose();
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    Agent? agent = Get.put(ProfileController()).getAgentDetails;
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton(
          icon: const Icon(Icons.menu),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: TextButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: AppColor.mainColor,
                          title: Text(
                            "Are you sure you want to delete your account?",
                            style: GoogleFonts.dmSans(
                                color: AppColor.brandColor,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          content: SizedBox(
                            height: 250,
                            child: Column(
                              children: [
                                Text(
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.dmSans(
                                        color: AppColor.brandColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500),
                                    "Please let us know why you choose not to continue using our app."),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.gray,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: TextField(
                                      controller: nameCom,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.gray,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    maxLines: 7,
                                    minLines: 5,
                                    controller: whyCom,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        border: InputBorder.none,
                                        hintText:
                                            "Please provide your reason for deleting your account here."),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 100.w,
                                    child: ButtonComp(
                                        onPressed: () {}, value: "Close")),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                    width: 100.w,
                                    child: ButtonComp(
                                        onPressed: () async {
                                          await AStorage.logALLOut();
                                          Get.offAll(
                                              () => const AgentWelcomeScreen());
                                        },
                                        value: "Delete")),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      });
                },
                child: Text("Delete Account",
                    style: AppTextStyle.capton(color: AppColor.errorColor)),
              ),
            )
          ],
        ),
        backgroundColor: AppColor.brandColor,
        elevation: 0,
      ),
      body: isloading
          ? const Loader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.28,
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.sizeOf(context).height * 0.18,
                          decoration: const BoxDecoration(
                            color: AppColor.brandColor,
                          ),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () async {
                                  await AStorage.logALLOut();
                                  Get.offAll(() => const AgentWelcomeScreen());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Log Out",
                                      style: AppTextStyle.body(
                                          color: AppColor.whiteColor,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(AppImages.exitIcon),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Positioned(
                          bottom: 0,
                          left: (MediaQuery.of(context).size.width - 160) / 2,
                          child: SizedBox(
                            width: 160,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Positioned(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor.whiteColor,
                                                  width: 8),
                                              shape: BoxShape.circle),
                                          child: ninImage != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: CircleAvatar(
                                                    radius: 70,
                                                    child:
                                                        Image.file(ninImage!),
                                                  ),
                                                )
                                              : agent == null ||
                                                      agent.profileImage == null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: const CircleAvatar(
                                                        radius: 70,
                                                        child: Icon(
                                                          Icons.person,
                                                          size: 70,
                                                        ),
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 70,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              "${agent.profileImage}",
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Icon(Icons
                                                                  .android),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(Icons
                                                                  .android),
                                                        ),
                                                      ),
                                                    )),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          File? profileImage =
                                              await pickImage();
                                          if (profileImage != null) {
                                            setState(() {
                                              ninImage = profileImage;
                                            });
                                            await userController.uploadProfile(
                                                profileImage: profileImage);
                                            Get.snackbar("Success",
                                                "Profile Image Updated");
                                            setState(() {});
                                          }
                                        },
                                        child: const CircleAvatar(
                                            backgroundColor:
                                                AppColor.mainSecondryColor,
                                            child: Icon(
                                              Icons.camera_alt_rounded,
                                              color: AppColor.whiteColor,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.mainSecondryColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Text(
                                        agent?.isVerified ?? false
                                            ? "Active"
                                            : "Inactive",
                                        style: AppTextStyle.capton(
                                            color: AppColor.whiteColor,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        ProfileForm(
                            isEdit: true,
                            value: nameCom.text,
                            label: "Full Name",
                            ontap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 550,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            color: AppColor.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: SingleChildScrollView(
                                          child: Center(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Center(
                                                    child: Text(
                                                      "Edit Profile",
                                                      style: GoogleFonts.dmSans(
                                                        color:
                                                            AppColor.brandColor,
                                                        fontSize: 17.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "Full Name",
                                                    style: GoogleFonts.dmSans(
                                                      color:
                                                          AppColor.brandColor,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Formfied(
                                                      controller: nameCom,
                                                      hintText: ""),
                                                  // SizedBox(height: 10),
                                                  // Text(
                                                  //   "Email",
                                                  //   style: GoogleFonts.dmSans(
                                                  //     color: AppColor.mainColor,
                                                  //     fontSize: 15.sp,
                                                  //     fontWeight: FontWeight.w500,
                                                  //   ),
                                                  // ),
                                                  // Formfied(
                                                  //     keyboardType:
                                                  //         TextInputType.emailAddress,
                                                  //     controller: emailController,
                                                  //     hintText:
                                                  //         "${user!.data.user.email}"),
                                                  // SizedBox(height: 10),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "Account Number",
                                                    style: GoogleFonts.dmSans(
                                                      color:
                                                          AppColor.brandColor,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Formfied(
                                                      controller: accountNumber,
                                                      hintText: ""),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "Account Name",
                                                    style: GoogleFonts.dmSans(
                                                      color:
                                                          AppColor.brandColor,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Formfied(
                                                      controller: accountName,
                                                      hintText: ""),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "Bank Name",
                                                    style: GoogleFonts.dmSans(
                                                      color:
                                                          AppColor.brandColor,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Formfied(
                                                      controller: bankName,
                                                      hintText: ""),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColor
                                                                .mainSecondryColor),
                                                        color:
                                                            AppColor.brandColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child:
                                                          DropdownButtonFormField(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      20),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              value:
                                                                  dropDownValue,
                                                              decoration: const InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                              icon: const Icon(Icons
                                                                  .arrow_drop_down_outlined),
                                                              dropdownColor:
                                                                  AppColor
                                                                      .mainSecondryColor,
                                                              items: [
                                                                DropdownMenuItem(
                                                                  value:
                                                                      "Weekly",
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Weekly",
                                                                      style: TextStyle(
                                                                          color: AppColor
                                                                              .whiteColor,
                                                                          fontFamily:
                                                                              'DMSans',
                                                                          fontSize: 18
                                                                              .sp,
                                                                          letterSpacing:
                                                                              0,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          height:
                                                                              1.5),
                                                                    ),
                                                                  ),
                                                                ),
                                                                DropdownMenuItem(
                                                                  value:
                                                                      "Monthly",
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Monthly",
                                                                      style: TextStyle(
                                                                          color: AppColor
                                                                              .whiteColor,
                                                                          fontFamily:
                                                                              'DMSans',
                                                                          fontSize: 16
                                                                              .sp,
                                                                          letterSpacing:
                                                                              0,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          height:
                                                                              1.5),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                              onChanged: (v) {
                                                                setState(() {
                                                                  dropDownValue =
                                                                      v!;
                                                                });
                                                                if (accountName
                                                                            .text ==
                                                                        "" ||
                                                                    bankName.text ==
                                                                        '') {
                                                                  Get.snackbar(
                                                                      "Notice",
                                                                      "All Feild Are Required",
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .BOTTOM);
                                                                } else if (accountNumber
                                                                        .text
                                                                        .length <
                                                                    10) {
                                                                  Get.snackbar(
                                                                      "Notice",
                                                                      "Account Number Must Be 10 Digits",
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .BOTTOM);
                                                                } else {}
                                                              }),
                                                    ),
                                                  ),
                                                  //  SizedBox(height: 10),
                                                  // Text(
                                                  //   "Mobile Number",
                                                  //   style: GoogleFonts.dmSans(
                                                  //     color: AppColor.mainColor,
                                                  //     fontSize: 15.sp,
                                                  //     fontWeight: FontWeight.w500,
                                                  //   ),
                                                  // ),
                                                  // Formfied(
                                                  //     keyboardType: TextInputType.phone,
                                                  //     controller: phoneController,
                                                  //     hintText: "${user!.data.user.phone}"),
                                                  const SizedBox(height: 10),
                                                  Center(
                                                    child: SizedBox(
                                                        width: 198.w,
                                                        child: ButtonComp(
                                                            bgcolor: AppColor
                                                                .brandColor,
                                                            textColor: AppColor
                                                                .whiteColor,
                                                            onPressed:
                                                                () async {
                                                              Get.back();
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              var res = await userController.editProfile(
                                                                  name: nameCom
                                                                      .text
                                                                      .trim(),
                                                                  email: emailCom
                                                                      .text
                                                                      .trim(),
                                                                  accountName:
                                                                      accountName
                                                                          .text,
                                                                  accountNumber:
                                                                      accountNumber
                                                                          .text,
                                                                  bankName:
                                                                      bankName
                                                                          .text,
                                                                  paymentOption:
                                                                      dropDownValue ??
                                                                          "Weekly");
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                              Get.back();
                                                              Get.snackbar(
                                                                  backgroundColor:
                                                                      AppColor
                                                                          .mainSecondryColor,
                                                                  "Success",
                                                                  res["message"]);
                                                            },
                                                            value: "Continue")),
                                                  )
                                                ]),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }),
                        SizedBox(height: 10.h),
                        ProfileForm(value: emailCom.text, label: "E-mail"),
                        SizedBox(height: 10.h),
                        ProfileForm(
                            value: phoneCom.text, label: "Phone Number"),
                        SizedBox(height: 10.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Payment Plan",
                                style: AppTextStyle.capton(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColor.gray,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                value: dropDownValue,
                                items: [
                                  DropdownMenuItem(
                                    value: "Weekly",
                                    child: Text("Weekly",
                                        style: AppTextStyle.capton()),
                                  ),
                                  DropdownMenuItem(
                                      value: "Monthly",
                                      child: Text("Monthly",
                                          style: AppTextStyle.capton())),
                                ],
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ProfileForm(value: bankName.text, label: "Bank Name"),
                        SizedBox(height: 10.h),
                        ProfileForm(
                            value: accountName.text, label: "Account Name"),
                        SizedBox(height: 10.h),
                        ProfileForm(
                            value: accountNumber.text, label: "Account Number"),
                        SizedBox(height: 10.h),
                        ProfileForm(value: ninCom.text, label: "Nin"),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class CardDetails extends StatelessWidget {
  const CardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.gray, borderRadius: BorderRadius.circular(20)),
    );
  }
}

class ProfileForm extends StatelessWidget {
  const ProfileForm(
      {super.key,
      required this.value,
      required this.label,
      this.ontap,
      this.isEdit = false});
  final String label;
  final String value;
  final VoidCallback? ontap;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.capton(fontWeight: FontWeight.bold)),
        Container(
            height: 45.h,
            decoration: BoxDecoration(
              color: AppColor.gray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(value, style: AppTextStyle.capton()),
                  const Spacer(),
                  isEdit
                      ? GestureDetector(
                          onTap: ontap,
                          child: const Icon(Icons.edit),
                        )
                      : Container()
                ],
              ),
            ))
      ],
    );
  }
}
