:- use_module(library(main), [main/0]).
:- use_module(library(prolog_pack), []).
:- use_module(library(readutil), [read_file_to_terms/3]).

main(_) :-
    dependencies(Packs),
    install_packs(Packs).


% list of dependencies needed by this application
dependencies(Packs) :-
    packfile(File),
    !,
    read_file_to_terms(File, Terms, []),
    findall(Pack, member(requires(Pack), Terms), Packs).
dependencies([]).


% name of this application's Packfile
packfile('Packfile') :-
    exists_file('Packfile'),
    !.
packfile('pack.pl') :-
    exists_file('pack.pl').


% install every pack in a list.
% a fair amount of this is inspired by prolog_pack module.
% i'll merge it upstream once I'm convinced this is the right way
% forward.
install_packs([]).
install_packs([Pack|Packs]) :-
    prolog_pack:query_pack_server(locate(Pack), Reply),
    ( Reply = true(Results) ->
        most_recent_pack(Pack, Results, InstallOptions),
        format('Installing ~w ...~n', [Pack]),
        pack_install(Pack, [interactive(false),upgrade(true)|InstallOptions]),
        nl,
        install_packs(Packs)
    ; true ->
        print_message(warning, pack(no_match(Pack))),
        fail
    ).


% install options for the most recent version of Pack
most_recent_pack(Pack, [_Version-[URL]|_], InstallOptions) :-
    prolog_pack:git_url(URL, Pack),
    !,
	InstallOptions = [url(URL), git(true)].
most_recent_pack(_Pack, [_Version-[URL]|_], InstallOptions) :-
    InstallOptions = [url(URL)].
