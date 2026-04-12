import 'package:digi_care_pro/app/data/constants/pref_key.dart';
import 'package:digi_care_pro/app/data/pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {

  String? _selectedLang = Get.locale!.languageCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('change_language'.tr), centerTitle: true),
      body: ListView(
        children: [
          _buildLanguageTile(
            context,
            langCode: 'en',
            label: 'english'.tr,
            flagPath: 'assets/icons/GB-ENG.svg',
          ),
          _buildLanguageTile(
            context,
            langCode: 'fr',
            label: 'french'.tr,
            flagPath: 'assets/icons/FR.svg',
          ),
          _buildLanguageTile(
            context,
            langCode: 'de',
            label: 'german'.tr,
            flagPath: 'assets/icons/DE.svg',
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(
      BuildContext context, {
        required String langCode,
        required String label,
        required String flagPath,
      }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: SvgPicture.asset(flagPath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
      trailing: Radio<String>(
        value: langCode,
        groupValue: _selectedLang,
        onChanged: (value) {
          setState(() {
            _selectedLang = value!;
            Get.updateLocale(Locale(_selectedLang!));

            Pref.setString(PrefKey.locale, _selectedLang);
          });
        },
      ),
      onTap: () {
        setState(() {
          _selectedLang = langCode;
          Get.updateLocale(Locale(_selectedLang!));

          Pref.setString(PrefKey.locale, _selectedLang);
        });
      },
    );
  }
}
