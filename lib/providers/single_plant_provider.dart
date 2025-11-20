import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_response.dart';
import '../services/api/search_service.dart';
import '../services/local/secure_storage.dart';

final searchService = SearchService();
final secureStorage = SecureStorageService();

class SinglePlantState {
  final List<String> suggestions;
  final String? selectedItem;
  final CodeGenerateResponse? generatedCode;
  final bool isLoading;
  final String? error;

  SinglePlantState({
    this.suggestions = const [],
    this.selectedItem,
    this.generatedCode,
    this.isLoading = false,
    this.error,
  });

  SinglePlantState copyWith({
    List<String>? suggestions,
    String? selectedItem,
    CodeGenerateResponse? generatedCode,
    bool? isLoading,
    String? error,
    bool clearSelected = false,
    bool clearGenerated = false,
    bool clearError = false,
  }) {
    return SinglePlantState(
      suggestions: suggestions ?? this.suggestions,
      selectedItem: clearSelected ? null : (selectedItem ?? this.selectedItem),
      generatedCode: clearGenerated ? null : (generatedCode ?? this.generatedCode),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class SinglePlantNotifier extends StateNotifier<SinglePlantState> {
  SinglePlantNotifier() : super(SinglePlantState());

  Future<void> searchSuggestions(String keyword) async {
    if (keyword.isEmpty) {
      state = state.copyWith(suggestions: [], clearSelected: true);
      return;
    }

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

      final response = await searchService.getSuggestions(
        keyword: keyword,
        token: token,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          suggestions: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          suggestions: [],
          isLoading: false,
          error: response.message ?? '搜索失败',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '网络错误: ${e.toString()}',
      );
    }
  }

  void selectItem(String item) {
    state = state.copyWith(
      selectedItem: item,
      suggestions: [],
      clearGenerated: true,
    );
  }

  void clearSelection() {
    state = state.copyWith(
      clearSelected: true,
      suggestions: [],
      clearGenerated: true,
    );
  }

  Future<void> generateCode() async {
    if (state.selectedItem == null) return;

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

      final response = await searchService.generateCode(
        keyword: state.selectedItem!,
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
    state = SinglePlantState();
  }
}

final singlePlantProvider =
    StateNotifierProvider<SinglePlantNotifier, SinglePlantState>(
  (ref) => SinglePlantNotifier(),
);
