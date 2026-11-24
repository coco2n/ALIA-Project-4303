%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST 381 - Artificial Intelligence
%%% GADEA-VILLANOVA Come
%%% Project
%%% Source : https://github.com/coco2n/ALIA-Project-4303.git
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% A Prolog Implementation of connect 4 with IA players
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     USEFUL PREDICATES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

len([],0).
len([_|Y],R) :- len(Y,A),R is A+1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     FACTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic board/1.

changePlayer(x, o).
changePlayer(o, x).

%.......................................
% display
%.......................................

displayLine(1,[[H1|_],[H2|_],[H3|_],[H4|_],[H5|_],[H6|_],[H7|_]]) :-
    write(H1), write(' | '),
    write(H2), write(' | '),
    write(H3), write(' | '),
    write(H4), write(' | '),
    write(H5), write(' | '),
    write(H6), write(' | '),
    writeln(H7)
    .

displayLine(X,[[_|T1],[_|T2],[_|T3],[_|T4],[_|T5],[_|T6],[_|T7]]) :-
    X > 1,
    NextX is X - 1,
    displayLine(NextX,[T1,T2,T3,T4,T5,T6,T7])
    .

displayBoard :-
    board([C1,C2,C3,C4,C5,C6,C7]),
    writeln('Current Board:'),
    displayLine(7,[C1,C2,C3,C4,C5,C6,C7]), 
    displayLine(6,[C1,C2,C3,C4,C5,C6,C7]), 
    displayLine(5,[C1,C2,C3,C4,C5,C6,C7]), 
    displayLine(4,[C1,C2,C3,C4,C5,C6,C7]), 
    displayLine(3,[C1,C2,C3,C4,C5,C6,C7]), 
    displayLine(2,[C1,C2,C3,C4,C5,C6,C7]), 
    displayLine(1,[C1,C2,C3,C4,C5,C6,C7])
    .

%.......................................
% column
%.......................................
% The mark in a column(N) corresponds to an item in a list, as follows:
column([M,_,_,_,_,_],1,M).
column([_,M,_,_,_,_],2,M).
column([_,_,M,_,_,_],3,M).
column([_,_,_,M,_,_],4,M).
column([_,_,_,_,M,_],5,M).
column([_,_,_,_,_,M],6,M).


%.......................................
% move
%.......................................

playMoveInColumn(['?'|T],[Player|T],Player).
playMoveInColumn([H|T1], [H|T2],Player) :- 
    H \= '?',
    playMoveInColumn(T1, T2, Player)
    .

playMove([C|T], 1, [NewC|T], Player):-
    playMoveInColumn(C,NewC, Player)
    .

playMove([C|T], N, [C|NewT], Player):-
    N > 1,
    N < 8,
    NextN is N - 1,
    playMove(T, NextN, NewT, Player)
    .

applyIt(Board, NewBoard) :-
    retract(board(Board)),
    assert(board(NewBoard))
    .


%.......................................
% game_over
%.......................................

gameOver(Board) :- False.

gagne(Board, Player) :- False.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     MAIN PROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

play(Player) :-
    board(Board),
    displayBoard,
    write('New turn for: '), writeln(Player),
    ia(Board, Move, Player),
    playMove(Board, Move, NewBoard, Player),
    applyIt(Board, NewBoard),
    (   gagne(NewBoard, Player)
    ->  displayBoard,
        write(Player), writeln(' wins!'),
        !
    ;   gameOver(NewBoard)
    ->  displayBoard,
        writeln('Draw!'),
        !
    ;   changePlayer(Player, NextPlayer),
        play(NextPlayer)
    )
    .

init :-
    assert(board(  [['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?']   
                    ])),
    displayBoard,
    playMove([C1,C2,C3,C4,C5,C6,C7], 3, NewBoard, x),
    playMove(NewBoard, 4, NewBoard2, o),
    playMove(NewBoard2, 3, NewBoard3, x),
    applyIt([C1,C2,C3,C4,C5,C6,C7], NewBoard3),
    displayBoard
    .


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% End of program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%