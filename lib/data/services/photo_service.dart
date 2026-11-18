import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/id_generator.dart';

/// Mengambil foto (kamera / galeri) lalu menyimpannya di folder aplikasi
/// agar tetap ada walau foto asli dihapus dari galeri.
class PhotoService {
  PhotoService._();
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pick({required bool fromCamera}) async {
    final XFile? file = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 70,
    );
    if (file == null) return null;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${dir.path}/photos');
      if (!await photoDir.exists()) {
        await photoDir.create(recursive: true);
      }
      final target = '${photoDir.path}/${IdGen.id()}.jpg';
      await File(file.path).copy(target);
      return target;
    } catch (_) {
      // Jika gagal menyalin, pakai path asli.
      return file.path;
    }
  }

  static bool exists(String? path) {
    if (path == null || path.isEmpty) return false;
    try {
      return File(path).existsSync();
    } catch (_) {
      return false;
    }
  }
}
