\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2026/06/26 Local academic CV class]

\LoadClass[11pt,a4paper]{article}

\RequirePackage[a4paper,left=1.55cm,right=1.55cm,top=1.35cm,bottom=1.45cm,includefoot]{geometry}
\RequirePackage{array}
\RequirePackage{enumitem}
\RequirePackage{ifthen}
\RequirePackage{xcolor}
\RequirePackage{hyperref}
\RequirePackage{tabularx}
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}

\definecolor{cvblue}{RGB}{28,55,150}
\definecolor{cvgray}{RGB}{90,90,90}

\hypersetup{
  colorlinks=true,
  urlcolor=cvblue,
  linkcolor=cvblue
}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[C]{\small\thepage}

\linespread{1.10}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\setlength{\tabcolsep}{4pt}
\setlength{\emergencystretch}{2em}
\Urlmuskip=0mu plus 2mu\relax
\renewcommand{\arraystretch}{1.16}
\setlist[itemize]{leftmargin=1.3em,itemsep=0pt,topsep=0pt,parsep=0pt,partopsep=0pt}
\setlist[enumerate]{leftmargin=2.15em,itemsep=0pt,topsep=0pt,parsep=0pt,partopsep=0pt}

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
\newcommand{\infoitem}[2]{\textbf{#1：} & #2\\}
\newcommand{\leftinfo}[2]{\g@addto@macro\@leftinfo{\infoitem{#1}{#2}}}
\newcommand{\rightinfo}[2]{\g@addto@macro\@rightinfo{\infoitem{#1}{#2}}}
\newcommand{\basicinfo}[2]{\leftinfo{#1}{#2}}
\newlength{\cvinfoheight}
\setlength{\cvinfoheight}{2.18cm}
\newcommand{\headerrows}[1]{\setlength{\cvinfoheight}{#1\baselineskip}}

\newcommand{\printheader}{%
  \begin{center}
    {\Huge\bfseries \@name}\par
    \ifthenelse{\equal{\@cvtitle}{}}{}{\vspace{2pt}{\large \@cvtitle}\par}
    \vspace{4pt}
    {\small \@addresses}
  \end{center}
  \vspace{-4pt}
}

\newcommand{\portraitbox}{%
  \begingroup
  \setlength{\fboxsep}{0pt}%
  \ifthenelse{\equal{\@portraitimage}{}}{%
    \fbox{%
      \parbox[c][\cvinfoheight][c]{2.35cm}{%
        \centering
        \textcolor{cvgray}{\small 头像}\\[2pt]
        \textcolor{cvgray}{\small 占位}
      }%
    }%
  }{%
    \includegraphics[height=1.12\cvinfoheight,keepaspectratio]{\@portraitimage}%
  }%
  \endgroup
}

\newcommand{\makecvheader}{%
  \begin{center}
    {\Huge\bfseries \@name}\par
  \end{center}
  \vspace{1pt}
  \noindent
  \begin{minipage}[t][\cvinfoheight][t]{0.80\textwidth}
    \vspace{0pt}
    \begin{minipage}[t]{0.48\linewidth}
      \vspace{0pt}
      \begin{tabularx}{\linewidth}{@{}p{1.8cm}>{\raggedright\arraybackslash}X@{}}
        \@leftinfo
      \end{tabularx}
    \end{minipage}\hfill
    \begin{minipage}[t]{0.48\linewidth}
      \vspace{0pt}
      \begin{tabularx}{\linewidth}{@{}p{1.8cm}>{\raggedright\arraybackslash}X@{}}
        \@rightinfo
      \end{tabularx}
    \end{minipage}
  \end{minipage}\hfill
  \begin{minipage}[t][\cvinfoheight][t]{0.17\textwidth}
    \vspace{0pt}
    \raggedleft \portraitbox
  \end{minipage}
  \vspace{8pt}
}

\AtBeginDocument{\if@manualheader\else\printheader\fi}

\newenvironment{rSection}[1]{%
  \vspace{7pt}
  {\large\bfseries #1}\par
  \vspace{2pt}
  \hrule
  \vspace{7pt}
}{%
  \vspace{4pt}
}

\newenvironment{rSubsection}[4]{%
  \textbf{#1}\hfill{\itshape #2}\par
  \ifthenelse{\equal{#3}{}}{}{\textit{#3}\hfill\textit{#4}\par}
  \begin{itemize}
}{%
  \end{itemize}
  \vspace{2pt}
}

\newenvironment{cvgroup}[1]{%
  \begin{itemize}
    \item \textbf{#1：}
    \begin{enumerate}
}{%
    \end{enumerate}
  \end{itemize}
}

\newenvironment{cvbullets}[1]{%
  \begin{itemize}
    \item \textbf{#1：}
    \begin{itemize}[label=$\circ$,leftmargin=1.7em]
}{%
    \end{itemize}
  \end{itemize}
}

\newcommand{\eduentry}[5]{%
  \noindent
  \begin{tabularx}{\textwidth}{@{}p{2.25cm}p{3.35cm}p{3.05cm}Xr@{}}
    \textbullet\ \textbf{#1} & #2 & #3 & #4 & #5
  \end{tabularx}
}

\newcommand{\subdetail}[1]{%
  \begin{itemize}[label=$\circ$,leftmargin=2.8em,itemsep=0pt,topsep=0pt,parsep=0pt,partopsep=0pt]
    \item #1
  \end{itemize}
}

\newcommand{\skillrow}[2]{\textbf{#1} & #2\\}
\newcommand{\skillitem}[2]{\item \textbf{#1：}#2}
\newcommand{\projectentry}[4]{\item \textbf{#1}，#2，#3；#4}
\newcommand{\authorhl}[1]{\textbf{\underline{#1}}}
\newcommand{\journal}[1]{\textcolor{cvblue}{\textit{#1}}}
\newcommand{\doi}[1]{\href{#1}{\nolinkurl{#1}}}
\newcommand{\cvdate}[1]{\hfill{\itshape #1}}
