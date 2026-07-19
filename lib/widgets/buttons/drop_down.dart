
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class DropdownField<T> extends ConsumerStatefulWidget {
  final String title;
  final T? value;
  final List<T> options;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final String? hintText;

  const DropdownField({
    super.key,
    required this.title,
    required this.options,
    required this.itemLabel,
    required this.onChanged,
    this.value,
    this.hintText,
  });

  @override
  ConsumerState<DropdownField<T>> createState() =>
      _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T>
    extends ConsumerState<DropdownField<T>>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _dropdownKey = GlobalKey();

  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    _animationController.dispose();
    super.dispose();
  }
  void _openDropdown() {
    if (_overlayEntry != null) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);

    _animationController.forward();

    setState(() {
      _isOpen = true;
    });
  }


  void _closeDropdown() {
    if (!mounted) return;

    _overlayEntry?.remove();
    _overlayEntry = null;

    _animationController.reverse();

    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  void _toggleDropdown() {
    _isOpen ? _closeDropdown() : _openDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox =
    _dropdownKey.currentContext!.findRenderObject() as RenderBox;

    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.translucent,
              child: SizedBox.expand(),
            ),
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height  ),
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  child: SizeTransition(
                    sizeFactor: _expandAnimation,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.options.length,
                      separatorBuilder: (_, __) => Divider(height: 0,color: Colors.grey,),
                      itemBuilder: (context, index) {
                        final item = widget.options[index];
                        final isSelected = item == widget.value;

                        return InkWell(
                          onTap: () {
                            widget.onChanged(item);
                            _closeDropdown();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  text: widget.itemLabel(item),
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? AppColors.instance.primary
                                      : AppColors.instance.black300,
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check,
                                    color: AppColors.instance.primary,
                                    size: 18,
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       //   const Gap(height: 15),

          AppText(
            text: widget.title,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.instance.black900,
          ),

          const Gap(height: 10),

          CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              key: _dropdownKey,
              onTap: _toggleDropdown,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 15),
                  vertical: AppSize.height(value: 13),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black54),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: widget.value != null
                          ? widget.itemLabel(widget.value as T)
                          : widget.hintText ?? widget.title,
                      fontSize: 16,
                      color: AppColors.instance.black300,
                    ),
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5)
                          .animate(_animationController),
                      child: const Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}