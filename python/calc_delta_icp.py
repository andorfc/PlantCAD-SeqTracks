#!/usr/bin/env python3
"""
calc_delta_icp.py

Compute Δ(IC×P) = (IC×P)_alt – (IC×P)_ref from two WIG tracks.

Assumptions
-----------
* Input files are in WIG variableStep or fixedStep format, one‑based coordinates.
* Chromosomes in both files are sorted the same way (standard for WIGs).
* Missing values are interpreted as 0.0.

Usage
-----
python calc_delta_icp.py \
       B73_full_v5_reference.wig \
       B73_full_v5_nonreference.wig \
       B73_full_v5_ndelta.wig
"""

import sys
from collections import defaultdict

def parse_wig(path):
    """
    Return a dict: {chrom: {pos: value, ...}, ...}
    Handles variableStep and fixedStep records.
    """
    data = defaultdict(dict)
    chrom = None
    step = span = 1
    start = None
    fixed_mode = False

    with open(path) as fh:
        for line in fh:
            line = line.rstrip()
            if not line or line.startswith("track"):
                continue

            if line.startswith("variableStep"):
                fixed_mode = False
                parts = dict(field.split("=", 1) for field in line.split()[1:])
                chrom  = parts["chrom"]
                span   = int(parts.get("span", 1))
                continue

            if line.startswith("fixedStep"):
                fixed_mode = True
                parts = dict(field.split("=", 1) for field in line.split()[1:])
                chrom  = parts["chrom"]
                start  = int(parts["start"])
                step   = int(parts.get("step", 1))
                span   = int(parts.get("span", 1))
                index  = 0
                continue

            # data line
            if not chrom:
                continue  # malformed wig – skip until a step line appears

            if fixed_mode:
                value = float(line)
                pos   = start + index * step          # one‑based
                index += 1
            else:  # variableStep
                pos_str, value_str = line.split()
                pos   = int(pos_str)
                value = float(value_str)

            data[chrom][pos] = value

            # ignore span>1 blocks for Δ computation; if needed, replicate value

    return data


def write_delta_wig(ref, alt, out_path):
    chroms = sorted(set(ref) | set(alt))

    with open(out_path, "w") as out:
        out.write(
            'track type=wiggle_0 name="B73 Δ(IC×P) Alt–Ref" '
            'description="Signed difference between non‑reference and reference IC‑weighted scores"\n'
        )

        for chrom in chroms:
            out.write(f"variableStep chrom={chrom} span=1\n")
            positions = sorted(set(ref.get(chrom, {})) | set(alt.get(chrom, {})))

            for pos in positions:
                delta = alt.get(chrom, {}).get(pos, 0.0) - ref.get(chrom, {}).get(pos, 0.0)
                if delta == 0.0:
                    continue  # skip zeros to keep file compact
                out.write(f"{pos}\t{delta:.6f}\n")


def main():
    if len(sys.argv) != 4:
        sys.exit(
            "Usage: python calc_delta_icp.py <reference.wig> <alt.wig> <output.wig>"
        )

    ref_path, alt_path, out_path = sys.argv[1:]

    print("Reading reference track …")
    ref_scores = parse_wig(ref_path)

    print("Reading alternate track …")
    alt_scores = parse_wig(alt_path)

    print("Writing Δ(IC×P) track …")
    write_delta_wig(ref_scores, alt_scores, out_path)

    print("Done:", out_path)


if __name__ == "__main__":
    main()
