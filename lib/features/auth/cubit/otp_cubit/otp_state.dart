part of 'otp_cubit.dart';

sealed class OtpState {}

final class OtpInitial extends OtpState {}

final class OtpFailure extends OtpState {}

final class OtpSendedSuccessfully extends OtpState {}

final class OtpVerified extends OtpState {}

final class OtpLoading extends OtpState {}
