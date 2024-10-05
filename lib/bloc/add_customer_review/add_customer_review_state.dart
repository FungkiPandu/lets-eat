part of 'add_customer_review_cubit.dart';

sealed class AddCustomerReviewState extends Equatable {
  const AddCustomerReviewState();
}

final class AddCustomerReviewInitial extends AddCustomerReviewState {
  @override
  List<Object> get props => [];
}
