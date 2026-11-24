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

% Lit une ligne complète sans point final et la convertit en nombre ou en atome
read_input(Val) :-
    read_line_to_string(user_input, Str),
    normalize_space(string(CleanStr), Str),
    (   number_string(Val, CleanStr)
    ->  true
    ;   atom_string(Val, CleanStr)
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     FACTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- dynamic player/2.
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
    retractall(board(_)),
    assert(board(NewBoard))
    .

validMoveInColumn(['?'|_]).
validMoveInColumn([H|T]) :-
    H \= '?',
     validMoveInColumn(T)
    .

validMove([C|_], 1) :-
    validMoveInColumn(C)
    .
validMove([_|T], Move) :-
    Move > 1,
    Move < 8,
    NextMove is Move - 1,
    validMove(T, NextMove)
    .

%.......................................
% game_over
%.......................................

gameOver(Board) :- 
    \+ validMove(Board, 1),
    \+ validMove(Board, 2),
    \+ validMove(Board, 3),
    \+ validMove(Board, 4),
    \+ validMove(Board, 5),
    \+ validMove(Board, 6),
    \+ validMove(Board, 7)
    .

gagne(Board, Move, Player) :- fail. % to complete


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     IA MODULE FOR CONNECT 4
%%% put every AI model here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

randomIA(Board, Move, Player) :-
    repeat,
    random_between(1, 7, Move),
    validMove(Board, Move).
    .

% to change ia model, just change the predicate called by ia 
ia(Board, Move, Player) :-
    randomIA(Board, Move, Player)
    .
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     MAIN PROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run :-
    hello,
    play(x),
    goodbye.

hello :-
    retractall(board(_)),
    retractall(player(_, _)),
    asserta(board([ ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'] ])),
    nl, writeln('=== PUISSANCE 4 ==='),
    read_players.

read_players :-
    nl, write('Nombre de joueurs humains (0, 1 ou 2) ? '),
    read_input(N),
    set_players(N).

set_players(0) :-
    asserta(player(x, computer)),
    asserta(player(o, computer)), !.

set_players(1) :-
    nl, write('Voulez-vous jouer x ou o (x commence) ? '),
    read_input(M),
    human_playing(M), !.
set_players(2) :-
    asserta(player(x, human)),
    asserta(player(o, human)), !.
set_players(_) :-
    writeln('Entree invalide. Tapez 0., 1. ou 2.'),
    read_players.

human_playing(M) :-
    (M == 'x' ; M == 'X'),
    asserta(player(x, human)),
    asserta(player(o, computer)), !.
human_playing(M) :-
    (M == 'o' ; M == 'O'),
    asserta(player(x, computer)),
    asserta(player(o, human)), !.
human_playing(_) :-
    writeln('Entree invalide. Tapez x. ou o.'),
    set_players(1).

goodbye :-
    retractall(board(_)),
    retractall(player(_, _)),
    read_play_again(V), !,
    (V == 'Y' ; V == 'y'), !,
    run.
goodbye. % Termine proprement si l'utilisateur répond N

read_play_again(V) :-
    nl, write('Rejouer (y/n) ? '),
    read_input(V),
    (V == 'y' ; V == 'Y' ; V == 'n' ; V == 'N'), !.
read_play_again(V) :-
    writeln('Veuillez entrer y. ou n.'),
    read_play_again(V).

chooseMove(human, Board, Move, Player) :-
    repeat,
    write('Joueur '), write(Player), write(', choisissez une colonne (1-7) : '),
    read_input(Move),
    integer(Move),
    validMove(Board, Move), !.

chooseMove(computer, Board, Move, Player) :-
    writeln('L\'ordinateur reflechit...'),
    ia(Board, Move, Player),
    write('L\'ordinateur joue en colonne '), writeln(Move).

play(Player) :-
    board(Board),
    displayBoard,
    nl, write('Tour de : '), writeln(Player),
    player(Player, Type),
    chooseMove(Type, Board, Move, Player),
    playMove(Board, Move, NewBoard, Player),
    applyIt(Board, NewBoard),
    (   gagne(NewBoard, Move, Player)
    ->  displayBoard,
        write(Player), writeln(' gagne !'),
        !
    ;   gameOver(NewBoard)
    ->  displayBoard,
        writeln('Match nul !'),
        !
    ;   changePlayer(Player, NextPlayer),
        play(NextPlayer)
    ).

init :-
    retractall(board(_)),
    retractall(player(_, _)),
    asserta(player(x, computer)),
    asserta(player(o, computer)),
    asserta(board([ ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'],
                    ['?','?','?','?','?','?'] ])),
    play(x).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% End of program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%