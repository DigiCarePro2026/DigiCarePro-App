class PagingModel{

  int page;
  int pageSize;
  int?totalCount;

  PagingModel({required this.page, required this.pageSize, this.totalCount});
}