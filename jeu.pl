%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ALIA -- Game project
%%% GADEA-VILLANOVA Côme, [enter name here]
%%% Due [TBA]
%%% Source : [https://github.com/coco2n/ALIA-Project-4303.git]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% A Prolog Implementation of connect 4 with IA players
%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% définition du jeu

:- dynamic board/1.

% --- Boucle principale du jeu ---
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
    ).


displayLine(1,[[H1|_],[H2|_],[H3|_],[H4|_],[H5|_],[H6|_],[H7|_]]) :-
    write(H1), write(' | '), write(H2), write(' | '), write(H3), write(' | '), write(H4), write(' | '), write(H5), write(' | '), write(H6), write(' | '), writeln(H7).

displayLine(X,[[[_|T1]],[[_|T2]],[[_|T3]],[[_|T4]],[[_|T5]],[[_|T6]],[[_|T7]]]) :-
    X > 1,
    NextX is X - 1,
    displayLine(NextX,[T1,T2,T3,T4,T5,T6,T7]).

displayBoard :-
    board([C1,C2,C3,C4,C5,C6,C7]),
    writeln('Current Board:'),
    displayLine(7,[C1,C2,C3,C4,C5,C6,C7]),
    displayLine(6,[C1,C2,C3,C4,C5,C6,C7]),
    displayLine(5,[C1,C2,C3,C4,C5,C6,C7]),
    displayLine(4,[C1,C2,C3,C4,C5,C6,C7]),
    displayLine(3,[C1,C2,C3,C4,C5,C6,C7]),
    displayLine(2,[C1,C2,C3,C4,C5,C6,C7]),
    displayLine(1,[C1,C2,C3,C4,C5,C6,C7]).

playMove([C|T], 1, [NewC|T], Player):-
    playMoveInColumn(C, NewC, Player).

playMoveInColumn()


applyIt(Board, NewBoard) :-
    retract(board(Board)),
    assert(board(NewBoard)).
