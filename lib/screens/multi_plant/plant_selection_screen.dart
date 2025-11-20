import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/plant_data.dart';
import '../../providers/multi_plant_provider.dart';
import 'result_screen.dart';

class PlantSelectionScreen extends ConsumerWidget {
  const PlantSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(multiPlantProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state.selectedPool == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('选择植物')),
        body: const Center(child: Text('未选择模式')),
      );
    }

    final pool = state.selectedPool!;

    return Scaffold(
      appBar: AppBar(
        title: Text(pool.name),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: state.canGenerate
                      ? Colors.green
                      : colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${state.selectedPlants.length}/${pool.selectCount}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: state.canGenerate
                        ? Colors.white
                        : colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 植物网格
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: pool.plants.length,
              itemBuilder: (context, index) {
                final plant = pool.plants[index];
                final isSelected =
                    state.selectedPlants.any((p) => p.id == plant.id);

                return _buildPlantCard(
                  context,
                  ref,
                  plant,
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

  Widget _buildPlantCard(
    BuildContext context,
    WidgetRef ref,
    PlantItem plant,
    bool isSelected,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(multiPlantProvider.notifier).togglePlant(plant);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 3 : 1,
          ),
          color: isSelected
              ? colorScheme.primaryContainer.withOpacity(0.3)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  plant.imageAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.eco,
                      size: 40,
                      color: colorScheme.primary,
                    );
                  },
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              child: Text(
                plant.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
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
    MultiPlantState state,
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
          // 已选择的植物列表
          if (state.selectedPlants.isNotEmpty) ...[
            Text(
              '已选择 (${state.selectedPlants.length}/${state.selectedPool!.selectCount}):',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.selectedPlants.length,
                itemBuilder: (context, index) {
                  final plant = state.selectedPlants[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Chip(
                      avatar: CircleAvatar(
                        backgroundImage: AssetImage(plant.imageAsset),
                        onBackgroundImageError: (_, __) {},
                      ),
                      label: Text(
                        plant.name,
                        style: theme.textTheme.bodySmall,
                      ),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        ref.read(multiPlantProvider.notifier).removePlant(plant);
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
                color: state.canGenerate ? Colors.green : colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.canGenerate
                      ? '已选择 ${state.selectedPlants.length} 个植物，可以生成礼包码'
                      : '请继续选择，还差 ${state.remainingCount} 个',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: state.canGenerate
                        ? Colors.green
                        : colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 生成按钮
          ElevatedButton.icon(
            onPressed: state.canGenerate
                ? () async {
                    await ref.read(multiPlantProvider.notifier).generateCode();
                    if (context.mounted && state.generatedCode != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResultScreen(),
                        ),
                      );
                    }
                  }
                : null,
            icon: const Icon(Icons.card_giftcard),
            label: const Text('生成礼包码'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  state.canGenerate ? colorScheme.primary : Colors.grey,
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
}
