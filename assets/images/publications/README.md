# Publication images

Add paper thumbnails here as transparent PNG files whenever possible. Reference them from `_data/publications.yml`, for example:

```yaml
image: /assets/images/publications/my-paper.png
image_alt: "Short description of the paper figure"
```

The source PNGs used before background removal are preserved in `originals/`.
Run `python3 scripts/transparent_publication_images.py` to regenerate the
transparent working copies without changing the backups. GIFs are left alone.
