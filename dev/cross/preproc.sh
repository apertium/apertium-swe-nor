#!/bin/bash

     sed 's%\(</l>.*\)\(</r></p> *<par n="adj"\)%<s n="adj"/>\1<s n="adj"/>\2%' \
    |sed 's%\(</l>.*\)\(</r></p> *<par n="adj_sint:adj"\)%<s n="adj"/><s n="sint"/>\1<s n="adj"/>\2%' \
    |sed 's%\(</l>.*\)\(</r></p> *<par n="adj:adj_sint"\)%<s n="adj"/>\1<s n="adj"/><s n="sint"/>\2%' \
    |sed 's%\(</l>.*\)\(</r></p> *<par n="adj_sint"\)%<s n="adj"/><s n="sint"/>\1<s n="adj"/><s n="sint"/>\2%' \
    |sed 's%\(</l>.*\)\(</r></p> *<par n=":f/m"\)%\1<s n="f"/>\2%' \
    |sed 's%\(</l>.*\)\(</r></p> *<par n="vblex\)%<s n="vblex"/>\1<s n="vblex"/>\2%' \
    |sed 's%\(</l>.*\)\(</r></p> *<par n="pstv"\)%<s n="vblex"/>\1<s n="vblex"/><s n="pstv"/>\2%' \
    |sed 's%\(</l>.*\)\(</r></p> *<par n="pass:pstv"\)%<s n="vblex"/><s n="pass"/>\1<s n="vblex"/><s n="pstv"/>\2%'
