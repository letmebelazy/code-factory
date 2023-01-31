import 'package:code_factory/common/model/cursor_pagination_model.dart';
import 'package:code_factory/common/model/model_with_id.dart';
import 'package:code_factory/common/model/pagination_params.dart';
import 'package:code_factory/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProvider<T extends IModelWithId, U extends IBasePaginationRepository<T>> extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({required this.repository}) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = true,
  }) async {
    try {
      if (state is CursorPagination<T> && !forceRefetch) {
        final pState = state as CursorPagination<T>;

        if (!pState.meta.hasMore) return;
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) return;

      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      if (fetchMore) {
        final pState = state as CursorPagination<T>;
        state = CursorPaginationFetchingMore<T>(meta: pState.meta, data: pState.data);
        paginationParams = paginationParams.copyWith(after: pState.data.last.id);
      } else {
        if (state is CursorPagination<T> && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(meta: pState.meta, data: pState.data);
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore<T>) {
        final pState = state as CursorPaginationFetchingMore<T>;

        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}