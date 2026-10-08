"""Check the public file allowlist and fictional PDF data (requires pypdf)."""
import argparse
from pathlib import Path
import re
import subprocess
from urllib.parse import urlsplit
from pypdf import PdfReader

ROOT = Path(__file__).resolve().parents[1]

def pdf_text(path, page_number):
    result = subprocess.run(
        ["pdftotext", "-enc", "UTF-8", "-f", str(page_number), "-l", str(page_number), str(path), "-"],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
    assert b"Syntax Error" not in result.stderr, "Install Poppler's CJK mapping data before checking PDFs"
    return result.stdout.decode("utf-8")

def check_pdf(path):
    reader = PdfReader(path)
    assert len(reader.pages) == 2, str(path.name) + ": expected two pages"
    assert not reader.trailer["/Root"].get("/AF"), "Associated files found"
    names = reader.trailer["/Root"].get("/Names", {})
    if hasattr(names, "get_object"):
        names = names.get_object()
    assert not names.get("/EmbeddedFiles") and not names.get("/JavaScript"), "Embedded content found"
    metadata = str(reader.metadata)
    assert not re.search(r"(?<![A-Za-z])[A-Za-z]:[\\/]|/home/|/Users/", metadata), "Local path in metadata"
    assert reader.metadata.get("/Author") == "Research CV contributors", "Unexpected PDF author"
    uri_count = 0
    for page_number, page in enumerate(reader.pages, 1):
        text = pdf_text(path, page_number)
        assert "虚构示例" in text, "Missing fictional example footer"
        for email in re.findall(r"[\w.+-]+@[\w.-]+\.[A-Za-z]+", text):
            assert email.endswith("@example.com"), "Non-example email in PDF"
        for annotation in page.get("/Annots", []):
            action = annotation.get_object().get("/A")
            if not action:
                continue
            action = action.get_object()
            assert action.get("/S") in ("/URI", "/GoTo"), "Unexpected PDF action"
            if "/URI" not in action:
                continue
            uri = str(action["/URI"])
            parsed = urlsplit(uri)
            assert ((parsed.scheme == "https" and parsed.hostname == "example.com") or
                    (parsed.scheme == "mailto" and parsed.path.endswith("@example.com"))), \
                    "Non-example external target in " + path.name
            uri_count += 1
    print(path.name + ": 2 pages; " + str(uri_count) + " placeholder links; metadata checked")

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pdf-dir", type=Path, default=ROOT)
    args = parser.parse_args()
    allowed = {line.strip() for line in (ROOT / "release-files.txt").read_text(encoding="utf-8").splitlines()
               if line.strip() and not line.startswith("#")}
    result = subprocess.check_output(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard"], cwd=ROOT)
    actual = set(result.decode("utf-8").splitlines())
    assert actual == allowed, "Public file allowlist mismatch: " + repr(sorted(actual ^ allowed))
    for name in allowed:
        path = ROOT / name
        assert path.is_file(), "Missing release file: " + name
        if path.suffix not in (".tex", ".cls", ".md"):
            continue
        data = path.read_text(encoding="utf-8")
        assert not re.search(r"(?<![A-Za-z])[A-Za-z]:[\\/]|/home/|/Users/", data), "Machine path in " + name
        for email in re.findall(r"[\w.+-]+@[\w.-]+\.[A-Za-z]+", data):
            assert email.endswith("@example.com"), "Non-example email in " + name
    for variant in ("research", "industry", "ai4s"):
        check_pdf(args.pdf_dir / ("medium-professional-" + variant + "-cn.pdf"))
    print("Public file allowlist and fictional PDF checks passed.")

if __name__ == "__main__":
    main()
