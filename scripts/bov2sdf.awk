#!/usr/bin/awk -f

# Transfrom BOV file [1] to sdf format used in uDeviceX
#
# Refs:
# [1] https://wci.llnl.gov/codes/visit/2.0.0/GettingDataIntoVisIt2.0.0.pdf
#
# Usage:
# ./bov2sdf.awk <bov file> <sdf file>
function round(x,   ival, aval, fraction)
{
   ival = int(x)    # integer part, int() truncates

   # see if fractional part
   if (ival == x)   # no fraction
      return ival   # ensure no decimals

   if (x < 0) {
      aval = -x     # absolute value
      ival = int(aval)
      fraction = aval - ival
      if (fraction >= .5)
         return int(x) - 1   # -2.5 --> -3
      else
         return int(x)       # -2.3 --> -2
   } else {
      fraction = x - ival
      if (fraction >= .5)
         return ival + 1
      else
         return ival
   }
}

function strip_comments() {sub(/#.*/, "")}
function strip_tr_ws(s)   {  # strip trailing whitespaces
    sub(/^[ \t]*/, "", s)
    sub(/[ \t]*$/, "", s)
    return s
}

function parse_line(s)     { # sets `lhs' and `rhs'
    match(s, /^[^:]+:/)
    lhs = substr(s, RSTART, RLENGTH-1)
    lhs = strip_tr_ws(lhs)

    rhs = substr(s, RSTART+RLENGTH)
    rhs = strip_tr_ws(rhs)
}

function emptyp(s) {return s ~ /^[\t ]*$/}

function parse_data_size(s,    arr) {
    split(s, arr)
    nLx=arr[1]; nLy=arr[2]; nLz=arr[3]
}

function parse_brick_origin(s,    arr) {
    split(s, arr)
    xl=arr[1]; yl=arr[2]; zl=arr[3]
}

function parse_brick_size(s,    arr) {
    split(s, arr)
    Lx=arr[1]; Ly=arr[2]; Lz=arr[3]
}

function parse_bov(fi     ) {  # sets `df', `xl', `yl', `zl', ...
    while (getline < fi > 0) {
	strip_comments()
	if (emptyp($0)) continue
	parse_line($0) # sets `lhs' and `rhs'
	if      (lhs=="DATA_FILE")    df = rhs # data file
	else if (lhs=="DATA SIZE")    parse_data_size(rhs)
	else if (lhs=="BRICK ORIGIN") parse_brick_origin(rhs)
	else if (lhs=="BRICK SIZE")   parse_brick_size(rhs)
    }
    close(fi)
}

function print_sdf_header(fo,    xext, yext, zext) {
    xext = Lx; yext = Ly; zext = Lz

    if (br) # box round, TODO
	print round(xext/br)*br, round(yext/br)*br, round(zext/br)*br > fo
    else
	print xext, yext, zext                                        > fo

    print nLx, nLy, nLz    > fo
}

function lsystem(cmd, rc) {
    printf "(bov2sdf.awk) executing:\n%s\n", cmd
    rc = system(cmd)
    if (rc) {
	printf "(bov2sdf.awk)(ERROR)\n"
	exit rc
    }
}

function print_sdf_data(fo,    cmd) {
    close(fo)
    cmd = sprintf("cat %s >> %s", df_full, fo)
    lsystem(cmd)
}

function full_df(   cmd, d) { #  full path to value file from BOV
    cmd = sprintf("dirname \"%s\"", fi)
    cmd | getline d
    return d "/"  df
}

BEGIN {
    fi=ARGV[1] # input BOV
    fo=ARGV[2] # output sdf file

    parse_bov(fi)

    df_full = full_df() # full data file

    print_sdf_header(fo)
    print_sdf_data(fo)
    exit
}
