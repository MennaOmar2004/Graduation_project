import 'package:wanisi_app/model_of_child/child.dart';

abstract class ChildState{}

class InitialChildState extends ChildState{}

class LoadChild extends ChildState{
  final List<Child> childrenList;
  LoadChild(this.childrenList);
}

class LoadChildFailed extends ChildState {
  final String error;
  LoadChildFailed(this.error);
}

class ChildSelectedSuccess extends ChildState{
  final Child data;
  ChildSelectedSuccess(this.data);
}

class ChildError extends ChildState{
  final String error;
  ChildError(this.error);
}

class ChildUpdatedSuccess extends ChildState {}
