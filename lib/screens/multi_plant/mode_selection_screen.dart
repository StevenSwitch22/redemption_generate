import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/plant_pools.dart';
import '../../providers/multi_plant_provider.dart';
import '../../widgets/common_card.dart';
import 'plant_selection_screen.dart';

class ModeSelectionScreen extends ConsumerWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('选择模式'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 提示卡片
          CommonCard(
            type: CardType.filled,
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '请选择多植物礼包模式',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 模式卡片列表
          ...PlantPools.allPools.map((pool) => _buildModeCard(
                context,
                ref,
                pool,
                theme,
                colorScheme,
              )),
        ],
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context,
    WidgetRef ref,
    PlantPool pool,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return CommonCard(
      type: CardType.plain,
      onTap: () {
        ref.read(multiPlantProvider.notifier).selectPool(pool);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PlantSelectionScreen(),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.stars,
                color: colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                pool.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            pool.description,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildInfoChip(
                '总数 ${pool.totalCount}个',
                colorScheme,
                theme,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                '需选 ${pool.selectCount}个',
                colorScheme,
                theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    String label,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
