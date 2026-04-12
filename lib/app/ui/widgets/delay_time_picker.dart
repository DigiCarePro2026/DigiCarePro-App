import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart' show fieldRadius;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../theme/app_dimens.dart' show fieldRadius;

class DelayTimePickerField extends StatefulWidget {
  const DelayTimePickerField({
    super.key,
    required this.title,
    this.initialValue,
    this.onChanged,
    this.showHours = true,
    this.enabled = true,
  });

  final String title;
  final Duration? initialValue;
  final ValueChanged<Duration>? onChanged;
  final bool showHours;
  final bool enabled;

  @override
  State<DelayTimePickerField> createState() => _DelayTimePickerFieldState();
}

class _DelayTimePickerFieldState extends State<DelayTimePickerField> {
  int _hours = 0;
  int _minutes = 0;

  @override
  void initState() {
    super.initState();
    final init = widget.initialValue ?? Duration.zero;
    _hours = init.inHours;
    _minutes = init.inMinutes % 60;
  }

  void _updateValue() {
    final duration = Duration(hours: _hours, minutes: _minutes);
    widget.onChanged?.call(duration);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = widget.enabled
        ? theme.textTheme.bodyMedium?.color
        : theme.disabledColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: theme.textTheme.labelMedium),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(fieldRadius),
            border: Border.all(color: theme.colorScheme.outline, width: 1.5),
            color: widget.enabled ? null : theme.disabledColor.withOpacity(0.1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (widget.showHours) ...[
                _buildNumberSpinner(
                  label: 'hours'.tr,
                  value: _hours,
                  max: 23,
                  onChanged: (val) {
                    setState(() => _hours = val);
                    _updateValue();
                  },
                  textColor: textColor,
                ),
                const SizedBox(width: 16),
              ],
              _buildNumberSpinner(
                label: 'minutes'.tr,
                value: _minutes,
                step: 5,
                max: 55,
                onChanged: (val) {
                  setState(() => _minutes = val);
                  _updateValue();
                },
                textColor: textColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberSpinner({
    required String label,
    required int value,
    required int max,
    required ValueChanged<int> onChanged,
    Color? textColor,
    int step = 1,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: textColor)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: value > 0 ? () => onChanged(value - step) : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.red.withAlpha(200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/icons/minus.svg',
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: value < max ? () => onChanged(value + step) : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withAlpha(200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/icons/plus.svg',
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
