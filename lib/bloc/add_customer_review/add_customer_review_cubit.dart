import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_customer_review_state.dart';

class AddCustomerReviewCubit extends Cubit<AddCustomerReviewState> {
  AddCustomerReviewCubit() : super(AddCustomerReviewInitial());
}
