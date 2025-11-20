import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/plant_data.dart';
import '../models/search_response.dart';
import '../services/api/search_service.dart';
import '../services/local/secure_storage.dart';

final searchService = SearchService();
final secureStorage = SecureStorageService();

class MultiCostumeState {
  final List<CostumeItem> selectedCostumes;
  final CodeGenerateResponse? generatedCode;
  final bool isLoading;
  final String? error;

  MultiCostumeState({
    this.selectedCostumes = const [],
    this.generatedCode,
    this.isLoading = false,
    this.error,
  });

  bool get canGenerate => selectedCostumes.isNotEmpty;

  MultiCostumeState copyWith({
    List<CostumeItem>? selectedCostumes,
    CodeGenerateResponse? generatedCode,
    bool? isLoading,
    String? error,
    bool clearGenerated = false,
    bool clearError = false,
  }) {
    return MultiCostumeState(
      selectedCostumes: selectedCostumes ?? this.selectedCostumes,
      generatedCode:
          clearGenerated ? null : (generatedCode ?? this.generatedCode),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MultiCostumeNotifier extends StateNotifier<MultiCostumeState> {
  MultiCostumeNotifier() : super(MultiCostumeState());

  void toggleCostume(CostumeItem costume) {
    final currentSelected = List<CostumeItem>.from(state.selectedCostumes);

    if (currentSelected.any((c) => c.id == costume.id)) {
      currentSelected.removeWhere((c) => c.id == costume.id);
    } else {
      currentSelected.add(costume);
    }

    state = state.copyWith(selectedCostumes: currentSelected);
  }

  void removeCostume(CostumeItem costume) {
    final currentSelected = List<CostumeItem>.from(state.selectedCostumes);
    currentSelected.removeWhere((c) => c.id == costume.id);
    state = state.copyWith(selectedCostumes: currentSelected);
  }

  Future<void> generateCode() async {
    if (!state.canGenerate) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final token = await secureStorage.getToken();
      if (token == null) {
        state = state.copyWith(
          isLoading: false,
          error: '未找到登录凭证，请重新登录',
        );
        return;
      }

      // 按照页面原始顺序排序选中的装扮ID
      // 从CostumePools获取原始顺序
      final originalOrder = <String, int>{};
      // 需要导入CostumePools，所以先创建索引映射
      final allCostumesIds = [
        '30010082', '30010394', '30010451', '30010703',
        '31110224', '31110292', '31110303', '31110672',
        '31110704', '32000344', '32000792', '32000832',
      ];
      for (var i = 0; i < allCostumesIds.length; i++) {
        originalOrder[allCostumesIds[i]] = i;
      }

      // 根据原始顺序排序选中的装扮
      final sortedCostumes = List<CostumeItem>.from(state.selectedCostumes)
        ..sort((a, b) {
          final indexA = originalOrder[a.id] ?? 999;
          final indexB = originalOrder[b.id] ?? 999;
          return indexA.compareTo(indexB);
        });

      // 构造关键词：用空格拼接排序后的装扮ID
      final keyword = sortedCostumes.map((c) => c.id).join(' ');

      final response = await searchService.generateCode(
        keyword: keyword,
        token: token,
      );

      if (response.success) {
        // 如果返回了新token，更新本地存储
        if (response.newToken != null) {
          await secureStorage.saveToken(response.newToken!);
        }

        state = state.copyWith(
          generatedCode: response,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? '生成失败',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '网络错误: ${e.toString()}',
      );
    }
  }

  void reset() {
    state = MultiCostumeState();
  }

  void resetSelection() {
    state = state.copyWith(
      selectedCostumes: [],
      clearGenerated: true,
    );
  }
}

final multiCostumeProvider =
    StateNotifierProvider<MultiCostumeNotifier, MultiCostumeState>(
  (ref) => MultiCostumeNotifier(),
);
