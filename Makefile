all: flow

flow.tab.c flow.tab.h: flow.y
	bison -d flow.y

lex.yy.c: flow.l flow.tab.h
	flex flow.l

flow: lex.yy.c flow.tab.c flow.tab.h
	gcc flow.tab.c lex.yy.c -lfl -o flow
