import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:interview_ace/core/l10n/app_localizations.dart';

/// Custom in-app photo picker that bypasses broken native iOS pickers
/// Uses photo_manager to read photos and Flutter GridView to display them
/// Flutter's touch handling works perfectly on iOS Simulator
class CustomPhotoPicker extends StatefulWidget {
  const CustomPhotoPicker({super.key});

  static Future<File?> pick(BuildContext context) async {
    return await Navigator.of(context).push<File?>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const CustomPhotoPicker(),
      ),
    );
  }

  @override
  State<CustomPhotoPicker> createState() => _CustomPhotoPickerState();
}

class _CustomPhotoPickerState extends State<CustomPhotoPicker> {
  List<AssetEntity> _assets = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      setState(() {
        _error = 'Photo access denied. Please enable in Settings.';
        _loading = false;
      });
      return;
    }

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      hasAll: true,
    );

    if (albums.isEmpty) {
      setState(() {
        _error = 'No photo albums found.';
        _loading = false;
      });
      return;
    }

    final recentAlbum = albums.first;
    final assets = await recentAlbum.getAssetListRange(start: 0, end: 100);

    setState(() {
      _assets = assets;
      _loading = false;
    });
  }

  Future<void> _selectPhoto(AssetEntity asset) async {
    final file = await asset.file;
    if (file != null && mounted) {
      Navigator.of(context).pop(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.selectPhoto),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(null),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.photo_library_outlined, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    if (_assets.isEmpty) {
      return const Center(child: Text('No photos available'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: _assets.length,
      itemBuilder: (context, index) {
        return _PhotoTile(
          asset: _assets[index],
          onTap: () => _selectPhoto(_assets[index]),
        );
      },
    );
  }
}

class _PhotoTile extends StatefulWidget {
  final AssetEntity asset;
  final VoidCallback onTap;

  const _PhotoTile({required this.asset, required this.onTap});

  @override
  State<_PhotoTile> createState() => _PhotoTileState();
}

class _PhotoTileState extends State<_PhotoTile> {
  Uint8List? _thumb;

  @override
  void initState() {
    super.initState();
    _loadThumb();
  }

  Future<void> _loadThumb() async {
    final thumb = await widget.asset.thumbnailDataWithSize(
      const ThumbnailSize(300, 300),
    );
    if (mounted && thumb != null) {
      setState(() => _thumb = thumb);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        color: Colors.grey[200],
        child: _thumb != null
            ? Image.memory(_thumb!, fit: BoxFit.cover)
            : const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
      ),
    );
  }
}
