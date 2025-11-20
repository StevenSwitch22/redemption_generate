import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../providers/single_plant_provider.dart';
import '../../widgets/common_card.dart';

class SinglePlantScreen extends ConsumerStatefulWidget {
  const SinglePlantScreen({super.key});

  @override
  ConsumerState<SinglePlantScreen> createState() => _SinglePlantScreenState();
}

class _SinglePlantScreenState extends ConsumerState<SinglePlantScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(singlePlantProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.eco_outlined),
            SizedBox(width: 8),
            Text('单植物/装扮礼包'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 搜索输入框
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                labelText: '输入植物或装扮名称',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(singlePlantProvider.notifier).clearSelection();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
                if (value.isNotEmpty) {
                  ref.read(singlePlantProvider.notifier).searchSuggestions(value);
                } else {
                  ref.read(singlePlantProvider.notifier).clearSelection();
                }
              },
            ),
          ),

          // 内容区域
          Expanded(
            child: _buildContent(state, theme, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    SinglePlantState state,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    // 显示加载状态
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 显示错误
    if (state.error != null) {
      return Center(
        child: CommonCard(
          type: CardType.filled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                state.error!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // 显示生成结果
    if (state.generatedCode != null) {
      return _buildGeneratedResult(state, theme, colorScheme);
    }

    // 显示已选择的项目和生成按钮
    if (state.selectedItem != null) {
      return _buildSelectedItem(state, theme, colorScheme);
    }

    // 显示搜索建议列表
    if (state.suggestions.isNotEmpty) {
      return _buildSuggestionsList(state, theme, colorScheme);
    }

    // 空状态
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '请输入植物或装扮名称进行搜索',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList(
    SinglePlantState state,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = state.suggestions[index];
        return CommonCard(
          type: CardType.plain,
          margin: const EdgeInsets.only(bottom: 12),
          onTap: () {
            _searchController.text = suggestion;
            ref.read(singlePlantProvider.notifier).selectItem(suggestion);
            _searchFocusNode.unfocus();
          },
          child: Row(
            children: [
              Icon(
                Icons.eco_outlined,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  suggestion,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedItem(
    SinglePlantState state,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CommonCard(
          type: CardType.plain,
          onTap: () {
            ref.read(singlePlantProvider.notifier).generateCode();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.card_giftcard,
                size: 48,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                '生成礼包',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneratedResult(
    SinglePlantState state,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final codeData = state.generatedCode!.data!;
    final encryptedDataJson = jsonEncode(codeData.encryptedData.toJson());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: CommonCard(
        type: CardType.plain,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 成功图标和标题
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '生成成功',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 植物/装扮名称
            Row(
              children: [
                Icon(
                  Icons.eco,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    codeData.searchKey,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Divider(color: colorScheme.outline),
            const SizedBox(height: 16),

            // 兑换码标题
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '兑换码',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 兑换码内容
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
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: encryptedDataJson));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('兑换码已复制到剪贴板'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('复制兑换码'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
