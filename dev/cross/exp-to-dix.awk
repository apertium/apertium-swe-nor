#!/usr/bin/awk -f
BEGIN{
    FS=":"
    e="<e>         "
    if(vr=="nno" || vr=="nob") {
        e="<e vr=\""vr"\">"
    }
}

/__REGEXP?__/ {next}

{
  gsub(/ /,"<b/>")
  $0=gensub(/<([^>/]*)>/,"<s n=\"\\1\"/>", "g")
  $0=gensub(/#<b\/>([^<]*)/,"<g><b/>\\1</g>","g")

  par=""
  if(/<s n="vblex"\/>.*<s n="vblex"\/><s n="pstv"\/>/){
    par="<par n=\"vblex:pstv\"/>"
    gsub(/<s n="(vblex|pstv)"\/>/,"")
  }
  else if(/<s n="vblex"\/>.*<s n="vblex"\/>/){
    par="<par n=\"vblex\"/>"
    gsub(/<s n="vblex"\/>/,"")
  }
  else if(/<s n="adj"\/><s n="sint"\/>.*<s n="adj"\/><s n="sint"\/>/){
    par="<par n=\"adj_sint\"/>"
    gsub(/<s n="adj"\/><s n="sint"\/>/,"")
  }
  else if(/<s n="adj"\/><s n="sint"\/>.*<s n="adj"\/>/){
    par="<par n=\"adj_sint:adj\"/>"
    gsub(/<s n="adj"\/>(<s n="sint"\/>)?/,"")
  }
  else if(/<s n="adj"\/>.*<s n="adj"\/><s n="sint"\/>/){
    par="<par n=\"adj:adj_sint\"/>"
    gsub(/<s n="adj"\/>(<s n="sint"\/>)?/,"")
  }
  else if(/<s n="adj"\/>.*<s n="adj"\/>/){
    par="<par n=\"adj\"/>"
    gsub(/<s n="adj"\/>/,"")
  }
  else if(/<s n="n"\/><s n="f"\/>$/){
    par="<par n=\":f/m\"/>"
    gsub(/<s n="f"\/>/,"")
  }

  print e"<p><l>"$1"</l>	<r>"$2"</r></p>"par"</e>"
}
