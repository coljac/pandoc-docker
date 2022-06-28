BEGIN {
  inblock = 0
  figures = 0
  iswide = 0
  currentfigure = ""
  print "\n"
}

# Comments go through
/^ *%/ {
    print
    next
}

/begin{figure/ {
  inblock += 1
  figures++
}

/width=0.99000.*textwidth/ {
    gsub(/0.99000.textwidth/, "\\columwidth")
    print
}

/end{figure/ {
  inblock -= 1
  if (iswide) {
    fig = "figure*"
  } else {
    fig = "figure"
  } 
  print "\\begin{" fig "}"
  print currentfigure 
  print "\\end{" fig "}"
  currentfigure = ""
  iswide = 0
}

/,height=.textheight/ {
    if (inblock) {
        gsub(/,height=.textheight/, "")
    }
}

# !/{figure/ { if (inblock) {
!/(begin|end){figure/ { 
    if (inblock) {
    currentfigure = currentfigure $0 "\n"
    if ($0 ~ /1col/) {
      iswide = 0
    } else if ($0 ~ /2col/) {
      iswide = 1
    }
  } else {
    print 
  }
}

# END {
  # print "\nFigures: ", figures
# }
