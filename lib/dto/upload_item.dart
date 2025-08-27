


class UploadItem{
  final String fileName;
  final String path; // Pour mobile
  final dynamic file; // Pour Web : PlatformFile / XFile
  double progress;
  bool isUploading;

  UploadItem({
    required this.fileName,
    required this.path,
    this.file,
    this.progress = 0,
    this.isUploading = false,
  });

}