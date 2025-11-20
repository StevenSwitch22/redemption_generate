import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/plant_data.dart';
import '../models/plant_pools.dart';
import '../models/search_response.dart';
import '../services/api/search_service.dart';
import '../services/local/secure_storage.dart';

final searchService = SearchService();
final secureStorage = SecureStorageService();

class MultiPlantState {
  final PlantPool? selectedPool;
  final List<PlantItem> selectedPlants;
  final CodeGenerateResponse? generatedCode;
  final bool isLoading;
  final String? error;

  MultiPlantState({
    this.selectedPool,
    this.selectedPlants = const [],
    this.generatedCode,
    this.isLoading = false,
    this.error,
  });

  bool get canGenerate =>
      selectedPool != null &&
      selectedPlants.length == selectedPool!.selectCount;

  int get remainingCount =>
      selectedPool != null
          ? selectedPool!.selectCount - selectedPlants.length
          : 0;

  MultiPlantState copyWith({
    PlantPool? selectedPool,
    List<PlantItem>? selectedPlants,
    CodeGenerateResponse? generatedCode,
    bool? isLoading,
    String? error,
    bool clearPool = false,
    bool clearGenerated = false,
    bool clearError = false,
  }) {
    return MultiPlantState(
      selectedPool: clearPool ? null : (selectedPool ?? this.selectedPool),
      selectedPlants: selectedPlants ?? this.selectedPlants,
      generatedCode:
          clearGenerated ? null : (generatedCode ?? this.generatedCode),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MultiPlantNotifier extends StateNotifier<MultiPlantState> {
  MultiPlantNotifier() : super(MultiPlantState());

  void selectPool(PlantPool pool) {
    state = state.copyWith(
      selectedPool: pool,
      selectedPlants: [],
      clearGenerated: true,
    );
  }

  void togglePlant(PlantItem plant) {
    final currentSelected = List<PlantItem>.from(state.selectedPlants);

    if (currentSelected.any((p) => p.id == plant.id)) {
      currentSelected.removeWhere((p) => p.id == plant.id);
    } else {
      if (state.selectedPool != null &&
          currentSelected.length < state.selectedPool!.selectCount) {
        currentSelected.add(plant);
      }
    }

    state = state.copyWith(selectedPlants: currentSelected);
  }

  void removePlant(PlantItem plant) {
    final currentSelected = List<PlantItem>.from(state.selectedPlants);
    currentSelected.removeWhere((p) => p.id == plant.id);
    state = state.copyWith(selectedPlants: currentSelected);
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

      // 构造关键词：用空格拼接所有植物ID
      final keyword = state.selectedPlants.map((p) => p.id).join(' ');

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
    state = MultiPlantState();
  }

  void resetSelection() {
    state = state.copyWith(
      selectedPlants: [],
      clearGenerated: true,
    );
  }
}

final multiPlantProvider =
    StateNotifierProvider<MultiPlantNotifier, MultiPlantState>(
  (ref) => MultiPlantNotifier(),
);
