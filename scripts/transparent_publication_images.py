#!/usr/bin/env python3
"""Make edge-connected white publication backgrounds transparent.

Original PNG files are copied once to ``assets/images/publications/originals``
before the working copies are converted in place.
"""

from pathlib import Path
import shutil

import numpy as np
from PIL import Image
from scipy import ndimage


ROOT = Path(__file__).resolve().parents[1]
IMAGE_DIR = ROOT / "assets" / "images" / "publications"
BACKUP_DIR = IMAGE_DIR / "originals"
CONNECT_THRESHOLD = 220
TRANSPARENT_THRESHOLD = 245
MAX_CHANNEL_SPREAD = 30


def convert(path: Path) -> tuple[int, int]:
    backup = BACKUP_DIR / path.name
    if not backup.exists():
        shutil.copy2(path, backup)

    with Image.open(backup) as source:
        rgba = np.array(source.convert("RGBA"), dtype=np.uint8)

    rgb = rgba[:, :, :3]
    minimum = rgb.min(axis=2)
    spread = rgb.max(axis=2) - minimum
    near_white = (minimum >= CONNECT_THRESHOLD) & (spread <= MAX_CHANNEL_SPREAD)

    seeds = np.zeros(near_white.shape, dtype=bool)
    seeds[0, :] = near_white[0, :]
    seeds[-1, :] = near_white[-1, :]
    seeds[:, 0] = near_white[:, 0]
    seeds[:, -1] = near_white[:, -1]
    background = ndimage.binary_propagation(seeds, mask=near_white)

    softness = np.clip(
        (TRANSPARENT_THRESHOLD - minimum.astype(np.int16))
        * 255
        / (TRANSPARENT_THRESHOLD - CONNECT_THRESHOLD),
        0,
        255,
    ).astype(np.uint8)
    original_alpha = rgba[:, :, 3].copy()
    rgba[:, :, 3] = np.where(
        background,
        np.minimum(original_alpha, softness),
        original_alpha,
    )

    Image.fromarray(rgba, mode="RGBA").save(path, format="PNG", optimize=True)
    changed = int(np.count_nonzero(rgba[:, :, 3] != original_alpha))
    transparent = int(np.count_nonzero(rgba[:, :, 3] == 0))
    return changed, transparent


def main() -> None:
    BACKUP_DIR.mkdir(exist_ok=True)
    paths = sorted(IMAGE_DIR.glob("*.png"))
    changed_files = 0
    for path in paths:
        changed, transparent = convert(path)
        changed_files += changed > 0
        print(f"{path.name}: changed={changed}, transparent={transparent}")
    print(
        f"Processed {len(paths)} PNGs; {changed_files} received transparent pixels; "
        f"originals are in {BACKUP_DIR.relative_to(ROOT)}"
    )


if __name__ == "__main__":
    main()
