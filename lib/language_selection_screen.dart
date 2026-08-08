import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const LanguageSelectionScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // كود اللغة الافتراضي
  String _selectedLocale = 'ar';

  // قائمة اللغات الـ 7 المدعومة بالتطبيق
  final List<Map<String, String>> _languages = [
    {'code': 'ar', 'name': 'العربية', 'native': 'Arabic'},
    {'code': 'en', 'name': 'English', 'native': 'الإنجليزية'},
    {'code': 'fr', 'name': 'Français', 'native': 'الفرنسية'},
    {'code': 'es', 'name': 'Español', 'native': 'الإسبانية'},
    {'code': 'de', 'name': 'Deutsch', 'native': 'الألمانية'},
    {'code': 'ru', 'name': 'Русский', 'native': 'الروسية'},
    {'code': 'zh', 'name': '中文', 'native': 'الصينية'},
  ];

  /// حفظ اللغة المختارة وعلامة إتمام الترحيب في SharedPreferences
  Future<void> _saveLanguageAndProceed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', _selectedLocale);
      await prefs.setBool('is_first_run', false);

      if (!mounted) return;

      // الانتقال إلى الشاشة الرئيسية واستبدال شاشة الترحيب
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainDashboardView(
            isDarkMode: widget.isDarkMode,
            onThemeToggle: widget.onThemeToggle,
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error saving language: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;
    final Color primaryColor = const Color(0xFF1E88E5);
    final Color bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // أيقونة الترحيب والترويسة
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.language, size: 48, color: primaryColor),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  'مرحباً بك / Welcome',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'اختر لغتك المفضلة للمتابعة\nSelect your preferred language',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // قائمة اختيار اللغات
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    final bool isSelected = _selectedLocale == lang['code'];

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLocale = lang['code']!;
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? primaryColor : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              lang['name']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: textColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              lang['native']!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isSelected ? primaryColor : Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // زر المتابعة
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _saveLanguageAndProceed,
                  child: const Text(
                    'متابعة / Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}