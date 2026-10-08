"""Build the three fictional examples; requires XeLaTeX (and pdftoppm for previews)."""
import argparse
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[1]
VARIANTS = ("research", "industry", "ai4s")

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-dir", type=Path, default=ROOT / "build")
    parser.add_argument("--refresh-previews", action="store_true",
                        help="Update tracked example PDFs and six PNG previews after a successful build.")
    args = parser.parse_args()
    out = args.output_dir.resolve()
    out.mkdir(parents=True, exist_ok=True)
    for variant in VARIANTS:
        stem = "medium-professional-" + variant + "-cn"
        for pass_number in (1, 2):
            result = subprocess.run(
                ["xelatex", "-interaction=nonstopmode", "-halt-on-error", "-file-line-error",
                 "-output-directory=" + str(out), stem + ".tex"],
                cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            (out / (stem + "-pass" + str(pass_number) + ".txt")).write_bytes(result.stdout)
            if result.returncode:
                print(result.stdout.decode("utf-8", errors="replace")[-6000:])
                raise SystemExit(result.returncode)
        log = (out / (stem + ".log")).read_text(encoding="utf-8", errors="replace")
        problems = [line for line in log.splitlines()
                    if "Overfull" in line or "Missing character:" in line]
        if problems:
            raise SystemExit(stem + " failed layout checks:\n" + "\n".join(problems))
        print(stem + ": two XeLaTeX passes completed", flush=True)
    if args.refresh_previews:
        previews = ROOT / "previews"
        previews.mkdir(exist_ok=True)
        for variant in VARIANTS:
            stem = "medium-professional-" + variant + "-cn"
            shutil.copy2(out / (stem + ".pdf"), ROOT / (stem + ".pdf"))
            rendered = subprocess.run(["pdftoppm", "-r", "110", "-png", "-f", "1", "-l", "2",
                            str(out / (stem + ".pdf")), str(previews / variant)],
                            check=True, capture_output=True)
            if b"Syntax Error" in rendered.stderr:
                raise SystemExit("Preview renderer lacks CJK data. Install a complete Poppler distribution.")
        print("Updated three PDFs and six previews.")

if __name__ == "__main__":
    main()
