grammar LDPatch;
/** based partially on https://github.com/antlr/grammars-v4/blob/master/json/JSON.g4 **/
parse         : patch EOF ;
patch         : statement | statementList ;
statementList : '[' statement ( SEP statement )* ']';
statement     : '{' op_jobj SEP s_jobj SEP p_jobj SEP o_jobj (SEP g_jobj)? '}';


op_jobj : OP ':' opt ;
s_jobj  : S ':' subject ;
p_jobj  : P ':' predicate ;
o_jobj  : O ':' object ;
g_jobj  : G ':' graph ;

opt           : OPT ;
subject       : JSONURI ;
predicate     : JSONURI ;
object        : jsonuri
              | string
              | typedstring 
              | langstring
              | plainliteral
              ;
graph         : JSONURI ;
jsonuri  : JSONURI ;
typedstring : '{' '"@value"' ':' string SEP TYPE ':' jsonuri '}' ;
langstring : '{' '"@value"' ':' string SEP LANG ':' string '}' ;
string : STRING ;
number : NUMBER ;
plainliteral : ( string | number ) ;

TYPE : '"@type"' ;
LANG : '"@lang"' ;
SEP  : ',' ;
OP   : '"op"' ;
S    : '"s"' ;
P    : '"p"' ;
O    : '"o"' ;
G    : '"g"' ;
OPT : '"' ( ADD | DEL ) '"' ;

JSONURI  : '"' HTTP ( PN_CHARS | '.' | ':' | '/' | '\\' | '#' | '@' | '%' | '&' | UCHAR )+ '"' ;
STRING : '"' ( ESC | ~["\\] )* '"' ;
NUMBER
    :   '-'? INT '.' [0-9]+ EXP?
    |   '-'? INT EXP            
    |   '-'? INT               
    ;

WS : [ \t\r\n]+ -> skip ;

fragment  ADD : 'add' ;
fragment  DEL : 'del' ;
fragment ESC :   '\\' ["\\/bfnrt] | UNICODE ;
fragment HTTP     : ('http' 's'? | 'HTTP' 'S'?) '://'  ;
fragment UCHAR    : UNICODE | '\\U' HEX HEX HEX HEX HEX HEX HEX HEX;
fragment PN_CHARS_BASE :   'A'..'Z'
        |   'a'..'z'
        |   '\u00C0'..'\u00D6'
        |   '\u00D8'..'\u00F6'
        |   '\u00F8'..'\u02FF'
        |   '\u0370'..'\u037D'
        |   '\u037F'..'\u1FFF'
        |   '\u200C'..'\u200D'
        |   '\u2070'..'\u218F'
        |   '\u2C00'..'\u2FEF'
        |   '\u3001'..'\uD7FF'
        |   '\uF900'..'\uFDCF'
        |   '\uFDF0'..'\uFFFD'
        ;
fragment PN_CHARS_U    : PN_CHARS_BASE | '_';
fragment PN_CHARS      : PN_CHARS_U | '-' | [0-9] | '\u00B7' | [\u0300-\u036F] | [\u203F-\u2040];
fragment HEX           : [0-9] | [A-F] | [a-f];
fragment UNICODE       : '\\u' HEX HEX HEX HEX ;
fragment INT :   '0' | [1-9] [0-9]* ;
fragment EXP :   [Ee] [+\-]? INT ;