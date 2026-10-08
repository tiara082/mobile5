import 'package:dio/dio.dart';

String friendlyApiError(Object error) {
  if (error is DioException) {
    if (error.response?.statusCode == 401) {
      return 'Sesi berakhir. Silakan login kembali.';
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Server terlalu lama merespons.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Tidak ada koneksi internet.';
    }
  }
  return 'Terjadi kesalahan. Silakan coba lagi.';
}
