import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../models/plant_data.dart';
import '../../models/plant_pools.dart';
import '../../providers/multi_costume_provider.dart';

class MultiCostumeScreen extends ConsumerWidget {
  const MultiCostumeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(multiCostumeProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 如果已生成，显示结果页面
    if (state.generatedCode != null) {
      return _buildResultScreen(context, ref, state, theme, colorScheme);
    }

    // 否则显示选择页面
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.style_outlined),
            const SizedBox(width: 8),
            const Text('12装扮任意选'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: state.canGenerate
                    ? Colors.purple
                    : colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${state.selectedCostumes.length}/12',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: state.canGenerate
                      ? Colors.white
                      : colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 装扮网格
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: CostumePools.allCostumes.length,
              itemBuilder: (context, index) {
                final costume = CostumePools.allCostumes[index];
                final isSelected =
                    state.selectedCostumes.any((c) => c.id == costume.id);

                return _buildCostumeCard(
                  context,
                  ref,
                  costume,
                  isSelected,
                  theme,
                  colorScheme,
                );
              },
            ),
          ),

          // 底部栏
          _buildBottomBar(context, ref, state, theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildCostumeCard(
    BuildContext context,
    WidgetRef ref,
    CostumeItem costume,
    bool isSelected,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(multiCostumeProvider.notifier).toggleCostume(costume);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.purple : colorScheme.outline,
            width: isSelected ? 3 : 1,
          ),
          color: isSelected
              ? Colors.purple.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  costume.imageAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.style,
                      size: 40,
                      color: Colors.purple,
                    );
                  },
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.purple
                    : colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              child: Text(
                costume.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected ? Colors.white : colorScheme.onSurface,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    WidgetRef ref,
    MultiCostumeState state,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 已选择的装扮列表
          if (state.selectedCostumes.isNotEmpty) ...[
            Text(
              '已选装扮 (${state.selectedCostumes.length}/12):',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.selectedCostumes.length,
                itemBuilder: (context, index) {
                  final costume = state.selectedCostumes[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Chip(
                      avatar: CircleAvatar(
                        backgroundImage: AssetImage(costume.imageAsset),
                        onBackgroundImageError: (_, __) {},
                      ),
                      label: Text(
                        costume.name.length > 8
                            ? '${costume.name.substring(0, 8)}...'
                            : costume.name,
                        style: theme.textTheme.bodySmall,
                      ),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        ref
                            .read(multiCostumeProvider.notifier)
                            .removeCostume(costume);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 提示文字
          Row(
            children: [
              Icon(
                state.canGenerate ? Icons.check_circle : Icons.info_outline,
                size: 20,
                color: state.canGenerate ? Colors.purple : colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.canGenerate
                      ? '已选择 ${state.selectedCostumes.length} 个装扮，可以生成...'
                      : '请选择至少1个装扮',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: state.canGenerate
                        ? Colors.purple
                        : colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 生成按钮
          ElevatedButton.icon(
            onPressed: state.canGenerate && !state.isLoading
                ? () async {
                    await ref.read(multiCostumeProvider.notifier).generateCode();
                  }
                : null,
            icon: state.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.style),
            label: Text(state.isLoading ? '生成中...' : '生成装扮礼包码'),
            style: ElevatedButton.styleFrom(
              backgroundColor: state.canGenerate ? Colors.purple : Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(
    BuildContext context,
    WidgetRef ref,
    MultiCostumeState state,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final codeData = state.generatedCode!.data!;
    final encryptedDataJson = jsonEncode(codeData.encryptedData.toJson());

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.celebration),
            SizedBox(width: 8),
            Text('生成成功'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 成功状态卡片
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colorScheme.outline),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.purple,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '装扮礼包码生成成功！',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '已选择 ${state.selectedCostumes.length} 个超级装扮',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 选中的装扮列表
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colorScheme.outline),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '选中的装扮:',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...state.selectedCostumes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final costume = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.purple),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.asset(
                                  costume.imageAsset,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.style,
                                      size: 20,
                                      color: Colors.purple,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                costume.name,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 装扮礼包码卡片
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colorScheme.outline),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '装扮礼包码:',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: SelectableText(
                        encryptedDataJson,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 复制按钮
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: encryptedDataJson));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('礼包码已复制到剪贴板'),
                                ],
                              ),
                              backgroundColor: Colors.purple,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text(' 复制礼包码'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 返回修改装扮按钮
            OutlinedButton.icon(
              onPressed: () {
                ref.read(multiCostumeProvider.notifier).resetSelection();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text(' 返回修改装扮'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),

            // 重新开始按钮
            OutlinedButton.icon(
              onPressed: () {
                ref.read(multiCostumeProvider.notifier).reset();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.refresh),
              label: const Text(' 重新开始'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
