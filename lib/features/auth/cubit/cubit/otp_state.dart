part of 'otp_cubit.dart';

sealed class OtpState {}

final class OtpInitial extends OtpState {}

final class OtpFailure extends OtpState {}

final class OtpSuccess extends OtpState {}

final class OtpLoading extends OtpState {}
