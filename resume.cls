\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2026/10/08 Research CV 2.0]
% SPDX-License-Identifier: CC-BY-NC-SA-4.0
% Upstream attribution is preserved in LICENSE.

\LoadClass[11pt,a4paper]{article}

\RequirePackage[a4paper,left=1.45cm,right=1.45cm,top=1.15cm,bottom=1.15cm,includefoot]{geometry}
\RequirePackage{array}
\RequirePackage{enumitem}
\RequirePackage{ifthen}
\RequirePackage{xcolor}
\RequirePackage[normalem]{ulem}
\RequirePackage{hyperref}
\RequirePackage{tabularx}
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\RequirePackage{needspace}
\RequirePackage{lastpage}
\RequirePackage{fontspec}
\RequirePackage{xeCJK}
\input{cv-fonts.tex}
\input{cv-icons.tex}

\definecolor{cvnavy}{HTML}{123A5A}
\definecolor{cvblue}{HTML}{176DA5}
\definecolor{cvlight}{HTML}{EAF4FA}
\definecolor{cvgray}{HTML}{65727D}
\definecolor{cvline}{HTML}{B8CEDD}
\definecolor{cvtext}{HTML}{202A31}
\definecolor{cvwhite}{HTML}{FFFFFF}

\hypersetup{
  colorlinks=true,
  urlcolor=cvblue,
  linkcolor=cvblue,
  pdfborder={0 0 0}
}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[C]{\textcolor{cvgray}{\footnotesize \thepage\,/\,\pageref*{LastPage}}}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\setlength{\tabcolsep}{4pt}
\setlength{\emergencystretch}{2em}
\Urlmuskip=0mu plus 2mu\relax
\renewcommand{\arraystretch}{1.08}
\setlist[itemize]{leftmargin=1.35em,itemsep=1.8pt,topsep=2pt,parsep=0pt,partopsep=0pt}
\setlist[enumerate]{leftmargin=2.0em,itemsep=3.2pt,topsep=2pt,parsep=0pt,partopsep=0pt}

\newcommand{\@name}{}
\newcommand{\@cvtitle}{}
\newcommand{\@addresses}{}
\newcommand{\@leftinfo}{}
\newcommand{\@rightinfo}{}
\newcommand{\@portraitimage}{}
\newif\if@manualheader
\@manualheaderfalse

