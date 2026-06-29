# Academic Style Chinese CV Templates

这是一个面向中文学术与工程研发简历的 XeLaTeX 模板包，包含研究导向和行业导向两个示例。示例内容均为虚构占位信息，可直接替换为个人经历。

## Preview

- [研究版 PDF](medium-professional-research-cn.pdf)
- [行业版 PDF](medium-professional-industry-cn.pdf)
- `fig-template/`: 匿名格式参考图，用于展示模板复现目标和最终效果。

## Files

- `medium-professional-research-cn.tex`: 中文研究型简历示例。
- `medium-professional-industry-cn.tex`: 中文行业型简历示例。
- `resume.cls`: 本模板使用的本地简历样式类。
- `assets/id-photo.jpg`: 默认卡通头像占位图。
- `fig-template/`: 脱敏后的格式参考图。
- `LICENSE`: 开源许可证与上游模板署名说明。

## Replace The Portrait

两个模板默认引用：

```tex
\portraitimage{assets/id-photo.jpg}
```

使用时直接用自己的证件照或头像替换 `assets/id-photo.jpg`，保持文件名不变即可重新编译。也可以把命令参数改成其它相对路径。

## Build

请使用 XeLaTeX 编译：

```powershell
xelatex medium-professional-research-cn.tex
xelatex medium-professional-industry-cn.tex
```

模板默认优先使用 `Noto Serif SC`，如果本机没有该字体，则回退到 `SimSun`。建议安装 Noto Serif SC / Noto Serif CJK SC 以获得更稳定的中文排版效果。

## License And Attribution

This project is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License (`CC BY-NC-SA 4.0`). See [LICENSE](LICENSE) and the official legal code: <https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode>.

This template is adapted from the Medium Length Professional CV LaTeX Template, Version 3.0, originally published at <https://www.LaTeXTemplates.com>. Original template author: Vel. Original author: Trey Hunner.