\newcommand{\name}[1]{\renewcommand{\@name}{#1}}
\newcommand{\cvtitle}[1]{\renewcommand{\@cvtitle}{#1}}
\newcommand{\address}[1]{\g@addto@macro\@addresses{{#1}\par}}
\newcommand{\manualheader}{\@manualheadertrue}
\newcommand{\portraitimage}[1]{\renewcommand{\@portraitimage}{#1}}
\newcommand{\infoitem}[2]{\textcolor{cvgray}{\footnotesize #1} & {\footnotesize #2}\\[1pt]}
\newcommand{\leftinfo}[2]{\g@addto@macro\@leftinfo{\infoitem{#1}{#2}}}
\newcommand{\rightinfo}[2]{\g@addto@macro\@rightinfo{\infoitem{#1}{#2}}}
\newcommand{\basicinfo}[2]{\leftinfo{#1}{#2}}
\newlength{\cvinfoheight}
\setlength{\cvinfoheight}{2.55cm}
\newcommand{\headerrows}[1]{\setlength{\cvinfoheight}{#1\baselineskip}}

\newcommand{\cvtag}[1]{%
  {\setlength{\fboxsep}{2.3pt}\colorbox{cvlight}{\textcolor{cvblue}{\footnotesize\bfseries\strut #1}}}%
}
\newcommand{\cvtagdark}[1]{%
  {\setlength{\fboxsep}{3pt}\colorbox{cvnavy}{\textcolor{cvwhite}{\footnotesize\bfseries\strut #1}}}%
}
\newcommand{\rolebadge}[1]{%
  {\setlength{\fboxsep}{2.2pt}\colorbox{cvlight}{\textcolor{cvblue}{\scriptsize\bfseries\strut #1}}}%
}
\newcommand{\metricbadge}[1]{%
  {\setlength{\fboxsep}{1.8pt}\colorbox{cvlight}{\textcolor{cvblue}{\scriptsize\bfseries\strut #1}}}%
}
\newcommand{\contactlink}[2]{\href{#2}{\textcolor{cvblue}{\bfseries #1}}}
\newcommand{\evidencelink}[2]{\href{#2}{\textcolor{cvblue}{\scriptsize\bfseries #1}}}
\newcommand{\cvlinkicon}[1]{\raisebox{-0.04em}{#1}}
\newcommand{\contacticonlink}[3]{%
  \href{#3}{\textcolor{cvblue}{\cvlinkicon{#1}\hspace{0.28em}\bfseries #2}}%
}
\newcommand{\evidenceiconlink}[3]{%
  \mbox{\href{#3}{\textcolor{cvblue}{\scriptsize\cvlinkicon{#1}\hspace{0.24em}\bfseries #2}}}%
}

\newcommand{\printheader}{%
  \begin{center}
    {\fontsize{26pt}{28pt}\selectfont\bfseries\textcolor{cvnavy}{\@name}}\par
    \ifthenelse{\equal{\@cvtitle}{}}{}{\vspace{2pt}{\large\bfseries \@cvtitle}\par}
    \vspace{3pt}
    {\small \@addresses}
  \end{center}
  \vspace{-2pt}
}

% Opt-in header positioning: preserve legacy layout unless a variant overrides.
\newlength{\cvheadernameraise}
\setlength{\cvheadernameraise}{0pt}
\newlength{\cvportraitheight}
\setlength{\cvportraitheight}{2.80cm}
\newlength{\cvportraitoffset}
\setlength{\cvportraitoffset}{0pt}
\newif\ifcvheaderseparator
\cvheaderseparatortrue

\newcommand{\portraitbox}{%
  \begingroup
  \setlength{\fboxsep}{0pt}%
  \ifthenelse{\equal{\@portraitimage}{}}{%
    \fcolorbox{cvline}{cvlight}{%
      \parbox[c][2.7cm][c]{2.05cm}{%
        \centering\textcolor{cvgray}{\small 证件照}
      }%
    }%
  }{%
    \includegraphics[height=\cvportraitheight,keepaspectratio]{\@portraitimage}%
  }%
  \endgroup
}

\newcommand{\makecvheader}{%
  \noindent
  \begin{minipage}[c]{0.81\textwidth}
    {\fontsize{27pt}{29pt}\selectfont\bfseries
      \ifdim\cvheadernameraise=0pt\relax
        \textcolor{cvnavy}{\@name}%
      \else
        \raisebox{\cvheadernameraise}[\height][\depth]{\textcolor{cvnavy}{\@name}}%
      \fi}\par
    \ifthenelse{\equal{\@cvtitle}{}}{}{\vspace{1pt}{\normalsize\bfseries\textcolor{cvtext}{\@cvtitle}}\par}
    \vspace{5pt}
    \begin{minipage}[t]{0.49\linewidth}
      \begin{tabularx}{\linewidth}{@{}p{1.35cm}>{\raggedright\arraybackslash}X@{}}
        \@leftinfo
      \end{tabularx}
    \end{minipage}\hfill
    \begin{minipage}[t]{0.49\linewidth}
      \begin{tabularx}{\linewidth}{@{}p{1.35cm}>{\raggedright\arraybackslash}X@{}}
        \@rightinfo
      \end{tabularx}
    \end{minipage}
  \end{minipage}\hfill
  \begin{minipage}[c]{0.15\textwidth}
    \raggedleft
    \ifdim\cvportraitoffset=0pt\relax
      \portraitbox
    \else
      \raisebox{\cvportraitoffset}[\height][\depth]{\portraitbox}%
    \fi
  \end{minipage}
  \vspace{5pt}
  \ifcvheaderseparator
    {\color{cvline}\hrule height 0.8pt}%
  \else
    \hrule height 0.8pt width 0pt % retain exactly the same vertical space
  \fi
  \vspace{2pt}
}

% AI4S: school, role, contact, graduation, availability, Scholar, GitHub, tags.
% One table owns all four information rows, with a common 15 pt baseline pitch.
\newcommand{\makeaiheader}[8]{%
  \noindent
  \begingroup
  \fontsize{10pt}{15pt}\selectfont
  \renewcommand{\arraystretch}{1}%
  \setlength{\extrarowheight}{0pt}%
  \begin{tabularx}{\textwidth}{@{}X>{\raggedleft\arraybackslash}p{7.5cm}@{}}
    {\fontsize{28pt}{30pt}\selectfont\bfseries\raisebox{\cvheadernameraise}[\height][\depth]{\textcolor{cvnavy}{\@name}}} &
    {\small\bfseries\textcolor{cvblue}{#2}}\\[4pt]
    {\normalsize\bfseries #1} &
    {\small\textcolor{cvgray}{#4}}\\
    {\small\textcolor{cvgray}{#3}} &
    {\small\textcolor{cvgray}{#5}}\\
    \multicolumn{2}{@{}l@{}}{{\small\textcolor{cvgray}{#6}}}\\
    \multicolumn{2}{@{}l@{}}{{\small\textcolor{cvgray}{#7}}}
  \end{tabularx}
  \endgroup\par
  \ifthenelse{\equal{#8}{}}{}{\vspace{4pt}#8\par}%
  \vspace{5pt}
  \ifcvheaderseparator
    {\color{cvline}\hrule height 0.8pt}%
  \else
    \hrule height 0.8pt width 0pt
  \fi
  \vspace{2pt}
}

\AtBeginDocument{%
  \color{cvtext}%
  \fontsize{10.8pt}{13.5pt}\selectfont
  \if@manualheader\else\printheader\fi
}

\newenvironment{rSection}[1]{%
  \Needspace{4.5\baselineskip}%
  \vspace{6pt}
  {\fontsize{14pt}{15pt}\selectfont\bfseries\textcolor{cvnavy}{#1}}\par
  \vspace{1.5pt}
  {\color{cvline}\hrule height 0.55pt}
  \vspace{5pt}
}{%
  \vspace{1pt}
}

% Optional right-aligned tags share the existing section heading baseline.
\newenvironment{rSectionWithTags}[2]{%
  \begin{rSection}{\makebox[\linewidth][l]{#1\hfill #2}}%
}{%
  \end{rSection}%
}

\newenvironment{rSubsection}[4]{%
  \textbf{#1}\hfill{\footnotesize\textcolor{cvgray}{#2}}\par
  \ifthenelse{\equal{#3}{}}{}{\textcolor{cvblue}{#3}\hfill\textcolor{cvgray}{#4}\par}
  \begin{itemize}
}{%
  \end{itemize}
  \vspace{1pt}
}

\newcommand{\cvgroupheading}[1]{%
  \Needspace{3\baselineskip}%
  \vspace{1pt}{\small\bfseries\textcolor{cvblue}{#1}}\par\vspace{1pt}
}

\newenvironment{cvgroup}[1]{%
  \cvgroupheading{#1}
  \begin{enumerate}
}{%
  \end{enumerate}
}

\newenvironment{cvbullets}[1]{%
  \cvgroupheading{#1}
  \begin{itemize}
}{%
  \end{itemize}
}

\newcommand{\eduentry}[5]{%
  \Needspace{2.2\baselineskip}%
  \begin{tabularx}{\textwidth}{@{}Xr@{}}
    \textbf{#1}\enspace\textbf{#2}\enspace{\textcolor{cvgray}{#3}}\enspace #4 &
    {\footnotesize\textcolor{cvgray}{#5}}
  \end{tabularx}
}

\newcommand{\subdetail}[1]{%
  \hspace{1.2em}{\footnotesize\textcolor{cvgray}{#1}}\par
}

\newcommand{\skillrow}[2]{\textbf{#1} & #2\\}
\newcommand{\skillitem}[2]{\item \textbf{#1}\enspace #2}
% Each variant can adjust project heading separation without changing others.
\newlength{\cvprojecttitlegap}
\setlength{\cvprojecttitlegap}{-2pt}
\newcommand{\projectentry}[4]{%
  \item \Needspace{2.4\baselineskip}%
  \begin{tabularx}{\linewidth}{@{}Xr@{}}
    \textbf{#1} & {\footnotesize\textcolor{cvgray}{#3}}
  \end{tabularx}
  \vspace{\cvprojecttitlegap}
  {\footnotesize\textcolor{cvblue}{#2}}\enspace #4%
}
% Academic project entries break only between complete items.
\newcommand{\researchprojectentry}[4]{%
  \item \begin{minipage}[t]{\linewidth}
  \begin{tabularx}{\linewidth}{@{}Xr@{}}
    \textbf{#1} & {\footnotesize\textcolor{cvgray}{#3}}
  \end{tabularx}
  \vspace{\cvprojecttitlegap}
  {\footnotesize\textcolor{cvblue}{#2}}\enspace #4
  \end{minipage}%
}
\newlength{\cvresearchcaseitemgap}
\setlength{\cvresearchcaseitemgap}{4pt}
\newcommand{\cvresearchcaselabelone}{研究问题}
\newcommand{\cvresearchcaselabeltwo}{独立完成}
\newcommand{\cvresearchcaselabelthree}{成果}
\newcommand{\researchcase}[6]{%
  % Keep the complete case together using its actual height, not a line estimate.
  \par\noindent
  \begin{minipage}{\textwidth}
  \begin{tabularx}{\textwidth}{@{}Xr@{}}
    \textbf{#1} & {\footnotesize\textcolor{cvgray}{#3}}
  \end{tabularx}
  \vspace{0pt}
  {\footnotesize\textcolor{cvblue}{#2}}\par
  % Balance heading-to-metadata and metadata-to-body baseline distances.
  \vspace{1.2pt}
  {\fontsize{10.3pt}{12.5pt}\selectfont
    \begingroup
    \renewcommand{\arraystretch}{1.03}%
    \begin{tabularx}{\textwidth}{@{}>{\raggedright\arraybackslash}p{1.55cm}>{\raggedright\arraybackslash}X@{}}
      \textbf{\textcolor{cvblue}{\cvresearchcaselabelone}} & #4\\[0.6pt]
      \textbf{\textcolor{cvblue}{\cvresearchcaselabeltwo}} & #5\\[0.6pt]
      \textbf{\textcolor{cvblue}{\cvresearchcaselabelthree}} & #6
    \end{tabularx}
    \endgroup
  }
  \end{minipage}\par
  \vspace{\cvresearchcaseitemgap}
}
\newcommand{\authorhl}[1]{\textbf{#1}}
\newcommand{\paperauthorhl}[1]{%
  \begingroup
  \renewcommand{\ULthickness}{0.45pt}%
  \setlength{\ULdepth}{1.5pt}%
  \textcolor{cvtext}{\uline{\textbf{#1}}}%
  \endgroup
}
\newcommand{\journal}[1]{\textit{#1}}
\newcommand{\doi}[1]{\evidenceiconlink{\cvDoiIcon}{DOI}{#1}}
\newcommand{\cvdate}[1]{\hfill{\footnotesize\textcolor{cvgray}{#1}}}

\newcommand{\paperentry}[7]{%
  \Needspace{4.2\baselineskip}%
  \noindent
  \begin{tabularx}{\textwidth}{@{}p{1.35cm}X@{}}
    \rolebadge{#1} &
    \href{#6}{\textbf{#3}}\\[-1pt]
    & {\footnotesize\textcolor{cvgray}{#2}}\\[-1pt]
    & {\footnotesize\journal{#4}, #5\enspace\doi{#6}}\\[-1pt]
    & #7
  \end{tabularx}
  \vspace{4pt}
}

% Compact structure can retain the academic variant's original title size.
\newcommand{\cvcompactpapertitlefont}{\small}
\newcommand{\cvcompactpapermetaformat}{}
\newcommand{\cvcompactpapermetaend}{}
\newcommand{\cvcompactpaperauthors}[1]{\textcolor{cvgray}{#1}}
\newcommand{\cvcompactpapermetasep}{\enspace}
\newcommand{\cvpaperjournalmetadata}[3]{\journal{#1}, #2\enspace #3}
\newlength{\cvcompactpaperdetailgap}
\setlength{\cvcompactpaperdetailgap}{1.5pt}
\newlength{\cvcompactpaperitemgap}
\setlength{\cvcompactpaperitemgap}{4pt}
\newcommand{\compactpaperentry}[7]{%
  \Needspace{4.2\baselineskip}%
  \noindent
  {\cvcompactpapertitlefont\raggedright\rightskip=0pt plus 10em\relax\mbox{\textcolor{cvblue}{\bfseries #1｜}}\enspace
    \href{#6}{\textbf{#3}}}\par
  \vspace{\cvcompactpaperdetailgap}
  {\footnotesize\cvcompactpapermetaformat\cvcompactpaperauthors{#2}\cvcompactpapermetasep
    \cvpaperjournalmetadata{#4}{#5}{#7}\cvcompactpapermetaend}\par
  \vspace{\cvcompactpaperitemgap}
}

\newcommand{\publicationnote}[1]{%
  \Needspace{2.2\baselineskip}%
  {\footnotesize\textcolor{cvgray}{#1}}\par
}

\newcommand{\researchhighlight}[3]{%
  \Needspace{4\baselineskip}%
  \begin{tabularx}{\textwidth}{@{}p{2.15cm}X@{}}
    \cvtag{#1} &
    \textbf{#2}\par{\small #3}
  \end{tabularx}
  \vspace{3pt}
}

\newcommand{\cvstat}[2]{%
  \begin{minipage}[c]{0.22\textwidth}
    \centering
    {\fontsize{18pt}{19pt}\selectfont\bfseries\textcolor{cvnavy}{#1}}\par
    {\footnotesize\textcolor{cvgray}{#2}}
  \end{minipage}
}

\newcommand{\cvstatcompact}[2]{%
  \begin{minipage}[c][1.16cm][c]{0.235\textwidth}
    \centering
    {\fontsize{18pt}{19pt}\selectfont\bfseries\textcolor{cvnavy}{#1}}\par
    {\fontsize{9.3pt}{10.5pt}\selectfont\textcolor{cvgray}{#2}}
  \end{minipage}
}

\newcommand{\cvstatdetail}[3]{%
  \begin{minipage}[c][1.42cm][c]{0.235\textwidth}
    \centering
    {\fontsize{18pt}{19pt}\selectfont\bfseries\textcolor{cvnavy}{#1}}\par
    {\footnotesize\textcolor{cvgray}{#2}}\par
    {\scriptsize\textcolor{cvgray}{#3}}
  \end{minipage}
}
